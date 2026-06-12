<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StockReorder.aspx.cs" Inherits="WADevelopment.StockReorder" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Module 4: Reorder Record Management</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <!-- Flaticon Uicons -->
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-regular-rounded/css/uicons-regular-rounded.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-solid-rounded/css/uicons-solid-rounded.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/2.6.0/uicons-bold-rounded/css/uicons-bold-rounded.css" />
    <!-- Google Fonts -->
    
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" />
    <link rel="stylesheet" href="/CSS/StockReorder.css" />
</head>
<body>

    <!-- Top Navigation Bar -->
    <nav class="site-topbar">
        <div class="container-fluid px-4">
            <div class="d-flex align-items-center justify-content-between">
                <a href="#" class="topbar-brand">
                    <i class="fi fi-rr-boxes me-2"></i>
                    <span>Maju Jaya Agrotech Supplies</span>
                </a>
                <div class="topbar-links d-none d-md-flex align-items-center gap-3">
                    <a href="#" class="topbar-link"><i class="fi fi-rr-home me-1"></i> Dashboard</a>
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

        <!-- ASP.NET Validation Summary -->
        <asp:ValidationSummary ID="valSummary" runat="server"
            CssClass="validation-summary container-fluid px-4 pt-3"
            HeaderText="Please fix the following errors:"
            DisplayMode="BulletList"
            ShowMessageBox="false"
            ShowSummary="true" />

        <!-- Page Header -->
        <header class="page-header">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                    <div>
                        <nav aria-label="breadcrumb" class="mb-1">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item">
                                    <a href="#" class="breadcrumb-link">
                                        <i class="fi fi-rr-angle-left me-1"></i> Inventory Hub
                                    </a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Reorder Management</li>
                            </ol>
                        </nav>
                        <h1 class="page-title mb-0">Module 4: Reorder Record Management</h1>
                        <p class="page-meta mb-0">
                            Responsible Developer: <strong>Person 4</strong>
                            <span class="mx-2">•</span> Safety Stocks &amp; Automatic Reorder Triggers
                        </p>
                    </div>
                    <a href="#" class="btn btn-procurement">
                        <i class="fi fi-rr-radar me-2"></i> Procurement Radar
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container-fluid px-4">
                <div class="row g-4">

                    <!-- LEFT: Define Reorder Parameters -->
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

                                <!-- Reorder Logic ID -->
                                <div class="mb-3">
                                    <label for="txtReorderLogicId" class="field-label">
                                        <i class="fi fi-rr-id-badge me-1"></i> REORDER LOGIC ID
                                    </label>
                                    <div class="input-with-icon">
                                        <asp:TextBox ID="txtReorderLogicId" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="REO-LOG-054"
                                            MaxLength="20" />
                                        <span class="input-icon-right"><i class="fi fi-rr-fingerprint"></i></span>
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvReorderLogicId" runat="server"
                                        ControlToValidate="txtReorderLogicId"
                                        CssClass="field-error"
                                        ErrorMessage="Reorder Logic ID is required."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Reorder Logic ID is required.
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revReorderLogicId" runat="server"
                                        ControlToValidate="txtReorderLogicId"
                                        CssClass="field-error"
                                        ValidationExpression="^[A-Z]{3}-[A-Z]{3}-\d{3,6}$"
                                        ErrorMessage="Reorder Logic ID must follow the format: REO-LOG-054"
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Format must be: REO-LOG-054
                                    </asp:RegularExpressionValidator>
                                </div>

                                <!-- Select Product -->
                                <div class="mb-3">
                                    <label for="ddlProduct" class="field-label">
                                        <i class="fi fi-rr-box-open me-1"></i> SELECT PRODUCT
                                    </label>
                                    <div class="input-with-icon">
                                        <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-select field-input">
                                            <asp:ListItem Value="" Text="-- Choose a product --" />
                                            <asp:ListItem Value="PRD-2026-003" Text="PRD-2026-003 – Ergonomic Crop Pruner" Selected="True" />
                                            <asp:ListItem Value="PRD-2026-004" Text="PRD-2026-004 – Heavy-Duty Garden Hoe" />
                                            <asp:ListItem Value="PRD-2026-005" Text="PRD-2026-005 – Irrigation Drip Kit" />
                                            <asp:ListItem Value="PRD-2026-006" Text="PRD-2026-006 – Soil pH Tester" />
                                            <asp:ListItem Value="PRD-2026-007" Text="PRD-2026-007 – Organic Fertiliser 10kg" />
                                        </asp:DropDownList>
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvProduct" runat="server"
                                        ControlToValidate="ddlProduct"
                                        InitialValue=""
                                        CssClass="field-error"
                                        ErrorMessage="Please select a product."
                                        Display="Dynamic">
                                        <i class="fi fi-rr-exclamation me-1"></i> Please select a product.
                                    </asp:RequiredFieldValidator>
                                </div>

                                <!-- Avg Daily Use & Lead Time (two-column) -->
                                <div class="row g-3 mb-3">
                                    <div class="col-6">
                                        <label for="txtAvgDailyUse" class="field-label">
                                            <i class="fi fi-rr-chart-line-up me-1"></i> AVG DAILY USE
                                        </label>
                                        <asp:TextBox ID="txtAvgDailyUse" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="5"
                                            MaxLength="6" />
                                        <asp:RequiredFieldValidator ID="rfvAvgDailyUse" runat="server"
                                            ControlToValidate="txtAvgDailyUse"
                                            CssClass="field-error"
                                            ErrorMessage="Avg Daily Use is required."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rvAvgDailyUse" runat="server"
                                            ControlToValidate="txtAvgDailyUse"
                                            Type="Integer"
                                            MinimumValue="1"
                                            MaximumValue="9999"
                                            CssClass="field-error"
                                            ErrorMessage="Avg Daily Use must be 1–9999."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be 1–9999.
                                        </asp:RangeValidator>
                                    </div>
                                    <div class="col-6">
                                        <label for="txtLeadTime" class="field-label">
                                            <i class="fi fi-rr-clock me-1"></i> LEAD TIME (DAYS)
                                        </label>
                                        <asp:TextBox ID="txtLeadTime" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="7"
                                            MaxLength="4" />
                                        <asp:RequiredFieldValidator ID="rfvLeadTime" runat="server"
                                            ControlToValidate="txtLeadTime"
                                            CssClass="field-error"
                                            ErrorMessage="Lead Time is required."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rvLeadTime" runat="server"
                                            ControlToValidate="txtLeadTime"
                                            Type="Integer"
                                            MinimumValue="1"
                                            MaximumValue="365"
                                            CssClass="field-error"
                                            ErrorMessage="Lead Time must be 1–365 days."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be 1–365.
                                        </asp:RangeValidator>
                                    </div>
                                </div>

                                <!-- Safety Stock Limit & Annual Demand -->
                                <div class="row g-3 mb-4">
                                    <div class="col-6">
                                        <label for="txtSafetyStockLimit" class="field-label">
                                            <i class="fi fi-rr-shield-check me-1"></i> SAFETY STOCK LIMIT
                                        </label>
                                        <asp:TextBox ID="txtSafetyStockLimit" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="15"
                                            MaxLength="6" />
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
                                            ErrorMessage="Safety Stock must be 0–99999."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be 0–99999.
                                        </asp:RangeValidator>
                                    </div>
                                    <div class="col-6">
                                        <label for="txtAnnualDemand" class="field-label">
                                            <i class="fi fi-rr-calendar me-1"></i> ANNUAL DEMAND
                                        </label>
                                        <asp:TextBox ID="txtAnnualDemand" runat="server"
                                            CssClass="form-control field-input"
                                            placeholder="1800"
                                            MaxLength="8" />
                                        <asp:RequiredFieldValidator ID="rfvAnnualDemand" runat="server"
                                            ControlToValidate="txtAnnualDemand"
                                            CssClass="field-error"
                                            ErrorMessage="Annual Demand is required."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Required.
                                        </asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rvAnnualDemand" runat="server"
                                            ControlToValidate="txtAnnualDemand"
                                            Type="Integer"
                                            MinimumValue="1"
                                            MaximumValue="9999999"
                                            CssClass="field-error"
                                            ErrorMessage="Annual Demand must be 1–9,999,999."
                                            Display="Dynamic">
                                            <i class="fi fi-rr-exclamation me-1"></i> Must be 1–9,999,999.
                                        </asp:RangeValidator>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
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

                                <!-- Server-side success message -->
                                <asp:Label ID="lblMessage" runat="server" CssClass="form-message mt-3 d-block" Visible="false" />
                            </div>
                        </div>
                    </div>

                    <!-- RIGHT: Analytics + Table -->
                    <div class="col-12 col-lg-8 d-flex flex-column gap-4">

                        <!-- EOQ Analytics Engine Card -->
                        <div class="card eoq-card">
                            <div class="eoq-card-inner">
                                <div class="d-flex align-items-start justify-content-between mb-2 flex-wrap gap-2">
                                    <span class="eoq-badge">
                                        <i class="fi fi-rr-cpu me-1"></i> COMPLEX ANALYTICS ENGINE 4
                                    </span>
                                    <span class="eoq-suite-label">Inventory Science Suite</span>
                                </div>

                                <h2 class="eoq-title">
                                    Economic Order Quantity (EOQ) &amp; Safety Stock Calibration
                                </h2>
                                <p class="eoq-desc mb-2">
                                    Calculates optimal batch size (EOQ) minimising setup/carrying overheads, and the critical Reorder Point (ROP):
                                </p>

                                <div class="formula-row flex-wrap">
                                    <code class="formula-chip">EOQ = √((2 × Demand × Setup Cost) ÷ Holding Cost)</code>
                                    <code class="formula-chip">ROP = (Daily Use × Lead Time) + Safety Stock</code>
                                </div>

                                <!-- Live Calculation Output -->
                                <div class="row g-0 mt-4 eoq-metrics-row">
                                    <div class="col-4">
                                        <div class="eoq-metric-block">
                                            <span class="eoq-metric-label">RECOMMENDED EOQ</span>
                                            <span class="eoq-metric-value green" id="spanEOQ">
                                                <asp:Label ID="lblEOQ" runat="server" Text="—" />
                                                <small class="eoq-unit">Units</small>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="eoq-metric-block eoq-metric-border">
                                            <span class="eoq-metric-label">COMPUTED ROP TRIGGER</span>
                                            <span class="eoq-metric-value green" id="spanROP">
                                                <asp:Label ID="lblROP" runat="server" Text="—" />
                                                <small class="eoq-unit">Units</small>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="eoq-metric-block">
                                            <span class="eoq-metric-label">SAFETY STOCK BUFFER</span>
                                            <span class="eoq-metric-value amber" id="spanSSB">
                                                <asp:Label ID="lblSafetyBuffer" runat="server" Text="—" />
                                                <small class="eoq-unit">Units</small>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Active Reorder Registers Table -->
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
                                        <i class="fi fi-rr-exclamation-triangle me-1"></i>
                                        <asp:Label ID="lblAlertCount" runat="server" Text="2" /> ALERTS
                                    </span>
                                </div>

                                <!-- Search / Filter Bar -->
                                <div class="px-4 pb-3 d-flex gap-2 flex-wrap">
                                    <div class="search-wrap flex-grow-1">
                                        <i class="fi fi-rr-search search-icon"></i>
                                        <asp:TextBox ID="txtSearch" runat="server"
                                            CssClass="form-control search-input"
                                            placeholder="Search product name or code…"
                                            AutoComplete="off" />
                                    </div>
                                    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select filter-select">
                                        <asp:ListItem Value="All" Text="All Statuses" />
                                        <asp:ListItem Value="TRIGGER REORDER" Text="Trigger Reorder" />
                                        <asp:ListItem Value="OK" Text="OK" />
                                        <asp:ListItem Value="LOW" Text="Low" />
                                    </asp:DropDownList>
                                    <asp:Button ID="btnSearch" runat="server"
                                        CssClass="btn btn-filter"
                                        Text="Filter"
                                        CausesValidation="false"
                                        OnClick="btnSearch_Click" />
                                </div>

                                <!-- Table -->
                                <div class="table-responsive">
                                    <asp:GridView ID="gvReorderAlerts" runat="server"
                                        CssClass="table reorder-table mb-0"
                                        AutoGenerateColumns="false"
                                        DataKeyNames="ProductCode"
                                        GridLines="None"
                                        OnRowCommand="gvReorderAlerts_RowCommand"
                                        EmptyDataText="No reorder records found. Establish a rule to populate this register."
                                        EmptyDataRowStyle-CssClass="empty-row">
                                        <Columns>
                                            <asp:TemplateField HeaderText="PRODUCT NAME">
                                                <ItemTemplate>
                                                    <div class="product-name-cell">
                                                        <span class="product-name"><%# Eval("ProductName") %></span>
                                                        <span class="product-code">Code: <%# Eval("ProductCode") %></span>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="CURRENT QTY">
                                                <ItemTemplate>
                                                    <span class='<%# GetQtyClass(Eval("CurrentQty"), Eval("CalculatedROP")) %>'>
                                                        <%# Eval("CurrentQty") %> Units
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="CalculatedROP" HeaderText="CALCULATED ROP" DataFormatString="{0} Units" />
                                            <asp:BoundField DataField="SafetyStock" HeaderText="SAFETY STOCK" DataFormatString="{0} Units" />
                                            <asp:BoundField DataField="CalculatedEOQ" HeaderText="CALCULATED EOQ" DataFormatString="{0} Units" ItemStyle-CssClass="bold-cell" />
                                            <asp:TemplateField HeaderText="STATUS ACTION">
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
                                                            CommandArgument='<%# Eval("ProductCode") %>'
                                                            CausesValidation="false"
                                                            ToolTip="Edit Record">
                                                            <i class="fi fi-rr-pencil"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="lbConfirm" runat="server"
                                                            CssClass="action-btn confirm-btn"
                                                            CommandName="ConfirmRow"
                                                            CommandArgument='<%# Eval("ProductCode") %>'
                                                            CausesValidation="false"
                                                            ToolTip="Confirm Reorder">
                                                            <i class="fi fi-rr-check-circle"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton ID="lbDelete" runat="server"
                                                            CssClass="action-btn delete-btn"
                                                            CommandName="DeleteRow"
                                                            CommandArgument='<%# Eval("ProductCode") %>'
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

                                <!-- Pagination -->
                                <div class="reorder-table-footer d-flex align-items-center justify-content-between flex-wrap gap-2 px-4 py-3">
                                    <span class="footer-count">
                                        Showing <asp:Label ID="lblRecordCount" runat="server" Text="1" /> of
                                        <asp:Label ID="lblTotalRecords" runat="server" Text="1" /> records
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

        <!-- Footer -->
        <footer class="site-footer">
            <div class="container-fluid px-4">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <span>Maju Jaya Agrotech Supplies Sdn. Bhd. ERP Prototype Suite</span>
                    <span>Inventory Module 4 • Safety Stocks &amp; Automatic Reorder Triggers • © 2026 (DEV)</span>
                </div>
            </div>
        </footer>

    </form>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // ─── Client-side EOQ / ROP live calculation ───────────────────────────
        function recalculate() {
            var dailyUse = parseFloat(document.getElementById('<%= txtAvgDailyUse.ClientID %>').value) || 0;
            var leadTime = parseFloat(document.getElementById('<%= txtLeadTime.ClientID %>').value) || 0;
            var safetyStock = parseFloat(document.getElementById('<%= txtSafetyStockLimit.ClientID %>').value) || 0;
            var annualDemand = parseFloat(document.getElementById('<%= txtAnnualDemand.ClientID %>').value) || 0;

            var setupCost = 50;    // default assumption
            var holdingCost = 2;   // default assumption

            var eoqLabel = document.getElementById('<%= lblEOQ.ClientID %>');
            var ropLabel = document.getElementById('<%= lblROP.ClientID %>');
            var ssbLabel = document.getElementById('<%= lblSafetyBuffer.ClientID %>');

            if (annualDemand > 0 && setupCost > 0 && holdingCost > 0) {
                var eoq = Math.round(Math.sqrt((2 * annualDemand * setupCost) / holdingCost));
                eoqLabel.textContent = eoq;
            } else {
                eoqLabel.textContent = '—';
            }

            if (dailyUse > 0 && leadTime > 0) {
                var rop = Math.round((dailyUse * leadTime) + safetyStock);
                ropLabel.textContent = rop;
            } else {
                ropLabel.textContent = '—';
            }

            ssbLabel.textContent = safetyStock > 0 ? safetyStock : '—';
        }

        // Attach live listeners
        ['<%= txtAvgDailyUse.ClientID %>', '<%= txtLeadTime.ClientID %>',
         '<%= txtSafetyStockLimit.ClientID %>', '<%= txtAnnualDemand.ClientID %>'].forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.addEventListener('input', recalculate);
        });

        // ─── Client-side JS validation (extra layer on top of ASP.NET validators) ───
        function validateFormJS() {
            var logicId = document.getElementById('<%= txtReorderLogicId.ClientID %>').value.trim();
            var product = document.getElementById('<%= ddlProduct.ClientID %>').value;
            var dailyUse = document.getElementById('<%= txtAvgDailyUse.ClientID %>').value.trim();
            var leadTime = document.getElementById('<%= txtLeadTime.ClientID %>').value.trim();
            var safetyStock = document.getElementById('<%= txtSafetyStockLimit.ClientID %>').value.trim();
            var annualDemand = document.getElementById('<%= txtAnnualDemand.ClientID %>').value.trim();

            var errors = [];

            if (!logicId) errors.push('Reorder Logic ID is required.');
            if (!product) errors.push('Please select a product.');
            if (!dailyUse || isNaN(dailyUse) || parseInt(dailyUse) < 1) errors.push('Avg Daily Use must be a positive number.');
            if (!leadTime || isNaN(leadTime) || parseInt(leadTime) < 1) errors.push('Lead Time must be a positive number.');
            if (safetyStock === '' || isNaN(safetyStock) || parseInt(safetyStock) < 0) errors.push('Safety Stock Limit must be 0 or above.');
            if (!annualDemand || isNaN(annualDemand) || parseInt(annualDemand) < 1) errors.push('Annual Demand must be a positive number.');

            if (errors.length > 0) {
                alert('Please fix the following:\n\n• ' + errors.join('\n• '));
                return false;
            }
            return true;
        }

        // ─── Delete confirmation dialog ───────────────────────────────────────
        function confirmDelete() {
            return confirm('Are you sure you want to delete this reorder record? This action cannot be undone.');
        }

        // ─── Live search client-side filtering ───────────────────────────────
        document.addEventListener('DOMContentLoaded', function () {
            var searchInput = document.getElementById('<%= txtSearch.ClientID %>');
            if (searchInput) {
                searchInput.addEventListener('keyup', function () {
                    var filter = this.value.toLowerCase();
                    var rows = document.querySelectorAll('.reorder-table tbody tr');
                    rows.forEach(function (row) {
                        var text = row.textContent.toLowerCase();
                        row.style.display = text.includes(filter) ? '' : 'none';
                    });
                });
            }

            // Run initial calculation if fields have pre-filled values
            recalculate();
        });
    </script>
</body>
</html>
