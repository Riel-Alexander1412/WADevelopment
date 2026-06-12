using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WADevelopment
{
    public partial class StockReorder : Page
    {
        string connStr => ConfigurationManager.ConnectionStrings["DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProductDropdown();
                BindGrid(LoadReorderRecords());
                RefreshSummaryCard();
            }
        }
        protected void ddlProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlProduct.SelectedValue))
            {
                ClearSKUFields();
                return;
            }

            int sku = int.Parse(ddlProduct.SelectedValue);
            PopulateSKUFields(sku);
        }

        protected void btnEstablishRule_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            if (string.IsNullOrEmpty(hfSKU.Value))
            {
                ShowMessage("Please select a product before establishing a rule.", false);
                return;
            }

            int sku = int.Parse(hfSKU.Value);
            int amount = int.Parse(txtAmount.Text.Trim());
            int safetyStock = int.Parse(txtSafetyStockLimit.Text.Trim());
            int userId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 1;

            InsertStockIn(sku, amount, userId, safetyStock);
            BindGrid(LoadReorderRecords());
            PopulateSKUFields(sku);

            ShowMessage($"<i class='fi fi-rr-check-circle me-1'></i> Reorder of <strong>{amount} units</strong> logged for <strong>{ddlProduct.SelectedItem.Text}</strong>.", true);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlProduct.SelectedIndex = 0;
            txtSKU.Text = string.Empty;
            txtAmount.Text = string.Empty;
            txtSafetyStockLimit.Text = string.Empty;
            hfSKU.Value = string.Empty;

            ClearSKUFields();
            lblMessage.Visible = false;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            var results = LoadReorderRecords(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
            BindGrid(results);
        }

        protected void gvReorderAlerts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (string.IsNullOrEmpty(e.CommandArgument?.ToString())) return;
            int sku = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "EditRow":
                    LoadRowIntoForm(sku);
                    break;

                case "DeleteRow":
                    DeleteLatestStockIn(sku);
                    BindGrid(LoadReorderRecords());
                    RefreshSummaryCard();
                    ShowMessage("<i class='fi fi-rr-trash me-1'></i> Latest reorder record deleted.", false);
                    break;
            }
        }
        private void LoadProductDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT SKU, Name, Amount, MinAmount FROM Products ORDER BY Name ASC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlProduct.Items.Clear();
                        ddlProduct.Items.Add(new ListItem("-- Choose a product --", ""));

                        while (reader.Read())
                        {
                            int sku = Convert.ToInt32(reader["SKU"]);
                            string name = reader["Name"].ToString();
                            int qty = Convert.ToInt32(reader["Amount"]);
                            int minQty = Convert.ToInt32(reader["MinAmount"]);

                            string label = $"{sku} – {name}  (Stock: {qty} / Min: {minQty})";
                            ddlProduct.Items.Add(new ListItem(label, sku.ToString()));
                        }
                    }
                }
            }
        }

        private void PopulateSKUFields(int sku)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT SKU, MinAmount FROM Products WHERE SKU = @SKU";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@SKU", sku);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int minAmount = Convert.ToInt32(reader["MinAmount"]);

                            txtSKU.Text = sku.ToString();
                            hfSKU.Value = sku.ToString();

                            txtSafetyStockLimit.Text = minAmount.ToString();
                        }
                    }
                }
            }

            RefreshSummaryCard();
        }

        private void RefreshSummaryCard()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT
                        SUM(CAST(Amount AS DECIMAL(18,2)) * CostPerUnit)   AS TotalNetWorth,
                        SUM(CAST(Amount AS DECIMAL(18,2)) * SellingPrice)  AS TotalSellPrice,
                        AVG(CAST(Amount AS DECIMAL(18,2)))                 AS AvgStockUnit
                    FROM Products";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            decimal netWorth = reader["TotalNetWorth"] != DBNull.Value ? Convert.ToDecimal(reader["TotalNetWorth"]) : 0;
                            decimal sellPrice = reader["TotalSellPrice"] != DBNull.Value ? Convert.ToDecimal(reader["TotalSellPrice"]) : 0;
                            decimal avgUnits = reader["AvgStockUnit"] != DBNull.Value ? Convert.ToDecimal(reader["AvgStockUnit"]) : 0;

                            lblTotalNetWorth.Text = netWorth.ToString("N2");
                            lblTotalSellPrice.Text = sellPrice.ToString("N2");
                            lblAvgStockUnit.Text = Math.Round(avgUnits, 1).ToString("N1");
                        }
                        else
                        {
                            lblTotalNetWorth.Text = "0.00";
                            lblTotalSellPrice.Text = "0.00";
                            lblAvgStockUnit.Text = "0.0";
                        }
                    }
                }
            }
        }

        private void ClearSKUFields()
        {
            txtSKU.Text = string.Empty;
            hfSKU.Value = string.Empty;
            txtSafetyStockLimit.Text = string.Empty;

            lblTotalNetWorth.Text = "—";
            lblTotalSellPrice.Text = "—";
            lblAvgStockUnit.Text = "—";
        }

        private void LoadRowIntoForm(int sku)
        {
            var item = ddlProduct.Items.FindByValue(sku.ToString());
            if (item != null) ddlProduct.SelectedValue = sku.ToString();

            PopulateSKUFields(sku);

            ShowMessage($"<i class='fi fi-rr-pencil me-1'></i> Editing SKU <strong>{sku}</strong>. Adjust Amount and Safety Stock, then click Establish Rule.", true);
        }

        private void InsertStockIn(int sku, int amount, int userId, int newMinAmount)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    -- Log the stock-in event
                    INSERT INTO StockIn (SKU, Amount, [User], Date)
                    VALUES (@SKU, @Amount, @User, @Date);

                    -- Add the incoming amount to current stock
                    UPDATE Products
                    SET    Amount    = Amount + @Amount,
                           MinAmount = @MinAmount
                    WHERE  SKU = @SKU;";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@SKU", sku);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@User", userId);
                    cmd.Parameters.AddWithValue("@Date", DateTime.Now);
                    cmd.Parameters.AddWithValue("@MinAmount", newMinAmount);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void DeleteLatestStockIn(int sku)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sqlFind = @"
                    SELECT TOP 1 StockInID, Amount
                    FROM   StockIn
                    WHERE  SKU = @SKU
                    ORDER  BY Date DESC";

                int stockInId = 0;
                int stockAmt = 0;

                using (SqlCommand cmd = new SqlCommand(sqlFind, conn))
                {
                    cmd.Parameters.AddWithValue("@SKU", sku);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            stockInId = Convert.ToInt32(reader["StockInID"]);
                            stockAmt = Convert.ToInt32(reader["Amount"]);
                        }
                    }
                }

                if (stockInId == 0) return;

                string sqlDelete = @"
                    DELETE FROM StockIn WHERE StockInID = @ID;

                    -- Reverse the amount (floor at 0 to avoid negative stock)
                    UPDATE Products
                    SET    Amount = CASE WHEN Amount - @Amount < 0 THEN 0 ELSE Amount - @Amount END
                    WHERE  SKU = @SKU;";

                using (SqlCommand cmd = new SqlCommand(sqlDelete, conn))
                {
                    cmd.Parameters.AddWithValue("@ID", stockInId);
                    cmd.Parameters.AddWithValue("@Amount", stockAmt);
                    cmd.Parameters.AddWithValue("@SKU", sku);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private List<ReorderRecord> LoadReorderRecords(string keyword = "", string statusFilter = "All")
        {
            var records = new List<ReorderRecord>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT
                        p.SKU,
                        p.Name        AS ProductName,
                        p.Amount,
                        p.MinAmount,
                        p.Category,
                        CASE
                            WHEN p.Amount <= p.MinAmount           THEN 'TRIGGER REORDER'
                            WHEN p.Amount <= p.MinAmount * 1.5     THEN 'LOW'
                            ELSE 'OK'
                        END AS Status
                    FROM  Products p
                    WHERE (@Keyword = '' OR p.Name     LIKE @Search
                                        OR CAST(p.SKU AS VARCHAR) LIKE @Search
                                        OR p.Category  LIKE @Search)
                      AND (@Status = 'All' OR
                           CASE
                               WHEN p.Amount <= p.MinAmount       THEN 'TRIGGER REORDER'
                               WHEN p.Amount <= p.MinAmount * 1.5 THEN 'LOW'
                               ELSE 'OK'
                           END = @Status)
                    ORDER BY p.Amount ASC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Keyword", keyword ?? "");
                    cmd.Parameters.AddWithValue("@Search", "%" + (keyword ?? "") + "%");
                    cmd.Parameters.AddWithValue("@Status", statusFilter ?? "All");

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            records.Add(new ReorderRecord
                            {
                                SKU = Convert.ToInt32(reader["SKU"]),
                                ProductName = reader["ProductName"].ToString(),
                                Amount = Convert.ToInt32(reader["Amount"]),
                                MinAmount = Convert.ToInt32(reader["MinAmount"]),
                                Category = reader["Category"].ToString(),
                                Status = reader["Status"].ToString()
                            });
                        }
                    }
                }
            }

            return records;
        }

        private void BindGrid(List<ReorderRecord> records)
        {
            lblAlertCount.Text = records.Count(r => r.Status == "TRIGGER REORDER").ToString();
            lblRecordCount.Text = records.Count.ToString();
            lblTotalRecords.Text = records.Count.ToString();

            gvReorderAlerts.DataSource = records;
            gvReorderAlerts.DataBind();
        }

        private void ShowMessage(string html, bool success)
        {
            lblMessage.Visible = true;
            lblMessage.Text = html;
            lblMessage.CssClass = success ? "form-message success" : "form-message error";
        }
        protected string GetQtyClass(object amountObj, object minAmountObj)
        {
            if (amountObj == null || minAmountObj == null) return "qty-ok";
            int amount = Convert.ToInt32(amountObj);
            int minAmount = Convert.ToInt32(minAmountObj);

            if (amount <= minAmount) return "qty-critical";
            if (amount <= minAmount * 1.5) return "qty-low";
            return "qty-ok";
        }
        protected string GetStatusClass(string status)
        {
            switch (status?.ToUpper())
            {
                case "TRIGGER REORDER": return "status-trigger";
                case "LOW": return "status-low";
                default: return "status-ok";
            }
        }
    }
    public class ReorderRecord
    {
        public int SKU { get; set; }
        public string ProductName { get; set; }
        public int Amount { get; set; }
        public int MinAmount { get; set; }
        public string Category { get; set; }
        public string Status { get; set; }
    }
}
