
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.bean.*" %>
<%@ page import="model.adapter.RateRequest" %>
<%@ page import="model.service.RateService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>

<%String currentFilter = (String) request.getAttribute("currentFilter");%>
<%
    System.out.println("ok: " + currentFilter);%>
<%String currentFindText = (String) request.getAttribute("currentFindText");%>
<%
    List<RateRequest> rate = RateService.getInstance().getAll();
    System.out.println("Oke:" + rate.size());
//    for(RateRequest r : rate){
//        System.out.println(r.toString());
//    }
%>
<%System.out.println(currentFilter + "  -  " + currentFindText);%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý đánh giá</title>
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <!--https://www.bootstrapcdn.com/-->
    <%--    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"--%>
    <%--          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">--%>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        #detailOrder {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            z-index: 9999;
            background-color: #e0eaf4;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }

        .pagination {
            position: fixed;
            overflow: auto;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
        }

        .dt-empty, .dt-info {
            display: none;
        }

        #data th:nth-child(4),
        #data td:nth-child(4) {
            width: 20%;
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container-fluid mx-auto mt-2">
<%--     action="<%=request.getContextPath()%>/admin/sentiment" method="post" --%>
    <form action="<%=request.getContextPath()%>/admin/sentiment" method="post" id="sentimentForm">
        <div class="customer_list  mt-5 ">
            <h3 class="d-flex justify-content-center text-danger">Quản lý đánh giá</h3>
            <div class="table-wrapper-scroll-y my-custom-scrollbar d-flex justify-content-center mt-3">
                <table id="data" class="table table-striped table-hover" style="min-width: 1000px; width: 100%;">
                    <thead>
                    <tr class="text-center sticky-top">
                        <th class="text-nowrap text-center">Mã SP</th>
                        <th class="text-nowrap text-center col-5">Tên SP</th>
                        <th class="text-nowrap text-center">Tổng đánh giá</th>
                        <th class="text-nowrap text-center">Tiêu cực</th>
                        <th class="text-nowrap text-center">Tích cực</th>
                        <th class="text-nowrap text-center">Trung lập</th>
                        <th class="text-nowrap text-center">Điểm đánh giá trung bình</th>
                        <th class="text-nowrap text-center">Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (RateRequest r : rate) {
                            if (r != null) {
//                                User customer = UserService.getInstance().getUserById(r.getUserId() + "");
                    %>
                    <tr class="text-center" style=" cursor: pointer;"
                        id="<%=r.getProductId()%>"
                    >
                        <td class="text-center"><%=r.getProductId()%>
                        </td>
                        <td class="text-center"><%=r.getName()%>
                        </td>
                        <td class="text-center">
                            <%= r.getTongDanhGia() %>
                        </td>
<%--                        Tiêu cực--%>
                        <td class="text-center">5
                        </td>
<%--                        Tích cực--%>
                        <td class="text-center">3
                        </td>
<%--                        Trung lập--%>
                        <td class="text-center">2
                        </td>
                        <td class="text-center"><%=r.getDanhGiaTrungBinh()%>
                        </td>

                        <td>
                            <button type="button" class="btn btn-sm btn-info" onclick='showDetailModal(<%=r.getProductId()%>)'>Chi tiết</button>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <input type="hidden" id="currentOrderId" name="currentOrderId">
        <input type="hidden" id="currentFilter" name="currentFilter" value="<%=currentFilter%>">
        <input type="hidden" id="currentPageNumber" name="currentPageNumber"
               value="<%=request.getAttribute("currentPageNumber")==null?0:request.getAttribute("currentPageNumber")%>">
    </form>
    <div id="detailOrder" style="display:none;">
    </div>
</div>
<%--PopUp--%>
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderDetailModalLabel">Chi tiết đánh giá</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <table id="reviewTable" class="table table-bordered table-striped w-100">
                    <thead>
                    <tr>
                        <th>Tên sản phẩm</th>
                        <th>Người dùng</th>
                        <th>Ngày đánh giá</th>
                        <th>Bình luận</th>
                        <th>Thái độ</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="rowIndex">
<script>
    const searchInput = document.querySelector('#searchInput');
    let table;
    $(document).ready(function () {
        table = $('#data').DataTable({
            "paging": true,
            "searching": true, // Không có tính năng tìm kiếm
            "lengthChange": false, // Không cho phép thay đổi số lượng bản ghi trên mỗi trang
            "pageLength": 5,
            "infor": false,
            "displayStart": document.getElementById("currentPageNumber").value * 5,
            language: {
                search: "Nhập từ khóa tìm kiếm"
            }
        });
        table.on('page.dt', function () {
            let pageInfo = table.page.info();
            document.getElementById("currentPageNumber").value = pageInfo.page;
        });

        const radios = document.getElementsByName('choiceFindType');
        let selectedValue = "orderId_rdo"; // Giá trị mặc định
        for (const radio of radios) {
            radio.addEventListener('change', function () {
                selectedValue = this.value;
            });
        }

        if (searchInput) {
            searchInput.addEventListener('input', function () {
                const searchValue = this.value;
                if (selectedValue == "orderId_rdo") {
                    table.columns(0).search(searchValue).draw();
                } else if (selectedValue == "customerId_rdo") {
                    table.columns(1).search(searchValue).draw();
                } else if (selectedValue == "customerName_rdo") {
                    table.columns(2).search(searchValue).draw();
                }
            });
        }
    });




    function showDetailModal(productId) {
        fetch('<%=request.getContextPath()%>/admin/sentimentDetail?id=' + productId)
            .then(res => res.json())
            .then(data => {
                const tableId = '#reviewTable';
                const tableBody = document.querySelector(`${tableId} tbody`);
                tableBody.innerHTML = "";

                if ($.fn.DataTable.isDataTable(tableId)) {
                    $(tableId).DataTable().clear().destroy();
                }

                data.forEach(item => {
                    const row = `
                    <tr>
                        <td>${item.productName}</td>
                        <td>${item.userName}</td>
                        <td>${item.createDate}</td>
                        <td>${item.comment}</td>
                        <td>Tốt</td>
                    </tr>
                `;
                    tableBody.insertAdjacentHTML("beforeend", row);
                });

                $(tableId).DataTable();
                const modal = new bootstrap.Modal(document.getElementById("orderDetailModal"));
                modal.show();
            })
            .catch(error => {
                console.error("Lỗi khi lấy dữ liệu:", error);
            });
    }



</script>
<script src="<%=request.getContextPath()%>/views/Admin/js/logging.reload.js"></script>
</body>
<%
    } else {
        response
                .
                sendRedirect
                        (
                                request
                                        .
                                        getContextPath
                                                (
                                                )
                                        +
                                        "/login"
                        )
        ;
    }%>
</html>