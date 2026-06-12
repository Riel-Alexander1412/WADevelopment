<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StockManage.aspx.cs" Inherits="WADevelopment.StockManage" EnableViewState="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Product Management</title>
</head>
<body>
<form id="form1" runat="server">

    <h2>Product Management</h2>

    <asp:HiddenField ID="hfProductID" runat="server" Value="0" />

    <div>
        <label>SKU:</label>
        <asp:TextBox ID="txtSKU" runat="server" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSKU"
            ErrorMessage="Required" ForeColor="Red" Display="Dynamic" />
    </div>
    <div>
        <label>Product Name:</label>
        <asp:TextBox ID="txtProductName" runat="server" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtProductName"
            ErrorMessage="Required" ForeColor="Red" Display="Dynamic" />
    </div>
    <div>
        <label>Unit Price (RM):</label>
        <asp:TextBox ID="txtUnitPrice" runat="server" />
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUnitPrice"
            ErrorMessage="Required" ForeColor="Red" Display="Dynamic" />
        <asp:CompareValidator runat="server" ControlToValidate="txtUnitPrice"
            Operator="DataTypeCheck" Type="Double"
            ErrorMessage="Must be a number" ForeColor="Red" Display="Dynamic" />
    </div>
    <div>
        <asp:Button ID="btnSave" runat="server" Text="Add Product" OnClick="btnSave_Click" />
        <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" CausesValidation="false" />
    </div>

    <br />
    <asp:Label ID="lblMsg" runat="server" ForeColor="Green" /><br /><br />

    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="false"
        OnRowCommand="gvProducts_RowCommand" DataKeyNames="ProductID">
        <Columns>
            <asp:BoundField DataField="SKU" HeaderText="SKU" />
            <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
            <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price (RM)" DataFormatString="{0:F2}" />
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button runat="server" Text="Edit" CommandName="EditProduct"
                        CommandArgument="<%# Container.DataItemIndex %>" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:Button runat="server" Text="Delete" CommandName="DeleteProduct"
                        CommandArgument="<%# Container.DataItemIndex %>" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</form>
</body>
</html>