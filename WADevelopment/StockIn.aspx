<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StockIn.aspx.cs" Inherits="WADevelopment.StockIn" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Module 2: Stock In Management Department</title>

        <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>

    <body class="min-h-screen flex flex-col justify-between bg-slate-50/30 text-slate-800">
        <form id="form1" runat="server" class="min-h-screen flex flex-col justify-between">
            
            <div class="flex-grow">
                
                <div class="bg-[#0b131a] text-[10px] uppercase tracking-wider px-10 py-3 flex justify-between items-center border-b border-emerald-950/40">
                    <span class="text-slate-200 font-bold tracking-widest">Maju Jaya Agrotech Supplies Sdn. Bhd.</span>
                    <span class="text-emerald-500/80 font-semibold"><i class="fa-solid fa-layer-group mr-1.5"></i>Internal ERP Network</span>
                </div>

                <div class="max-w-[1600px] mx-auto p-8">
                    
                    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
                        <div>
                            <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">Module 2: Stock In Management</h1>
                            <p class="text-sm text-slate-500 mt-1">
                                Responsible Developer: <span class="font-bold text-slate-700">Person 2</span> <span class="text-slate-300 mx-1.5">•</span> Database Linked ERP Module
                            </p>
                        </div>
                        <a href="StockManage.aspx" class="inline-flex items-center gap-2 bg-white hover:bg-slate-50 text-slate-700 font-semibold text-xs px-4 py-2 rounded-xl border border-slate-200/80 shadow-xs transition duration-150">
                            <i class="fa-solid fa-arrow-left text-slate-400"></i> Return to Stock Hub
                        </a>
                    </div>

                    <asp:Label ID="lblStatusMessage" runat="server" Visible="false" 
                        CssClass="block mb-6 p-4 rounded-xl text-xs font-semibold shadow-xs"></asp:Label>

                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

                        <div class="lg:col-span-4 space-y-6">
                            
                            <div class="bg-white rounded-2xl border border-slate-100 shadow-xs p-6">
                                <div class="mb-4">
                                    <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                                        <i class="fa-solid fa-box-open text-emerald-600"></i> Create Master Product
                                    </h2>
                                    <p class="text-xs text-slate-400 mt-0.5">Insert a brand new item entry into the [dbo].[Products] catalog</p>
                                </div>

                                <div class="space-y-3.5">
                                    <div>
                                        <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Product Name</label>
                                        <asp:TextBox ID="txtNewProdName" runat="server" placeholder="e.g. Organic Fertilizer Premium" MaxLength="50"
                                            CssClass="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs"></asp:TextBox>
                                    </div>

                                    <div>
                                        <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Description (Optional)</label>
                                        <asp:TextBox ID="txtNewProdDesc" runat="server" placeholder="Brief specs or notes..." MaxLength="255" TextMode="MultiLine" Rows="2"
                                            CssClass="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs resize-none"></asp:TextBox>
                                    </div>

                                    <div class="grid grid-cols-3 gap-2">
                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Min Threshold</label>
                                            <asp:TextBox ID="txtNewProdMin" runat="server" placeholder="e.g. 20" type="number"
                                                CssClass="w-full bg-white border border-slate-200 rounded-lg px-2 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs"></asp:TextBox>
                                        </div>
                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Cost / Unit (RM)</label>
                                            <asp:TextBox ID="txtNewProdCost" runat="server" placeholder="0.00" type="number" step="0.01"
                                                CssClass="w-full bg-white border border-slate-200 rounded-lg px-2 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs"></asp:TextBox>
                                        </div>
                                        <div>
                                            <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Selling Price (RM)</label>
                                            <asp:TextBox ID="txtNewProdPrice" runat="server" placeholder="0.00" type="number" step="0.01"
                                                CssClass="w-full bg-white border border-slate-200 rounded-lg px-2 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1">Category</label>
                                        <asp:TextBox ID="txtNewProdCategory" runat="server" placeholder="e.g. Equipment, Fertilizer" MaxLength="50"
                                            CssClass="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs"></asp:TextBox>
                                    </div>

                                    <div class="pt-1">
                                        <asp:Button ID="btnCreateProduct" runat="server" Text="Register Product Item" OnClick="btnCreateProduct_Click" OnClientClick="return validateProductForm();"
                                            CssClass="w-full bg-slate-800 hover:bg-slate-900 text-white font-semibold text-xs py-2 rounded-lg shadow-sm transition duration-150 cursor-pointer text-center" />
                                    </div>
                                </div>
                            </div>

                            <div class="bg-white rounded-2xl border border-slate-100 shadow-xs p-6">
                                <div class="mb-4">
                                    <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                                        <i class="fa-solid fa-plus text-emerald-600"></i> <asp:Literal ID="litFormTitle" runat="server" Text="Register Stock Intake"></asp:Literal>
                                    </h2>
                                    <p class="text-xs text-slate-400 mt-0.5">Commit quantities directly to the [dbo].[StockIn] ledger</p>
                                </div>

                                <asp:HiddenField ID="hfStockInID" runat="server" Value="" />

                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1.5">Product Item Name (Linked to SKU)</label>
                                        <asp:DropDownList ID="ddlSKU" runat="server" 
                                            CssClass="w-full bg-white border border-slate-200 rounded-lg px-3 py-2 text-sm text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs">
                                            <asp:ListItem Value="" Text="-- Choose Product SKU --"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                    <div>
                                        <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1.5">Intake Amount (Quantity)</label>
                                        <asp:TextBox ID="txtAmount" runat="server" placeholder="e.g. 150" type="number"
                                            CssClass="w-full bg-white border border-slate-200 rounded-lg px-3 py-2 text-sm text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs"></asp:TextBox>
                                    </div>

                                    <div>
                                        <label class="block text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1.5">Authorized Recording User</label>
                                        <asp:DropDownList ID="ddlUser" runat="server" CssClass="w-full bg-white border border-slate-200 rounded-lg px-3 py-2 text-sm text-slate-700 focus:outline-none focus:border-emerald-500 shadow-xs">
                                            <asp:ListItem Value="" Text="-- Assign Verified Handler --"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                    <div class="flex items-center gap-3 pt-2">
                                        <asp:Button ID="btnSubmit" runat="server" Text="Post Inward Stock" OnClick="btnSubmit_Click" OnClientClick="return validateFrontendForm();"
                                            CssClass="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-xs py-2.5 rounded-lg shadow-sm transition duration-150 cursor-pointer text-center" />
                                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click"
                                            CssClass="bg-slate-50 hover:bg-slate-100 text-slate-500 font-semibold text-xs px-5 py-2.5 rounded-lg border border-slate-200 transition duration-150 cursor-pointer" />
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="lg:col-span-8 space-y-6">

                            <div class="bg-[#051a1e] text-white rounded-2xl shadow-xs p-6 border border-emerald-950">
                                <span class="bg-emerald-950 text-emerald-400 text-[9px] font-bold px-2 py-0.5 rounded tracking-wider uppercase">Complex Analytics Engine 2</span>
                                <h2 class="text-lg font-bold mt-1 text-slate-100">Live Inbound Stock Volume Aggregation Analysis</h2>
                                <div class="bg-[#031114] rounded-lg p-3 text-xs font-mono text-emerald-500 my-4 border border-emerald-950/50">
                                    Evaluated Formula Expression: <span class="text-emerald-400 font-bold ml-1">Total Verified Accumulated Units = SUM([Amount])</span>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div class="bg-[#072429] border border-emerald-900/40 rounded-xl p-4 text-center">
                                        <span class="block text-[9px] font-bold text-emerald-500/70 tracking-widest uppercase mb-1">Cumulative Stock Inbound Units</span>
                                        <span class="text-2xl font-extrabold text-emerald-400 tracking-tight">
                                            <asp:Literal ID="litCalculatedTotal" runat="server" Text="0 Units"></asp:Literal>
                                        </span>
                                    </div>
                                    <div class="bg-[#0c1a24] border border-slate-800/40 rounded-xl p-4 text-center">
                                        <span class="block text-[9px] font-bold text-slate-400 tracking-widest uppercase mb-1">Database Row Count</span>
                                        <span class="text-2xl font-extrabold text-slate-200 tracking-tight">
                                            <asp:Literal ID="litRowCount" runat="server" Text="0 Records"></asp:Literal>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-white rounded-2xl border border-slate-100 shadow-xs p-6">
                                <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6 pb-4 border-b border-slate-100">
                                    <div>
                                        <h2 class="text-lg font-bold text-slate-900">Stock Inbound Records Log</h2>
                                        <p class="text-xs text-slate-400 mt-0.5">Real-time mapping of SQL Server table entries</p>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <asp:TextBox ID="txtSearch" runat="server" placeholder="Filter by Product Name..." 
                                            CssClass="bg-slate-50 border border-slate-200 rounded-lg pl-3 pr-3 py-1.5 text-xs focus:outline-none focus:border-emerald-500 transition shadow-xs"></asp:TextBox>
                                        <asp:Button ID="btnSearch" runat="server" Text="Query" OnClick="btnSearch_Click"
                                            CssClass="bg-slate-800 hover:bg-slate-900 text-white text-xs px-3 py-1.5 rounded-lg cursor-pointer font-semibold" />
                                    </div>
                                </div>

                                <div class="overflow-x-auto">
                                    <asp:GridView ID="gvStockInLogs" runat="server" AutoGenerateColumns="False" DataKeyNames="StockInID"
                                        OnRowEditing="gvStockInLogs_RowEditing" OnRowDeleting="gvStockInLogs_RowDeleting"
                                        CssClass="w-full text-left text-xs text-slate-700 divide-y divide-slate-100" GridLines="None" BorderStyle="None">
                                        <HeaderStyle CssClass="border-b border-slate-100 text-[10px] font-bold text-slate-400 tracking-wider uppercase bg-slate-50/50" height="40px" />
                                        <RowStyle CssClass="hover:bg-slate-50/50 border-b border-slate-100/50" height="50px" />
                                        <Columns>
                                            <asp:BoundField DataField="StockInID" HeaderText="ID" ReadOnly="True" ItemStyle-Font-Bold="true" />
                                            <asp:BoundField DataField="ProductName" HeaderText="Product Item Name" />
                                            <asp:BoundField DataField="Amount" HeaderText="Amount Registered" ItemStyle-CssClass="font-semibold text-slate-900" />
                                            <asp:BoundField DataField="UserName" HeaderText="Handler Staff" />
                                            <asp:BoundField DataField="Date" HeaderText="Timestamp Certified" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                                            <asp:TemplateField HeaderText="Actions" ItemStyle-HorizontalAlign="Center">
                                                <ItemTemplate>
                                                    <div class="flex items-center gap-4 text-slate-400">
                                                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" Text="<i class='fa-regular fa-pen-to-square text-sm hover:text-emerald-600 transition'></i>" ToolTip="Modify Entry" />
                                                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" Text="<i class='fa-regular fa-trash-can text-sm hover:text-rose-500 transition'></i>" ToolTip="Purge Log" OnClientClick="return confirm('Execute immediate deletion sequence on this database entity record?');" />
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <footer class="bg-white border-t border-slate-200/80 py-4 px-10 text-xs text-slate-400">
                <div class="max-w-[1600px] mx-auto flex flex-col sm:flex-row justify-between items-center gap-2">
                    <div>
                        &copy; 2026 <span class="font-semibold text-slate-600">Maju Jaya Agrotech Supplies Sdn. Bhd.</span> All rights reserved.
                    </div>
                    <div class="flex items-center gap-4 font-medium text-slate-500">
                        <span class="flex items-center gap-1.5"><span class="h-2 w-2 rounded-full bg-emerald-500 block animate-pulse"></span> SQL Ledger Connected</span>
                        <span class="text-slate-300">|</span>
                        <span>Secure Session Active</span>
                    </div>
                </div>
            </footer>

        </form>

        <script type="text/javascript">
            function validateProductForm() {
                var name = document.getElementById('<%= txtNewProdName.ClientID %>').value.trim();
                var minAmt = document.getElementById('<%= txtNewProdMin.ClientID %>').value;
                var cost = document.getElementById('<%= txtNewProdCost.ClientID %>').value;
                var price = document.getElementById('<%= txtNewProdPrice.ClientID %>').value;

                var issues = [];
                if (!name) issues.push("Product Name cannot be blank.");
                if (!minAmt || parseInt(minAmt) < 0) issues.push("Minimum threshold must be 0 or higher.");
                if (!cost || parseFloat(cost) < 0) issues.push("Cost per unit cannot be negative.");
                if (!price || parseFloat(price) < 0) issues.push("Selling price cannot be negative.");

                if (issues.length > 0) {
                    alert("Product Creation Validation Error:\n\n" + issues.join("\n"));
                    return false;
                }
                return true;
            }

            function validateFrontendForm() {
                var sku = document.getElementById('<%= ddlSKU.ClientID %>').value;
                var amount = document.getElementById('<%= txtAmount.ClientID %>').value;
                var user = document.getElementById('<%= ddlUser.ClientID %>').value;

                var issues = [];
                if (!sku) issues.push("Product mapping selection is required.");
                if (!amount || parseInt(amount) <= 0) issues.push("Amount must contain a non-zero positive quantitative entry.");
                if (!user) issues.push("Transaction requires an authenticated recording Staff Handler assignment.");

                if (issues.length > 0) {
                    alert("Validation Constraints Detected:\n\n" + issues.join("\n"));
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>