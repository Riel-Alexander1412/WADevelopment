
protected void Page_Load(object sender, EventArgs e)
{
    // Handle AJAX delete request
    if (Request.HttpMethod == "POST" && Request.QueryString["action"] == "delete")
    {
        string skuParam = Request.QueryString["sku"];
        if (!string.IsNullOrEmpty(skuParam) && int.TryParse(skuParam, out int sku))
        {
            Response.Clear();
            Response.ContentType = "application/json";
            
            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Products WHERE SKU=@sku", con))
                {
                    cmd.Parameters.AddWithValue("@sku", sku);
                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    
                    if (rowsAffected > 0)
                    {
                        Response.Write("{\"success\": true, \"message\": \"Product deleted successfully.\"}");
                    }
                    else
                    {
                        Response.Write("{\"success\": false, \"message\": \"Product not found.\"}");
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("{\"success\": false, \"message\": \"" + ex.Message.Replace("\"", "\\\"") + "\"}");
            }
            
            Response.End();
            return;
        }
    }
    
    if (Request.QueryString["action"] == "search")
    {
    }
    
    if (!IsPostBack)
    {
        LoadProducts();
        RefreshSummaryCard();
        PopulateCategoryFilter();
    }
}