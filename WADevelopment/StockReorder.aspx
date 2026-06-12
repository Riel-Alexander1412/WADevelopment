<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StockReorder.aspx.cs" Inherits="WADevelopment.StockReorder" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Module 4: Reorder Record Management</title>
    
    <link rel="icon" href="/Assets/icon.jpg" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/> 

    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-solid-straight/css/uicons-solid-straight.css'>
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-bold-rounded/css/uicons-bold-rounded.css'>
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-thin-straight/css/uicons-thin-straight.css'>
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-solid-rounded/css/uicons-solid-rounded.css'>
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-thin-rounded/css/uicons-thin-rounded.css'>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" />
    <link rel="stylesheet" href="/CSS/StockReorder.css" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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
                    <a href="Dashboard.aspx" class="topbar-link"><i class="fi fi-rr-home me-1"></i> Dashboard</a>
                    <a href="#" class="topbar-link active"><i class="fi fi-rr-layers me-1"></i> Inventory Hub</a>
                    <a href="#" class="topbar-link"><i class="fi fi-rr-chart-histogram me-1"></i> Reports</a>
                    <a href="#" class="topbar-link"><i class="fi fi-rr-settings me-1"></i> Settings</a>
                </div>
                <div class="topbar-user d-flex align-items-center gap-2">
                    <span class="user-badge">Person 4</span>
                    <a href="#" class="btn btn-sm btn-outline-light"><i class="fi fi-rr-sign-out-alt"></i></a>
                </div>
            </div>
        </div>
    </nav>

    <form id="form1" runat="server">

        <asp:ValidationSummary ID="valSummary" runat="server"
            CssClass="validation-summary container-fluid px-4 pt-3"
            HeaderText="Please fix the following errors:"
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
                                <li class="breadcrumb-item active" aria-current="page">Reorder Management</li>
                            </ol>
                        </nav>
                        <h1 class="page-title mb-0">Module 4: Reorder Record Management</h1>
                        <p class="page-meta mb-0">
                            Responsible Developer: <strong>Gabriel</strong>
                            <span class="mx-2">•</span> Stock Management System
                        </p>
                    </div>
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
                                        <i class="fi fi-rr-settings-sliders"></i>
                                    </div>
                                    <div>
                                        <h2 class="param-title mb-0">Define Reorder Parameters</h2>
                                        <p class="param-subtitle mb-0">Establish minimum bounds to block critical out-of-stock scenarios</p>
                                    </div>
                                </div>

                                <hr class="param-divider" />
                                <div class="mb-3">
                                    <label for="txtSKU" class="field-label">
                                        <i class="fi fi-rr-id-badge me-1"></i> SKU NUMBER
                                    </label>
                                    <div class="input-with-icon">
                                        <asp:TextBox ID="txtSKU" runat="server"
                                            CssClass="form-control field-input field-readonly"
                                            placeholder="Auto-filled on product select"
                                            ReadOnly="true" />
                                        <span class="input-icon-right"><i class="fi fi-rr-fingerprint"></i></span>
                                    </div>
                                    <asp:HiddenField ID="hfSKU" runat="server" Value="" />
                                </div>
                                <div class="mb-3">
                                    <label for="ddlProduct" class="field-label">
                                        <i class="fi fi-rr-box-open me-1"></i> SELECT PRODUCT
                                    </label>
                                    <asp:DropDownList ID="ddlProduct" runat="server"
                                        CssClass="form-select field-input"
                                        AutoPostBack="true"
                                        OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged">
                                        <asp:ListItem Value="" Text="-- Choose a product --" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvProduct" runat="server"
                                        ControlToValidate="ddlProduct"
                                        InitialValue=""
                                        CssClass="field-error"
                                        ErrorMessage="Please select a product."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Please select a product.
                                    </asp:RequiredFieldValidator>
                                </div>
                                <div class="mb-3">
                                    <label for="txtAmount" class="field-label">
                                        <i class="fi fi-rr-inbox-in me-1"></i> AMOUNT TO REORDER (STOCK IN)
                                    </label>
                                    <asp:TextBox ID="txtAmount" runat="server"
                                        CssClass="form-control field-input"
                                        placeholder="e.g. 100"
                                        MaxLength="8" />
                                    <asp:RequiredFieldValidator ID="rfvAmount" runat="server"
                                        ControlToValidate="txtAmount"
                                        CssClass="field-error"
                                        ErrorMessage="Amount is required."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Amount is required.
                                    </asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="rvAmount" runat="server"
                                        ControlToValidate="txtAmount"
                                        Type="Integer"
                                        MinimumValue="1"
                                        MaximumValue="999999"
                                        CssClass="field-error"
                                        ErrorMessage="Amount must be between 1 and 999,999."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Must be between 1 and 999,999.
                                    </asp:RangeValidator>
                                </div>
                                <div class="mb-4">
                                    <label for="txtSafetyStockLimit" class="field-label">
                                        <i class="fi fi-rr-shield-check me-1"></i> SAFETY STOCK LIMIT (MIN AMOUNT)
                                    </label>
                                    <asp:TextBox ID="txtSafetyStockLimit" runat="server"
                                        CssClass="form-control field-input"
                                        placeholder="e.g. 15"
                                        MaxLength="6" />
                                    <small class="field-hint">
                                        <i class="fi fi-rr-info me-1"></i>
                                        Current DB value shown above. Override here to update MinAmount.
                                    </small>
                                    <asp:RequiredFieldValidator ID="rfvSafetyStockLimit" runat="server"
                                        ControlToValidate="txtSafetyStockLimit"
                                        CssClass="field-error"
                                        ErrorMessage="Safety Stock Limit is required."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Required.
                                    </asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="rvSafetyStockLimit" runat="server"
                                        ControlToValidate="txtSafetyStockLimit"
                                        Type="Integer"
                                        MinimumValue="0"
                                        MaximumValue="99999"
                                        CssClass="field-error"
                                        ErrorMessage="Safety Stock must be between 0 and 99,999."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Must be 0–99,999.
                                    </asp:RangeValidator>
                                </div>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnEstablishRule" runat="server"
                                        CssClass="btn btn-establish flex-grow-1"
                                        Text="Establish Rule"
                                        OnClick="btnEstablishRule_Click"
                                        OnClientClick="return validateFormJS();" />
                                    <asp:Button ID="btnReset" runat="server"
                                        CssClass="btn btn-reset-form"
                                        Text="Reset"
                                        CausesValidation="false"
                                        OnClick="btnReset_Click" />
                                </div>

                                <asp:Label ID="lblMessage" runat="server"
                                    CssClass="form-message mt-3 d-block"
                                    Visible="false" />
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">
                        <div class="card eoq-card">
                            <div class="eoq-card-inner">
                                <div class="d-flex align-items-start justify-content-between mb-2 flex-wrap gap-2">
                                    <span class="eoq-badge">
                                        <i class="fi fi-rr-cpu me-1"></i> STOCK LEVEL MONITOR
                                    </span>
                                    <span class="eoq-suite-label">Inventory Science Suite</span>
                                </div>

                                <h2 class="eoq-title">
                                    Inventory Asset Valuation Summary
                                </h2>
                                <p class="eoq-desc mb-2">
                                    Aggregated financial snapshot across all tracked products.
                                    Net Worth uses <strong>CostPerUnit</strong>; Sell Price uses <strong>SellingPrice</strong>;
                                    Avg Unit Amount is the mean stock level across all products.
                                </p>

                                <div class="formula-row flex-wrap">
                                    <code class="formula-chip">Net Worth = Σ (Amount × CostPerUnit)</code>
                                    <code class="formula-chip">Avg Units = Σ Amount ÷ Product Count</code>
                                </div>
                                <div class="row g-0 mt-4 eoq-metrics-row">
                                    <div class="col-4">
                                        <div class="eoq-metric-block">
                                            <span class="eoq-metric-label">TOTAL ASSETS NET WORTH</span>
                                            <span class="eoq-metric-value green" style="font-size:20px; letter-spacing:0;">
                                                <small class="eoq-unit" style="font-size:13px;">RM</small>
                                                <asp:Label ID="lblTotalNetWorth" runat="server" Text="—" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="eoq-metric-block eoq-metric-border">
                                            <span class="eoq-metric-label">TOTAL ASSETS SELL PRICE</span>
                                            <span class="eoq-metric-value green" style="font-size:20px; letter-spacing:0;">
                                                <small class="eoq-unit" style="font-size:13px;">RM</small>
                                                <asp:Label ID="lblTotalSellPrice" runat="server" Text="—" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="eoq-metric-block">
                                            <span class="eoq-metric-label">AVG STOCK UNIT AMOUNT</span>
                                            <span class="eoq-metric-value amber">
                                                <asp:Label ID="lblAvgStockUnit" runat="server" Text="—" />
                                                <small class="eoq-unit">Units</small>
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
                                            <i class="fi fi-rr-bells me-2"></i>
                                            Active Reorder Registers &amp; Shortage Alerts
                                        </h3>
                                        <p class="reorder-table-sub mb-0">Items nearing calculated safety boundaries requiring purchase actions</p>
                                    </div>
                                    <span class="alert-badge-pill">
                                        <i class="fi fi-ss-triangle-warning mt-1"></i>
                                        <asp:Label ID="lblAlertCount" class="me-2" runat="server" Text="0" /> ALERTS
                                    </span>
                                </div>
                                <div class="px-4 pb-3 d-flex gap-2 flex-wrap">
                                    <div class="search-wrap flex-grow-1">
                                        <i class="fi fi-rr-search search-icon"></i>
                                        <asp:TextBox ID="txtSearch" runat="server"
                                            CssClass="form-control search-input"
                                            placeholder="Search product name or SKU…"
                                            AutoComplete="off" />
                                    </div>
                                    <asp:DropDownList ID="ddlStatusFilter" runat="server"
                                        CssClass="form-select filter-select">
                                        <asp:ListItem Value="All"             Text="All Statuses" />
                                        <asp:ListItem Value="TRIGGER REORDER" Text="Trigger Reorder" />
                                        <asp:ListItem Value="LOW"             Text="Low" />
                                        <asp:ListItem Value="OK"              Text="OK" />
                                    </asp:DropDownList>
                                    <asp:Button ID="btnSearch" runat="server"
                                        CssClass="btn btn-filter"
                                        Text="Filter"
                                        CausesValidation="false"
                                        OnClick="btnSearch_Click" />
                                </div>
                                <div class="table-responsive">
                                    <asp:GridView ID="gvReorderAlerts" runat="server"
                                        CssClass="table reorder-table mb-0"
                                        AutoGenerateColumns="false"
                                        DataKeyNames="SKU"
                                        GridLines="None"
                                        OnRowCommand="gvReorderAlerts_RowCommand"
                                        EmptyDataText="No products are currently below their minimum stock threshold."
                                        EmptyDataRowStyle-CssClass="empty-row">
                                        <Columns>
                                            <asp:TemplateField HeaderText="PRODUCT NAME">
                                                <ItemTemplate>
                                                    <div class="product-name-cell">
                                                        <span class="product-name"><%# Eval("ProductName") %></span>
                                                        <span class="product-code">SKU: <%# Eval("SKU") %> &nbsp;|&nbsp; <%# Eval("Category") %></span>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="CURRENT STOCK">
                                                <ItemTemplate>
                                                    <span class='<%# GetQtyClass(Eval("Amount"), Eval("MinAmount")) %>'>
                                                        <%# Eval("Amount") %> Units
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="MinAmount"
                                                HeaderText="SAFETY STOCK (MIN)"
                                                DataFormatString="{0} Units" />
                                            <asp:TemplateField HeaderText="STATUS">
                                                <ItemTemplate>
                                                    <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                                                        <%# Eval("Status") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="ACTIONS">
                                                <ItemTemplate>
                                                    <div class="actions-cell d-flex gap-2">
                                                        <asp:LinkButton ID="lbEdit" runat="server"
                                                            CssClass="action-btn edit-btn"
                                                            CommandName="EditRow"
                                                            CommandArgument='<%# Eval("SKU") %>'
                                                            CausesValidation="false"
                                                            ToolTip="Load into form for editing">
                                                            <i class="fi fi-rr-pencil"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="lbDelete" runat="server"
                                                            CssClass="action-btn delete-btn"
                                                            CommandName="DeleteRow"
                                                            CommandArgument='<%# Eval("SKU") %>'
                                                            CausesValidation="false"
                                                            OnClientClick="return confirmDelete();"
                                                            ToolTip="Delete reorder record">
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
                                        Showing <asp:Label ID="lblRecordCount" runat="server" Text="0" /> of
                                        <asp:Label ID="lblTotalRecords" runat="server" Text="0" /> records
                                    </span>
                                    <div class="d-flex gap-1">
                                        <asp:Button ID="btnPrev" runat="server" CssClass="btn btn-page" Text="‹ Prev" CausesValidation="false" />
                                        <asp:Button ID="btnNext" runat="server" CssClass="btn btn-page" Text="Next ›" CausesValidation="false" />
                                    </div>
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
                    <span>Maju Jaya Agrotech Supplies Management System</span>
                    <span>Stocks Management & Inventory Module 4</span>
                </div>
            </div>
        </footer>

    </form>

    <script>
        document.addEventListener('DOMContentLoaded', function () {

            var ddl       = document.getElementById('<%= ddlProduct.ClientID %>');
            var txtSKU    = document.getElementById('<%= txtSKU.ClientID %>');
            var searchBox = document.getElementById('<%= txtSearch.ClientID %>');
            function syncSKU() {
                var val = ddl ? ddl.value : '';
                if (txtSKU) {
                    txtSKU.value = val ? val : '';
                }
            }

            if (ddl) ddl.addEventListener('change', syncSKU);
            syncSKU();

            if (searchBox) {
                searchBox.addEventListener('keyup', function () {
                    var filter = this.value.toLowerCase();
                    var rows   = document.querySelectorAll('.reorder-table tbody tr');
                    rows.forEach(function (row) {
                        row.style.display = row.textContent.toLowerCase().includes(filter) ? '' : 'none';
                    });
                });
            }
        });

        function validateFormJS() {
            var product      = document.getElementById('<%= ddlProduct.ClientID %>').value;
            var amount       = document.getElementById('<%= txtAmount.ClientID %>').value.trim();
            var safetyStock  = document.getElementById('<%= txtSafetyStockLimit.ClientID %>').value.trim();

            var errors = [];

            if (!product)
                errors.push('Please select a product.');
            if (!amount || isNaN(amount) || parseInt(amount) < 1)
                errors.push('Amount must be a positive whole number.');
            if (safetyStock === '' || isNaN(safetyStock) || parseInt(safetyStock) < 0)
                errors.push('Safety Stock Limit must be 0 or greater.');

            if (errors.length > 0) {
                alert('Please fix the following:\n\n• ' + errors.join('\n• '));
                return false;
            }
            return true;
        }

        function confirmDelete() {
            return confirm('Are you sure you want to delete this reorder record?\nThis action cannot be undone.');
        }
    </script>
</body>
</html>
