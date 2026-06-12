<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StockOut.aspx.cs" Inherits="WADevelopment.StockOut" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Module 3: Stock Out Management</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-solid-rounded/css/uicons-solid-rounded.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-bold-rounded/css/uicons-bold-rounded.css" />
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" />
    <link rel="stylesheet" href="/CSS/StockOut.css" />
</head>
<body>

    <nav class="site-topbar">
        <div class="container-fluid px-4">
            <div class="d-flex align-items-center justify-content-between">
                <a href="#" class="topbar-brand">
                    <i class="fi fi-rr-boxes me-2"></i>
                    <span>Maju Jaya Agrotech Supplies</span>
                </a>
                <div class="topbar-links d-none d-md-flex align-items-center gap-3">
                    <a href="#" class="topbar-link"><i class="fi fi-rr-home me-1"></i> Dashboard</a>
                    <a href="Stok" class="topbar-link active"><i class="fi fi-rr-layers me-1"></i> Inventory Hub</a>
                    <a href="#" class="topbar-link"><i class="fi fi-rr-chart-histogram me-1"></i> Reports</a>
                    <a href="#" class="topbar-link"><i class="fi fi-rr-settings me-1"></i> Settings</a>
                </div>
                <div class="topbar-user d-flex align-items-center gap-2">
                    <span class="user-badge">Person 3</span>
                    <a href="#" class="btn btn-sm btn-outline-light"><i class="fi fi-rr-sign-out-alt"></i></a>
                </div>
            </div>
        </div>
    </nav>

    <form id="form1" runat="server">

        <asp:ValidationSummary ID="valSummary" runat="server"
            CssClass="validation-summary container-fluid px-4 pt-3"
            HeaderText="Please resolve the following input issues:"
            DisplayMode="BulletList"
            ShowMessageBox="false"
            ShowSummary="true" />

        <header class="page-header">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                    <div>
                        <nav aria-label="breadcrumb" class="mb-1">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item">
                                    <a href="StockManage.aspx" class="breadcrumb-link">
                                        <i class="fi fi-rr-angle-left me-1"></i> Inventory Hub
                                    </a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Stock Out Management</li>
                            </ol>
                        </nav>
                        <h1 class="page-title mb-0">Stock Out Management</h1>
                        <p class="page-meta mb-0">
                            Responsible Developer: <strong>Ikhmal</strong>
                            <span class="mx-2">•</span> Manage Stocks Outbound
                        </p>
                    </div>
                    <a href="#" class="btn btn-dispatches">
                        <i class="fi fi-rr-paper-plane me-2"></i> Dispatches
                    </a>
                </div>
            </div>
        </header>

        <main class="main-content">
            <div class="container-fluid px-4">
                <div class="row g-4">

                    <div class="col-12 col-lg-4">
                        <div class="card param-card h-100">
                            <div class="card-body p-4">
                                <div class="d-flex align-items-start gap-3 mb-1">
                                    <div class="param-icon-wrap">
                                        <i class="fi fi-rr-add-document"></i>
                                    </div>
                                    <div>
                                        <h2 class="param-title mb-0">Record Outbound Stock</h2>
                                    </div>
                                </div>

                                <hr class="param-divider" />

                                <asp:HiddenField ID="hfIsEdit" runat="server" Value="false" />
                                <asp:HiddenField ID="hfStockOutId" runat="server" />

                                <div class="mb-3">
                                    <label for="txtStockOutIdDisplay" class="field-label">
                                        <i class="fi fi-rr-id-badge me-1"></i> DISPATCH CODE
                                    </label>
                                    <div class="input-with-icon">
                                        <asp:TextBox ID="txtStockOutIdDisplay" runat="server"
                                            CssClass="form-control field-input font-monospace text-muted bg-light"
                                            Enabled="false"
                                            placeholder="Auto-Generated on Save" />
                                        <span class="input-icon-right"><i class="fi fi-rr-fingerprint"></i></span>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="ddlProduct" class="field-label">
                                        <i class="fi fi-rr-box-open me-1"></i> SELECT PRODUCT
                                    </label>
                                    <div class="input-with-icon">
                                        <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-select field-input" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvProduct" runat="server"
                                        ControlToValidate="ddlProduct"
                                        InitialValue=""
                                        CssClass="field-error"
                                        ErrorMessage="Please select an inventory product SKU."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Please select a product.
                                    </asp:RequiredFieldValidator>
                                </div>

                                <div class="row g-3 mb-4">
                                    <div class="col-6">
                                        <label for="txtAmount" class="field-label">
                                            <i class="fi fi-rr-boxes me-1"></i> QUANTITY
                                        </label>
                                        <asp:TextBox ID="txtAmount" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="50"
                                            MaxLength="6" />
                                        <asp:RequiredFieldValidator ID="rfvAmount" runat="server"
                                            ControlToValidate="txtAmount"
                                            CssClass="field-error"
                                            ErrorMessage="Dispatched amount is required."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rvAmount" runat="server"
                                            ControlToValidate="txtAmount"
                                            Type="Integer"
                                            MinimumValue="1"
                                            MaximumValue="99999"
                                            CssClass="field-error"
                                            ErrorMessage="Quantity must be between 1 and 99999."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Invalid range.
                                        </asp:RangeValidator>
                                    </div>
                                    <div class="col-6">
                                        <label for="ddlUser" class="field-label">
                                            <i class="fi fi-rr-user me-1"></i> OPERATOR ID
                                        </label>
                                        <asp:DropDownList ID="ddlUser" runat="server" CssClass="form-select field-input" />
                                        <asp:RequiredFieldValidator ID="rfvUser" runat="server"
                                            ControlToValidate="ddlUser"
                                            InitialValue=""
                                            CssClass="field-error"
                                            ErrorMessage="Please select an operational user."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Select user.
                                        </asp:RequiredFieldValidator>
                                    </div>
                                    <div class="col-6">
    <label for="ddlType" class="field-label">
        <i class="fi fi-rr-settings-sliders me-1"></i> OUTBOUND TYPE
    </label>
    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select field-input">
        <asp:ListItem Text="Order Fulfillment" Value="Order Fulfillment" />
        <asp:ListItem Text="Product Loss" Value="Product Loss" />
    </asp:DropDownList>
