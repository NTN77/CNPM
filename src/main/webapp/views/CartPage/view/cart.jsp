<%@ page import="model.service.ImageService" %>
<%@ page import="java.util.*" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.bean.*" %><%--
=======
<<<<<<< HEAD
=======
<<<<<<< HEAD
<%--
>>>>>> origin/main
>>>>>>> origin/main

  Created by IntelliJ IDEA.
  User: Kien Nguyen
  Date: 1/19/2024
  Time: 11:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Giỏ Hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">

    <%--   IMPORT DATATABLES.  --%>
    <%--    1. Cài bootstrap cdn v5 --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.7/css/dataTables.dataTables.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.dataTables.css">

    <%--   2. Cài Jquery v3--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

    <%-- 3. Cài datatables--%>

    <script src="https://cdn.datatables.net/v/dt/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>





    <style>
        <%@include file="../css/cartstyle.css"%>
    </style>
</head>
<body>

<%--Thanh điều hướng - header--%>

<%@include file="/views/MenuBar/menu.jsp" %>
<%--<%Map<Integer, Item> list = cart. %>--%>
<%
    //Xử lý trường hợp, stock giảm sau khi khách đã thêm vào giỏ hàng trước đó => thông báo xin lỗi.
    List<String> messages = new ArrayList<>();


    Iterator<Map.Entry<Integer, Item>> entryIterator = cart.getItems().entrySet().iterator();
    while (entryIterator.hasNext()) {
        Map.Entry<Integer, Item> itemEntry = entryIterator.next();
        Product p = ProductService.getInstance().getProductById(itemEntry.getKey());
        int stock = p.getStock();
        int isSale = p.getIsSale();

        itemEntry.getValue().setProduct(p);

        double price = ProductService.getInstance().productPriceIncludeDiscount(p);

        itemEntry.getValue().getProduct().setStock(stock);
        if(isSale == 0) {
            messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " đã ngừng kinh doanh.");
            entryIterator.remove();
            continue;
        }

        if(itemEntry.getValue().getPrice() != price) {
            itemEntry.getValue().setPrice(price);
        }

        // Handle pre-order products (isSale = 3)
        if (isSale == 3) {
            model.bean.PreOrder preOrder = model.service.PreOrderService.getInstance().getPreOrderById(p.getId());
            if (preOrder != null) {
                int preOrderAmount = preOrder.getAmount();
                // If there's stock available, use stock limit
                if (stock > 0) {
                    if (itemEntry.getValue().getQuantity() > stock) {
                        itemEntry.getValue().setQuantity(stock);
                        messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " chỉ còn " + stock + " sản phẩm.");
                    }
                } 
                // If no stock, use pre-order amount limit
                else if (itemEntry.getValue().getQuantity() > preOrderAmount) {
                    itemEntry.getValue().setQuantity(preOrderAmount);
                    messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " chỉ còn " + preOrderAmount + " sản phẩm cho đặt trước.");
                }
            }
        }
        // Handle normal products
        else if (stock == 0) {
            itemEntry.getValue().setQuantity(stock);
            messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " đã hết hàng.");
        } else if (itemEntry.getValue().getQuantity() > stock) {
            itemEntry.getValue().setQuantity(stock);
            messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " chỉ còn " + stock + " sản phẩm.");
        }
    }



//    for(Map.Entry<Integer, Item> itemEntry : cart.getItems().entrySet()){
//        int stock = ProductService.getStockProduct(itemEntry.getKey());
//        int isSale = ProductService.getIsSale(itemEntry.getKey());
//        double price = ProductService.getInstance().productPriceIncludeDiscount(itemEntry.getValue().getProduct());
//        System.out.println(price);
//        itemEntry.getValue().getProduct().setStock(stock);
//        if(itemEntry.getValue().getPrice() != price) {
//            itemEntry.getValue().setPrice(price);
//        }
//
//        if(isSale == 0) {
//            messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " đã ngừng kinh doanh.");
//
//        }
//
//
//
//        if(stock == 0 ) {
//            itemEntry.getValue().setQuantity(stock);
//            messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " đã hết hàng.");
//        }
//
//
//        else if(itemEntry.getValue().getQuantity() > stock ) {
//            itemEntry.getValue().setQuantity(stock);
//            messages.add("Sản phẩm " + itemEntry.getValue().getProduct().getName() + " chỉ còn " + stock + " sản phẩm.");
//        }
//    }




