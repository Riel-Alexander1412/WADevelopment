<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WADevelopment.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login — Maju Jaya Agrotech ERP</title>

    <link rel="icon" href="/Assets/icon.jpg" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-solid-rounded/css/uicons-solid-rounded.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" />
    <link rel="stylesheet" href="/CSS/Login.css" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="login-body">
    <div class="login-bg-grid" aria-hidden="true"></div>
    <div class="login-orb login-orb-1" aria-hidden="true"></div>
    <div class="login-orb login-orb-2" aria-hidden="true"></div>

    <form id="form1" runat="server">

        <div class="login-wrapper">
            <div class="login-brand">
                <div class="login-brand-icon">
                    <i class="fi fi-rr-boxes"></i>
                </div>
                <div>
                    <span class="login-brand-name">Maju Jaya Agrotech Supplies</span>
                    <span class="login-brand-sub">ERP Prototype Suite</span>
                </div>
            </div>
            <div class="login-card">
                <div class="login-card-header">
                    <h1 class="login-title">Welcome back</h1>
                    <p class="login-subtitle">Sign in to access the Inventory Hub</p>
                </div>
                <asp:Label ID="lblError" runat="server"
                    CssClass="login-alert login-alert-error"
                    Visible="false" />

                <asp:Label ID="lblSuccess" runat="server"
                    CssClass="login-alert login-alert-success"
                    Visible="false" />
                <div class="login-field">
                    <label for="txtUsername" class="login-label">
                        <i class="fi fi-rr-user me-1"></i> USERNAME
                    </label>
                    <div class="login-input-wrap">
                        <asp:TextBox ID="txtUsername" runat="server"
                            CssClass="login-input"
                            placeholder="Enter your username"
                            MaxLength="50"
                            AutoComplete="username" />
                        <span class="login-input-icon"><i class="fi fi-rr-user"></i></span>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                        ControlToValidate="txtUsername"
                        CssClass="login-field-error"
                        ErrorMessage="Username is required."
                        Display="Dynamic">
                        <i class="fi fi-rr-exclamation me-1"></i> Username is required.
                    </asp:RequiredFieldValidator>
                </div>
                <div class="login-field">
                    <label for="txtPassword" class="login-label">
                        <i class="fi fi-rr-lock me-1"></i> PASSWORD
                    </label>
                    <div class="login-input-wrap">
                        <asp:TextBox ID="txtPassword" runat="server"
                            CssClass="login-input login-input-pw"
                            TextMode="Password"
                            placeholder="Enter your password"
                            MaxLength="100"
                            AutoComplete="current-password" />
                        <span class="login-input-icon"><i class="fi fi-rr-lock"></i></span>
                        <button type="button" class="login-pw-toggle" onclick="togglePassword()" tabindex="-1" aria-label="Toggle password visibility">
                            <i class="fi fi-rr-eye" id="pwToggleIcon"></i>
                        </button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        CssClass="login-field-error"
                        ErrorMessage="Password is required."
                        Display="Dynamic">
                        <i class="fi fi-rr-exclamation me-1"></i> Password is required.
                    </asp:RequiredFieldValidator>
                </div>
                <div class="login-remember d-flex align-items-center justify-content-between mb-4">
                    <label class="login-check-label">
                        <asp:CheckBox ID="chkRemember" runat="server" CssClass="login-checkbox" />
                        <span>Remember me</span>
                    </label>
                    <a href="#" class="login-forgot">Forgot password?</a>
                </div>
                <asp:Button ID="btnLogin" runat="server"
                    CssClass="btn login-btn"
                    Text="Sign In"
                    OnClick="btnLogin_Click"
                    OnClientClick="return validateLoginJS();" />
                <div class="login-divider">
                    <span>or</span>
                </div>
                <p class="login-register-row">
                    Don't have an account?
                    <a href="#" class="login-register-link">Contact your administrator</a>
                </p>

            </div>
            <p class="login-footer-note">
                <i class="fi fi-rr-shield-check me-1"></i>
                Secured session • Maju Jaya Agrotech Supplies Sdn. Bhd. © 2026
            </p>

        </div>

    </form>

    <script>
        function togglePassword() {
            var input = document.getElementById('<%= txtPassword.ClientID %>');
            var icon  = document.getElementById('pwToggleIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fi fi-rr-eye-crossed';
            } else {
                input.type = 'password';
                icon.className = 'fi fi-rr-eye';
            }
        }

        function validateLoginJS() {
            var username = document.getElementById('<%= txtUsername.ClientID %>').value.trim();
            var password = document.getElementById('<%= txtPassword.ClientID %>').value;
            var errors   = [];

            if (!username) errors.push('Username is required.');
            if (!password) errors.push('Password is required.');
            if (password.length > 0 && password.length < 4)
                errors.push('Password must be at least 4 characters.');

            if (errors.length > 0) {
                alert('Please fix the following:\n\n• ' + errors.join('\n• '));
                return false;
            }
            return true;
        }
    </script>
</body>
</html>