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

        private List<ReorderRecord> LoadReorderRecords(string keyword = "", string statusFilter = "All")
        {
            List<ReorderRecord> records = new List<ReorderRecord>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT 
                p.SKU,
                p.Name,
                p.Description,
                p.Amount        AS CurrentQty,
                p.MinAmount     AS SafetyStock,
                p.CostPerUnit,
                p.SellingPrice,
                p.Category,
                CAST(SQRT((2.0 * 1800 * 50) / 2.0) AS INT) AS CalculatedEOQ,
                (5 * 7) + p.MinAmount                       AS CalculatedROP,
                CASE 
                    WHEN p.Amount <= p.MinAmount             THEN 'TRIGGER REORDER'
                    WHEN p.Amount <= p.MinAmount * 1.5       THEN 'LOW'
                    ELSE 'OK'
                END AS Status
            FROM Products p
            WHERE (@Keyword = '' OR p.Name LIKE @Search 
                               OR p.Category LIKE @Search)
              AND (@Status = 'All' OR 
                   CASE 
                       WHEN p.Amount <= p.MinAmount       THEN 'TRIGGER REORDER'
                       WHEN p.Amount <= p.MinAmount * 1.5 THEN 'LOW'
                       ELSE 'OK'
                   END = @Status)
            ORDER BY p.Amount ASC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Keyword", keyword);
                    cmd.Parameters.AddWithValue("@Search", "%" + keyword + "%");
                    cmd.Parameters.AddWithValue("@Status", statusFilter);

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            records.Add(new ReorderRecord
                            {
                                SKU = Convert.ToInt32(reader["SKU"]),
                                ProductName = reader["Name"].ToString(),
                                Description = reader["Description"].ToString(),
                                Amount = Convert.ToInt32(reader["CurrentQty"]),
                                MinAmount = Convert.ToInt32(reader["SafetyStock"]),
                                CostPerUnit = Convert.ToDecimal(reader["CostPerUnit"]),
                                SellingPrice = Convert.ToDecimal(reader["SellingPrice"]),
                                Category = reader["Category"].ToString(),
                                CalculatedEOQ = Convert.ToInt32(reader["CalculatedEOQ"]),
                                CalculatedROP = Convert.ToInt32(reader["CalculatedROP"]),
                                Status = reader["Status"].ToString()
                            });
                        }
                    }
                }
            }

            return records;
        }

        private void InsertStockIn(int sku, int quantity, int userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            INSERT INTO StockIn (SKU, Amount, [User], Date)
            VALUES (@SKU, @Amount, @User, @Date);
            UPDATE Products 
            SET Amount = Amount + @Amount
            WHERE SKU = @SKU";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@SKU", sku);
                    cmd.Parameters.AddWithValue("@Amount", quantity);
                    cmd.Parameters.AddWithValue("@User", userId);
                    cmd.Parameters.AddWithValue("@Date", DateTime.Now);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        private void DeleteStockInRecord(int stockInId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "DELETE FROM StockIn WHERE StockInID = @ID";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ID", stockInId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
        private void LoadProductDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT SKU, Name, Amount, MinAmount 
            FROM Products 
            ORDER BY Name ASC";

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

                            string label = $"{sku} – {name} (Stock: {qty} / Min: {minQty})";
                            ddlProduct.Items.Add(new ListItem(label, sku.ToString()));
                        }
                    }
                }
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProductDropdown();
                BindGrid(LoadReorderRecords());
            }
        }
        protected void btnEstablishRule_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int sku = int.Parse(ddlProduct.SelectedValue);
            int eoqQty = int.Parse(lblEOQ.Text.Replace(",", ""));  // use computed EOQ as reorder qty
            int userId = Convert.ToInt32(Session["UserID"]);        // from your login session

            InsertStockIn(sku, eoqQty, userId);

            BindGrid(LoadReorderRecords());

            lblMessage.Visible = true;
            lblMessage.Text = $"<i class='fi fi-rr-check-circle me-1'></i> Reorder logged for <strong>{ddlProduct.SelectedItem.Text}</strong>.";
            lblMessage.CssClass = "form-message success";
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            var results = LoadReorderRecords(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
            BindGrid(results);
        }
        protected void gvReorderAlerts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int stockInId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteRow")
            {
                DeleteStockInRecord(stockInId);
                BindGrid(LoadReorderRecords());

                lblMessage.Visible = true;
                lblMessage.Text = "<i class='fi fi-rr-trash me-1'></i> Record deleted successfully.";
                lblMessage.CssClass = "form-message error";
            }
        }
        private void CalculateShow(double avgDailyUse, double leadTimeDays, double safetyStock, double annualDemand, double setupCost, double holdingCost)
        {
            int eoq = holdingCost > 0
                ? (int)Math.Round(Math.Sqrt((2.0 * annualDemand * setupCost) / holdingCost))
                : 0;
            int rop = (int)Math.Round((avgDailyUse * leadTimeDays) + safetyStock);

            lblEOQ.Text = eoq.ToString("N0");
            lblROP.Text = rop.ToString("N0");
            lblSafetyBuffer.Text = ((int)safetyStock).ToString("N0");
        }
        private void BindGrid(List<ReorderRecord> records)
        {
            int alertCount = records.Count(r => r.Status == "TRIGGER REORDER");
            lblAlertCount.Text = alertCount.ToString();
            lblRecordCount.Text = records.Count.ToString();
            lblTotalRecords.Text = records.Count.ToString();

            gvReorderAlerts.DataSource = records;
            gvReorderAlerts.DataBind();
        }

        protected string GetQtyClass(object qtyObj, object ropObj)
        {
            if (qtyObj == null || ropObj == null) return "qty-ok";
            int qty = Convert.ToInt32(qtyObj);
            int rop = Convert.ToInt32(ropObj);
            if (qty <= rop * 0.4) return "qty-critical";
            if (qty <= rop) return "qty-low";
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
        public string Description { get; set; }
        public int Amount { get; set; }
        public int MinAmount { get; set; }
        public decimal CostPerUnit { get; set; }
        public decimal SellingPrice { get; set; }
        public string Category { get; set; }
        public int CalculatedEOQ { get; set; }
        public int CalculatedROP { get; set; }
        public string Status { get; set; }
    }
}