</div>
                                </div>

                                <div class="mb-4">
                                    <label for="txtDate" class="field-label">
                                        <i class="fi fi-rr-calendar me-1"></i> DISPATCH DATE
                                    </label>
                                    <div class="input-with-icon">
                                        <asp:TextBox ID="txtDate" runat="server"
                                            CssClass="form-control field-input"
                                            TextMode="Date" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                                        ControlToValidate="txtDate"
                                        CssClass="field-error"
                                        ErrorMessage="Outflow date must be selected."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Date is required.
                                    </asp:RequiredFieldValidator>
                                </div>

                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnConfirmDispatch" runat="server"
                                        CssClass="btn btn-confirm flex-grow-1"
                                        Text="Confirm Dispatch"
                                        OnClick="btnConfirmDispatch_Click" />
                                    <asp:Button ID="btnReset" runat="server"
                                        CssClass="btn btn-reset-form"
                                        Text="Cancel"
                                        CausesValidation="false"
                                        OnClick="btnReset_Click" />
                                </div>

                                <asp:Label ID="lblMessage" runat="server" CssClass="form-message mt-3 d-block" Visible="false" />
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <div class="card analytics-card">
                            <div class="analytics-card-inner">
                                <div class="d-flex align-items-start justify-content-between mb-2 flex-wrap gap-2">
                                    <span class="analytics-badge">
                                        <i class="fi fi-rr-cpu me-1"></i> SHRINKAGE ANALYTICS
                                    </span>
                                    <span class="analytics-suite-label">Inventory Loss Control</span>
                                </div>

                                <h2 class="analytics-title">
                                    Shrinkage Calculator
                                </h2>

                                <div class="formula-row flex-wrap">
                                    <code class="formula-chip">Shrinkage Rate = (Damaged Value ÷ Total Inventory Value) × 100</code>
                                </div>

                                <div class="row g-0 mt-4 analytics-metrics-row">
                                    <div class="col-4">
                                        <div class="analytics-metric-block">
                                            <span class="analytics-metric-label">TOTAL DAMAGED LOSSES</span>
                                            <span class="analytics-metric-value red">
                                                RM <asp:Label ID="lblTotalLoss" runat="server" Text="0.00" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="analytics-metric-block analytics-metric-border">
                                            <span class="analytics-metric-label">SHRINKAGE RATE</span>
                                            <span class="analytics-metric-value green">
                                                <asp:Label ID="lblShrinkageRate" runat="server" Text="0.0%" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="analytics-metric-block">
                                            <span class="analytics-metric-label">TOTAL STOCK OUT COUNT</span>
                                            <span class="analytics-metric-value text-white">
                                                <asp:Label ID="lblTotalOutCount" runat="server" Text="0" />
                                                <small class="analytics-unit">Units</small>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card reorder-table-card">
                            <div class="card-body p-0">
                                <div class="reorder-table-header d-flex align-items-start justify-content-between flex-wrap gap-2 p-4 pb-3">
                                    <div>
                                        <h3 class="reorder-table-title mb-0">
                                            <i class="fi fi-rr-bell me-2"></i>
                                            Outbound Activity Logs
                                        </h3>
                                    </div>
                                    <span class="alert-badge-pill">
                                        <i class="fi fi-rr-paper-plane me-1"></i>
                                        <asp:Label ID="lblOutboundCount" runat="server" Text="0" /> LOGS
                                    </span>
                                </div>

                                <div class="px-4 pb-3 d-flex gap-2 flex-wrap">
                                    <div class="search-wrap flex-grow-1">
                                        <i class="fi fi-rr-search search-icon"></i>
                                        <asp:TextBox ID="txtSearch" runat="server"
                                            CssClass="form-control search-input"
                                            placeholder="Search product code or name..."
                                            AutoComplete="off" />
                                    </div>
                                    <asp:Button ID="btnSearch" runat="server"
                                        CssClass="btn btn-filter"
                                        Text="Filter"
                                        CausesValidation="false"
                                        OnClick="btnSearch_Click" />
                                    <asp:Button ID="btnClearSearch" runat="server"
                                        CssClass="btn btn-filter bg-secondary text-white"
                                        Text="Reset"
                                        CausesValidation="false"
                                        OnClick="btnClearSearch_Click" />
                                </div>

                                <div class="table-responsive">
                                    <asp:GridView ID="gvStockOutLogs" runat="server"
                                        CssClass="table reorder-table mb-0"
                                        AutoGenerateColumns="false"
                                        DataKeyNames="StockOutID"
                                        GridLines="None"
                                        OnRowCommand="gvStockOutLogs_RowCommand"
                                        EmptyDataText="No outbound logs registered. Record an operational stock out to populate."
                                        EmptyDataRowStyle-CssClass="empty-row">
                                        <Columns>
                                            <asp:TemplateField HeaderText="DISPATCH CODE">
                                                <ItemTemplate>
                                                    <span class="bold-cell">DSP-<%# Eval("StockOutID", "{0:0000}") %></span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="PRODUCT NAME">
                                                <ItemTemplate>
                                                    <div class="product-name-cell">
                                                        <span class="product-name"><%# Eval("ProductName") %></span>
                                                        <span class="product-code">SKU: <%# Eval("SKU") %></span>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="Amount" HeaderText="QTY SENT" DataFormatString="{0} Units" />
                                            <asp:TemplateField HeaderText="ASSOCIATED COST">
                                                <ItemTemplate>
                                                    <span class="cost-text">
                                                        RM <%# Convert.ToDecimal(Eval("CostPerUnit")) * Convert.ToInt32(Eval("Amount")) %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="TYPE">
                                                <ItemTemplate>
                                                    <span class='badge <%# Eval("Type").ToString() == "Product Loss" ? "bg-danger" : "bg-primary" %>'>
                                                        <%# Eval("Type") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="OperatorName" HeaderText="OPERATOR" />
                                            <asp:TemplateField HeaderText="DATE">
                                                <ItemTemplate>
                                                    <span><%# Convert.ToDateTime(Eval("Date")).ToString("yyyy-MM-dd") %></span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="ACTIONS">
                                                <ItemTemplate>
                                                    <div class="actions-cell d-flex gap-2">
                                                        <asp:LinkButton ID="lbEdit" runat="server"
                                                            CssClass="action-btn edit-btn"
                                                            CommandName="EditRow"
                                                            CommandArgument='<%# Eval("StockOutID") %>'
                                                            CausesValidation="false"
                                                            ToolTip="Edit Record">
                                                            <i class="fi fi-rr-pencil"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="lbDelete" runat="server"
                                                            CssClass="action-btn delete-btn"
                                                            CommandName="DeleteRow"
                                                            CommandArgument='<%# Eval("StockOutID") %>'
                                                            CausesValidation="false"
                                                            OnClientClick="return confirmDelete();"
                                                            ToolTip="Delete Record">
                                                            <i class="fi fi-rr-trash"></i>
                                                        </asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>

                                <div class="reorder-table-footer d-flex align-items-center justify-content-between flex-wrap gap-2 px-4 py-3">
                                    <span class="footer-count">
                                        Showing <asp:Label ID="lblRecordCount" runat="server" Text="0" /> records
                                    </span>
                                </div>

                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </main>

        <footer class="site-footer">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <span>Maju Jaya Agrotech Supplies Sdn. Bhd. ERP Prototype Suite</span>
                    <span>Inventory Module 3 • Order Dispatch &amp; Defect Management • © 2026 (DEV)</span>
                </div>
            </div>
        </footer>

    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script type="text/javascript">
        function confirmDelete() {
            return confirm('Are you sure you want to delete this stock out record? It will revert original warehouse storage values.');
        }

        document.addEventListener('DOMContentLoaded', function () {
            var searchInput = document.getElementById('<%= txtSearch.ClientID %>');
            if (searchInput) {
                searchInput.addEventListener('keyup', function () {
                    var filter = this.value.toLowerCase();
                    var rows = document.querySelectorAll('.reorder-table tbody tr');
                    rows.forEach(function (row) {
                        var text = row.textContent.toLowerCase();
                        if (!row.classList.contains('empty-row')) {
                            row.style.display = text.includes(filter) ? '' : 'none';
                        }
                    });
                });
            }
        });
    </script>
</body>
</html>