<%@ page import="model.bean.Order" %>
<%@ page import="model.service.OrderService" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.bean.User" %>
<%@ page import="model.bean.OrderDetail" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.io.StringReader" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
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
    List<Order> orders = null;
    if (currentFilter != null) {
        if (currentFilter.equals("all")) {
            orders = OrderService.getInstance().getAllOrder();
        } else if (currentFilter.equals("waitConfirmOrders")) {
            orders = OrderService.getInstance().getWaitConfirmOrders();
        } else if (currentFilter.equals("preparingOrders")) {
            orders = OrderService.getInstance().getPreparingOrders();
        } else if (currentFilter.equals("deliveringOrders")) {
            orders = OrderService.getInstance().getDeliveringOrders();
        } else if (currentFilter.equals("canceledOrders")) {
            orders = OrderService.getInstance().getCanceledOrders();
        } else if (currentFilter.equals("succcessfulOrders")) {
            orders = OrderService.getInstance().getSucccessfulOrders();
        } else {
            currentFilter = "all";
            orders = OrderService.getInstance().getAllOrder();
        }
    } else {
        currentFilter = "all";
        orders = OrderService.getInstance().getAllOrder();
    }
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
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
            <div class="table-wrapper-scroll-y my-custom-scrollbar d-flex justify-content-center mt-3 mx-3">
                <table id="data" class="table table-striped table-hover">
                    <thead>
                    <tr class="text-center sticky-top">
                        <th class="text-nowrap">Mã ĐH</th>
                        <th class="text-nowrap">Tên Khách Hàng</th>
                        <th class="text-nowrap">Địa Chỉ Giao</th>
                        <th class="text-nowrap">Ngày Đặt Hàng</th>
                        <th class="text-nowrap">Tổng Tiền Hóa Đơn</th>
                        <th class="text-nowrap">Phí Vận Chuyển</th>
                        <th class="text-nowrap">Tổng Hóa Đơn</th>
                        <th class="text-nowrap">Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Order o : orders) {
                            if (o != null) {
                                User customer = UserService.getInstance().getUserById(o.getUserId() + "");
                    %>
                    <tr class="text-center" style=" cursor: pointer;"
                        onclick="showOrderDetails(event,this)"
                        id="<%=o.getId()%>"
                    >
                        <td class="text-center"><%=o.getId()%>
                        </td>
                        <td class="text-start"><%=customer.getName()%>
                        </td>
                        <td class="text-start"><%=o.getAddress()%>
                        </td>
                        <td><%=o.getOrderDate()%>
                        </td>
                        <td><%=numberFormat.format(o.getTotalPrice())%>
                        </td>
                        <td><%=numberFormat.format(o.getShippingFee())%>
                        </td>
                        <td><%=numberFormat.format(o.getTotalPrice() + o.getShippingFee())%>
                        </td>
                        <td
                                style="background-color: <%=o.getStatusAsColor()%>; color: #ffffff"
                        ><%=o.getStatusAsName()%>
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

    function deliveredOrder(orderId) {
        const rowIndex = document.getElementById("rowIndex").value;
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/order-ajax-handle", // Điều chỉnh URL tới Servlet của bạn
            data: {
                action: "deliveredOrder",
                orderId: orderId
            },
            // Truyền dữ liệu cần thiết cho Servlet
            success: function (response) {
                //change status
                if ($('#status')) {
                    $('#status').html(asNameStatus(3));
                }
                if ($('#handleButtons')) {
                    $('#handleButtons').remove()
                }
                // delete row in table
                $('#data tbody tr').eq(rowIndex).remove();

                // reload log gui
                reloadGUI();
            },
            error: function () {
                alert("Error deleting user!");
            }
        })
    }

    function preparingOder(orderId) {
        const rowIndex = document.getElementById("rowIndex").value;
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/order-ajax-handle", // Điều chỉnh URL tới Servlet của bạn
            data: {
                action: "preparingOder",
                orderId: orderId
            },
            // Truyền dữ liệu cần thiết cho Servlet
            success: function (response) {
                //change status
                if ($('#status')) {
                    $('#status').html(asNameStatus(2));
                }
                if ($('#handleButtons')) {
                    $('#handleButtons').remove()
                }
                // delete row in table
                $('#data tbody tr').eq(rowIndex).remove();

                // reload log gui
                reloadGUI();
            },
            error: function () {
                alert("Error deleting user!");
            }
        })
    }

    function confirmOrder(orderId) {
        const rowIndex = document.getElementById("rowIndex").value;
        if ($('#loadingConfirmBox')) {
            $('#loadingConfirmBox').css('display', 'block');
        }
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/order-ajax-handle", // Điều chỉnh URL tới Servlet của bạn
            data: {
                action: "confirmOrder",
                orderId: orderId
            },
            // Truyền dữ liệu cần thiết cho Servlet
            success: function (response) {
                if ($('#status')) {
                    console.log(response)
                    $('#status').html(asNameStatus(1));
                }
                let parentDocument = window.parent.document;
                let waitConfirmOrdersNumber = parentDocument.getElementById('waitConfirmOrdersNumber');
                waitConfirmOrdersNumber.innerHTML = response;
                //buttons handle: hủy + xác nhận
                if ($('#handleButtons')) {
                    $('#handleButtons').remove()
                }
                //     xóa dòng
                $('#data tbody tr').eq(rowIndex).remove();
                if ($('#loadingConfirmBox')) {
                    $('#loadingConfirmBox').remove();
                }
                // reload log gui
                reloadGUI();
            },
            error: function () {
                alert("Error deleting user!");
            }
        })
    }

    function cancelOrder(orderId, rowIndex) {
        let cancelReason;
        if ($('#cancelReason')) {
            cancelReason = $('#cancelReason').value;
        }
        if ($('#loadingCancelBox')) {
            $('#loadingCancelBox').css('display', 'block');
        }
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/order-ajax-handle",
            data: {
                action: "customerCancelOrder",
                orderId: orderId,
                cancelReason: cancelReason
            },
            success: function (response) {
                if ($('#status')) {
                    console.log(response)
                    $('#status').html(asNameStatus(response));
                }
                if ($('#cancelOrderBox')) {
                    $('#cancelOrderBox').remove()
                }
                if ($('#handleButtons')) {
                    $('#handleButtons').remove()
                }
                let parentDocument = window.parent.document;
                let waitConfirmOrdersNumber = parentDocument.getElementById('waitConfirmOrdersNumber');
                waitConfirmOrdersNumber.innerHTML = response;

                $('#data tbody tr').eq(rowIndex).remove();
                // reload log gui
                reloadGUI();
            },
            error: function () {
                alert("Hủy đơn hàng thất bại!");
            }
        })
    }

    function showOrderDetails(event, clickedElement) {
        let rowIndex = 0;
        let row = clickedElement;
        while ((row = row.previousElementSibling) != null) {
            rowIndex++;
        }
        document.getElementById("rowIndex").value = rowIndex;
        event.preventDefault();
        const orderId = clickedElement.id;
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/order-ajax-handle",
            data: {
                action: "showOrder",
                orderId: orderId
            },
            success: function (response) {
                let orderDetailsResponse;

                // Kiểm tra nếu response đã là đối tượng JSON
                if (typeof response === "string") {
                    try {
                        orderDetailsResponse = JSON.parse(response);
                    } catch (e) {
                        console.error("Response không phải là JSON hợp lệ:", response);
                        return;
                    }
                } else {
                    orderDetailsResponse = response;
                }
                let showCancelBox, waitConfirmHandleButton, preparingHandleButton, deleveringHandleButton;
                if (orderDetailsResponse.order.status == 0 || orderDetailsResponse.order.status == 1 || orderDetailsResponse.order.status == 2) {
                    showCancelBox = `
                        <div  class="mx-2" id ="cancelBox">
                         <div>
                            <button type="button" class="btn btn-danger mx-2"
                             id = "btnShowCancelOrder"
                             onclick="showCancelOrder(${orderDetailsResponse.order.id}, ${rowIndex})">Hủy đơn hàng
                             </button>
                        </div>
                        <div id="cancelOrderBox"></div>
                        </div>
                    `
                }
                if (orderDetailsResponse.order.status == 0) {
                    waitConfirmHandleButton = `
                        <div  class="mx-2">
                            <buton type="button" class="btn btn-success mx-2"
                            id="confirmButton"
                            onclick="confirmOrder(${orderDetailsResponse.order.id})"
                             >Xác nhận đơn hàng</button>
                             <div id="loadingConfirmBox" style="display:none;">
                                <span class="spinner-border spinner-border-sm" role="status"
                                      aria-hidden="true"></span>
                                Đang xác nhận đơn hàng
                        </div>
                        </div>
                    `
                }
                if (orderDetailsResponse.order.status == 1) {
                    preparingHandleButton = `
                        <div  class="mx-2">
                            <buton type="button" class="btn btn-success mx-2"
                                onclick="preparingOder(${orderDetailsResponse.order.id})"
                            >
                                Xác nhận đã đóng gói
                            </button>
                        </div>
                    `
                }
                if (orderDetailsResponse.order.status == 2) {
                    deleveringHandleButton = `
                        <div class="mx-2">
                            <buton type="button"class="btn btn-success mx-2"
                                id="deliveredButton"
                                onclick="deliveredOrder(${orderDetailsResponse.order.id})"
                             >Xác nhận đã giao</button>
                        </div>
                    `
                }
                let htmlContent = `
                    <div class="fw-bold text-end" style="font-size: 30px;">
                        <button type="button" id="back_btn" onclick="hideDetailOrder()">
                            <i class="fa-regular fa-rectangle-xmark"></i>
                        </button>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <h3 style = "text-decoration: underline;">Chi tiết sản phẩm</h3>
                            <div class="row" id="product-details" style="height: 500px;overflow-y: scroll;">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" p-3 rounded">
                                <h2 style = "text-decoration: underline;">Thông tin chi tiết đơn hàng</h2>
                                <p><strong>Mã đơn hàng:</strong> ${orderDetailsResponse.order.id}</p>
                                <p><strong>Email tài khoản:</strong> ${orderDetailsResponse.user.email}</p>
                                <p><strong>Ngày đặt hàng:</strong> ${formattedDate(orderDetailsResponse.order.orderDate)}</p>
                                <p><strong>Trạng thái:</strong> <p id="status" class="text-center fw-bold fs-5">${asNameStatus(orderDetailsResponse.order.status)}</p></p>
                                <p><strong>Tên người nhận:</strong> ${orderDetailsResponse.order.consigneeName}</p>
                                <p><strong>Số điện thoại người nhận:</strong> ${orderDetailsResponse.order.consigneePhoneNumber}</p>
                                <p><strong>Địa chỉ giao:</strong> ${orderDetailsResponse.order.address}</p>
                                <p><strong>Tiền sản phẩm:</strong> ${formattedPrice(orderDetailsResponse.order.totalPrice - orderDetailsResponse.order.shippingFee)}</p>
                                <p><strong>Phí vận chuyển:</strong> ${formattedPrice(orderDetailsResponse.order.shippingFee)}</p>
                                <p><strong>Tổng tiền:</strong> ${formattedPrice(orderDetailsResponse.order.totalPrice)}</p>
                                <p><strong>Ghi chú:</strong> ${orderDetailsResponse.order.note?orderDetailsResponse.order.note:""}</p>
                                <div class="d-flex" id="handleButtons">
                                ` + (showCancelBox ? showCancelBox : "") + `
                                 ` + (waitConfirmHandleButton ? waitConfirmHandleButton : "") + `
                                  ` + (preparingHandleButton ? preparingHandleButton : "") + `
                                   ` + (deleveringHandleButton ? deleveringHandleButton : "") + `
                                </div>
                            </div>
                        </div>
                    </div>
                `;

                // Tạo HTML cho danh sách sản phẩm
                let productDetailsHtml = '';
                orderDetailsResponse.orderDetailMappings.forEach(function (orderDetailMapping) {
                    productDetailsHtml += `
                        <div class="col-md-12 mb-4">
                            <div class="card">
                                <div class="row" >
                                    <img src="<%=request.getContextPath()+"/"%>${orderDetailMapping.imagePath}" class="col-4" width="100px" alt="Product Image">
                                    <div class="col">
                                        <h5 class="card-title mt-3">${orderDetailMapping.productName}</h5>
                                        <p class="card-text  my-0 ">Đơn giá: ${formattedPrice(orderDetailMapping.orderDetail.finalSellingPrice)}</p>
                                        <p class="card-text  my-0">X ${orderDetailMapping.orderDetail.quantity}</p>
                                        <p class="card-text fw-bold text-danger my-0">${formattedPrice(orderDetailMapping.orderDetail.finalSellingPrice * orderDetailMapping.orderDetail.quantity)}</p>
                                        <a href="<%=request.getContextPath()%>/product-detail?id=${orderDetailMapping.orderDetail.productId}" class ="my-3">Xem, Đánh giá trực tiếp sản phẩm</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
                });

                // Hiển thị thông tin chi tiết đơn hàng
                $('#detailOrder').addClass('w-100 h-100 p-3 rounded');
                $('#detailOrder').css('display', 'block');
                $('#detailOrder').html(htmlContent);
                // Hiển thị danh sách sản phẩm
                $('#product-details').html(productDetailsHtml);

            },
            error: function () {
                alert("error")
            }
        })
    }

    function showCancelOrder(orderId, rowIndex) {
        let cancelOrderBox = `
                       <div class="mb-3">
                          <label for="cancelReason" class="form-label">Lý do hủy đơn hàng</label>
                          <textarea class="form-control" id="cancelReason" rows="2"></textarea>
                        </div>
                        <button type="button" class="w-100 btn btn-danger" onclick="cancelOrder(${orderId}, ${rowIndex})">Xác nhận hủy</button>
                        <div id="loadingCancelBox" style="display:none;">
                            <span class="spinner-border spinner-border-sm" role="status"
                                  aria-hidden="true"></span>
                            Đang hủy bỏ đơn hàng
                        </div>
                    `;
        if ($('#cancelOrderBox')) {
            $('#cancelOrderBox').html(cancelOrderBox)

            if ($('#cancelOrderBox').css('display') === 'none') {
                $('#cancelOrderBox').css('display', 'block');
            } else {
                $('#cancelOrderBox').css('display', 'none');
            }
        }
    }

    function hideDetailOrder() {
        $('#detailOrder').css('display', 'none');
    }

    function formattedDate(value) {
        // Định dạng ngày giờ theo yyyy-MM-dd HH:mm:ss.S
        const orderDate = new Date(value);
        const year = orderDate.getFullYear();
        const month = String(orderDate.getMonth() + 1).padStart(2, '0');
        const day = String(orderDate.getDate()).padStart(2, '0');
        const hours = String(orderDate.getHours()).padStart(2, '0');
        const minutes = String(orderDate.getMinutes()).padStart(2, '0');
        const seconds = String(orderDate.getSeconds()).padStart(2, '0');
        const milliseconds = String(orderDate.getMilliseconds()).padStart(3, '0');
        const formattedDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}.${milliseconds}`;
        return formattedDate;
    }

    function formattedPrice(value) {
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(value);
        return formattedPrice;
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