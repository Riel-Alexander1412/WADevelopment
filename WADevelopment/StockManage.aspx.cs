using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace WADevelopment
{
    public partial class StockManage : System.Web.UI.Page
    {
        string connStr => ConfigurationManager.ConnectionStrings["DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadProducts();
        }

        void LoadProducts()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Products ORDER BY ProductName", con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int productID = int.Parse(hfProductID.Value);

            if (productID == 0)
            {
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand chk = new SqlCommand("SELECT ProductID FROM Products WHERE SKU=@sku", con))
                {
                    chk.Parameters.AddWithValue("@sku", txtSKU.Text.Trim());
                    con.Open();
                    object result = chk.ExecuteScalar();
                    if (result != null)
                        productID = int.Parse(result.ToString());
                }
            }

            string sql = productID == 0
                ? "INSERT INTO Products (SKU, ProductName, UnitPrice) VALUES (@sku, @name, @price)"
                : "UPDATE Products SET SKU=@sku, ProductName=@name, UnitPrice=@price WHERE ProductID=@id";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@sku", txtSKU.Text.Trim());
                cmd.Parameters.AddWithValue("@name", txtProductName.Text.Trim());
                cmd.Parameters.AddWithValue("@price", decimal.Parse(txtUnitPrice.Text));
                if (productID != 0) cmd.Parameters.AddWithValue("@id", productID);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMsg.ForeColor = System.Drawing.Color.Green;
            lblMsg.Text = productID == 0 ? "Product added." : "Product updated.";
            ClearForm();
            LoadProducts();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rowIndex = int.Parse(e.CommandArgument.ToString());
            int productID = int.Parse(gvProducts.DataKeys[rowIndex].Value.ToString());

            if (e.CommandName == "EditProduct")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Products WHERE ProductID=@id", con))
                {
                    cmd.Parameters.AddWithValue("@id", productID);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfProductID.Value = productID.ToString();
                        txtSKU.Text = dr["SKU"].ToString();
                        txtProductName.Text = dr["ProductName"].ToString();
                        txtUnitPrice.Text = dr["UnitPrice"].ToString();
                        btnSave.Text = "Update Product";
                    }
                }
                lblMsg.Text = "";
            }
            else if (e.CommandName == "DeleteProduct")
            {
                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Products WHERE ProductID=@id", con))
                {
                    cmd.Parameters.AddWithValue("@id", productID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                lblMsg.ForeColor = System.Drawing.Color.Green;
                lblMsg.Text = "Product deleted.";
                LoadProducts();
            }
        }

        protected void btnClear_Click(object sender, EventArgs e) => ClearForm();

        void ClearForm()
        {
            hfProductID.Value = "0";
            txtSKU.Text = txtProductName.Text = txtUnitPrice.Text = "";
            btnSave.Text = "Add Product";
        }
    }
}