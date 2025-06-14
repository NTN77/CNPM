<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.adapter.InventoryProduct" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.bean.Discount" %>
<%@ page import="model.bean.Image" %>
<%@ page import="model.service.*" %>
<%@ page import="static model.service.DiscountService.getPercentageByDiscount" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /**
     * FORMAT GIÁ TIỀN THEO ĐƠN VỊ CỦA VIỆT NAM.
     */
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency); %>
<%
    List<InventoryProduct> ipList = InventoryService.getInstance().showInventoryView();
    InventoryProduct ipd = (InventoryProduct) request.getAttribute("product_detail");
    List<Category> categories = CategoryService.getInstance().getALl();
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

    <%--   IMPORT DATATABLES.  --%>
    <%--    1. Cài bootstrap cdn v5 --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.7/css/dataTables.dataTables.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.dataTables.css">

    <%--   2. Cài Jquery v3--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

    <%-- 3. Cài datatables--%>

    <script src="https://cdn.datatables.net/v/dt/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"
            integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
            crossorigin="anonymous"></script>

    <%--    Print excel, pdf, start  vv...v--%>
    <script src="https://cdn.datatables.net/2.0.7/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/dataTables.buttons.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.dataTables.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.print.min.js"></script>
    <%--    Print excel, pdf, start  end--%>

    <%--    END DATATABLES.  --%>
    <title>Kho hàng HandmadeStore</title>
    <style>
        body {
            background-color: #e5e5e5;
            color: #eb1616;
            font-family: "Open Sans", sans-serif;
            font-weight: bold;
            font-size: 16px;
            margin: 0;
        }


        .header {
            margin-top: 20px;
        }

        .header h2 {
            text-align: center;
        }

        .data_table {
            background-color: #FFFFFF;
            padding: 15px;
            box-shadow: 1px 3px 5px #aaa;
            border-radius: 5px;
        }


        #edit-info {
            background-color: #eff6ff;
            color: #000;
            box-shadow: 1px 3px 5px #aaa;
            border-radius: 5px;
            position: fixed; /* Định vị cố định */
            top: 50%; /* Đẩy div2 xuống giữa màn hình */
            left: 50%; /* Canh giữa div2 */
            transform: translate(-50%, -50%); /* Điều chỉnh vị trí chính giữa */
            width: 80%; /* Chiều rộng của div2 */
            max-height: 80%; /* Chiều cao tối đa của div2, vượt quá màn hình sẽ cuộn */
            overflow-y: auto; /* Cho phép cuộn dọc nếu nội dung dài hơn chiều cao */
            z-index: 3;

        }

        .detail-info h3 {
            color: #eb1616;
        }

        .quantity-label {
            justify-content: space-around;
            align-items: center;

        }

        .vertical-line {
            width: 1px;
            height: 24px; /* Adjust the height as needed */
            background-color: black; /* Adjust the color as needed */
            margin: 0 10px; /* Optional: add margin to separate from other elements */
        }

        .image-area {
            border: 1px solid #dee2e6;
            border-radius: 5px;


        }

        .spinner-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .d-none {
            display: none !important;
        }

        #overlay {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 2;
        }

        .container-fluid {
            z-index: 1;
        }


    </style>
</head>
<%
    /** XỬ LÝ ĐỂ VÀO TÀI KHOẢN ADMIN.
     * + check nếu không phải admin => quay trở về đăng nhập.
     */

//    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
//    if (isAdmin) {


%>
<body>

