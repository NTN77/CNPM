<%@ page import="org.w3c.dom.stylesheets.LinkStyle" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="model.bean.*" %>
<%@ page import="model.dao.UserDAO" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.service.UserService" %><%--
  Created by IntelliJ IDEA.
  User: Kien Nguyen
  Date: 12/11/2023
  Time: 4:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");%>

<% Product product = (Product) request.getAttribute("productById");%>
<% List<Image> imageList = (List<Image>) request.getAttribute("listImage");%>
<% Category categoryByProduct = (Category) request.getAttribute("categoryByProduct");%>
<% String description = product.getDescription();%>
<% List<Product> relatedProduct = (List<Product>) request.getAttribute("productRelated");%>
<%List<Rate> rateList = (List<Rate>) request.getAttribute("listRate");%>
<%
    int allStarsCount = ProductService.getInstance().getStarNumberCount(product.getId());
    int fiveStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 5);
    int fourStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 4);
    int threeStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 3);
    int twoStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 2);
    int oneStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 1);
%>
<%
    User sessionUser = (User) request.getSession().getAttribute("auth");
%>

<%
    int maxQuantity = 1;
    if (product.getIsSale() == 3 && product.getStock() == 0) {
        Object preOrderAmountObj = request.getAttribute("preOrderAmount");
        maxQuantity = preOrderAmountObj != null ? Integer.parseInt(preOrderAmountObj.toString()) : 1;
    } else {
        maxQuantity = product.getStock();
    }
%>
<input type="hidden" id="max-quantity" value="<%=maxQuantity%>">

<html>
<head>
    <title>ProductDetails</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@1,500&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Alumni+Sans+Inline+One&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap"
          rel="stylesheet">
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <!--https://releases.jquery.com/-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"
            integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>

        <%@include file="../css/product.css"%>
        .dt-empty {
            display: none;
        }
    </style>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/stars.css">