%>


<nav aria-label="breadcrumb ">
    <ol class="breadcrumb m-0 ">
        <li class="breadcrumb-item"><a
                href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp">Trang Chủ</a></li>

        <li class="breadcrumb-item active" aria-current="page" style="color: #e32124">Giỏ hàng
        </li>
    </ol>
</nav>
<div>
    <%if (!messages.isEmpty()) { %>
    <div id="inform" class="d-flex justify-content-center flex-column align-items-center p-3">
        <h2>Kính gửi quý khách hàng,</h2>
    <span>Chúng tôi xin trân trọng thông báo rằng sau khi kiểm tra, có một số sản phẩm trong giỏ hàng của Quý khách hiện không đủ số lượng trong kho. Cụ thể là:
    </span>
        <% for(String i : messages) { %>
        <p style="font-weight: bold; color: red" class="m-0 p-2" ><%=i%></p>

        <%
            }
        %>
        <span>Chúng tôi rất xin lỗi về sự bất tiện này và cam kết sẽ nhanh chóng khắc phục tình trạng hàng hoá để mang đến dịch vụ tốt nhất cho Quý khách. </span>
    </div>

    <%}%>
</div>


<div class="row">
    <div class="col-12">
            <div class="vh-100 w-100 bg-body d-flex justify-content-center align-items-center ">


                <%  if (cart.getItems().isEmpty()) {
                %>
                    <div  id="empty-cart-display" class="d-flex flex-column justify-content-center align-items-center ">
                    <img src="<%=request.getContextPath()%>/images/empty-cart.png" class="w-256px h-256px" alt="">
                    <h3>Giỏ hàng của bạn đang trống !</h3>
                    <span>Quay trở lại trang chủ, khám phá và đưa vào giỏ những lựa chọn tuyệt vời nào!</span>
                        <button type="button" class="pause_bt mt-3" style="background-color: #faf5f5"
                                onclick="window.location = '../../MainPage/view_mainpage/mainpage.jsp'">Tiếp tục mua hàng
                        </button>
                    </div>
                <%
                    } else {
                %>
                <!--Main-->
                <div id="list-cart-item">
                    <div class="m-auto" style="height: 400px;width: 90%; overflow-y: auto;">
                        <table id="order-list" class="table table-borderless text-center mb-5">
                            <thead>
                            <tr class="align-middle border">
                                <th class="border-0" style="width: 19%">Sản phẩm</th>
                                <th class="border-0" style="width: 28%">Thông tin sản phẩm</th>
                                <th class="border-0" style="width: 17%">Đơn giá</th>
                                <th class="border-0" style="width: 18%">Số lượng</th>
                                <th class="border-0" style="width: 13%">Thành tiền</th>
                                <th class="border-0" style="width: 5%">Xóa</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%Item itemTemp = new Item();
                            double total = 0;%>
                            <% for (Item item : cart.getItems().values()) { %>
                            <%
                            total += item.getQuantity() * item.getPrice();
                                itemTemp = item;%>
                            <tr class="border-1">
                                <td class="align-middle">
                                    <% String pathImage = ImageService.getInstance().pathImageOnly(item.getProduct().getId()); %>

                                    <img class="product-img" src="<%=request.getContextPath()%>/<%=pathImage%>"
                                         alt="sanpham" width="80%"
                                         height="80%">
                                </td>
                                <td class="align-middle">
                                    <div>
                                        <a class="text-decoration-none" href="<%=request.getContextPath()%>/product-detail?id=<%=item.getProduct().getId()%>"> <h6 style="color: black"><%=item.getProduct().getName()%>
                                        </h6> </a>

                                    </div>
                                </td>
                                <td class="align-middle">
                                    <%=numberFormat.format(item.getPrice())%>
                                </td>
                                <td class="align-middle">
                                    <div class="quantity-box d-flex p-1 border justify-content-center">
                                        <input type="hidden" name="id" value="<%=item.getProduct().getId()%>">
                                        <% int preOrderAmount = -1;
                                           if (item.getProduct().getIsSale() == 3) {
                                               model.bean.PreOrder preOrder = model.service.PreOrderService.getInstance().getPreOrderById(item.getProduct().getId());
                                               if (preOrder != null) {
                                                   preOrderAmount = preOrder.getAmount();
                                               }
                                           }
                                        %>
                                        <% if (preOrderAmount > 0) { %>
                                        <input type="hidden" id="preorder_amount_<%=item.getProduct().getId()%>" value="<%=preOrderAmount%>">
                                        <% } %>
                                        <button id="increase_bt" type="submit" name="num" value="-1"
                                                class="text-center border-0 bg-body fw-bold"
                                                style="width: 30px;" >
                                            <a style="text-decoration: none" onclick="giamSL(this,<%=item.getProduct().getId()%>,<%=item.getPrice()%>)">-</a>
                                        </button>
                                        <input id="quantity_input<%=item.getProduct().getId()%>" readonly class="border-0 w-50 text-center" type="text"
                                               value="<%=item.getQuantity()%>" >
                                        <button type="submit"  name="num" value="1"
                                                id="reduce_bt" class="text-center border-0 bg-body fw-bold"
                                                style="width:30px;" >
                                            <a style="text-decoration: none" onclick="tangSL(this,<%=item.getProduct().getId()%>,<%=item.getPrice()%>,<%=item.getProduct().getStock()%>)">+</a>
                                        </button>
                                    </div>
                                </td>
                                <td id="totalItem<%=item.getProduct().getId()%>" class="align-middle">
                                    <%=numberFormat.format(item.getQuantity() * item.getPrice())%>
                                </td>
                                <td class="align-middle">
                                    <button onclick="deleteRow(this,<%=item.getProduct().getId()%>,<%=item.getPrice()%>)" style="border: none;background: white;color: blue;">
                                        <i class="fa-solid fa-trash-can"></i> </button>
                                </td>
                            </tr>


                            <%}%>


                            </tbody>
                        </table>
                    </div>
                    <div class="line-block text-end mb-3 mt-5 me-5">
                        <span class="total-amount h4 me-1 fw-normal">Tổng tiền:</span>
                        <p id="total_Cart" class="d-none"><%=total%></p>
                        <span id="total_amount" class="h5"><%=numberFormat.format(total)%></span>
                    </div>
                    <div class="line-block text-end">
                        <button type="button" class="pause_bt"
                                onclick="window.location = '../../MainPage/view_mainpage/mainpage.jsp'">Tiếp tục mua hàng
                        </button>
                        <%if(total > 0) {%>
                        <% 
                            boolean hasPreOrder = false;
                            for (Item item : cart.getItems().values()) {
                                if (item.getProduct().getIsSale() == 3 && item.getProduct().getStock() == 0) {
                                    model.bean.PreOrder preOrder = model.service.PreOrderService.getInstance().getPreOrderById(item.getProduct().getId());
                                    if (preOrder != null && preOrder.getAmount() > 0) {
                                        hasPreOrder = true;
                                        break;
                                    }
                                }
                            }
                        %>
                        <%if(hasPreOrder){%>
                        <button type="button" id="btn-preorder-payment" class="complete_bt me-5" style="background-color: #ff9800;">
                            Thanh toán đặt trước
                        </button>
                        <%}%>
                        <%if(u != null){%>
                        <button type="button" id="btn-payment" class="complete_bt me-5"
                                >Thanh Toán
                        </button>
                        <%}else{%>
                        <button type="button" class="complete_bt me-5"
                                onclick="window.location = '<%=request.getContextPath()%>/login'">Thanh Toán
                        </button>
                        <%}%>
                        <%}%>
                    </div>
                </div>

                <%}%>
            </div>
    </div>
