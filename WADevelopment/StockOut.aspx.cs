using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WADevelopment
{
    public partial class StockOut : Page
    {
        string connStr => ConfigurationManager.ConnectionStrings["DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx", false);
                }
                LoadProductDropdown();
                LoadUserDropdown();
                BindGrid();
                CalculateShrinkageMetrics();
            }
        }

        private void LoadProductDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT SKU, Name, Amount FROM Products ORDER BY Name ASC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlProduct.Items.Clear();
                        ddlProduct.Items.Add(new ListItem("-- Choose a product --", ""));
                        while (reader.Read())
                        {
                            string sku = reader["SKU"].ToString();
                            string name = reader["Name"].ToString();
                            string amount = reader["Amount"].ToString();
                            ddlProduct.Items.Add(new ListItem($"{sku} - {name} (Stock: {amount})", sku));
                        }
                    }
                }
            }
        }

        private void LoadUserDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT UserID, Name FROM Users ORDER BY Name ASC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlUser.Items.Clear();
                        ddlUser.Items.Add(new ListItem("-- Select Operator --", ""));
                        while (reader.Read())
                        {
                            string userId = reader["UserID"].ToString();
                            string name = reader["Name"].ToString();
                            ddlUser.Items.Add(new ListItem($"{userId} - {name}", userId));
                        }
                    }
                }
            }
        }

        private void BindGrid(string searchKeyword = "")
        {
            List<StockOutRecord> records = new List<StockOutRecord>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT 
                        s.StockOutID,
                        s.SKU,
                        p.Name AS ProductName,
                        s.Amount,
                        p.CostPerUnit,
                        u.Name AS OperatorName,
                        s.Date,
                        s.Type
                    FROM StockOut s
                    INNER JOIN Products p ON s.SKU = p.SKU
                    INNER JOIN Users u ON s.[User] = u.UserID";

                if (!string.IsNullOrEmpty(searchKeyword))
                {
                    sql += " WHERE p.Name LIKE @Search OR CAST(s.SKU AS VARCHAR) LIKE @Search";
                }

                sql += " ORDER BY s.Date DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (!string.IsNullOrEmpty(searchKeyword))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchKeyword + "%");
                    }

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            records.Add(new StockOutRecord
                            {
                                StockOutID = Convert.ToInt32(reader["StockOutID"]),
                                SKU = Convert.ToInt32(reader["SKU"]),
                                ProductName = reader["ProductName"].ToString(),
                                Amount = Convert.ToInt32(reader["Amount"]),
                                CostPerUnit = Convert.ToDecimal(reader["CostPerUnit"]),
                                OperatorName = reader["OperatorName"].ToString(),
                                Date = Convert.ToDateTime(reader["Date"]),
                                Type = reader["Type"].ToString()
                            });
                        }
                    }
                }
            }

            lblRecordCount.Text = records.Count.ToString();
            lblOutboundCount.Text = records.Count.ToString();
            gvStockOutLogs.DataSource = records;
            gvStockOutLogs.DataBind();
        }

        private void CalculateShrinkageMetrics()
        {
            decimal totalLossValue = 0;
            decimal totalStockValue = 0;
            int totalOutboundQty = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {

                string sqlLoss = @"
            SELECT ISNULL(SUM(s.Amount * p.CostPerUnit), 0) 
            FROM StockOut s
            INNER JOIN Products p ON s.SKU = p.SKU
            WHERE s.Type = 'Product Loss'";


                string sqlTotalOut = "SELECT ISNULL(SUM(Amount), 0) FROM StockOut";


                string sqlStockValue = "SELECT ISNULL(SUM(Amount * CostPerUnit), 0) FROM Products";

                conn.Open();

                using (SqlCommand cmd = new SqlCommand(sqlLoss, conn))
                    totalLossValue = (decimal)cmd.ExecuteScalar();

                using (SqlCommand cmd = new SqlCommand(sqlTotalOut, conn))
                    totalOutboundQty = (int)cmd.ExecuteScalar();

                using (SqlCommand cmd = new SqlCommand(sqlStockValue, conn))
                    totalStockValue = (decimal)cmd.ExecuteScalar();
            }


            lblTotalLoss.Text = totalLossValue.ToString("N2");
            lblTotalOutCount.Text = totalOutboundQty.ToString("N0");


            decimal totalPotentialValue = totalStockValue + totalLossValue;

            if (totalPotentialValue > 0)
            {
                decimal shrinkageRate = (totalLossValue / totalPotentialValue) * 100;
                lblShrinkageRate.Text = shrinkageRate.ToString("N2") + "%";
            }
            else
            {
                lblShrinkageRate.Text = "0.00%";
            }
        }

        protected void btnConfirmDispatch_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int sku = int.Parse(ddlProduct.SelectedValue);
            int amount = int.Parse(txtAmount.Text.Trim());
            int userId = int.Parse(ddlUser.SelectedValue);
            DateTime date = DateTime.Parse(txtDate.Text.Trim());

            bool isEdit = hfIsEdit.Value == "true";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    if (isEdit)
                    {
                        int stockOutId = int.Parse(hfStockOutId.Value);
                        int previousAmount = 0;
                        string getPreviousSql = "SELECT Amount FROM StockOut WHERE StockOutID = @ID";
                        using (SqlCommand cmd = new SqlCommand(getPreviousSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@ID", stockOutId);
                            object obj = cmd.ExecuteScalar();
                            if (obj != null) previousAmount = Convert.ToInt32(obj);
                        }

                        string updateStockSql = "UPDATE Products SET Amount = Amount + @PrevAmount - @NewAmount WHERE SKU = @SKU";
                        using (SqlCommand cmd = new SqlCommand(updateStockSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@PrevAmount", previousAmount);
                            cmd.Parameters.AddWithValue("@NewAmount", amount);
                            cmd.Parameters.AddWithValue("@SKU", sku);
                            cmd.ExecuteNonQuery();
                        }

                        string updateRecordSql = "UPDATE StockOut SET SKU=@SKU, Amount=@Amount, [User]=@User, Date=@Date, Type=@Type WHERE StockOutID=@StockOutID";
                        using (SqlCommand cmd = new SqlCommand(updateRecordSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@SKU", sku);
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.Parameters.AddWithValue("@User", userId);
                            cmd.Parameters.AddWithValue("@Date", date);
                            cmd.Parameters.AddWithValue("@StockOutID", stockOutId);
                            cmd.Parameters.AddWithValue("@Type", ddlType.SelectedValue);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertSql = "INSERT INTO StockOut (SKU, Amount, [User], Date, Type) VALUES (@SKU, @Amount, @User, @Date, @Type)";

                        using (SqlCommand cmd = new SqlCommand(insertSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@SKU", sku);
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.Parameters.AddWithValue("@User", userId);
                            cmd.Parameters.AddWithValue("@Date", date);
                            cmd.Parameters.AddWithValue("@Type", ddlType.SelectedValue);
                            cmd.ExecuteNonQuery();
                        }

                        string deductStockSql = "UPDATE Products SET Amount = Amount - @Amount WHERE SKU = @SKU";
                        using (SqlCommand cmd = new SqlCommand(deductStockSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.Parameters.AddWithValue("@SKU", sku);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit();

                    lblMessage.Visible = true;
                    lblMessage.Text = isEdit
                        ? $"<i class='fi fi-rr-check-circle me-1'></i> Stock Out log updated successfully."
                        : $"<i class='fi fi-rr-check-circle me-1'></i> Stock Out log generated successfully.";
                    lblMessage.CssClass = "form-message success d-block text-success font-semibold mt-3";
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Visible = true;
                    lblMessage.Text = $"<i class='fi fi-rr-exclamation me-1'></i> Error: {ex.Message}";
                    lblMessage.CssClass = "form-message error d-block text-danger font-semibold mt-3";
                }
            }

            ResetFields();
            LoadProductDropdown();
            BindGrid();
            CalculateShrinkageMetrics();
        }

        protected void gvStockOutLogs_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditRow")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {

                    string sql = "SELECT StockOutID, SKU, Amount, [User], Date, Type FROM StockOut WHERE StockOutID = @ID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", id);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {

                                txtStockOutIdDisplay.Text = "DSP-" + reader["StockOutID"].ToString();
                                hfStockOutId.Value = reader["StockOutID"].ToString();
                                ddlProduct.SelectedValue = reader["SKU"].ToString();
                                txtAmount.Text = reader["Amount"].ToString();
                                ddlUser.SelectedValue = reader["User"].ToString();


                                if (reader["Date"] != DBNull.Value)
                                {
                                    txtDate.Text = Convert.ToDateTime(reader["Date"]).ToString("yyyy-MM-dd");
                                }


                                if (reader["Type"] != DBNull.Value)
                                {
                                    ddlType.SelectedValue = reader["Type"].ToString();
                                }

                                hfIsEdit.Value = "true";
                                btnConfirmDispatch.Text = "Update Log";
                                lblMessage.Visible = false;
                            }
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction();

                    try
                    {
                        int prevAmount = 0;
                        int sku = 0;
                        string getDetailsSql = "SELECT SKU, Amount FROM StockOut WHERE StockOutID = @ID";
                        using (SqlCommand cmd = new SqlCommand(getDetailsSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@ID", id);
                            using (SqlDataReader rdr = cmd.ExecuteReader())
                            {
                                if (rdr.Read())
                                {
                                    sku = Convert.ToInt32(rdr["SKU"]);
                                    prevAmount = Convert.ToInt32(rdr["Amount"]);
                                }
                            }
                        }

                        string updateStockSql = "UPDATE Products SET Amount = Amount + @Amount WHERE SKU = @SKU";
                        using (SqlCommand cmd = new SqlCommand(updateStockSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Amount", prevAmount);
                            cmd.Parameters.AddWithValue("@SKU", sku);
                            cmd.ExecuteNonQuery();
                        }

                        string deleteSql = "DELETE FROM StockOut WHERE StockOutID = @ID";
                        using (SqlCommand cmd = new SqlCommand(deleteSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@ID", id);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();
                        lblMessage.Visible = true;
                        lblMessage.Text = "<i class='fi fi-rr-trash me-1'></i> Log removed and warehouse stock restored.";
                        lblMessage.CssClass = "form-message success d-block text-success font-semibold mt-3";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        lblMessage.Visible = true;
                        lblMessage.Text = $"<i class='fi fi-rr-exclamation me-1'></i> Error: {ex.Message}";
                        lblMessage.CssClass = "form-message error d-block text-danger font-semibold mt-3";
                    }
                }

                ResetFields();
                LoadProductDropdown();
                BindGrid();
                CalculateShrinkageMetrics();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindGrid(txtSearch.Text.Trim());
        }

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindGrid();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ResetFields();
        }

        private void ResetFields()
        {
            txtStockOutIdDisplay.Text = "";
            hfStockOutId.Value = "";
            ddlProduct.SelectedIndex = 0;
            txtAmount.Text = "";
            ddlUser.SelectedIndex = 0;
            txtDate.Text = "";
            ddlType.SelectedIndex = 0;
            hfIsEdit.Value = "false";
            btnConfirmDispatch.Text = "Confirm Dispatch";
        }
    }

    public class StockOutRecord
    {
        public int StockOutID { get; set; }
        public int SKU { get; set; }
        public string ProductName { get; set; }
        public int Amount { get; set; }
        public decimal CostPerUnit { get; set; }
        public string OperatorName { get; set; }
        public DateTime Date { get; set; }
        public string Type { get; set; }
    }
}