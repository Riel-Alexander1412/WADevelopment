using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace WADevelopment
{
    public partial class Login : Page
    {
        string connStr => ConfigurationManager.ConnectionStrings["DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    Response.Redirect("~/StockManage.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                if (Request.QueryString["reason"] == "expired")
                {
                    lblError.Visible = true;
                    lblError.Text = "<i class='fi fi-rr-clock me-1'></i> Your session has expired. Please sign in again.";
                    Response.Redirect("~/Login.aspx", false);
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;  

            int userId = 0;
            string userFullName = string.Empty;
            string userRole = string.Empty;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT UserID, Name, Role
                    FROM   Users
                    WHERE  Name = @Username
                      AND  Password = @Password";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            userId = Convert.ToInt32(reader["UserID"]);
                            userFullName = reader["Name"].ToString();
                            userRole = reader["Role"].ToString();
                        }
                    }
                }
            }

            if (userId == 0)
            {
                lblError.Visible = true;
                lblError.Text = "<i class='fi fi-rr-cross-circle me-1'></i> Invalid username or password. Please try again.";
                txtPassword.Text = string.Empty;
                return;
            }

            Session["UserID"] = userId;
            Session["Username"] = username;
            Session["FullName"] = userFullName;
            Session["Role"] = userRole;
            Session["LoginTime"] = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            if (chkRemember.Checked)
            {
                HttpCookie cookie = new HttpCookie("ERP_RememberedUser", username)
                {
                    Expires = DateTime.Now.AddDays(30),
                    HttpOnly = true,
                    Secure = Request.IsSecureConnection
                };
                Response.Cookies.Add(cookie);
            }
            else
            {
                if (Request.Cookies["ERP_RememberedUser"] != null)
                {
                    HttpCookie expireCookie = new HttpCookie("ERP_RememberedUser")
                    {
                        Expires = DateTime.Now.AddDays(-1)
                    };
                    Response.Cookies.Add(expireCookie);
                }
            }

            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("/"))
                Response.Redirect(returnUrl, false);
            else
                Response.Redirect("~/Dashboard.aspx", false);

            Context.ApplicationInstance.CompleteRequest();
        }
    }
}