</div>


<!--    Footer-->
<%@include file="/views/Footer/footer.jsp" %>
<%--JS--%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>

function deleteRow(btn,idProduct,priceProduct) {
    let actionCart = "delete";
    let total_amount = document.getElementById("total_amount");
    let total_Cart = document.getElementById("total_Cart");
    let total = parseInt(total_Cart.innerText);
    let quantity_input = document.getElementById("quantity_input"+idProduct);
    let quantityPresent = quantity_input.value;
    console.log("quanty Present " + quantityPresent);
    console.log(total);
    let newTotal = total - (priceProduct*quantityPresent);
    const numberFomat = Intl.NumberFormat('vi-VN',{
        style: 'currency',
        currency: "VND",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    });
    console.log(total);
    console.log(priceProduct);
    console.log(quantityPresent);
    console.log(priceProduct*quantityPresent);
    $.ajax({
        url: "/HandMadeStore/add-cart",
        method: "POST",
        data: {
            actionCart: actionCart,
            id: idProduct
        },
        success: function (response) {
            console.log("Thành Công Xóa");
            let currentCartItems = $("#order-list tr").length;
            console.log( "so item : " +  currentCartItems);
                btn.closest("tr").remove();
                currentCartItems -=1;
            console.log( "so item after : " +  currentCartItems);

                if(currentCartItems === 1){
                    $("#list-cart-item").html(`
                    <div  id="empty-cart-display" class="d-flex flex-column justify-content-center align-items-center ">
                    <img src="<%=request.getContextPath()%>/images/empty-cart.png" class="w-256px h-256px" alt="">
                    <h3>Giỏ hàng của bạn đang trống !</h3>
                    <span>Quay trở lại trang chủ, khám phá và đưa vào giỏ những lựa chọn tuyệt vời nào!</span>
                        <button type="button" class="pause_bt mt-3" style="background-color: #faf5f5"
                                onclick="window.location = '../../MainPage/view_mainpage/mainpage.jsp'">Tiếp tục mua hàng
                        </button>
                    </div>
                `);
                    return; // Ngừng thực hiện các bước tiếp theo
                }
                else {
                    // Check if the deleted item was a pre-order product
                    let isPreOrderProduct = false;
                    let remainingPreOrderItems = 0;
                    
                    // Check remaining items for pre-order products
                    $("#order-list tr").each(function() {
                        let productId = $(this).find('input[name="id"]').val();
                        if (productId) {
                            let preorderAmountInput = $(`#preorder_amount_${productId}`);
                            if (preorderAmountInput.length > 0) {
                                remainingPreOrderItems++;
                            }
                        }
                    });

                    // Hide pre-order payment button if no pre-order items remain
                    if (remainingPreOrderItems === 0) {
                        $("#btn-preorder-payment").hide();
                    }

                    let formatTotal = numberFomat.format(newTotal);
                    console.log(formatTotal);
                    total_amount.innerText = formatTotal;
                    total_Cart.innerText = newTotal;
                    handleDeleteToCart(response);
                    Swal.fire({
                        position: "center",
                        icon: "success",
                        title: "Xóa Sản Phẩm Thành Công!",
                        showConfirmButton: false,
                        timer: 1500
                    });
                }
        }
    })
}