<div class="container-fluid w-100 my-0 mt-2 position-relative ">
    <div class="row">
        <div class="header">
            <h2>Kho hàng HandmadeStore</h2>
        </div>

        <div class="col-12">
            <div class="data_table  mt-2 ">
                    <div class="d-flex justify-content-end">
                        <input type="text" placeholder="Nhập mã sản phẩm" id="searchInput">
                    </div>
                <table id="table-inventory" class="display table table-striped table-hover table-bordered">
                    <thead class="table-danger">
                    <tr>
                        <th>Xem</th>
                        <th>Mã</th>
                        <th>Tên</th>
                        <th>Giá nhập</th>
                        <th>Giá bán</th>
                        <th>Khuyến mãi</th>
                        <th>Lượng tồn</th>
                        <th>Lượng bán</th>
                        <th>Biến động giá</th>
                        <th>Nhập gần nhất</th>
                        <th>Trạng thái</th>
                        <th>Đặt hàng trước</th>
                    </tr>
                    </thead>

                </table>
            </div>
        </div>
        <%--        </form>--%>


    </div>
</div>
<div id="spinner-overlay" class="spinner-overlay d-none">
    <div class="spinner-border text-primary" role="status">
        <span class="sr-only">Loading...</span>
    </div>
</div>
<div id="overlay"></div>

<div id="edit-info">

</div>


