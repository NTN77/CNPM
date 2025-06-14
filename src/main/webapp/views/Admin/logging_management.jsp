<%@ page import="java.util.List" %>
<%@ page import="logs.Log" %>
<%@ page import="logs.LoggingService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Log> logs = LoggingService.getInstance().getLogs();
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý log</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Admin/css/table_style.css">
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <!--https://www.bootstrapcdn.com/-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <style>
        .pagination {
            position: fixed;
            overflow: auto;
            bottom: 20%;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
        }

        .dt-empty, .dt-info {
            display: none;
        }

        #clear_box {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            display: none;
            z-index: 1033;
            background-color: #2c3e50; /* Adjust the background color as needed */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Optional: Add a box shadow for a subtle effect */
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container-fluid mx-auto mt-2">
    <%--    <h1><%=LoggingService.getInstance().getAbsolutePath()%></h1>--%>
    <div class="d-flex justify-content-between">
        <div class="btn-group mr-2 mb-2" role="group" aria-label="First group">
            <button type="button" class="btn btn-info" id="allFilter">
                Tất cả
            </button>
            <button type="button" class="btn" id="informFilter" style="background-color: #0dcaf0">
                INFORM
            </button>
            <button type="button" class="btn" id="alertFilter" style="background-color: #ffecb3">
                ALERT
            </button>
            <button type="button" class="btn" id="warningFilter" style="background-color: #fd7e14">
                WARNING
            </button>
            <button type="button" class="btn" id="dangerFilter" style="background-color: #dc3545">
                DANGER
            </button>
        </div>
        <div class="d-flex">
            <div class="text-decoration-underline text-warning me-2 fw-bold"
                 style="cursor: pointer"
                 onclick="showClearINFROMBox()"
            >Dọn dẹp INFORM
            </div>
            <div class="text-decoration-underline text-warning fw-bold"
                 style="cursor: pointer"
                 onclick="showClearALERTBox()"
            >Dọn dẹp ALERT
            </div>
        </div>
    </div>
    <div class="table-wrapper-scroll-y my-custom-scrollbar  d-flex justify-content-center">
        <table id="data" class="table table-striped table-hover">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap fix-column" scope="col"
                    style=" position: sticky;left: 0;z-index: 1;">Mã Log
                </th>
                <th class="text-nowrap" scope="col">Mức độ</th>
                <th class="text-nowrap" scope="col">Hoạt động</th>
                <th class="text-nowrap" scope="col">Nội dung</th>
                <th scope="col">Thời gian</th>
                <th class="text-nowrap" scope="col">Địa chỉ IP</th>
                <th class="text-nowrap" scope="col">Thành phố</th>
                <th class="text-nowrap" scope="col">Khu vực</th>
                <th class="text-nowrap" scope="col">Quốc gia</th>
            </tr>
            </thead>
            <tbody>
            <% for (int i = logs.size() - 1; i >= 0; i--) { %>
            <tr class="text-center">
                <td><%= logs.get(i).getId() %>
                </td>
                <td style="background-color:
                    <% if (logs.get(i).isINFORMLevel()) { %>
                        #0dcaf0
                    <% } else if (logs.get(i).isALERTLevel()) { %>
                        #ffecb3
                    <% } else if (logs.get(i).isWARNINGLevel()) { %>
                        #fd7e14
                    <% } else if (logs.get(i).isDANGERLevel()) { %>
                        #dc3545
                        <% } %>">
                    <%= logs.get(i).getLevel() %>
                    <%if (logs.get(i).isINFORMLevel() || logs.get(i).isALERTLevel()) {%>
                    <div>
                        <i class="fa-solid fa-trash-can fs-4" style="cursor: pointer ; color: #5c7093;"
                           onclick="removeLog(<%=logs.get(i).getId()%>, this)"
                        ></i>
                    </div>
                    <%}%>
                </td>
                <td><%= logs.get(i).getAction() %>
                </td>
                <td><%= logs.get(i).getMessage() %>
                </td>
                <td><%= logs.get(i).getFormattedCreatedTime() %>
                </td>
                <td><%= logs.get(i).getIpAddress() %>
                </td>
                <td><%= logs.get(i).getCity() %>
                </td>
                <td><%= logs.get(i).getRegion() %>
                </td>
                <td><%= logs.get(i).getCountryName() %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <div id="clear_box"></div>
</div>
<script>
    const allFilter = document.querySelector('#allFilter');
    const informFilter = document.querySelector('#informFilter');
    const alertFilter = document.querySelector('#alertFilter');
    const warningFilter = document.querySelector('#warningFilter');
    const dangerFilter = document.querySelector('#dangerFilter');
    let table;
    $(document).ready(function () {
        table = $('#data').DataTable({
            "searching": true,
            "lengthChange": false,
            "pageLength": 10,
            "order": [[0, "desc"]],
            language: {
                search: "Nhập từ khóa tìm kiếm"
            }
        });
        if (allFilter) {
            allFilter.addEventListener('click', function () {
                table.columns(1).search('').draw();
            })
        }
        if (informFilter) {
            informFilter.addEventListener('click', function () {
                table.columns(1).search('INFORM').draw();
            })
        }
        if (alertFilter) {
            alertFilter.addEventListener('click', function () {
                table.columns(1).search('ALERT').draw();
            })
        }
        if (warningFilter) {
            warningFilter.addEventListener('click', function () {
                table.columns(1).search('WARNING').draw();
            })
        }
        if (dangerFilter) {
            dangerFilter.addEventListener('click', function () {
                table.columns(1).search('DANGER').draw();
            })
        }
    });

    function showClearINFROMBox() {
        const container = document.getElementById('clear_box');
        container.innerHTML = `
        <div>
            <h4 class="text-danger">Bạn sẽ không thể hoàn tác thao tác này!</h1>
            <button type="button" class="btn btn-outline-secondary" onclick="removeClearBox()">Hủy</button>
            <button type="button" class="btn btn-outline-danger" onclick="clearInformLogs()">Tiếp tục</button>
        </div>`;
        container.style.display = 'block';
    }

    function showClearALERTBox() {
        const container = document.getElementById('clear_box');
        container.innerHTML = `
        <div>
            <h4 class="text-danger">Bạn sẽ không thể hoàn tác thao tác này!</h1>
            <button type="button" class="btn btn-outline-secondary" onclick="removeClearBox()">Hủy</button>
            <button type="button" class="btn btn-outline-danger" onclick="clearAlertLogs()">Tiếp tục</button>
        </div>`;
        container.style.display = 'block';
    }

    function removeClearBox() {
        const container = document.getElementById('clear_box');
        container.innerHTML = ``;
        container.style.display = 'none';
    }

    function clearInformLogs() {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/log",
            data: {
                action: "clearInformLogs"
            },
            success: function (response) {
                // Xóa các hàng có mức độ "INFORM" từ bảng
                $('#data tbody tr').filter(function () {
                    return $(this).find('td:eq(1)').text().trim() === 'INFORM';
                }).remove();
                // reload log gui
                reloadGUI();
                location.reload();
            },
            error: function () {
                alert("Không thành công");
            }
        });
    }


    function clearAlertLogs() {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/log",
            data: {
                action: "clearAlertLogs"
            },
            success: function (response) {
                // Xóa các hàng có mức độ "INFORM" từ bảng
                $('#data tbody tr').filter(function () {
                    return $(this).find('td:eq(1)').text().trim() === 'ALERT';
                }).remove();
                // reload log gui
                reloadGUI();
                location.reload();
            },
            error: function () {
                alert("Không thành công");
            }
        });
    }

    function removeLog(id, e) {
        // const rowIndex = e.closest('tr').rowIndex - 1;
        const row = $(e).closest('tr');
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/log",
            data: {
                action: "removeLog",
                id: id
            },
            success: function (response) {
                // $('#data tbody tr').eq(rowIndex).remove();
                table.row(row).remove().draw();
                removeClearBox();
                // reload log gui
                reloadGUI();
            },
            error: function () {
                alert("Không thành công")
            }
        })
    }
</script>
<script src="<%=request.getContextPath()%>/views/Admin/js/logging.reload.js"></script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
</html>