</head>
<body>
<%--Thanh điều hướng - header--%>
<%@include file="/views/MenuBar/menu.jsp" %>
<!-- Nội dung Product-details-->
<!-- Thẻ navigation : thanh chuyển hướng -->
<section class="product-details container">
    <nav aria-label="breadcrumb ">
        <div>
            <i class="fa-solid fa-backward p-2 fs-5" onclick="window.history.back()" style="cursor: pointer"></i>
        </div>
        <ol class="breadcrumb m-0 ">
            <li class="breadcrumb-item"><a
                    href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp">Trang Chủ</a></li>
            <li class="breadcrumb-item"><a
                    href="productsPage?categoryFilter=<%=categoryByProduct.getId()%>"><%=categoryByProduct.getName()%>
            </a></li>
            <li class="breadcrumb-item active" aria-current="page" style="color: #e32124"><%=product.getName()%>
            </li>
        </ol>
    </nav>
    <div class="row ">
        <%--    Phần hiển thị ảnh sản phẩm. (trái)--%>
        <!--  zoom container start-->

        <div class="xzoom-container col-lg-6 col-md-12 col-12 left-pd">
            <div class="small-img-group col-lg-2 ">
                <%
                    for (int i = 0; i < Math.min(imageList.size(), 4); i++) {
                        Image secondImage = imageList.get(i);
                %>
                <div class="small-img-col ">
                    <img src="<%= secondImage.getPath()%>" width="100%" class="small-img" alt="">
                </div>
                <%}%>
            </div>
            <%
                if (imageList != null && !imageList.isEmpty()) {
                    Image mainImage = imageList.get(0);
            %>
            <div class="main-img col-lg-10">
                <img class=" large-img " id="MainImg" src="<%=mainImage.getPath()%>" alt="">
                <img class="large-img " id="imgZoom" src="<%=mainImage.getPath()%>" alt="">
                <%
                    }
                %>

            </div>

        </div>
        <%--     Phần hiển thị thông tin chi tiết của sản phẩm (phải)--%>
        <div class="col-lg-6 col-md-12 col-12 right-pd">

            <h3 class=""><%=product.getName() %>
            </h3>
            <%!double averageStarsNumber;%>
            <%averageStarsNumber = ProductService.getInstance().getAverageRateStars(product.getId());%>
            <%if(averageStarsNumber>0){%>
            <div class="d-flex rate-content">
                <div class="icon-rate me-3 d-flex align-items-center">
                    <div class="me-1" style="font-weight: bold; font-size: 25px"><%=ProductService.getInstance().roundNumber(averageStarsNumber)%></div>
                    <div class="stars">
                        <svg viewBox="0 0 576 512" title="star">
                            <path d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                        </svg>
                        <svg viewBox="0 0 576 512" title="star">
                            <path d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                        </svg>
                        <svg viewBox="0 0 576 512" title="star">
                            <path d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                        </svg>
                        <svg viewBox="0 0 576 512" title="star">
                            <path d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                        </svg>
                        <svg viewBox="0 0 576 512" title="star">
                            <path d="M259.3 17.8L194 150.2 47.9 171.5c-26.2 3.8-36.7 36.1-17.7 54.6l105.7 103-25 145.5c-4.5 26.3 23.2 46 46.4 33.7L288 439.6l130.7 68.7c23.2 12.2 50.9-7.4 46.4-33.7l-25-145.5 105.7-103c19-18.5 8.5-50.8-17.7-54.6L382 150.2 316.7 17.8c-11.7-23.6-45.6-23.9-57.4 0z"/>
                        </svg>

                        <div class="cover" style="width: <%=(100-(averageStarsNumber/5)*100)%>%;"></div>
                    </div>
                    <a href="#rating-comment">Xem chi tiết</a>
                </div>
            </div>
            <%}%>
            <% Object preOrderAmountObj = request.getAttribute("preOrderAmount"); %>
            <% if (product.getStock() > 0) { %>
                <div class="state-pd my-2">
                    <label class="me-2 label-title">
                        Còn <strong style="color: #ff1a1a"><%=product.getStock()%></strong> sản phẩm
                    </label>
                    <label class="me-2 "> <strong>| Trạng thái :</strong>
                        <%
                            String status = "Ngừng kinh doanh";
                            switch (product.getIsSale()) {
                                case 1:
                                    status = "Có sẵn";
                                    break;
                                case 2:
                                    status = "Tạm hết hàng";
                                    break;
                                case 3:
                                    status = "Được đặt trước";
                                    break;
                            }
                        %>
                        <%=status%>
                    </label>
                </div>
            <% } else if (product.getIsSale() == 3) { %>
                <% if (preOrderAmountObj != null) { %>
                    <div class="state-pd my-2">
                        <label class="me-2 label-title">
                            Được đặt trước <strong style="color: #ff1a1a"><%=preOrderAmountObj%></strong> sản phẩm
                        </label>
                        <label class="me-2 "> <strong>| Trạng thái :</strong> Được đặt trước</label>
                    </div>
                <% } else { %>
                    <script>
                        window.onload = function() {
                            Swal.fire({
                                icon: 'info',
                                title: 'Chưa đăng ký đặt hàng trước',
                                text: 'Sản phẩm này hiện chưa mở đặt trước.',
                                confirmButtonText: 'Đóng'
                            });
                        }
                    </script>
                <% } %>
            <% } %>


            <%
                double discountPrice = ProductService.getInstance().productPriceIncludeDiscount(product);
                if (product.getSellingPrice() > discountPrice) {
                    int discountProductKM = ProductService.getInstance().discountProduct(product.getId());
            %>

            <div class="price-discount d-flex flex-row">
                <h2 class="price-pd">
                    <%=numberFormat.format(discountPrice)%>
                </h2>
                <span class="ms-2" style="color: #4d8a54"> <strong>  <%=discountProductKM + "%"%><strong/></span>
            </div>
            <span>Giá gốc : <span
                    class="text-decoration-line-through fst-italic"><%=numberFormat.format(product.getSellingPrice())%></span></span>
            <% } else {%>
            <h2 class="price-pd">
                <%=numberFormat.format(product.getSellingPrice())%>
            </h2>
            <%}%>
            <div class="row mt-3">
                <%
                    if (product.getIsSale() == 1 || product.getIsSale() == 3) {
                %>
                <div class="quantity-pd mb-4 col-4">
                    <label class="me-2 label-title" style="font-size: 14px">Số lượng: </label>
                    <div class="qu-value">
                        <button class="pd-des m-0" id="#minus-button">-</button>
                        <input type="text" class="quantity-input p-0" id="#quantity-label" value="1">
                        <button class="pd-inc m-0" id="#plus-button">+</button>
                    </div>
                </div>
                <button class="buy-btn col-4" style="font-size: 16px" <%=request.getAttribute("disable")%>>
                    Thêm vào giỏ hàng
                </button>
                <% } else {%>
                <a href="#relate" style="font-style: italic; font-size: 14px"> Xem các sản phẩm khác </a>
                <%}%>
            </div>

            <a class="order-btn" style="font-size: 16px" <%=request.getAttribute("disable")%>
               href="<%=request.getContextPath()%>/order-custom?id=<%=product.getId()%>&category=<%=product.getCategoryId()%>"
            >
                Tùy chỉnh
            </a>


            <hr class="mx-auto">
            <h4 class=" mt-4 mb-4 ">Chi tiết sản phẩm</h4>

            <%--          Xử lý hiển thị chi tiết sản phẩm theo từng dòng văn bản--%>
            <%
                String[] lines = description.split("\\r?\\n");
                for (String line : lines) {

            %>

            <p class="gray-content"><%=line%>
            </p>
            <%}%>
        </div>
    </div>