<script>
    let viewOrder = document.getElementById("orderView");
    let overlay = document.getElementById("overlay")
    <%-- BẮT ĐẦU LOAD DỮ LIỆU TỪ DB VÀO AJAX FILE -> HIỂN THỊ --%>
    let dataInventory = []
    let objectInventory;
    <%
        for(InventoryProduct o : ipList) {
             int discountPrice = (int)  (InventoryService.getInstance().productPriceIncludeDiscount(o.getId()));
     %>
    /* NOte về data-orderId : đây là dữ liệu tùy chỉnh, được lưu trữ trong phần tử button.
    - Lấy nó bằng cách .data(orderId).
    - Ta gán data-orderId = 15. -> data là dữ liệu của thẻ., orderId = 15 !.

     */
    objectInventory = {
        'productId': '<%=o.getId()%>',
        'productName': '<%=o.getName()%>',
        'costPrice': '<%=numberFormat.format(o.getCostPrice())%>',

        <%if((discountPrice != o.getSellingPrice()) ) {%>


        'sellingPrice': '<%= numberFormat.format(
                discountPrice) + " (" + numberFormat.format(
                o.getSellingPrice())  + ")"
                 %> ',
        'discount': '<%=DiscountService.getPercentageByDiscount(o.getDiscountId())%>',


        <%} else {%>
        'sellingPrice': '<%=  numberFormat.format(
                o.getSellingPrice())
                 %> ',
        'discount': '0',
        <%}%>




        'quantityRemaining': '<%=o.getQuantityRemaining()%>',
        'soldOut': '<%=o.getSoldOut()%>',
        'priceDifference': <%=o.getPriceDifference()%>,
        'lastModified': '<%=o.getLastModified()%>',
        'isSale': '<%=o.getIsSale()%>',
        'detailButton': '<button onclick="showEdit(<%=o.getId()%>)" class="btn btn-primary btn-detail view-detail" ><i class="fa-solid fa-eye"></i></button>'
    }
    dataInventory.push(objectInventory);

    <%}%>

    const searchInput = document.querySelector('#searchInput');
    let table;
    $(document).ready(function () {
            table = $("#table-inventory").DataTable(
                {
                    layout: {
                        topStart: {
                            buttons: ['copy','excel', 'pdf', 'print']
                        }
                    }
                    ,
                    paging: false,
                    scrollCollapse: true,
                    scrollY: '50vh',
                    order: [[5, 'desc']],
                    language: {
                        search: "Tìm kiếm:",
                    },

                    data: dataInventory, columns: [
                        {data: 'detailButton'},
                        {data: 'productId'},
                        {data: 'productName'},
                        {data: 'costPrice'},
                        {
                            data: 'sellingPrice'
                        },
                        {
                            data: 'discount',
                            render: function (data, type) {
                                if (type == 'display') {
                                    var value = parseInt(data);
                                    var colour = '';
                                    if (value >= 50) {
                                        colour = '#d00000';
                                    } else if (value >= 30) {
                                        colour = '#e85d04';
                                    } else if (value > 0) {
                                        colour = '#ffba08';
                                    }
                                    if (value === 0) {
                                        return '';
                                    }

                                    return '<span style="background-color: ' + colour + '; color: #FFFFFF">' + value + '%' + '</div>';
                                }
                                return data;


                            }

                        },
                        {data: 'quantityRemaining'},
                        {data: 'soldOut'},
                        {
                            data: 'priceDifference',
                            render: function (data, type) {
                                if (type == 'display') {
                                    var value = parseInt(data);
                                    var colour = 'green';
                                    var icon = '';
                                    var number = DataTable.render
                                        .number(',', '.', 0, '', ' ₫') // Không cần số thập phân
                                        .display(data);

                                    if (value > 0) {
                                        icon = '<i class="fas fa-arrow-alt-circle-up" style=`color:${colour}`></i>'
                                    } else if (value < 0) {
                                        colour = 'red';
                                        icon = '<i class="fas fa-arrow-alt-circle-down" style=`color:${colour}`></i>'
                                    } else {
                                        colour = 'gray';
                                        icon = '<i class="fas fa-minus-circle" style=`color:${colour}`></i>'
                                        return `<span style="color:${colour}">${icon}</span>`;
                                    }
                                    return `<span style="color:${colour}">${icon} ${number}</span>`;

                                }
                                return data;
                            }

                        },
                        {data: 'lastModified'},
                        {
                            data: 'isSale',
                            render: function (data, type) {
                                if (type === 'display') {
                                    if (data === "0") {
                                        return 'Ngừng bán';
                                    } else if (data === "2") {
                                        return 'Hết hàng';
                                    } else if (data === "3") {
                                        return 'Được đặt trước'}
                                    else{
                                        return 'Có sẵn';
                                    }
                                }
                                return data; // Trả về giá trị gốc trong các chế độ khác (sort, filter, type)
                            }
                        },
                        {
                            data: null,
                            render: function (data, type, row) {
                                if (type === 'display') {
                                    if (row.isSale === "3") {
                                        return '<button class="btn btn-info btn-sm" onclick="handlePreOrder(' + row.productId + ')">Xem chi tiết</button>';
                                    }
                                    return '';
                                }
                                return data;
                            }
                        }
                    ]
                });
            if (searchInput) {
                searchInput.addEventListener('input', function () {
                    table.columns(1).search(this.value).draw();
                });
            }
        }
    );

    <%--KẾT THÚC LOAD DỮ LIỆU TỪ DB VÀO AJAX FILE -> HIỂN THỊ--%>


    <%--BẮT ĐẦU XỬ LÝ NÚT XEM CHI TIẾT--%>

    function showEdit(productid) {

        // Gửi giá trị ID sang mã JSP.
        $('#spinner-overlay').removeClass('d-none');

        $.ajax({
            url: '/HandMadeStore/admin/inventory',
            type: 'GET',
            data: {id: productid},
            success: function (response) {
                // Hiển thị edit-info và overlay
                document.getElementById("edit-info").style.display = "block";
                document.getElementById("overlay").style.display = "block";

                <%--window.location.href = "<%=request.getContextPath()%>/admin/inventory?id=" + productid;--%>

                $('#edit-info').html(response);


            },
            error: function (error) {
                console.log("Lỗi khi lấy productID ", error);
            },

            complete: function () {
                // Ẩn spinner sau khi AJAX hoàn thành (bao gồm cả khi có lỗi) sau khoảng thời gian 3 giây
                setTimeout(function () {
                    $('#spinner-overlay').addClass('d-none');
                }, 1000); // 0.3s
            }

        });
    }


    <%--KẾT THÚC XỬ LÝ NÚT XEM CHI TIẾT ĐƠN HÀNG--%>


    function showAvailableCategory() {
        document.getElementById("showInputToNewCategory").style.display = "none";
        document.getElementById("showAvailableCategory").style.display = "block";
    }

    function showInputToNewCategory() {
        document.getElementById("showAvailableCategory").style.display = "none";
        document.getElementById("showInputToNewCategory").style.display = "block";
    }

    function hideEditProduct() {
        document.getElementById("edit-info").style.display = "none";
        document.getElementById("overlay").style.display = "none";
    }

    function showPreOrderDetails(detailsHtml) {
        const modalHtml = `
            <div class="modal fade" id="preOrderModal" tabindex="-1" role="dialog" aria-labelledby="preOrderModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="preOrderModalLabel">Chi tiết đặt hàng trước</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            ${detailsHtml}
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        $('#preOrderModal').remove();
        $('body').append(modalHtml);
        $('#preOrderModal').modal('show');
    }

    function showCreatePreOrderForm(productId) {
        const modalHtml = `
            <div class="modal fade" id="preOrderModal" tabindex="-1" role="dialog" aria-labelledby="preOrderModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="preOrderModalLabel">Tạo đặt hàng trước</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="createPreOrderForm">
                                <input type="hidden" id="productId" value="${productId}">
                                <div class="form-group mb-3">
                                    <label for="amount" class="form-label">Số lượng:</label>
                                    <input type="number" class="form-control" id="amount" required min="1">
                                </div>
                                <div class="form-group mb-3">
                                    <label for="dateEnd" class="form-label">Ngày kết thúc:</label>
                                    <input type="date" class="form-control" id="dateEnd" required>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-primary" onclick="createPreOrder()">Tạo</button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        $('#preOrderModal').remove();
        $('body').append(modalHtml);
        $('#preOrderModal').modal('show');
    }

    function handlePreOrder(productId) {
        $('#spinner-overlay').removeClass('d-none');
        
        $.ajax({
            url: '/HandMadeStore/admin/preorder/details',
            type: 'GET',
            data: {id: productId},
            success: function(response) {
                console.log("Response:", response); // Debug log
                if (!response || response.trim() === '') {
                    console.log("No pre-order exists, showing create form"); // Debug log
                    showCreatePreOrderForm(productId);
                } else {
                    console.log("Pre-order exists, showing details"); // Debug log
                    showPreOrderDetails(response);
                }
            },
            error: function(error) {
                console.log("Error getting pre-order details:", error); // Debug log
                showCreatePreOrderForm(productId);
            },
            complete: function() {
                setTimeout(function() {
                    $('#spinner-overlay').addClass('d-none');
                }, 1000);
            }
        });
    }

    function createPreOrder() {
        const productId = $('#productId').val();
        const amount = $('#amount').val();
        const dateEnd = $('#dateEnd').val();

        if (!amount || !dateEnd) {
            alert('Vui lòng điền đầy đủ thông tin');
            return;
        }

        $('#spinner-overlay').removeClass('d-none');

        $.ajax({
            url: '/HandMadeStore/admin/preorder/create',
            type: 'POST',
            data: {
                productId: productId,
                amount: amount,
                dateEnd: dateEnd
            },
            success: function(response) {
                if (response.status === 'success') {
                    alert('Tạo đặt hàng trước thành công');
                    $('#preOrderModal').modal('hide');
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra: ' + response.message);
                }
            },
            error: function(xhr) {
                try {
                    const response = JSON.parse(xhr.responseText);
                    alert(response.message);
                } catch (e) {
                    alert("Có lỗi xảy ra khi tạo đặt hàng trước");
                }
            },
            complete: function() {
                setTimeout(function() {
                    $('#spinner-overlay').addClass('d-none');
                }, 1000);
            }
        });
    }

</script>
</body>
<%


    //    }
//    else {
//        response
//                .
//                sendRedirect
//                        (
//                                request
//                                        .
//                                        getContextPath
//                                                (
//                                                )
//                                        +
//                                        "/login"
//                        )
//        ;
//    }
%>
</html>