// Giảm So luong
function giamSL(btn,idProduct,priceProduct){
    console.log(idProduct);
    let totalItem = document.getElementById("totalItem"+idProduct);
    const numberFomat = Intl.NumberFormat('vi-VN',{
        style: 'currency',
        currency: "VND",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    });
    let total_amount = document.getElementById("total_amount");
    let total_Cart = document.getElementById("total_Cart");
    let total = parseInt(total_Cart.innerText);
    let quantityInput = document.getElementById("quantity_input"+idProduct);
    let quantity = quantityInput.value;
    let num = -1;
    console.log(quantity);
    if(quantity > 1){
        $.ajax({
            url: "/HandMadeStore/add-cart",
            data: {
                actionCart: "put",
                id: idProduct,
                num: num
            },
            success: function (response){
                console.log("Thành công giảm");
                let  quantityAfter = quantity -1;
                quantityInput.value = quantityAfter;
                let formatTotalItem = numberFomat.format(quantityAfter * priceProduct);
                totalItem.innerText = formatTotalItem;
                let totalAfter = total - priceProduct;
                total_Cart.innerText = totalAfter;
                total_amount.innerText = numberFomat.format(totalAfter);
            }
        })
    }else{
        Swal.fire({
            position: "center",
            icon: "error",
            title: "Không thể giảm số lượng được nữa!",
            showConfirmButton: false,
            timer: 1500
        });
    }
}
// Tang So luong
function tangSL(btn, idProduct, priceProduct, stockProduct) {
    let totalItem = document.getElementById("totalItem" + idProduct);
    const numberFomat = Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: "VND",
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    });
    let total_amount = document.getElementById("total_amount");
    let total_Cart = document.getElementById("total_Cart");
    let total = parseInt(total_Cart.innerText);
    let quantityInput = document.getElementById("quantity_input" + idProduct);
    let quantity = parseInt(quantityInput.value);
    let num = 1;

    // Check if this is a pre-order product
    let preorderAmountInput = document.getElementById("preorder_amount_" + idProduct);
    let maxQuantity = stockProduct;

    // If it's a pre-order product and has no stock, use pre-order amount
    if (preorderAmountInput && stockProduct === 0) {
        maxQuantity = parseInt(preorderAmountInput.value);
    }

    if (quantity < maxQuantity) {
        $.ajax({
            url: "/HandMadeStore/add-cart",
            data: {
                actionCart: "put",
                id: idProduct,
                num: num
            },
            success: function (response) {
                let quantityAfter = quantity + 1;
                quantityInput.value = quantityAfter;
                let formatTotalItem = numberFomat.format(quantityAfter * priceProduct);
                totalItem.innerText = formatTotalItem;
                let totalAfter = total + priceProduct;
                total_Cart.innerText = totalAfter;
                total_amount.innerText = numberFomat.format(totalAfter);
            }
        })
    } else {
        let message = stockProduct === 0 ? 
            "Không thể tăng số lượng vì đã đạt giới hạn đặt trước!" :
            "Không thể tăng số lượng vì sản phẩm không đủ!";
            
        Swal.fire({
            position: "center",
            icon: "error",
            title: message,
            showConfirmButton: false,
            timer: 1500
        });
    }
}


