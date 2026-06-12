<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StockManage.aspx.cs" Inherits="WADevelopment.StockManage" EnableViewState="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Module 3: Product Management</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-solid-rounded/css/uicons-solid-rounded.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-bold-rounded/css/uicons-bold-rounded.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" />
    <link rel="stylesheet" href="/CSS/StockManage.css" />

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
                                    <a href="Dashboard.aspx" class="breadcrumb-link">
                                        <i class="fi fi-rr-angle-left me-1"></i> Dashboard
                                    </a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Product Management</li>
                            </ol>
                        </nav>
                        <p class="page-meta mb-0">
                            Responsible Developer: <strong>Person 3</strong>
                            <span class="mx-2">•</span> Stock Catalogue &amp; Pricing Records
                        </p>
                    </div>
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="StockReorder.aspx" class="btn-header-action">
                            <i class="fi fi-rr-shopping-cart me-2"></i> Stock Reorder
                        </a>
                        <a href="StockOut.aspx" class="btn-header-action">
                            <i class="fi fi-rr-inbox-out me-2"></i> Stock Out
                        </a>
                            <a href="StockIn.aspx" class="btn-header-action">
                                <i class="fi fi-rr-inbox-in me-2"></i> Stock In
                            </a>
                    </div>
                </div>
            </div>
        </header>

        <main class="main-content">
            <div class="container-fluid px-4">
                <div class="row g-4">

                    <!-- LEFT PANEL: Add / Edit Product -->
                    <div class="col-12 col-lg-4">
                        <div class="card param-card h-100">
                            <div class="card-body p-4">
                                <div class="d-flex align-items-start gap-3 mb-1">
                                    <div class="param-icon-wrap">
                                        <i class="fi fi-rr-box-open"></i>
                                    </div>
                                    <div>
                                        <h2 class="param-title mb-0">Product Details</h2>
                                        <p class="param-subtitle mb-0">Add a new product or update an existing catalogue entry</p>
                                    </div>
                                </div>

                                <hr class="param-divider" />

                                <%-- Hidden field stores SKU (0 = new insert) --%>
                                <asp:HiddenField ID="hfSKU" runat="server" Value="0" />

                                <!-- NAME -->
                                <div class="mb-3">
                                    <label class="field-label">
                                        <i class="fi fi-rr-tag me-1"></i> PRODUCT NAME
                                    </label>
                                    <asp:TextBox ID="txtName" runat="server"
                                        CssClass="form-control field-input"
                                        placeholder="e.g. Ergonomic Crop Pruner"
                                        MaxLength="50" />
                                    <asp:RequiredFieldValidator runat="server"
                                        ControlToValidate="txtName"
                                        CssClass="field-error"
                                        ErrorMessage="Product name is required."
                                        Display="Dynamic"
                                        ValidationGroup="ProductForm">
                                        <i class="fi fi-rr-exclamation me-1"></i> Required.
                                    </asp:RequiredFieldValidator>
                                </div>

                                <!-- DESCRIPTION -->
                                <div class="mb-3">
                                    <label class="field-label">
                                        <i class="fi fi-rr-align-left me-1"></i> DESCRIPTION <span style="font-weight:400;letter-spacing:0">(optional)</span>
                                    </label>
                                    <asp:TextBox ID="txtDescription" runat="server"
                                        CssClass="form-control field-input"
                                        TextMode="MultiLine" Rows="2"
                                        placeholder="Short product description…"
                                        MaxLength="255" />
                                </div>

                                <!-- AMOUNT + MIN AMOUNT (side by side) -->
                                <div class="row g-2 mb-3">
                                    <div class="col-6">
                                        <label class="field-label">
                                            <i class="fi fi-rr-inbox-in me-1"></i> AMOUNT
                                        </label>
                                        <asp:TextBox ID="txtAmount" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="1"
                                            MaxLength="8" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtAmount"
                                            CssClass="field-error"
                                            ErrorMessage="Amount is required."
                                            Display="Dynamic"
                                            ValidationGroup="ProductForm">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator runat="server"
                                            ControlToValidate="txtAmount"
                                            MinimumValue="1"
                                            MaximumValue="99999999"
                                            Type="Integer"
                                            CssClass="field-error"
                                            ErrorMessage="Amount must be between 1 and 99,999,999."
                                            ValidationGroup="ProductForm"
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be at least 1 (Max 99,999,999).
                                        </asp:RangeValidator>
                                    </div>
                                    <div class="col-6">
                                        <label class="field-label">
                                            <i class="fi fi-rr-shield-check me-1"></i> MIN AMOUNT
                                        </label>
                                        <asp:TextBox ID="txtMinAmount" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="1"
                                            MaxLength="8" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtMinAmount"
                                            CssClass="field-error"
                                            ErrorMessage="Min Amount is required."
                                            Display="Dynamic"
                                            ValidationGroup="ProductForm">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator runat="server"
                                            ControlToValidate="txtMinAmount"
                                            MinimumValue="1"
                                            MaximumValue="99999999"
                                            Type="Integer"
                                            CssClass="field-error"
                                            ErrorMessage="Min Amount must be between 1 and 99,999,999."
                                            ValidationGroup="ProductForm"
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be at least 1 (Max 99,999,999).
                                        </asp:RangeValidator>
                                    </div>
                                </div>

                                <!-- COST PER UNIT + SELLING PRICE (side by side) -->
                                <div class="row g-2 mb-3">
                                    <div class="col-6">
                                        <label class="field-label">
                                            <i class="fi fi-rr-coins me-1"></i> COST/UNIT (RM)
                                        </label>
                                        <asp:TextBox ID="txtCostPerUnit" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="0.01"
                                            MaxLength="12" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtCostPerUnit"
                                            CssClass="field-error"
                                            ErrorMessage="Cost per unit is required."
                                            Display="Dynamic"
                                            ValidationGroup="ProductForm">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator runat="server"
                                            ControlToValidate="txtCostPerUnit"
                                            MinimumValue="0.01"
                                            MaximumValue="999999999.99"
                                            Type="Double"
                                            CssClass="field-error"
                                            ErrorMessage="Cost must be between 0.01 and 999,999,999.99."
                                            ValidationGroup="ProductForm"
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be at least RM0.01 (Max 999,999,999.99).
                                        </asp:RangeValidator>
                                    </div>
                                    <div class="col-6">
                                        <label class="field-label">
                                            <i class="fi fi-rr-sack-dollar me-1"></i> SELL PRICE (RM)
                                        </label>
                                        <asp:TextBox ID="txtSellingPrice" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="0.01"
                                            MaxLength="12" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtSellingPrice"
                                            CssClass="field-error"
                                            ErrorMessage="Selling price is required."
                                            Display="Dynamic"
                                            ValidationGroup="ProductForm">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator runat="server"
                                            ControlToValidate="txtSellingPrice"
                                            MinimumValue="0.01"
                                            MaximumValue="999999999.99"
                                            Type="Double"
                                            CssClass="field-error"
                                            ErrorMessage="Price must be between 0.01 and 999,999,999.99."
                                            ValidationGroup="ProductForm"
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be at least RM0.01 (Max 999,999,999.99).
                                        </asp:RangeValidator>
                                    </div>
                                </div>

                                <!-- CATEGORY -->
                                <div class="mb-4">
                                    <label class="field-label">
                                        <i class="fi fi-rr-apps me-1"></i> CATEGORY <span style="font-weight:400;letter-spacing:0">(optional)</span>
                                    </label>
                                    <asp:TextBox ID="txtCategory" runat="server"
                                        CssClass="form-control field-input"
                                        placeholder="e.g. Hand Tools"
                                        MaxLength="50" />
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnSave" runat="server"
                                        CssClass="btn btn-primary-action flex-grow-1"
                                        Text="Add Product"
                                        OnClick="btnSave_Click"
                                        ValidationGroup="ProductForm" />
                                    <asp:Button ID="btnClear" runat="server"
                                        CssClass="btn btn-reset-form"
                                        Text="Clear"
                                        CausesValidation="false"
                                        OnClick="btnClear_Click" />
                                </div>

                                <asp:Label ID="lblMsg" runat="server"
                                    CssClass="form-message mt-3 d-block"
                                    Visible="false" />
                            </div>
                        </div>
                    </div>

                    <!-- RIGHT PANEL: Inventory Summary + Table -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- Inventory Summary Card -->
                        <div class="card analytics-card">
                            <div class="analytics-card-inner">
                                <div class="d-flex align-items-start justify-content-between mb-2 flex-wrap gap-2">
                                    <span class="analytics-badge">
                                        <i class="fi fi-rr-cube me-1"></i> CATALOGUE OVERVIEW
                                    </span>
                                    <span class="analytics-suite-label">Inventory Science Suite</span>
                                </div>

                                <h2 class="analytics-title">Product Catalogue Summary</h2>
                                <p class="analytics-desc mb-2">
                                    Live snapshot of all registered products.
                                    Net Worth uses <strong>CostPerUnit</strong>; Sell Value uses <strong>SellingPrice</strong>;
                                    Total SKUs is the count of distinct catalogue entries.
                                </p>

                                <div class="formula-row">
                                    <code class="formula-chip">Net Worth = Σ (Amount × CostPerUnit)</code>
                                    <code class="formula-chip">Sell Value = Σ (Amount × SellingPrice)</code>
                                </div>

                                <div class="row g-0 mt-4 metrics-row">
                                    <div class="col-4">
                                        <div class="metric-block">
                                            <span class="metric-label">TOTAL NET WORTH</span>
                                            <span class="metric-value green" style="font-size:20px;letter-spacing:0;">
                                                <small class="metric-unit" style="font-size:13px;">RM</small>
                                                <asp:Label ID="lblTotalNetWorth" runat="server" Text="—" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="metric-block metric-block-border">
                                            <span class="metric-label">TOTAL SELL VALUE</span>
                                            <span class="metric-value green" style="font-size:20px;letter-spacing:0;">
                                                <small class="metric-unit" style="font-size:13px;">RM</small>
                                                <asp:Label ID="lblTotalSellValue" runat="server" Text="—" />
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="metric-block">
                                            <span class="metric-label">TOTAL SKUs</span>
                                            <span class="metric-value amber">
                                                <asp:Label ID="lblTotalSKUs" runat="server" Text="—" />
                                                <small class="metric-unit">Items</small>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Products Table -->
                        <div class="card data-table-card">
                            <div class="card-body p-0">
                                <div class="d-flex align-items-start justify-content-between flex-wrap gap-2 p-4 pb-3">
                                    <div>
                                        <h3 class="table-card-title mb-0">
                                            <i class="fi fi-rr-list me-2"></i>
                                            Product Catalogue
                                        </h3>
                                        <p class="table-card-sub mb-0">All registered stock items and their current pricing &amp; quantity records</p>
                                    </div>
                                    <span class="count-badge-pill">
                                        <i class="fi fi-rr-box me-1"></i>
                                        <asp:Label ID="lblProductCount" runat="server" Text="0" /> PRODUCTS
                                    </span>
                                </div>

                                <!-- Search / Filter Bar -->
                                <asp:Panel ID="pnlSearch" runat="server" DefaultButton="btnHiddenSearch">
                                    <div class="px-4 pb-3 d-flex gap-2 flex-wrap">
                                        <div class="search-wrap flex-grow-1">
                                            <i class="fi fi-rr-search search-icon"></i>
                                            <asp:TextBox ID="txtSearch" runat="server"
                                                CssClass="form-control search-input"
                                                placeholder="Search name, category…"
                                                AutoComplete="off" />
                                        </div>
        
                                        <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-select filter-select">
                                            <asp:ListItem Value="All" Text="All Categories" />
                                        </asp:DropDownList>
        
                                        <asp:LinkButton ID="btnSearch" runat="server"
                                            CssClass="btn btn-filter btn-filter-icon"
                                            CausesValidation="false"
                                            OnClick="btnSearch_Click">
                                            <i class="fi fi-rr-search"></i>
                                        </asp:LinkButton>

                                        <asp:Button ID="btnHiddenSearch" runat="server" 
                                            OnClick="btnSearch_Click" 
                                            CausesValidation="false" 
                                            style="display:none;" />
                                    </div>
                                </asp:Panel>

                                <!-- GridView -->
                                <div class="table-responsive">
                                    <asp:GridView ID="gvProducts" runat="server"
                                        CssClass="table erp-table mb-0"
                                        AutoGenerateColumns="false"
                                        DataKeyNames="SKU"
                                        GridLines="None"
                                        OnRowCommand="gvProducts_RowCommand"
                                        EmptyDataText="No products found. Add one using the form on the left."
                                        EmptyDataRowStyle-CssClass="empty-row">
                                        <Columns>

                                            <%-- Product Name + SKU + Category --%>
                                            <asp:TemplateField HeaderText="PRODUCT">
                                                <ItemTemplate>
                                                    <div class="product-name-cell">
                                                        <span class="product-name"><%# Eval("Name") %></span>
                                                        <span class="product-code">SKU: <%# Eval("SKU") %>&nbsp;|&nbsp;<%# Eval("Category") %></span>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <%-- Stock amount with colour coding vs MinAmount --%>
                                            <asp:TemplateField HeaderText="STOCK">
                                                <ItemTemplate>
                                                    <span class='<%# GetQtyClass(Eval("Amount"), Eval("MinAmount")) %>'>
                                                        <%# Eval("Amount") %> Units
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:BoundField DataField="MinAmount" HeaderText="MIN" DataFormatString="{0}" />

                                            <asp:BoundField DataField="CostPerUnit"  HeaderText="COST (RM)"  DataFormatString="{0:F2}" />
                                            <asp:BoundField DataField="SellingPrice" HeaderText="PRICE (RM)" DataFormatString="{0:F2}" />

                                            <%-- Actions --%>
                                            <asp:TemplateField HeaderText="ACTIONS">
                                                <ItemTemplate>
                                                    <div class="actions-cell">
                                                        <asp:LinkButton runat="server"
                                                            CssClass="action-btn edit-btn"
                                                            CommandName="EditProduct"
                                                            CommandArgument='<%# Container.DataItemIndex %>'
                                                            CausesValidation="false"
                                                            ToolTip="Edit product">
                                                            <i class="fi fi-rr-pencil"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton runat="server"
                                                            CssClass="action-btn delete-btn"
                                                            CommandName="DeleteProduct"
                                                            CommandArgument='<%# Container.DataItemIndex %>'
                                                            CausesValidation="false"
                                                            OnClientClick="return confirm('Delete this product? This cannot be undone.');"
                                                            ToolTip="Delete product">
                                                            <i class="fi fi-rr-trash"></i>
                                                        </asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                        </Columns>
                                    </asp:GridView>
                                </div>

                                <!-- Footer -->
                                <div class="table-footer d-flex align-items-center justify-content-between flex-wrap gap-2 px-4 py-3">
                                    <span class="footer-count">
                                        Showing <asp:Label ID="lblRecordCount" runat="server" Text="0" /> of
                                        <asp:Label ID="lblTotalRecords" runat="server" Text="0" /> products
                                    </span>
                                    <div class="d-flex gap-1">
                                        <asp:Button ID="btnPrev" runat="server" CssClass="btn btn-page" Text="‹ Prev" CausesValidation="false" />
                                        <asp:Button ID="btnNext" runat="server" CssClass="btn btn-page" Text="Next ›" CausesValidation="false" />
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div><!-- end right col -->
                </div><!-- end row -->
            </div>
        </main>

        <footer class="site-footer">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <span>Maju Jaya Agrotech Supplies Sdn. Bhd. ERP Prototype Suite</span>
                    <span>Inventory Module 3 • Stock Catalogue &amp; Pricing Records • © 2026 (DEV)</span>
                </div>
            </div>
        </footer>

    </form>

    <script src="/JS/StockManage.js"></script>
</body>
</html>