using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WADevelopment
{
    public partial class StockReorder : Page
    {
        // ─── Simulated data store (replace with DB calls) ────────────────────
        private static List<ReorderRecord> _reorderRecords = new List<ReorderRecord>
        {
            new ReorderRecord
            {
                ProductCode   = "PRD-2026-003",
                ProductName   = "Ergonomic Crop Pruner",
                CurrentQty    = 18,
                CalculatedROP = 50,
                SafetyStock   = 15,
                CalculatedEOQ = 190,
                Status        = "TRIGGER REORDER"
            },
            new ReorderRecord
            {
                ProductCode   = "PRD-2026-004",
                ProductName   = "Heavy-Duty Garden Hoe",
                CurrentQty    = 92,
                CalculatedROP = 40,
                SafetyStock   = 10,
                CalculatedEOQ = 140,
                Status        = "OK"
            }
        };

        // ─── Page_Load ────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Pre-fill default Logic ID on first load
                txtReorderLogicId.Text = "REO-LOG-054";
                txtAvgDailyUse.Text = "5";
                txtLeadTime.Text = "7";
                txtSafetyStockLimit.Text = "15";
                txtAnnualDemand.Text = "1800";

                // Calculate and display EOQ/ROP for default values
                ComputeAndDisplay(
                    avgDailyUse: 5,
                    leadTimeDays: 7,
                    safetyStock: 15,
                    annualDemand: 1800,
                    setupCost: 50,
                    holdingCost: 2
                );

                BindGrid(_reorderRecords);
            }
        }

        // ─── Establish Rule ───────────────────────────────────────────────────
        protected void btnEstablishRule_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            // Parse inputs
            int dailyUse = int.Parse(txtAvgDailyUse.Text.Trim());
            int leadTime = int.Parse(txtLeadTime.Text.Trim());
            int safetyStock = int.Parse(txtSafetyStockLimit.Text.Trim());
            int annualDemand = int.Parse(txtAnnualDemand.Text.Trim());
            string productVal = ddlProduct.SelectedValue;
            string productText = ddlProduct.SelectedItem.Text;
            string logicId = txtReorderLogicId.Text.Trim();

            const double setupCost = 50.0;
            const double holdingCost = 2.0;

            // Compute EOQ & ROP
            int eoq = (int)Math.Round(Math.Sqrt((2.0 * annualDemand * setupCost) / holdingCost));
            int rop = (dailyUse * leadTime) + safetyStock;

            ComputeAndDisplay(dailyUse, leadTime, safetyStock, annualDemand, setupCost, holdingCost);

            // Determine status
            // Simulate current qty from existing record or default to 999
            var existing = _reorderRecords.FirstOrDefault(r => r.ProductCode == productVal);
            int currentQty = existing?.CurrentQty ?? 999;
            string status = currentQty <= rop ? "TRIGGER REORDER" : "OK";

            // Upsert record
            if (existing != null)
            {
                existing.CalculatedROP = rop;
                existing.SafetyStock = safetyStock;
                existing.CalculatedEOQ = eoq;
                existing.Status = status;
            }
            else
            {
                _reorderRecords.Add(new ReorderRecord
                {
                    ProductCode = productVal,
                    ProductName = productText.Contains("–") ? productText.Split('–')[1].Trim() : productText,
                    CurrentQty = currentQty,
                    CalculatedROP = rop,
                    SafetyStock = safetyStock,
                    CalculatedEOQ = eoq,
                    Status = status
                });
            }

            BindGrid(_reorderRecords);

            // Success feedback
            lblMessage.Visible = true;
            lblMessage.Text = $"<i class=\"fi fi-rr-check-circle me-1\"></i> Reorder rule <strong>{logicId}</strong> established successfully for <strong>{productText.Split('–').Last().Trim()}</strong>.";
            lblMessage.CssClass = "form-message success";
        }

        // ─── Reset Form ───────────────────────────────────────────────────────
        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtReorderLogicId.Text = string.Empty;
            ddlProduct.SelectedIndex = 0;
            txtAvgDailyUse.Text = string.Empty;
            txtLeadTime.Text = string.Empty;
            txtSafetyStockLimit.Text = string.Empty;
            txtAnnualDemand.Text = string.Empty;

            lblEOQ.Text = "—";
            lblROP.Text = "—";
            lblSafetyBuffer.Text = "—";

            lblMessage.Visible = false;
        }

        // ─── Search / Filter ──────────────────────────────────────────────────
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtSearch.Text.Trim().ToLower();
            string statusFilter = ddlStatusFilter.SelectedValue;

            var filtered = _reorderRecords.AsEnumerable();

            if (!string.IsNullOrEmpty(keyword))
                filtered = filtered.Where(r =>
                    r.ProductName.ToLower().Contains(keyword) ||
                    r.ProductCode.ToLower().Contains(keyword));

            if (statusFilter != "All")
                filtered = filtered.Where(r => r.Status.Equals(statusFilter, StringComparison.OrdinalIgnoreCase));

            BindGrid(filtered.ToList());
        }

        // ─── GridView RowCommand (Edit / Confirm / Delete) ────────────────────
        protected void gvReorderAlerts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string productCode = e.CommandArgument?.ToString();

            switch (e.CommandName)
            {
                case "DeleteRow":
                    _reorderRecords.RemoveAll(r => r.ProductCode == productCode);
                    BindGrid(_reorderRecords);
                    lblMessage.Visible = true;
                    lblMessage.Text = $"<i class=\"fi fi-rr-trash me-1\"></i> Record <strong>{productCode}</strong> has been deleted.";
                    lblMessage.CssClass = "form-message error";
                    break;

                case "ConfirmRow":
                    var rec = _reorderRecords.FirstOrDefault(r => r.ProductCode == productCode);
                    if (rec != null) rec.Status = "OK";
                    BindGrid(_reorderRecords);
                    lblMessage.Visible = true;
                    lblMessage.Text = $"<i class=\"fi fi-rr-check-circle me-1\"></i> Reorder for <strong>{productCode}</strong> confirmed as actioned.";
                    lblMessage.CssClass = "form-message success";
                    break;

                case "EditRow":
                    var target = _reorderRecords.FirstOrDefault(r => r.ProductCode == productCode);
                    if (target != null)
                    {
                        // Pre-fill form with record data for editing
                        ddlProduct.SelectedValue = target.ProductCode;
                        txtSafetyStockLimit.Text = target.SafetyStock.ToString();
                        lblMessage.Visible = true;
                        lblMessage.Text = $"<i class=\"fi fi-rr-pencil me-1\"></i> Editing record <strong>{productCode}</strong>. Adjust parameters and click Establish Rule.";
                        lblMessage.CssClass = "form-message success";
                    }
                    break;
            }
        }

        // ─── Helpers ─────────────────────────────────────────────────────────
        private void ComputeAndDisplay(
            double avgDailyUse, double leadTimeDays,
            double safetyStock, double annualDemand,
            double setupCost, double holdingCost)
        {
            int eoq = holdingCost > 0
                ? (int)Math.Round(Math.Sqrt((2.0 * annualDemand * setupCost) / holdingCost))
                : 0;
            int rop = (int)Math.Round((avgDailyUse * leadTimeDays) + safetyStock);

            lblEOQ.Text = eoq.ToString("N0");
            lblROP.Text = rop.ToString("N0");
            lblSafetyBuffer.Text = ((int)safetyStock).ToString("N0");
        }

        private void BindGrid(List<ReorderRecord> records)
        {
            int alertCount = records.Count(r => r.Status == "TRIGGER REORDER");
            lblAlertCount.Text = alertCount.ToString();
            lblRecordCount.Text = records.Count.ToString();
            lblTotalRecords.Text = records.Count.ToString();

            gvReorderAlerts.DataSource = records;
            gvReorderAlerts.DataBind();
        }

        // ─── Code-behind helper exposed to markup ─────────────────────────────
        protected string GetQtyClass(object qtyObj, object ropObj)
        {
            if (qtyObj == null || ropObj == null) return "qty-ok";
            int qty = Convert.ToInt32(qtyObj);
            int rop = Convert.ToInt32(ropObj);
            if (qty <= rop * 0.4) return "qty-critical";
            if (qty <= rop) return "qty-low";
            return "qty-ok";
        }

        protected string GetStatusClass(string status)
        {
            switch (status?.ToUpper())
            {
                case "TRIGGER REORDER": return "status-trigger";
                case "LOW": return "status-low";
                default: return "status-ok";
            }
        }
    }

    // ─── Model ───────────────────────────────────────────────────────────────
    public class ReorderRecord
    {
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public int CurrentQty { get; set; }
        public int CalculatedROP { get; set; }
        public int SafetyStock { get; set; }
        public int CalculatedEOQ { get; set; }
        public string Status { get; set; }
    }
}