// Validate trước khi vào trang thanh toán.
$(document).ready(function () {
    $("#btn-payment").click(function () {
        // Check if there are any pre-order products
        let hasPreOrderProducts = false;
        $("#order-list tr").each(function() {
            let productId = $(this).find('input[name="id"]').val();
            if (productId) {
                let preorderAmountInput = $(`#preorder_amount_${productId}`);
                if (preorderAmountInput.length > 0) {
                    hasPreOrderProducts = true;
                    return false; // break the loop
                }
            }
        });

        $.ajax({
            type: "GET",
            url: "/HandMadeStore/payment",
            data: {
                hasPreOrderProducts: hasPreOrderProducts
            },
            success: function (response) {
                if(response.isValid) {
                    window.location.href = "../../PaymentPage/payment.jsp?hasPreOrderProducts=" + hasPreOrderProducts;
                }
                else {
                    var errorMessageHtml = '<ul>';
                    response.forEach(function(message) {
                        errorMessageHtml += '<li>' + message + '</li>';
                    });
                    errorMessageHtml += '</ul>';

                    Swal.fire({
                        title: 'Thông báo',
                        html: errorMessageHtml,
                        icon: 'info',
                        showCancelButton: true,
                        confirmButtonText: 'Chấp nhận',
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.reload()
                        }
                    });
                }
            },
            error: function (xhr, status, error) {
                console.log("Loi khi gui yeu cau ajax"+ error);
            }
        })
    });
});

// Add pre-order payment button handler
$(document).ready(function () {
    $("#btn-preorder-payment").click(function () {
        // Filter only pre-order items
        let preOrderItems = [];
        $("#order-list tr").each(function() {
            let productId = $(this).find('input[name="id"]').val();
            if (productId) {
                let preorderAmountInput = $(`#preorder_amount_${productId}`);
                if (preorderAmountInput.length > 0) {
                    let quantity = $(this).find('input[id^="quantity_input"]').val();
                    preOrderItems.push({
                        id: productId,
                        quantity: quantity
                    });
                }
            }
        });

        $.ajax({
            type: "GET",
            url: "/HandMadeStore/payment",
            data: { 
                isPreOrder: true
            },
            success: function (response) {
                if(response.isValid) {
                    window.location.href = "../../PaymentPage/payment.jsp?isPreOrder=true"
                }
                else {
                    var errorMessageHtml = '<ul>';
                    response.forEach(function(message) {
                        errorMessageHtml += '<li>' + message + '</li>';
                    });
                    errorMessageHtml += '</ul>';

                    Swal.fire({
                        title: 'Thông báo',
                        html: errorMessageHtml,
                        icon: 'info',
                        showCancelButton: true,
                        confirmButtonText: 'Chấp nhận',
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.reload()
                        }
                    });
                }
            },
            error: function (xhr, status, error) {
                console.log("Loi khi gui yeu cau ajax"+ error);
                Swal.fire({
                    icon: 'error',
                    title: 'Có lỗi xảy ra',
                    text: 'Vui lòng thử lại sau',
                    showConfirmButton: true
                });
            }
        })
    });
});

</script>
</body>
</html>