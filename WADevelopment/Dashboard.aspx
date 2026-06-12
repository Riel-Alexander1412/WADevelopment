<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WADevelopment.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard — Maju Jaya Agrotech ERP</title>

    <link rel="icon" href="/Assets/icon.jpg" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn-uicons.flaticon.com/4.0.0/uicons-solid-rounded/css/uicons-solid-rounded.css" />
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-regular-straight/css/uicons-regular-straight.css'>
    <link rel='stylesheet' href='https://cdn-uicons.flaticon.com/4.0.0/uicons-regular-rounded/css/uicons-regular-rounded.css'>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" />

    <link rel="stylesheet" href="/CSS/Dashboard.css" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function showUnavailableAlert(event, deptName) {
            event.stopPropagation();
            alert("⚠️ " + deptName + " is not under our administration.\nAccess is currently restricted.");
            return false;
        }
    </script>
</head>
<body class="dashboard-body">
    <form id="form1" runat="server">
        <div class="dashboard-bg-grid" aria-hidden="true"></div>
        <div class="dashboard-orb dashboard-orb-1" aria-hidden="true"></div>
        <div class="dashboard-orb dashboard-orb-2" aria-hidden="true"></div>

        <div class="dashboard-main">
            <div class="dashboard-header">
                <div class="dashboard-brand">
                    <div class="brand-icon">
                        <i class="fi fi-rr-chart-tree"></i>
                    </div>
                    <div class="brand-text">
                        <h1>Maju Jaya Agrotech Supplies</h1>
                        <p>ERP Dashboard · Inventory Hub</p>
                    </div>
                </div>
                <div class="dashboard-welcome">
                    <i class="fi fi-rr-calendar-clock me-1"></i> Welcome User
                </div>
            </div>
            <div class="dashboard-grid">

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Customer Registration Department')">
                    <i class="fi fi-rr-user-add"></i>
                    <div class="tile-title">Customer Registration Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Product Order Department')">
                    <i class="fi fi-rr-shopping-cart"></i>
                    <div class="tile-title">Product Order Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Payment and Billing Department')">
                    <i class="fi fi-rr-credit-card"></i>
                    <div class="tile-title">Payment and Billing Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Delivery Management Department')">
                    <i class="fi fi-rs-truck-moving"></i>
                    <div class="tile-title">Delivery Management Department</div>
                </div>

                <a href="StockManage.aspx" class="dashboard-tile active-tile">
                    <i class="fi fi-rr-boxes"></i>
                    <div class="tile-title">Inventory and Stock Department</div>
                </a>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Supplier Management Department')">
                    <i class="fi fi-rr-handshake"></i>
                    <div class="tile-title">Supplier Management Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Equipment Rental Department')">
                    <i class="fi fi-rr-tools"></i>
                    <div class="tile-title">Equipment Rental Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Fertiliser Booking Department')">
                    <i class="fi fi-rr-seedling"></i>
                    <div class="tile-title">Fertiliser Booking Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Complaint and Customer Support Department')">
                    <i class="fi fi-rr-headset"></i>
                    <div class="tile-title">Complaint and Customer Support</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Maintenance Request Department')">
                    <i class="fi fi-rr-wrench"></i>
                    <div class="tile-title">Maintenance Request Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Training Registration Department')">
                    <i class="fi fi-rr-graduation-cap"></i>
                    <div class="tile-title">Training Registration Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Event and Agro Workshop Department')">
                    <i class="fi fi-rr-calendar-day"></i>
                    <div class="tile-title">Event and Agro Workshop Dept</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Staff Attendance Department')">
                    <i class="fi fi-rr-fingerprint"></i>
                    <div class="tile-title">Staff Attendance Department</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Leave and Duty Management Department')">
                    <i class="fi fi-rr-document"></i>
                    <div class="tile-title">Leave and Duty Management Dept</div>
                </div>

                <div class="dashboard-tile disabled-tile"
                     title="This department is not under our administration"
                     onclick="showUnavailableAlert(event, 'Promotion and Membership Department')">
                    <i class="fi fi-rr-gift"></i>
                    <div class="tile-title">Promotion and Membership Dept</div>
                </div>

            </div>
        </div>
    </form>
</body>
</html>