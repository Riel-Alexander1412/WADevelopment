using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WADevelopment
{
    public partial class StockIn : System.Web.UI.Page
    {
        private string connString => ConfigurationManager.ConnectionStrings["DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("~/Login.aspx", false);
                }
                PopulateProductsDropdown();
                PopulateUsersDropdown();
                RefreshSystemViewLogs();
            }
        }

        // Binds SKU and Name directly from your Products database table
        private void PopulateProductsDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT [SKU], [Name] FROM [dbo].[Products] ORDER BY [SKU] ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlSKU.DataSource = reader;
                            ddlSKU.DataValueField = "SKU";
                            ddlSKU.DataTextField = "Name";
                            ddlSKU.DataBind();
                        }
                    }
                    catch (Exception ex)
                    {
                        DisplayStatusAlert("Dropdown population failure (Products DB): " + ex.Message, false);
                    }
                }
            }
            ddlSKU.Items.Insert(0, new ListItem("-- Choose Product SKU --", ""));
        }

        private void PopulateUsersDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT [UserID], [Name] FROM [dbo].[Users] ORDER BY [UserID] ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlUser.DataSource = reader;
                            ddlUser.DataValueField = "UserID";
                            ddlUser.DataTextField = "Name";
                            ddlUser.DataBind();
                        }
                    }
                    catch (Exception ex)
                    {
                        DisplayStatusAlert("Dropdown population failure (Users DB): " + ex.Message, false);
                    }
                }
            }
            ddlUser.Items.Insert(0, new ListItem("-- Assign Verified Handler --", ""));
        }

        // --- NEW METHOD: PROCESSES NEW PRODUCT CREATION MASTER RECORD ---
        protected void btnCreateProduct_Click(object sender, EventArgs e)
        {
            string prodName = txtNewProdName.Text.Trim();
            string prodDesc = txtNewProdDesc.Text.Trim();
            string category = txtNewProdCategory.Text.Trim();

            if (string.IsNullOrEmpty(prodName))
            {
                DisplayStatusAlert("Validation Error: Product name is required.", false);
                return;
            }

            int minAmount = 0;
            int.TryParse(txtNewProdMin.Text.Trim(), out minAmount);

            decimal costPerUnit = 0;
            decimal.TryParse(txtNewProdCost.Text.Trim(), out costPerUnit);

            decimal sellingPrice = 0;
            decimal.TryParse(txtNewProdPrice.Text.Trim(), out sellingPrice);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Matches your exact columns [Name], [Description], [Amount], [MinAmount], [CostPerUnit], [SellingPrice], [Category]
                string insertProductSql = @"INSERT INTO [dbo].[Products] 
                    ([Name], [Description], [Amount], [MinAmount], [CostPerUnit], [SellingPrice], [Category]) 
                    VALUES (@Name, @Description, 0, @MinAmount, @CostPerUnit, @SellingPrice, @Category)";

                using (SqlCommand cmd = new SqlCommand(insertProductSql, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", prodName);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(prodDesc) ? (object)DBNull.Value : prodDesc);
                    cmd.Parameters.AddWithValue("@MinAmount", minAmount);
                    cmd.Parameters.AddWithValue("@CostPerUnit", costPerUnit);
                    cmd.Parameters.AddWithValue("@SellingPrice", sellingPrice);
                    cmd.Parameters.AddWithValue("@Category", string.IsNullOrEmpty(category) ? (object)DBNull.Value : category);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        DisplayStatusAlert($"Success: Product '{prodName}' has been permanently added to the master inventory catalog!", true);

                        // Clear creation fields
                        txtNewProdName.Text = string.Empty;
                        txtNewProdDesc.Text = string.Empty;
                        txtNewProdMin.Text = string.Empty;
                        txtNewProdCost.Text = string.Empty;
                        txtNewProdPrice.Text = string.Empty;
                        txtNewProdCategory.Text = string.Empty;

                        // CRITICAL: Refresh selection list so the item instantly shows up down below
                        PopulateProductsDropdown();
                    }
                    catch (Exception ex)
                    {
                        DisplayStatusAlert("Database Error creating product: " + ex.Message, false);
                    }
                }
            }
        }

        private void RefreshSystemViewLogs(string skuQueryFilter = "")
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string queryStr = @"SELECT s.[StockInID], s.[SKU], p.[Name] AS [ProductName], s.[Amount], u.[Name] AS [UserName], s.[User], s.[Date] 
                                    FROM [dbo].[StockIn] s
                                    INNER JOIN [dbo].[Products] p ON s.[SKU] = p.[SKU]
                                    INNER JOIN [dbo].[Users] u ON s.[User] = u.[UserID]";

                bool isNumericFilter = int.TryParse(skuQueryFilter, out int targetSku);

                if (isNumericFilter)
                {
                    queryStr += " WHERE s.[SKU] = @FilterSKU";
                }
                else if (!string.IsNullOrEmpty(skuQueryFilter))
                {
                    queryStr += " WHERE p.[Name] LIKE @FilterName";
                }

                queryStr += " ORDER BY s.[StockInID] DESC";

                using (SqlCommand cmd = new SqlCommand(queryStr, conn))
                {
                    if (isNumericFilter)
                    {
                        cmd.Parameters.AddWithValue("@FilterSKU", targetSku);
                    }
                    else if (!string.IsNullOrEmpty(skuQueryFilter))
                    {
                        cmd.Parameters.AddWithValue("@FilterName", "%" + skuQueryFilter + "%");
                    }

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        gvStockInLogs.DataSource = dt;
                        gvStockInLogs.DataBind();

                        ExecuteDatabaseMetricsAnalysis(dt);
                    }
                }
            }
        }

        private void ExecuteDatabaseMetricsAnalysis(DataTable currentGridSource)
        {
            int totalAccumulatedVolume = 0;
            int totalActiveRecordCount = currentGridSource.Rows.Count;

            foreach (DataRow row in currentGridSource.Rows)
            {
                if (row["Amount"] != DBNull.Value)
                {
                    totalAccumulatedVolume += Convert.ToInt32(row["Amount"]);
                }
            }

            litCalculatedTotal.Text = string.Format("{0:N0} Units", totalAccumulatedVolume);
            litRowCount.Text = string.Format("{0:N0} Records", totalActiveRecordCount);
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlSKU.SelectedValue) || !int.TryParse(ddlSKU.SelectedValue, out int skuId))
            {
                DisplayStatusAlert("Validation Error: Please choose a verified Product SKU.", false);
                return;
            }
            if (!int.TryParse(txtAmount.Text.Trim(), out int inputAmount) || inputAmount <= 0)
            {
                DisplayStatusAlert("Validation Error: Quantity amount must be a positive non-zero integer.", false);
                return;
            }
            if (string.IsNullOrEmpty(ddlUser.SelectedValue) || !int.TryParse(ddlUser.SelectedValue, out int userId))
            {
                DisplayStatusAlert("Validation Error: Transaction requires an authenticated Handler assignment.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        bool isUpdate = !string.IsNullOrEmpty(hfStockInID.Value);

                        if (!isUpdate)
                        {
                            string insertSql = "INSERT INTO [dbo].[StockIn] ([SKU], [Amount], [User], [Date]) VALUES (@SKU, @Amount, @User, GETDATE())";
                            using (SqlCommand cmd = new SqlCommand(insertSql, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@SKU", skuId);
                                cmd.Parameters.AddWithValue("@Amount", inputAmount);
                                cmd.Parameters.AddWithValue("@User", userId);
                                cmd.ExecuteNonQuery();
                            }

                            string updateProductSql = "UPDATE [dbo].[Products] SET [Amount] = [Amount] + @Amount WHERE [SKU] = @SKU";
                            using (SqlCommand cmdProduct = new SqlCommand(updateProductSql, conn, transaction))
                            {
                                cmdProduct.Parameters.AddWithValue("@Amount", inputAmount);
                                cmdProduct.Parameters.AddWithValue("@SKU", skuId);
                                cmdProduct.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            int stockInId = Convert.ToInt32(hfStockInID.Value);
                            int originalAmount = 0;
                            int originalSku = 0;

                            string fetchSql = "SELECT [SKU], [Amount] FROM [dbo].[StockIn] WHERE [StockInID] = @StockInID";
                            using (SqlCommand fetchCmd = new SqlCommand(fetchSql, conn, transaction))
                            {
                                fetchCmd.Parameters.AddWithValue("@StockInID", stockInId);
                                using (SqlDataReader reader = fetchCmd.ExecuteReader())
                                {
                                    if (reader.Read())
                                    {
                                        originalSku = Convert.ToInt32(reader["SKU"]);
                                        originalAmount = Convert.ToInt32(reader["Amount"]);
                                    }
                                }
                            }

                            string revertProductSql = "UPDATE [dbo].[Products] SET [Amount] = [Amount] - @OldAmount WHERE [SKU] = @OldSKU";
                            using (SqlCommand revertCmd = new SqlCommand(revertProductSql, conn, transaction))
                            {
                                revertCmd.Parameters.AddWithValue("@OldAmount", originalAmount);
                                revertCmd.Parameters.AddWithValue("@OldSKU", originalSku);
                                revertCmd.ExecuteNonQuery();
                            }

                            string updateSql = "UPDATE [dbo].[StockIn] SET [SKU] = @SKU, [Amount] = @Amount, [User] = @User WHERE [StockInID] = @StockInID";
                            using (SqlCommand cmd = new SqlCommand(updateSql, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@StockInID", stockInId);
                                cmd.Parameters.AddWithValue("@SKU", skuId);
                                cmd.Parameters.AddWithValue("@Amount", inputAmount);
                                cmd.Parameters.AddWithValue("@User", userId);
                                cmd.ExecuteNonQuery();
                            }

                            string applyNewProductSql = "UPDATE [dbo].[Products] SET [Amount] = [Amount] + @NewAmount WHERE [SKU] = @NewSKU";
                            using (SqlCommand applyCmd = new SqlCommand(applyNewProductSql, conn, transaction))
                            {
                                applyCmd.Parameters.AddWithValue("@NewAmount", inputAmount);
                                applyCmd.Parameters.AddWithValue("@NewSKU", skuId);
                                applyCmd.ExecuteNonQuery();
                            }
                        }

                        transaction.Commit();
                        DisplayStatusAlert("System Notification: Ledger reference log committed and inventory levels updated in Product database.", true);

                        ResetFormStateConfig();
                        RefreshSystemViewLogs();
                    }
                    catch (Exception ex)
                    {
                        if (transaction != null && transaction.Connection != null)
                        {
                            transaction.Rollback();
                        }
                        DisplayStatusAlert("Database Transaction Failure: " + ex.Message, false);
                    }
                }
            }
        }

        protected void gvStockInLogs_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int stockInId = Convert.ToInt32(gvStockInLogs.DataKeys[e.NewEditIndex].Value);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string findRowSql = "SELECT [StockInID], [SKU], [Amount], [User] FROM [dbo].[StockIn] WHERE [StockInID] = @StockInID";
                using (SqlCommand cmd = new SqlCommand(findRowSql, conn))
                {
                    cmd.Parameters.AddWithValue("@StockInID", stockInId);
                    conn.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        if (sdr.Read())
                        {
                            hfStockInID.Value = sdr["StockInID"].ToString();

                            string incomingSku = sdr["SKU"].ToString();
                            if (ddlSKU.Items.FindByValue(incomingSku) != null) ddlSKU.SelectedValue = incomingSku;

                            txtAmount.Text = sdr["Amount"].ToString();

                            string incomingUser = sdr["User"].ToString();
                            if (ddlUser.Items.FindByValue(incomingUser) != null) ddlUser.SelectedValue = incomingUser;

                            litFormTitle.Text = "Modify Transaction Reference Entity #" + hfStockInID.Value;
                            btnSubmit.Text = "Apply Ledger Changes";
                        }
                    }
                }
            }
            e.Cancel = true;
        }

        protected void gvStockInLogs_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int targetStockInId = Convert.ToInt32(gvStockInLogs.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        int targetSku = 0;
                        int targetAmount = 0;

                        string findSql = "SELECT [SKU], [Amount] FROM [dbo].[StockIn] WHERE [StockInID] = @StockInID";
                        using (SqlCommand findCmd = new SqlCommand(findSql, conn, transaction))
                        {
                            findCmd.Parameters.AddWithValue("@StockInID", targetStockInId);
                            using (SqlDataReader reader = findCmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    targetSku = Convert.ToInt32(reader["SKU"]);
                                    targetAmount = Convert.ToInt32(reader["Amount"]);
                                }
                            }
                        }

                        string deductProductSql = "UPDATE [dbo].[Products] SET [Amount] = [Amount] - @Amount WHERE [SKU] = @SKU";
                        using (SqlCommand deductCmd = new SqlCommand(deductProductSql, conn, transaction))
                        {
                            deductCmd.Parameters.AddWithValue("@Amount", targetAmount);
                            deductCmd.Parameters.AddWithValue("@SKU", targetSku);
                            deductCmd.ExecuteNonQuery();
                        }

                        string deleteSql = "DELETE FROM [dbo].[StockIn] WHERE [StockInID] = @StockInID";
                        using (SqlCommand cmd = new SqlCommand(deleteSql, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@StockInID", targetStockInId);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();
                        DisplayStatusAlert(string.Format("Success Notice: Transaction log record #{0} removed and database quantities recalculated.", targetStockInId), true);
                        RefreshSystemViewLogs();
                    }
                    catch (Exception ex)
                    {
                        if (transaction != null && transaction.Connection != null)
                        {
                            transaction.Rollback();
                        }
                        DisplayStatusAlert("System Deletion Restriction Warning: " + ex.Message, false);
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            RefreshSystemViewLogs(txtSearch.Text.Trim());
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetFormStateConfig();
        }

        private void ResetFormStateConfig()
        {
            hfStockInID.Value = string.Empty;
            if (ddlSKU.Items.Count > 0) ddlSKU.SelectedIndex = 0;
            txtAmount.Text = string.Empty;
            if (ddlUser.Items.Count > 0) ddlUser.SelectedIndex = 0;
            litFormTitle.Text = "Register Stock Intake";
            btnSubmit.Text = "Post Inward Stock";
        }

        private void DisplayStatusAlert(string messageText, bool isOperationSuccessful)
        {
            lblStatusMessage.Visible = true;
            lblStatusMessage.Text = messageText;
            if (isOperationSuccessful)
            {
                lblStatusMessage.CssClass = "block mb-6 p-4 rounded-xl text-xs font-semibold shadow-xs bg-emerald-50 text-emerald-700 border border-emerald-200";
            }
            else
            {
                lblStatusMessage.CssClass = "block mb-6 p-4 rounded-xl text-xs font-semibold shadow-xs bg-rose-50 text-rose-700 border border-rose-200";
            }
        }
    }
}