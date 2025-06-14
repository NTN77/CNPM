<%@ page import="model.service.OrderService" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.io.StringReader" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.bean.*" %>
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
    List<OrderImage> orders = OrderService.getInstance().getAllOrderCustom();
%>
<%System.out.println(currentFilter + "  -  " + currentFindText);%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý đơn hàng</title>
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
    <form action="<%=request.getContextPath()%>/admin/order" method="post" id="orderForm">
        <div class="customer_list  mt-5 ">
            <%--            form--%>
            <div class="row d-flex">
                <div class="col-lg-5 col-sm-12">
                    <div class="d-flex">
                        <div class="form-check mx-1">
                            <input class="form-check-input" type="radio" name="choiceFindType" id="orderId_rdo"
                                   value="orderId_rdo"
                                   checked
                            >
                            <label class="form-check-label" for="orderId_rdo">
                                Tìm theo mã đơn hàng
                            </label>
                        </div>
                        <div class="form-check mx-1">
                            <input class="form-check-input" type="radio" name="choiceFindType" id="customerId_rdo"
                                   value="customerId_rdo"
                            >
                            <label class="form-check-label" for="customerId_rdo">
                                Tìm theo mã khách hàng
                            </label>
                        </div>

                        <div class="form-check mx-1">
                            <input class="form-check-input" type="radio" name="choiceFindType" id="customerName_rdo"
                                   value="customerName_rdo"
                            >
                            <label class="form-check-label" for="customerName_rdo">
                                Tìm tên khách hàng
                            </label>
                        </div>
                    </div>
                    <input type="text" class="form-control 1"
                           name="findText"
                           id="searchInput"
                    >
                </div>
                <button type="submit" name="submit_filter" value="all" class="btn btn-secondary mx-2 col-lg-1 col-sm-1">
                    Tất cả đơn
                    hàng
                </button>
                <button type="submit" name="submit_filter" value="waitConfirmOrders"
                        class="btn btn-warning mx-2 col-sm-1">
                    Đơn
                    hàng cần xác nhận
                </button>
                <button type="submit" name="submit_filter" value="preparingOrders"
                        class="btn mx-2 col-sm-1" style="background-color: cadetblue">
                    Đơn hàng đang đóng gói
                </button>
                <button type="submit" name="submit_filter" value="deliveringOrders"
                        class="btn btn-primary mx-2 col-sm-1">Đơn
                    hàng đang giao
                </button>
                <button type="submit" name="submit_filter" value="canceledOrders" class="btn btn-danger mx-2 col-sm-1">
                    Đơn
                    hàng
                    đã hủy
                </button>
                <button type="submit" name="submit_filter" value="succcessfulOrders"
                        class="btn btn-success mx-2 col-sm-1">
                    Đơn
                    hàng thành công
                </button>
            </div>
            <div class="table-wrapper-scroll-y my-custom-scrollbar d-flex justify-content-center mt-3">
                <table id="data" class="table table-striped table-hover" style="min-width: 1000px; width: 100%;">
                    <thead>
                    <tr class="text-center sticky-top">
                        <th class="text-nowrap">Mã ĐH</th>
                        <th class="text-nowrap">Mã KH</th>
                        <th class="text-nowrap">Mã Sản phẩm</th>
                        <th class="text-nowrap">Ngày đặt Hàng</th>
                        <th class="text-nowrap">Trạng Thái</th>
                        <th class="text-nowrap" colspan="2">Chức năng</th>
                        <th class="text-nowrap">Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (OrderImage o : orders) {
                            if (o != null) {
                                User customer = UserService.getInstance().getUserById(o.getUserId() + "");
                    %>
                    <tr class="text-center" style=" cursor: pointer;"
                        id="<%=o.getId()%>"
                    >
                        <td class="text-center"><%=o.getId()%>
                        </td>
                        <td class="text-center">
                            <%= (customer != null) ? customer.getId() : "N/A" %>
                        </td>
                        <td class="text-center">
                            <%= o.getProductId() %>
                        </td>
                        <td class="text-start"><%=o.getOrderDate()%>
                        </td>
                        </td>
                        <td>
                            <span class="badge" style="background-color:<%=o.getStatusAsColor()%>;">
                                <%=o.getStatusAsName()%>
                            </span>
                        </td>
                        <td class="text-start">
                            <button type="button" class="btn btn-sm btn-success" onclick="confirmOrder(<%=o.getId()%>)">
                                Xác nhận
                            </button>
                        </td>
                        <td class="text-start">
                            <button type="button" class="btn btn-sm btn-danger" onclick="cancelOrder(<%=o.getId()%>)">
                                Hủy đơn
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-info" onclick='showDetailModal(<%=o.getId()%>)'>Chi tiết</button>
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
<!-- Modal chi tiết đơn hàng custom -->
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderDetailModalLabel">Chi tiết đơn hàng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
            </div>
            <div class="modal-body" id="modalDetailContent">
                    <%--Nội dung--%>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
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

    function confirmOrder(orderId) {
        Swal.fire({
            title: 'Xác nhận đơn hàng?',
            text: 'Bạn có chắc chắn muốn xác nhận đơn hàng này không?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Đang xác nhận đơn hàng...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                $.post("<%=request.getContextPath()%>/admin/order-custom", {
                    action: "confirm",
                    orderId: orderId
                }, function (response) {
                    if (response === "success") {
                        Swal.fire({
                            icon: 'success',
                            title: 'Thành công!',
                            text: 'Đơn hàng đã được xác nhận.'
                        }).then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi!',
                            text: 'Xác nhận đơn hàng thất bại.'
                        });
                    }
                });
            }
        });
    }



    function cancelOrder(orderId) {
        Swal.fire({
            title: 'Hủy đơn hàng',
            input: 'textarea',
            inputLabel: 'Lý do hủy đơn hàng',
            inputPlaceholder: 'Nhập lý do tại đây...',
            inputAttributes: {
                'aria-label': 'Nhập lý do tại đây'
            },
            showCancelButton: true,
            confirmButtonText: 'Xác nhận hủy',
            cancelButtonText: 'Đóng',
            preConfirm: (cancelReason) => {
                if (!cancelReason || cancelReason.trim() === '') {
                    Swal.showValidationMessage('Vui lòng nhập lý do hủy đơn hàng');
                }
                return cancelReason;
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const cancelReason = result.value;

                Swal.fire({
                    title: 'Đang xử lý hủy đơn...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                $.post("<%=request.getContextPath()%>/admin/order-custom", {
                    action: "cancel",
                    orderId: orderId,
                    cancelReason: cancelReason
                }, function (response) {
                    if (response === "success") {
                        Swal.fire({
                            icon: 'success',
                            title: 'Đã hủy đơn hàng!',
                            text: 'Thông tin đơn đã được cập nhật.'
                        }).then(() => {
                            location.reload();
                        });
                    } else if (response === "missing_reason") {
                        Swal.fire({
                            icon: 'warning',
                            title: 'Thiếu lý do',
                            text: 'Vui lòng nhập lý do hủy đơn hàng.'
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi!',
                            text: 'Không thể hủy đơn hàng. Vui lòng thử lại.'
                        });
                    }
                });
            }
        });
    }

    function showDetailModal(orderId) {
        // console.log("clicked", orderId);
        <%--console.log('<%=request.getContextPath()%>/getOrderDetail?id=' + orderId);--%>
        fetch('<%=request.getContextPath()%>/getOrderDetail?id=' + orderId)
            .then(res => {
                if (!res.ok) throw new Error('Lỗi khi gọi API: ' + res.status);
                return res.json();
            })
            .then(order => {
                let html = `
                    <p><strong>Ảnh custom:</strong><br><img src="${order.imagePath}" width="150"></p>
                    <p><strong>Ngày giao hàng:</strong> ${order.recieveDate}</p>
                    <p><strong>Địa chỉ:</strong> ${order.address}</p>
                    <p><strong>Tùy chọn:</strong> ${order.otherCustom}</p>
                    <p><strong>SĐT:</strong> ${order.tel}</p>
                    <p><strong>Ghi chú:</strong> ${order.note}</p>
                `;
                document.getElementById("modalDetailContent").innerHTML = html;
                let modal = new bootstrap.Modal(document.getElementById("orderDetailModal"));
                modal.show();
            });
    }


    function asNameStatus(statusNumber) {
        const numericStatus = parseInt(statusNumber, 10); // Hoặc Number(status)
        let statusText = '';
        switch (numericStatus) {
            case 0://isWaitConfirmOrder
                statusText = 'Chờ xác nhận';
                break;
            case 1://isPreparing
                statusText = 'Đang đóng gói';
                break;
            case 2://isDeliveringOrder
                statusText = 'Đang giao';
                break;
            case 3://isSucccessfulOrder
                statusText = 'Thành công';
                break;
            case 4://isCanceledOrder
                statusText = 'Đã hủy';
                break;
            default:
                statusText = 'Không xác định';
                break;
        }
        return statusText;
    }

    function asColorStatus(statusNumber) {
        let backgroundColor = '';
        switch (statusNumber) {
            case 0://isWaitConfirmOrder
                backgroundColor = '#ffcc00';
                break;
            case 1://isPreparing
                backgroundColor = '#5F9EA0';
                break;
            case 2://isDeliveringOrder
                backgroundColor = '#0171d3';
                break;
            case 3://isSucccessfulOrder
                backgroundColor = '#4d8a54';
                break;
            case 4://isCanceledOrder
                backgroundColor = '#ff0000';
                break;
            default:
                backgroundColor = '#ffffff';
                break;
        }
        return backgroundColor;
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