</section>

<section id="relate" class="mt-5 ">
    <div class="container pb-4">
        <h4>Sản phẩm liên quan</h4>
        <hr class="mx-auto">

        <div class="row my-5 ">

            <%for (Product pr : relatedProduct) {%>
            <%String pathImage = ImageService.getInstance().pathImageOnly(pr.getId());%>

            <div class="col info-item mx-3">
                <div class="info-img w-100 ">
                    <img src="<%=request.getContextPath()%>/<%=pathImage%>" alt=""
                         class="img-fluid d-block mx-auto mt-2 w-100 h-100">


                    <div class="row btns w-100 mx-auto ">
                        <button type="button" class="col-6 py-2">
                            <a href="<%=request.getContextPath()%>/add-cart?actionCart=post&num=1&id=<%=pr.getId()%>">
                                <i class="bi bi-cart-plus"></i>
                            </a>
                        </button>
                        <button type="button" class="col-6 py-2">
                            <a href="product-detail?id=<%=pr.getId()%>"> <i class="bi bi-eye"></i> </a>
                        </button>
                    </div>
                </div>
                <div class="info-product py-3 ">
                    <a href="product-detail?id=<%=pr.getId()%>"
                       class="d-block text-dark text-decoration-none info-name">
                        <%=pr.getName()%>
                    </a>
                    <span class="info-price fw-bold"><%=numberFormat.format(pr.getSellingPrice()) %></span>
                    <div class="info-rating d-flex mt-1">

                        <span>(<%=rateList.size()%> đánh giá)</span>
                    </div>
                </div>
            </div>
            <%}%>


        </div>


    </div>


