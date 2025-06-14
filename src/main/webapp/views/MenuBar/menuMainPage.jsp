<%@ page import="model.bean.User" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.bean.Cart" %>
<%@ page import="model.bean.Item" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="model.service.ImageService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<%User u = (User) session.getAttribute("auth");%>
<%
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) cart = new Cart();
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    <%--    <%@include file="menu.css" %>--%>
    <title>Menu</title>
</head>
<style>
    /*MenuBar*/
    .menu {
        background: rgba(250, 244, 244, 0.92);
        border-bottom: 1px solid rgba(155, 158, 162, 0.7);
    }

    .menu ul a {
        text-decoration: none;
        color: #797974;
    }

    .menu ul .name {
        font-size: 30px;
        font-weight: bold;
        font-family: sans-serif;
        position: absolute;
        left: 160px;
        top: 30px;
    }

    .menu ul .item_a {
        padding-top: 25px;
        position: absolute;
        left: 10px;
        top: -40px;
    }

    .menu ul li {
        list-style-type: none;
    }

    .menu ul li.item:hover {
        background: red;
    }

    .menu ul li.item:hover a {
        color: white;
    }

    .menu ul li.search i {
        background: red;
        padding: 4%;
    }

    #find {
        margin: 0;
    }

    .menu ul li.search input {
        padding-left: 10px;
        width: 200px;
        border: none;
        height: 100%;
        border-radius: 2px;
    }

    .menu ul li.login a:hover {
        color: red;
    }

    .menu ul li.cart a:hover {
        color: red;
    }

    #dangxuat {
        padding: 0;
        display: none;
    }

    #dangxuat a:hover {
        background: red;
        color: white;
    }

    #dangxuat a {
        color: black;
    }

    .menu ul li.login:hover #dangxuat {
        display: block;
    }

    .menu ul li.item {
        text-align: center;
    }

    input[type="search"] {
        border: none; /* Border mặc định */
    }

    input[type="search"]:focus {
        outline: none; /* Loại bỏ outline khi focus */
    }

    .search button {
        border: none;
        padding: 12px;
        background: red;
        border-radius: 2px;
    }

    #find {
        display: flex;
    }

    .fa-solid {
        font-size: 20px;

    }

    .fa-cart-shopping .badge {
        font-size: 10px;
    }

    #badge {
        transform: translate(50%, -50%);
    }

    /*    phần giỏ hàng*/
    /*
Đây la noi css nè các ban
 */

    .cart .top-cart-content {
        display: none;
        position: absolute;
        position: fixed;
        top: 80px;
        right: 20px;
        /*transform: translate(10%,30%);*/
        box-shadow: 0 0 15px -5px rgba(0, 0, 0, 0.4);
        background-color: rgba(255, 255, 255, 0.8);
        transition: all 0.3s ease;
    }


    .cart:hover .top-cart-content {
        display: block;
        z-index: 999;
    }


    .cart .top-cart-content::before {
        background-color: #ffcc00;
        display: block;
        opacity: 0;
        min-width: 200px;
        transition: all 0.3s ease 0s;
        position: absolute;
        transform: translateY(0px);
        right: 0;
        left: auto;
        padding: 0;
        text-align: left;
        box-shadow: 0 0 15px -5px rgba(0, 0, 0, 0.4);
        visibility: hidden;
        z-index: 10000;
    }


    .cart .top-cart-content #cart-side-bar {
        max-height: 625px;
        min-width: 310px;
        width: 310px;
        position: relative;
        padding: 15px;

    }

    .cart .top-cart-content #cart-side-bar .list-item-cart {
        max-height: 260px;
        overflow: auto;
        padding: 0;

    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li.item-sub:first-child {

        padding-top: 10px;
        border-top: none;
    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li.item-sub {
        padding: 12px 0px;
        overflow: hidden;
    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list {
        overflow: hidden;
    }


    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list a.product-image {
        float: left;
        display: flex;
        width: 80px;
        align-items: start;
        justify-content: center;
        margin-right: 10px;
        margin-bottom: 5px;
    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list a img {
        border: 0 none;
        max-width: 100%;
        height: auto;
        vertical-align: middle;
    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list .detail-item {
        width: calc(100% - 90px);
        float: left;
        display: block;
        word-break: break-word;
        position: relative;
    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list .detail-item .product-detail {
        padding-right: 10px;
        overflow: hidden;

    }

    .top-cart-content .product-detail .product-name {
        margin: 0;
        line-height: 1;
        padding-right: 20px;
    }

    .top-cart-content .product-detail .product-name a {
        font-size: 1em;
        line-height: 20px !important;
        font-weight: 400;
        color: #333;
        word-break: break-word;
    }

    .top-cart-content .product-detail-bottom {
        margin-bottom: 15px;
        line-height: 33px;
    }

    .top-cart-content .product-detail-bottom .price {
        color: #333;
        font-weight: 700;
        font-size: 16px;
        margin-right: 5px;
    }


    .top-cart-content .product-detail-bottom a .bi {
        position: absolute;
        right: 0;
        left: auto;
        top: 9px;
        transform: translateY(-50%);
        width: 18px;
        height: 18px;
        text-align: center;
        line-height: 18px;
        padding-left: 0;
        border-radius: 50%;
    }

    .top-cart-content .product-detail-bottom .quantity-select {
        display: flex;
        /*width: 18px;*/

    }

    .top-cart-content .product-detail-bottom .quantity-select button {
        display: inline-block;
        cursor: pointer;
        height: 24px;
        width: 24px;
        line-height: 1;
        text-align: center;
        overflow: hidden;
        border: 1px solid #ebebeb;
        border-style: hidden;
        /*background: none !important;*/
        font-size: 14px;
    }

    .top-cart-content .product-detail-bottom .quantity-select input {
        display: inline-block;
        width: 22px;
        height: 24px;
        min-height: 24px;
        padding: 0;
        text-align: center;
        margin: 0;
    }

    #cart-side-bar .pd .top-subtotal {
        font-size: 1em;
        font-weight: 400;
        padding: 15px 0 15px;
        border-bottom: 1px solid #ebebeb;
        margin-bottom: 15px;
        text-align: left;
        text-transform: none;

    }

    .top-subtotal .price {
        margin-right: 5px;
        font-size: 16px;
        font-weight: 500;
        float: right;

    }

    #cart-side-bar .pda {
        text-align: center;
        margin-top: 10px;
        display: flex;
        justify-content: space-around;

    }

    #cart-side-bar .pda a {
        padding: 0 20px;
        background-color: #ff0000;
        color: #fff;
        height: 40px;
        line-height: 40px;
        white-space: nowrap;
        text-align: center;
        border: none;
        border-radius: 0;
        letter-spacing: 0;

    }
    #menubar .itemNav .titleNav{
        color: black;
        font-size: 18px;
        font-weight: bold;
    }
    #menubar .itemNav .titleNav:hover{
        color: red;
    }
    #submenuNav{
        color: black;
    }
    #submenuNav:hover {
        background: red;
        color: white;
        font-weight: bold;
    }
