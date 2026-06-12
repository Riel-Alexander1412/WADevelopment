using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing;
using System.Web.UI.WebControls;

namespace WADevelopment
{
    public partial class StockManage : System.Web.UI.Page
    {
        string connStr => ConfigurationManager.ConnectionStrings["DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle AJAX search request
            if (Request.QueryString["action"] == "search")
            {
                string keyword = Request.QueryString["q"] ?? "";
                string category = Request.QueryString["cat"] ?? "All";
                Response.Clear();
                Response.ContentType = "application/json";
                Response.Write(GetProductsJson(keyword, category));
                Response.End();
                return;
            }

            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx", false);
                }
                LoadProducts();
                RefreshSummaryCard();
                PopulateCategoryFilter();
            }
        }

        // ── Data loading ──────────────────────────────────────────────────────

        void LoadProducts(string keyword = "", string category = "All")
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT SKU, Name, Description, Amount, MinAmount,
                           CostPerUnit, SellingPrice, Category
                    FROM   Products
                    WHERE  (@Keyword = '' OR Name LIKE @Search OR Category LIKE @Search)
                      AND  (@Category = 'All' OR Category = @Category)
                    ORDER  BY Name ASC";

                using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@Keyword", keyword ?? "");
                    da.SelectCommand.Parameters.AddWithValue("@Search", "%" + (keyword ?? "") + "%");
                    da.SelectCommand.Parameters.AddWithValue("@Category", category ?? "All");

                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvProducts.DataSource = dt;
                    gvProducts.DataBind();

                    lblRecordCount.Text = dt.Rows.Count.ToString();
                    lblTotalRecords.Text = dt.Rows.Count.ToString();
                    lblProductCount.Text = dt.Rows.Count.ToString();
                }
            }
        }

        void RefreshSummaryCard()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT
                        SUM(CAST(Amount AS DECIMAL(18,2)) * CostPerUnit)  AS TotalNetWorth,
                        SUM(CAST(Amount AS DECIMAL(18,2)) * SellingPrice) AS TotalSellValue,
                        COUNT(*)                                           AS TotalSKUs
                    FROM Products";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            decimal netWorth = dr["TotalNetWorth"] != DBNull.Value ? Convert.ToDecimal(dr["TotalNetWorth"]) : 0;
                            decimal sellValue = dr["TotalSellValue"] != DBNull.Value ? Convert.ToDecimal(dr["TotalSellValue"]) : 0;
                            int totalSKUs = dr["TotalSKUs"] != DBNull.Value ? Convert.ToInt32(dr["TotalSKUs"]) : 0;

                            lblTotalNetWorth.Text = netWorth.ToString("N2");
                            lblTotalSellValue.Text = sellValue.ToString("N2");
                            lblTotalSKUs.Text = totalSKUs.ToString();
                        }
                    }
                }
            }
        }

        void PopulateCategoryFilter()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT DISTINCT Category FROM Products WHERE Category IS NOT NULL ORDER BY Category", con))
            {
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlCategoryFilter.Items.Clear();
                    ddlCategoryFilter.Items.Add(new ListItem("All Categories", "All"));
                    while (dr.Read())
                        ddlCategoryFilter.Items.Add(new ListItem(dr["Category"].ToString(), dr["Category"].ToString()));
                }
            }
        }

        // ── Save (Insert / Update) ────────────────────────────────────────────

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!decimal.TryParse(txtCostPerUnit.Text, out decimal cost))
            {
                ShowMessage("Invalid cost value.", false); return;
            }
            if (!decimal.TryParse(txtSellingPrice.Text, out decimal price))
            {
                ShowMessage("Invalid selling price value.", false); return;
            }
            if (!int.TryParse(txtAmount.Text, out int amount))
            {
                ShowMessage("Invalid amount value.", false); return;
            }
            if (!int.TryParse(txtMinAmount.Text, out int minAmount))
            {
                ShowMessage("Invalid minimum amount value.", false); return;
            }

            int sku = int.Parse(hfSKU.Value);
            string sql = sku == 0
                ? @"INSERT INTO Products (Name, Description, Amount, MinAmount, CostPerUnit, SellingPrice, Category)
                    VALUES (@name, @desc, @amount, @minAmount, @cost, @price, @category)"
                : @"UPDATE Products
                    SET Name=@name, Description=@desc, Amount=@amount, MinAmount=@minAmount,
                        CostPerUnit=@cost, SellingPrice=@price, Category=@category
                    WHERE SKU=@sku";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@desc", string.IsNullOrWhiteSpace(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@amount", amount);
                cmd.Parameters.AddWithValue("@minAmount", minAmount);
                cmd.Parameters.AddWithValue("@cost", cost);
                cmd.Parameters.AddWithValue("@price", price);
                cmd.Parameters.AddWithValue("@category", string.IsNullOrWhiteSpace(txtCategory.Text) ? (object)DBNull.Value : txtCategory.Text.Trim());
                if (sku != 0) cmd.Parameters.AddWithValue("@sku", sku);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ShowMessage(sku == 0 ? "Product added successfully." : "Product updated successfully.", true);
            ClearForm();
            LoadProducts();
            RefreshSummaryCard();
            PopulateCategoryFilter();
        }

        // ── GridView row commands ─────────────────────────────────────────────

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = int.Parse(e.CommandArgument.ToString());
            int sku = int.Parse(gvProducts.DataKeys[rowIndex].Value.ToString());

            if (e.CommandName == "EditProduct")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Products WHERE SKU=@sku", con))
                {
                    cmd.Parameters.AddWithValue("@sku", sku);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfSKU.Value = sku.ToString();
                            txtName.Text = dr["Name"].ToString();
                            txtDescription.Text = dr["Description"].ToString();
                            txtAmount.Text = dr["Amount"].ToString();
                            txtMinAmount.Text = dr["MinAmount"].ToString();
                            txtCostPerUnit.Text = dr["CostPerUnit"].ToString();
                            txtSellingPrice.Text = dr["SellingPrice"].ToString();
                            txtCategory.Text = dr["Category"].ToString();
                            btnSave.Text = "Update Product";
                        }
                    }
                }
                ShowMessage($"Editing SKU {sku}. Make your changes and click Update Product.", true);
            }
            else if (e.CommandName == "DeleteProduct")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    // Check if product has any StockIn records
                    string checkStockIn = "SELECT COUNT(*) FROM StockIn WHERE SKU = @sku";
                    using (SqlCommand checkCmd = new SqlCommand(checkStockIn, con))
                    {
                        checkCmd.Parameters.AddWithValue("@sku", sku);
                        int stockInCount = (int)checkCmd.ExecuteScalar();

                        if (stockInCount > 0)
                        {
                            ShowMessage($"❌ Cannot delete this product. It has {stockInCount} Stock In record(s).", false);
                            return;
                        }
                    }

                    // Check if product has any StockOut records
                    string checkStockOut = "SELECT COUNT(*) FROM StockOut WHERE SKU = @sku";
                    using (SqlCommand checkCmd = new SqlCommand(checkStockOut, con))
                    {
                        checkCmd.Parameters.AddWithValue("@sku", sku);
                        int stockOutCount = (int)checkCmd.ExecuteScalar();

                        if (stockOutCount > 0)
                        {
                            ShowMessage($"❌ Cannot delete this product. It has {stockOutCount} Stock Out record(s).", false);
                            return;
                        }
                    }

                    // If we get here, safe to delete
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Products WHERE SKU=@sku", con))
                    {
                        cmd.Parameters.AddWithValue("@sku", sku);
                        cmd.ExecuteNonQuery();
                    }
                }
                ShowMessage("Product deleted successfully.", false);
                LoadProducts();
                RefreshSummaryCard();
                PopulateCategoryFilter();
            }
        }

        // ── Search / Filter ───────────────────────────────────────────────────

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts(txtSearch.Text.Trim(), ddlCategoryFilter.SelectedValue);
        }

        // ── Clear form ────────────────────────────────────────────────────────

        protected void btnClear_Click(object sender, EventArgs e) => ClearForm();

        void ClearForm()
        {
            hfSKU.Value = "0";
            txtName.Text = txtDescription.Text = txtAmount.Text = "";
            txtMinAmount.Text = txtCostPerUnit.Text = txtSellingPrice.Text = txtCategory.Text = "";
            btnSave.Text = "Add Product";
            lblMsg.Visible = false;
        }

        // ── UI helpers ────────────────────────────────────────────────────────

        void ShowMessage(string text, bool success)
        {
            lblMsg.Visible = true;
            lblMsg.Text = text;
            lblMsg.CssClass = "form-message d-block mt-3 " + (success ? "success" : "error");
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

        string GetProductsJson(string keyword, string category)
        {
            var sb = new System.Text.StringBuilder();
            sb.Append("[");
            bool first = true;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT SKU, Name, Description, Amount, MinAmount,
                           CostPerUnit, SellingPrice, Category
                    FROM   Products
                    WHERE  (@Keyword = '' OR Name LIKE @Search OR Category LIKE @Search)
                      AND  (@Category = 'All' OR Category = @Category)
                    ORDER  BY Name ASC";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@Keyword", keyword);
                    cmd.Parameters.AddWithValue("@Search", "%" + keyword + "%");
                    cmd.Parameters.AddWithValue("@Category", category);
                    con.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            if (!first) sb.Append(",");
                            first = false;

                            string name = dr["Name"].ToString().Replace("\"", "\\\"");
                            string desc = dr["Description"].ToString().Replace("\"", "\\\"");
                            string category_ = dr["Category"] == DBNull.Value ? "" : dr["Category"].ToString().Replace("\"", "\\\"");

                            sb.Append("{");
                            sb.AppendFormat("\"sku\":{0},", dr["SKU"]);
                            sb.AppendFormat("\"name\":\"{0}\",", name);
                            sb.AppendFormat("\"description\":\"{0}\",", desc);
                            sb.AppendFormat("\"amount\":{0},", dr["Amount"]);
                            sb.AppendFormat("\"minAmount\":{0},", dr["MinAmount"]);
                            sb.AppendFormat("\"costPerUnit\":{0},", dr["CostPerUnit"]);
                            sb.AppendFormat("\"sellingPrice\":{0},", dr["SellingPrice"]);
                            sb.AppendFormat("\"category\":\"{0}\"", category_);
                            sb.Append("}");
                        }
                    }
                }
            }

            sb.Append("]");
            return sb.ToString();
        }
    }
}