</section>
<%--</section>--%>
<section id="rating-comment" class="rating container mb-5">
    <h4 pb-1>Đánh giá sản phẩm</h4>
    <div class="d-flex">
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer; width: 70px"
             id="filter_all_star"
             onclick="renderRateByStarNumber(0)">Tất cả (<%=allStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer; width: 70px"
             id="filter_5_star"
             onclick="renderRateByStarNumber(5)">5 sao (<%=fiveStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_4_star"
             onclick="renderRateByStarNumber(4)">4 sao (<%=fourStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_3_star"
             onclick="renderRateByStarNumber(3)">3 sao (<%=threeStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_2_star"
             onclick="renderRateByStarNumber(2)">2 sao (<%=twoStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_1_star"
             onclick="renderRateByStarNumber(1)">1 sao (<%=oneStarsCount%>)
        </div>
    </div>
    <hr class="m-0">
    <!-- Các bình luận sẽ được hiển thị ở đây -->
    <table id="rate_table" style="width: 100%;">
        <thead style="display: none">
        <tr>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <% for (Rate r : rateList) {%>
        <tr>
            <td>
                <div class="d-flex flex-column mx-2 comments">
                    <%if (sessionUser != null && sessionUser.getId() == r.getUserId()) {%>
                    <div class="text-success mt-3">
                        Cảm ơn đánh giá của bạn!
                        <i class="fa-regular fa-face-smile-beam"></i>
                    </div>
                    <%}%>
                    <div class="p-1 d-flex flex-row">
                        <h6 class="pe-2 m-0 ">
                            <%=UserDAO.getUserNameById(r.getUserId())%>
                        </h6>
                        <p style="font-style: italic ; color: #898989 ; font-family: Arial" class="m-0"> Đã đăng vào
                            lúc   <%=" " + r.getCreateDate()%>
                        </p>
                    </div>

                    <div class=" p-1 ratings ">
                        <% int star = r.getStarRatings();
                            for (int i = 1; i <= 5; i++) { %>
                        <%if (i <= star) {%>
                        <i class="bi bi-star-fill " style="color: #ffcc00"></i>
                        <%} else {%>
                        <i class="bi bi-star-fill "></i>
                        <%
                                }
                            }
                        %>
                    </div>
                    <p class="p-1"><%=r.getComment()%>
                    </p>
                </div>
            </td>
        </tr>
        <%}%>
        </tbody>
    </table>
    <%
        if (sessionUser != null && UserService.getInstance().checkUserAllowedToRate(product.getId(), sessionUser.getId())) {
            //kiểm tra user đã mua chưa & chưa chỉnh sửa
            int changeNumber = ProductService.getInstance().getChangeNumber(product.getId(), sessionUser.getId());
            if (changeNumber == 0 || changeNumber == -1) {
    %>
    <div class="my-3" id="rate-box">
        <div class="rate">
            <input type="radio" id="star5" name="rate" value="5"/>
            <label for="star5" title="text">5 <i class="fa-solid fa-star" style="color: #FFD43B;font-size: 13px"></i></label>
            <input type="radio" id="star4" name="rate" value="4"/>
            <label for="star4" title="text">4 <i class="fa-solid fa-star" style="color: #FFD43B;font-size: 13px"></i></label>
            <input type="radio" id="star3" name="rate" value="3"/>
            <label for="star3" title="text">3 <i class="fa-solid fa-star" style="color: #FFD43B;font-size: 13px"></i></label>
            <input type="radio" id="star2" name="rate" value="2"/>
            <label for="star2" title="text">2 <i class="fa-solid fa-star" style="color: #FFD43B;font-size: 13px"></i></label>
            <input type="radio" id="star1" name="rate" value="1"/>
            <label for="star1" title="text">1 <i class="fa-solid fa-star" style="color: #FFD43B;font-size: 13px"></i></label>
        </div>
        <div class="border rounded-3">
            <div class="text-danger mt-3" id="rate_validate" style="display: none">
                <i class="fa-regular fa-hand-point-left"></i> Bạn chưa chọn sao đánh giá!
            </div>
            <textarea class="form-control mx-auto w-70" id="comment" name="comment"
                      rows="3" placeholder="Viết bình luận"></textarea>
        </div>
        <% if (changeNumber == 0) {%>
        <button type="button" class="btn  btn-outline-warning w-100" id="btn_editRating" onclick="addRating()">
            Hoàn tất chỉnh sửa đánh giá
        </button>
        <%} else if (changeNumber == -1) {%>
        <button type="button" class="btn  btn-outline-success w-100" id="btn_addRating" onclick="addRating()">
            Hoàn tất đánh giá
        </button>
        <%}%>
    </div>
    <%}%>
    <%}%>
</section>
<%if (sessionUser != null) {%>
<input type="hidden"
       value="<%=ProductService.getInstance().getNumberRateStarsByUser(product.getId(), sessionUser.getId())%>"
       id="oldRatingValue">
<input type="hidden"
       value="<%=sessionUser.getId()%>"
       id="userId">
<%}%>
<!--    Footer-->
<%@include file="/views/Footer/footer.jsp" %>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>

<script>

    <%--    XỬ LÝ ẢNH  START--%>
    var MainImg = document.getElementById('MainImg');
    var smallimg = document.getElementsByClassName('small-img');
    let imgZoom = document.getElementById('imgZoom')


    for (var i = 0; i < smallimg.length; i++) {
        smallimg[i].onclick = function () {
            // Thay đổi src của MainImg
            MainImg.src = this.src;
            imgZoom.src = this.src;


            // Đặt lại blur của tất cả các small-img về 20px
            for (var j = 0; j < smallimg.length; j++) {
                smallimg[j].style.filter = 'blur(1px)';
                smallimg[j].style.border = 'none';
            }

            // Đặt blur của small-img được click về 0
            this.style.filter = 'blur(0)';
            this.style.border = '2px solid #ff1a1a'
        };
    }

    // Đặt blur của smallimg[0] về 0 ban đầu
    smallimg[0].style.filter = 'blur(0)';
    smallimg[0].style.border = '2px solid #ff1a1a'


    MainImg.addEventListener('mousemove', (event) => {
        imgZoom.style.opacity = 1;
        let positionPx = event.x - MainImg.getBoundingClientRect().left;
        let positionx = (positionPx / MainImg.offsetWidth) * 100;

        let positionPy = event.y - MainImg.getBoundingClientRect().top;
        let positiony = (positionPy / MainImg.offsetHeight) * 100;


        imgZoom.style.setProperty('--zoom-x', positionx + '%');
        imgZoom.style.setProperty('--zoom-y', positiony + '%');

        let transformX = -(positionx - 50) / 3.5;
        let transformY = -(positionx - 50) / 3.5;
        imgZoom.style.transform = 'scale(1.1)' + 'translateX(' + transformX + ') translateY(' + transformY + ')';

    })

    MainImg.addEventListener('mouseout', () => {
        imgZoom.style.opacity = 0;
    })

    //  XỬ LÝ ẢNH END


    // XỬ LÝ THÊM VÀO GIỎ HÀNG START.

    document.addEventListener("DOMContentLoaded", function () {
        console.log("generilze");
        let incrementButton = document.getElementById("#plus-button")
        let decrementButton = document.getElementById("#minus-button");
        const quantityInput = document.getElementById("#quantity-label");
        const addToCartLink = document.querySelector(".buy-btn");


        incrementButton.addEventListener("click", function () {
            console.log("Button + clicked");
            quantityInput.value = parseInt(quantityInput.value) + 1;
            console.log(quantityInput.value)
        });

        decrementButton.addEventListener("click", function () {
            console.log("Button - clicked");
            const currentValue = parseInt(quantityInput.value);

            if (currentValue > 1) {
                quantityInput.value = currentValue - 1;
            }

        });


        let idProductList = [];
        addToCartLink.addEventListener("click", function (event) {
            let actionCart = "post";
            const maxQuantity = parseInt(document.getElementById("max-quantity").value);
            const currentQuantity = parseInt(quantityInput.value);

            if (currentQuantity > maxQuantity) {
                Swal.fire({
                    position: "center",
                    icon: "error",
                    title: "Số lượng vượt quá giới hạn cho phép!",
                    showConfirmButton: false,
                    timer: 1500
                });
                return;
            }

            $.ajax({
                url: "/HandMadeStore/add-cart",
                method: "POST",
                data: {
                    id: <%=product.getId()%>,
                    actionCart: actionCart,
                    num: quantityInput.value
                },
                success: function (response) {
                    console.log(response);
                    if (response != null && response == 'false') {
                        Swal.fire({
                            position: "center",
                            icon: "error",
                            title: "Vui lòng đăng nhập",
                            showConfirmButton: false,
                            timer: 1500
                        });
                        return;
                    }else if(response != null && response == 'NoPost'){
                        Swal.fire({
                            position: "center",
                            icon: "error",
                            title: "Sản Phẩm Không Đủ Số Lượng!",
                            showConfirmButton: false,
                            timer: 1500
                        });
                        return;
                    } else if (!idProductList.includes(<%=product.getId()%>)) {
                        idProductList.push(<%=product.getId()%>);
                        handleAddToCart(response);
                    }
                    Swal.fire({
                        position: "center",
                        icon: "success",
                        title: "Thêm Sản Phẩm Vào Giỏ Hàng Thành Công!",
                        showConfirmButton: false,
                        timer: 1500
                    });

                },
                error: function () {
                    Swal.fire({
                        position: "center",
                        icon: "error",
                        title: "Số lượng không hợp lệ !",
                        showConfirmButton: true,
                    });

                }

            })

            quantityInput.value = 1;
        })
    })


    // XỬ LÝ THÊM VÀO GIỎ HÀNG END.
    $(document).ready(function () {
        $('#rate_table').DataTable({
            "paging": true, // Phân trang
            "searching": false, // Không có tính năng tìm kiếm
            "lengthChange": false, // Không cho phép thay đổi số lượng bản ghi trên mỗi trang
            "pageLength": 5,
            "info": false
        });
    });


    function renderRateByStarNumber(starNumber) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/rate-ajax-handle",
            data: {
                productId: <%=product.getId()%>,
                action: "filterStar",
                starNumber: starNumber
            },
            success: function (response) {
                // Xóa bỏ DataTable nếu đã tồn tại
                if ($.fn.dataTable.isDataTable('#rate_table')) {
                    $('#rate_table').DataTable().clear().destroy();
                }
                $('#rate_table tbody').empty();
                const userIdElement = document.getElementById("userId");
                const userId = userIdElement ? userIdElement.value : null;
                response.forEach(function (r) {
                    const starHtml = renderStars(r.starRatings);
                    const cssForUser = (userId == r.userId) ?
                        `<div class="text-success mt-3">
                                Cảm ơn đánh giá của bạn!
                                <i class="fa-regular fa-face-smile-beam"></i>
                            </div>` : ``;
                    const rowHtml = `
                    <tr>
                        <td>
                             <div class="d-flex flex-column mx-2 comments">
                             ${cssForUser}
                                <div class="p-1 d-flex flex-row">
                                    <h6 class="pe-2 m-0 ">
                                    ${r.userFullName}
                                    </h6>
                                    <p style="font-style: italic ; color: #898989 ; font-family: Arial" class="m-0"> Đã đăng vào
                                        lúc   ${r.createDate}
                                    </p>
                                </div>
                                <div class=" p-1 ratings ">
                                    ${starHtml}
                                </div>
                                <p class="p-1">${r.comment}
                                </p>
                            </div>
                        </td>
                    </tr>
                `;
                    $('#rate_table tbody').append(rowHtml);
                });
                // Khởi tạo lại DataTable với các thiết lập cần thiết
                $('#rate_table').DataTable({
                    "paging": true,
                    "searching": false,
                    "lengthChange": false,
                    "pageLength": 5,
                    "info": false
                });
            },
            error: function () {
                alert("error")
            }
        })
    }

    function renderStars(star) {
        let starsHtml = '';
        for (let i = 1; i <= 5; i++) {
            if (i <= star) {
                starsHtml += '<i class="bi bi-star-fill" style="color: #ffcc00"></i>';
            } else {
                starsHtml += '<i class="bi bi-star-fill"></i>';
            }
        }
        return starsHtml;
    }

    function addRating() {
        let rating = document.querySelector('input[name="rate"]:checked');
        let ratingValue = rating ? rating.value : null;
        let comment = document.getElementById('comment').value;
        if (ratingValue == null) {
            document.getElementById("rate_validate").style.display = "block"
        } else {
            document.getElementById("rate_validate").style.display = "none";
            $.ajax({
                method: "POST",
                url: "/HandMadeStore/rate-ajax-handle",
                data: {
                    productId: <%=product.getId()%>,
                    action: "addRating",
                    ratingValue: ratingValue,
                    comment: comment
                },
                success: function (response) {
                    // Xóa bỏ DataTable nếu đã tồn tại
                    if ($.fn.dataTable.isDataTable('#rate_table')) {
                        $('#rate_table').DataTable().clear().destroy();
                    }
                    $('#rate_table tbody').empty();
                    response.forEach(function (r) {
                        const starHtml = renderStars(r.starRatings);
                        const userId = document.getElementById("userId").value;
                        const cssForUser = (userId == r.userId) ?
                            `<div class="text-success mt-3">
                                Cảm ơn đánh giá của bạn!
                                <i class="fa-regular fa-face-smile-beam"></i>
                            </div>` : ``;
                        const rowHtml = `
                    <tr>
                        <td>
                             <div class="d-flex flex-column mx-2 comments">
                             ${cssForUser}
                                <div class="p-1 d-flex flex-row">
                                    <h6 class="pe-2 m-0 ">${r.userFullName}
                                    </h6>
                                    <p style="font-style: italic ; color: #898989 ; font-family: Arial" class="m-0"> Đã đăng vào
                                        lúc   ${r.createDate}
                                    </p>
                                </div>
                                <div class=" p-1 ratings ">
                                    ${starHtml}
                                </div>
                                <p class="p-1">${r.comment}
                                </p>
                            </div>
                        </td>
                    </tr>
                `;
                        $('#rate_table tbody').append(rowHtml);
                    });
                    // Khởi tạo lại DataTable với các thiết lập cần thiết
                    $('#rate_table').DataTable({
                        "paging": true,
                        "searching": false,
                        "lengthChange": false,
                        "pageLength": 5,
                        "info": false
                    });


                    const changeNumber = response[0].changeNumber; // Assuming changeNumber is part of the response
                    console.log(response.length, changeNumber)
                    if (changeNumber === 1) {
                        const rateBox = document.querySelector("#rate-box");
                        rateBox.remove();
                        // ratingValue cũ
                        let oldRatingValue = document.querySelector("#oldRatingValue").value;
                        console.log("check", oldRatingValue);
                        let oldFilterStar = document.querySelector("#" + "filter_" + oldRatingValue + "_star")
                        let starText = oldFilterStar.innerText; //ex: 5 sao (4)
                        // Sử dụng biểu thức chính quy để tách giá trị số trong dấu ngoặc đơn
                        let matches = starText.match(/\((\d+)\)/);//lấy 4
                        if (matches) {
                            const starsCount = parseInt(matches[1], 10);
                            oldFilterStar.innerHTML = ratingValue + " sao (" + (starsCount - 1) + ")"
                        }
                        // ratingValue mới
                        let filterStar = document.querySelector("#" + "filter_" + ratingValue + "_star")
                        starText = filterStar.innerText; //ex: 5 sao (4)
                        // Sử dụng biểu thức chính quy để tách giá trị số trong dấu ngoặc đơn
                        matches = starText.match(/\((\d+)\)/);//lấy 4
                        if (matches) {
                            const starsCount = parseInt(matches[1], 10);
                            filterStar.innerHTML = ratingValue + " sao (" + (starsCount + 1) + ")"
                        }
                    } else if (changeNumber === 0) {
                        let all = document.querySelector("#filter_all_star");
                        all.innerHTML = "Tất cả (" + response.length + ")"
                        let filterStar = document.querySelector("#" + "filter_" + ratingValue + "_star")
                        const starText = filterStar.innerText; //ex: 5 sao (4)
                        // Sử dụng biểu thức chính quy để tách giá trị số trong dấu ngoặc đơn
                        var matches = starText.match(/\((\d+)\)/);//lấy 4
                        if (matches) {
                            const starsCount = parseInt(matches[1], 10);
                            filterStar.innerHTML = ratingValue + " sao (" + (starsCount + 1) + ")"
                            document.getElementById("oldRatingValue").value = (starsCount + 1);
                        } else {
                            console.log("Không tìm thấy giá trị trong dấu ngoặc đơn");
                        }
                        let btnAddRating = document.querySelector("#btn_addRating");
                        let btnEditRating = document.querySelector("#btn_editRating");
                        if (!btnEditRating) {
                            btnEditRating = document.createElement("button");
                            btnEditRating.type = "button";
                            btnEditRating.className = "btn btn-outline-warning w-100";
                            btnEditRating.id = "btn_editRating";
                            btnEditRating.innerText = "Hoàn tất chỉnh sửa đánh giá";
                            btnEditRating.onclick = addRating;

                            if (btnAddRating) {
                                btnAddRating.replaceWith(btnEditRating);
                            }
                        }
                    }
                },
                error: function () {
                    alert("error haizz")
                }
            })
        }
    }

</script>
</body>
</html>