</style>
<body>
<div id="menubar" class="menu">
    <ul class="d-flex m-0 justify-content-around">
        <li class="logo my-auto">
            <a class="item_a" href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp"> <img
                    src="<%=request.getContextPath()%>/images/logo.png" style="width: 15vh"></a>
        </li>
<%--        --%>
        <li class="nav-item dropdown itemNav my-auto" id="ProductList">
            <a class="nav-link dropdown-toggle titleNav" href="" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Danh Mục
            </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown" style="margin-top: 33px">
                <%for(Category categoryProduct : categoryP){%>
                <a id="submenuNav" class="dropdown-item" href="<%=request.getContextPath()%>/productsPage?categoryFilter=<%=categoryProduct.getId()%>"><%=categoryProduct.getName()%></a>
                <%}%>
            </div>
        </li>
        <li class="itemNav my-auto">
            <a class="titleNav" href="<%=request.getContextPath()%>/productsPage?categoryFilter=all">Danh sách sản Phẩm</a>
        </li>
        <li class="itemNav my-auto">
            <a class="titleNav" href="#bikip">Bí Kíp HandMade</a>
        </li>
        <li class="itemNav my-auto">
            <a class="titleNav" href="#footer">Liên hệ</a>
        </li>
<%--        --%>
        <li class="search d-flex py-4 my-auto">
            <form action="<%=request.getContextPath()%>/findProduct" method="post" id="find" class="d-flex">
                <input name="findProducts" type="search" placeholder="Bạn tìm gì...">
                <button><i class="fa-solid fa-magnifying-glass" style="color: white;"></i></button>
            </form>
        </li>
        <li class="login py-4 my-auto dropdown">
            <%if (u == null) {%>
            <i class="fa-solid fa-user" style="color: #496088;"></i>
            <a class="item_login" href="<%=request.getContextPath()%>/login">Đăng Nhập</a>
            <%} else {%>


            <button type="button" class="btn btn-sm btn-primary "><i class="fa-solid fa-user" style="color: white;"></i>
                <span><%= u.getName()%></span></button>
            <ul id="dangxuat" class="dx dropdown-menu">
                <%
                    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
                    if (isAdmin) {
                %>
                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/admin">
                    <i class="fa-solid fa-user-tie fs-3 me-1"></i>Quản lý hệ thống</a></li>
                <%}%>
                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/views/Admin/changeUserInfo.jsp"><i
                        class="fa-solid fa-user-pen"></i>Thông Tin Tài Khoản</a></li>
                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/logout"><i
                        class="fa-solid fa-right-from-bracket"></i> Đăng
                    Xuất</a></li>
            </ul>
            <%}%>
        </li>

        <li class="cart py-4 dropdown my-auto  position-relative">
            <%--            <i class="fa-solid fa-cart-shopping" style="color: #2a3241;"></i>--%>
            <%--            <a href="<%=request.getContextPath()%>/views/CartPage/cart.html">Giỏ Hàng</a>--%>
            <a href="<%=request.getContextPath()%>/views/CartPage/view/cart.jsp">

                <i class="fa-solid fa-cart-shopping position-relative" style="color: #2a3241;">
            <span id="badge" class="position-absolute top-0 start-0  badge rounded-pill
            bg-danger "><%=cart.getTotal()%> </span>
                </i>
                <span class="label ps-2"> Giỏ hàng </span>
            </a>
            <!--Danh sách giỏ hàng -->
            <div class="top-cart-content " style="display: none">
                <ul id="cart-side-bar" class="mini-product-list">

                    <ul class="list-item-cart">
                        <% double total = 0;%>
                        <% for (Item items : cart.getItems().values()) { %>
                        <li class="item-sub">
                            <div class="border_list">
                                <a class="product-image" href="">
                                    <img src="<%=request.getContextPath()%>/<%=ImageService.getInstance().pathImageOnly(items.getProduct().getId())%>"
                                         width="100" alt="">
                                </a>
                                <div class="detail-item">
                                    <div class="product-detail">
                                        <p class="product-name">
                                            <a href=""><%=items.getProduct().getName()%>
                                            </a>
                                        </p>
                                    </div>
                                    <div class="product-detail-bottom">
                                        <span class="price"> <%=numberFormat.format(items.getPrice())%></span>


                                        <a href="<%=request.getContextPath()%>/add-cart?actionCart=delete&id=<%=items.getProduct().getId()%>">
                                            <i class="bi bi-x-circle-fill"></i>
                                        </a>
                                        <div class="quantity-select">

                                            <button class="pd-des m-0" type="submit" name="num" value="-1">
                                                <a href="<%=request.getContextPath()%>/add-cart?actionCart=put&num=-1&id=<%=items.getProduct().getId()%>">- </a>
                                            </button>
                                            <input type="text" readonly class="quantity-input p-0"
                                                   value="<%=items.getQuantity()%>">
                                            <button type="submit" name="num" value="1"
                                                    class="pd-inc m-0">
                                                <a href="<%=request.getContextPath()%>/add-cart?actionCart=put&num=1&id=<%=items.getProduct().getId()%>">+</a>
                                            </button>

                                        </div>
                                    </div>

                                </div>

                            </div>
                        </li>

                        <%total += (items.getQuantity() * items.getPrice()); %>

                        <%}%>

                    </ul>
                    <div class="pd">
                        <div class="top-subtotal">
                            Tổng tiền:
                            <span class="price"> <%=numberFormat.format(total)%></span>
                        </div>
                    </div>
                    <%if (!cart.getItems().isEmpty()) {%>
                    <div class="pda rigth-ct">

                        <a href="<%=request.getContextPath()%>/views/CartPage/cart.jsp"
                           class="btn"><span>Giỏ hàng</span></a>

                        <%if (u != null) {%>
                        <a href="<%=request.getContextPath()%>/views/PaymentPage/payment.jsp" class="btn"><span>Thanh Toán</span></a>
                        <%} else {%>
                        <a href="<%=request.getContextPath()%>/login" class="btn"><span>Thanh Toán</span></a>
                        <%}%>


                    </div>
                    <%} else {%>
                    <div class="align-content-center">
                        <span>Giỏ hàng đang trống !</span></div>
                    <%}%>
                </ul>

            </div>
            </a>


        </li>


    </ul>
</div>
</body>
<script>
    function handleAddToCart(response) {
        let totalItem = document.getElementById('badge');
        let currentValue = parseInt(totalItem.innerText);
        currentValue += 1;
        totalItem.innerText = currentValue;
    }
    function handleDeleteToCart(response) {
        let totalItem = document.getElementById('badge');
        console.log(totalItem);
        let currentValue = parseInt(totalItem.innerText);
        currentValue -= 1;
        totalItem.innerText = currentValue;
    }

</script>
</html>