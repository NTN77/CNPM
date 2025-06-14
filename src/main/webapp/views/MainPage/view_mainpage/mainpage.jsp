<%@ page import="java.util.List" %>
<%@ page import="model.dao.ProductDAO" %>
<%@ page import="model.dao.TipDAO" %>
<%@ page import="model.bean.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.service.*" %>
<%@ page import="model.dao.CategoryDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/MainPage/css/mainpage.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <title>Cửa Hàng HandMade</title>
</head>


<body>
<%
    List<Category> categoryP = CategoryService.getInstance().getAllCategoriesWithNoProductsOnSale();
%>
<!--menu-->

<%--Thanh điều hướng - header--%>
<div class="sticky-top">
    <%@include file="/views/MenuBar/menuMainPage.jsp" %>
</div>
<!--carousel-->
<div id="carouselExampleCaptions" class="carousel slide">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="0" class="active"
                aria-current="true" aria-label="Slide 1"></button>
        <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="1"
                aria-label="Slide 2"></button>
        <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="2"
                aria-label="Slide 3"></button>
    </div>

    <div class="carousel-inner">
        <%!List<BannerItem> bannerItems = model.service.BannerService.getInstance().getAll();%>
        <%for (BannerItem i : bannerItems) {%>
        <div class="carousel-item active">
            <img src="<%=request.getContextPath()+"/"+i.getImg_path()%>"
                 class="d-block w-100" alt="...">
            <div class="carousel-caption d-none d-md-block">
                <h5 class=""><%=i.getTitle()%>
                </h5>
                <p><%=i.getDescription()%>
                </p>
            </div>
        </div>
        <%}%>
    </div>

    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
    </button>

    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
    </button>
</div>
<!--hoạt động carousel-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"
        integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+"
        crossorigin="anonymous"></script>

<%--Danh Mục--%>
<div class="categorys d-flex overflow-auto" style="white-space: nowrap">
    <%for (Category cate : categoryP) {%>
    <%int idProImage = CategoryDAO.oneProductofCategory(cate.getId());%>
    <%String pathImg = ImageService.getInstance().pathImageOnly(idProImage);%>
    <div class="item_category cate_<%=cate.getId()%>"
         style="background-image: url(<%=request.getContextPath()%>/<%=pathImg%>)">
        <p><%=cate.getName()%>
        </p>
        <div class="button_seld"><a href="<%=request.getContextPath()%>/productsPage?categoryFilter=<%=cate.getId()%>">Mua
            Ngay!</a></div>
    </div>
    <%}%>
</div>
<!--SanPham-->

<div class="product">
    <%-- Khuyến Mãi   --%>
    <%List<Product> listProductDiscount = ProductService.getInstance().productDiscountMainPage();%>
    <%if (!listProductDiscount.isEmpty()) {%>
    <div class="title_t" id="khuyenmai" style="width: 17%; margin: auto;">
        <a style="text-decoration: none;"
           href="<%=request.getContextPath()%>/productsPage?categoryFilter=all&isDiscount=true"><p
                class="text-center fs-5 fw-bold text-danger">Sản Phẩm Khuyến Mãi
        </p></a>
    </div>
    <div class="sp overflow-auto" id="sp_khuyenmai"
         style="width: 92%;margin: auto;margin-bottom: 50px;background: #d7f0eb;">
        <ul class="products  m-2  d-flex flex-nowrap">
            <%
                for (Product prd : listProductDiscount) {
            %>
            <%String pathImage = ImageService.getInstance().pathImageOnly(prd.getId());%>
            <li class="productkm">
                <div class="item_product  me-4">
                    <a class="image" href="<%=request.getContextPath()%>/product-detail?id=<%=prd.getId()%>"> <img
                            src="<%=request.getContextPath()%>/<%=pathImage%>"> </a>
                    <a href="<%=request.getContextPath()%>/product-detail?id=<%=prd.getId()%>"><p
                            class="pt-2 px-3 fst-italic"><%=prd.getName() %>
                    </p></a>
                    <%!double giaKhuyenMai;%>
                    <% giaKhuyenMai = ProductService.getInstance().productPriceIncludeDiscount(prd);%>
                    <%if (prd.getCategoryId() >= 0 && giaKhuyenMai != prd.getSellingPrice()) {%>
                    <%! int discountProductKM;%>
                    <% discountProductKM = ProductService.getInstance().discountProduct(prd.getId());%>
                    <div style="position: absolute;top: 0;z-index: 1000;background: red;color: white;padding: 5px;"><%=discountProductKM%>
                        %
                    </div>
                    <div>
                        <del><p style="margin-bottom: 0"><%=numberFormat.format(prd.getSellingPrice())%>
                        </p></del>
                        <p class="fw-bold text-danger"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(prd))%>
                        </p>
                    </div>
                    <%} else {%>
                    <div>
                        <p class="fw-bold my-0 text-danger"
                           style="margin-bottom: 0"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(prd))%>
                        </p>
                    </div>
                    <%}%>
                    <div class="add-to-cart">
                        <button onclick="addCart(this,<%=prd.getId()%>)"><span class="fw-bold">Thêm vào giỏ <i
                                class="fa-solid fa-cart-shopping"></i></span></button>
                    </div>
                    <div style="position: absolute; bottom: 0; width: 100%">
                        <%
                            double averageRateStars = ProductService.getInstance().roundNumber(ProductService.getInstance().getAverageRateStars(prd.getId()));%>
                        <div style="float: left;width: 50%; padding-bottom: 3%;font-size: 15px">
                            <span>Đã Bán:</span>
                            <span><%=prd.getStock()%></span>
                        </div>
                        <%if (averageRateStars > 0) {%>
                        <div style="float: right; width: 50%; padding-bottom: 3%;font-size: 15px; text-align: end; padding-right: 3px">
                            <div><%=averageRateStars%><i class="fa-solid fa-star"
                                                         style="color: #FFD43B;font-size: 13px"></i></div>
                        </div>
                        <%}%>

                    </div>
                </div>
            </li>
            <%}%>
        </ul>
        <div class="allKM text-center mb-4"><a class="text-decoration-none fw-bold fs-4"
                                               href="<%=request.getContextPath()%>/productsPage?categoryFilter=all&isDiscount=true">Xem
            Ngay!</a></div>
    </div>
    <%}%>
    <%--  Sản Phẩm  --%>
    <% for (Category ca : categoryP) {%>
    <div class="list_product container_product<%=ca.getId()%> d-flex" id="sp">
        <div class="title_t" id="<%=ca.getId()%>">
            <p class="text-center fs-5 fw-bold"><%=ca.getName()%>
            </p>
            <div class="button_seld"><a href="<%=request.getContextPath()%>/productsPage?categoryFilter=<%=ca.getId()%>">Xem
                Ngay!</a></div>
        </div>
        <div class="sp" id="sp_<%=ca.getId()%>">
            <ul class="products  m-2 d-flex flex-wrap">
                <%
                    List<Product> product15 = ProductDAO.list4product(ca.getId());
                    for (Product pr : product15) {
                %>
                <%String pathImage = ImageService.getInstance().pathImageOnly(pr.getId());%>
                <li class="product_list">
                    <div class="item_product  me-4">
                        <a class="image" href="<%=request.getContextPath()%>/product-detail?id=<%=pr.getId()%>"> <img
                                src="<%=request.getContextPath()%>/<%=pathImage%>"> </a>
                        <a href="<%=request.getContextPath()%>/product-detail?id=<%=pr.getId()%>"><p
                                class="pt-2 px-3 fw-bold" style="font-style: italic"><%=pr.getName() %>
                        </p></a>
                        <%!double giaBanSauCung;%>
                        <% giaBanSauCung = ProductService.getInstance().productPriceIncludeDiscount(pr);%>
                        <%if (pr.getCategoryId() >= 0 && giaBanSauCung != pr.getSellingPrice()) {%>
                        <%! int discountProduct;%>
                        <% discountProduct = ProductService.getInstance().discountProduct(pr.getId());%>
                        <div style="position: absolute;top: 0;z-index: 1000;background: red;color: white;padding: 5px;"><%=discountProduct%>
                            %
                        </div>
                        <div>
                            <div>
                                <del><p style="margin-bottom: 0"><%=numberFormat.format(pr.getSellingPrice())%>
                                </p></del>
                                <p class="fw-bold text-danger"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(pr))%>
                                </p>
                            </div>
                        </div>
                        <%} else {%>
                        <div>
                            <p class="fw-bold my-0 text-danger"
                               style="margin-bottom: 0"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(pr))%>
                            </p>
                        </div>
                        <%}%>
                        <div class="add-to-cart">
                            <button onclick="addCart(this,<%=pr.getId()%>)"><span class="fw-bold" git>Thêm vào giỏ <i
                                    class="fa-solid fa-cart-shopping"></i></span></button>
                        </div>
                        <div style="position: absolute; bottom: 0; width: 100%">
                            <%
                                double averageRateStars = ProductService.getInstance().roundNumber(ProductService.getInstance().getAverageRateStars(pr.getId()));%>
                            <div style="float: left;width: 50%; padding-bottom: 3%;font-size: 15px">
                                <span>Đã Bán:</span>
                                <span><%=pr.getStock()%></span>
                            </div>
                            <%if (averageRateStars > 0) {%>
                            <div style="float: right; width: 50%; padding-bottom: 3%;font-size: 15px; text-align: end; padding-right: 3px">
                                <div><%=averageRateStars%><i class="fa-solid fa-star" style="color: #FFD43B;font-size: 13px"></i></div>
                            </div>
                            <%}%>

                        </div>
                    </div>
                </li>
                <%}%>
            </ul>
        </div>
    </div>
    <%}%>
</div>


<!--Bí Kíp-->

<div class="bikip mt-5" id="bikip">
    <div class="title_bk">
        <p class="text-center fw-bold fs-4">BÍ KÍP LÀM ĐỒ HANDMADE</p>
    </div>
    <div class="solid_bk mb-5 m-auto"></div>
    <div class="content_bk">
        <ul class="d-flex justify-content-center">
            <%
                List<Tip> tipsList = TipDAO.getAllTips();
                for (Tip t : tipsList) {
            %>

            <li class="item text-center">
                <a href="<%=t.getVideoLink()%>" target="_blank"><img
                        src="<%=request.getContextPath()%>/<%=t.getImgPath()%>" width="90%"></a>
                <a href="<%=t.getVideoLink()%>" target="_blank"><h6
                        class="fw-bold text-center mt-3 px-3"><%=t.getTitle()%>
                </h6></a>
                <p class="px-5"><%=t.getDescription()%>
                </p>
            </li>
            <%}%>
        </ul>
    </div>
</div>
<!--    Footer-->
<div id="footer">
    <ul class="d-flex ">
        <li class="content col-6">
            <img src="<%=request.getContextPath()%>/images/logo.png" width="22%">
            <p class="me-5">
                HEADQUARTERS là cửa hàng về đồ HANDMADE về đồ trang trí, phụ kiện, thiệp, album ảnh, sổ tay được làm thủ
                công
                đẹp, ý nghĩa, thân thiện với mọi người.
            </p>
        </li>
        <li class="contact col-6 mt-5">
            <p class="content fs-2 fw-bold">Liên hệ với chúng tôi</p>
            <div class="address d-flex">
                <i class="fa-solid fa-location-dot py-2" style="color: #4d8a54"></i>
                <p class="p-2">Địa chỉ: Lớp DH21DTC,Khoa Công Nghệ Thông Tin,</br> Trường Đại Học Nông Lâm TP.HCM</p>
            </div>
            <div class="hotline d-flex">
                <i class="fa-solid fa-mobile-screen py-2" style="color: #4d8a54"></i>
                <p class="p-2">Hotline : 1900 3456</p>
            </div>
            <div class="icon">
                <a class="me-3 fs-3" href=""><i class="fa-brands fa-twitter" style="color: #4d8a54"></i></a>
                <a class="mx-3 fs-3" href=""><i class="fa-brands fa-facebook" style="color: #4d8a54"></i></a>
                <a class="mx-3 fs-3" href=""><i class="fa-brands fa-square-instagram" style="color: #4d8a54"></i></a>
                <a class="mx-3 fs-3" href=""><i class="fa-brands fa-youtube" style="color: #4d8a54"></i></a>
            </div>
        </li>
    </ul>
    <div class="solid  m-auto "></div>
    <div class="content_end fs-6 fw-bold text-center">
        <p>Bản quyền thuộc về HEADQUARTERS| Cung cấp bởi HEADQUARTERS</p>
    </div>
</div>
</body>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    let idProduct = [];

    function addCart(btn, id) {
        var actionCart = "post";
        var num = 1;
        $.ajax({
            url: "/HandMadeStore/add-cart",
            method: "POST",
            data: {
                id: id,
                actionCart: actionCart,
                num: num
            },
            success: function (response) {
                if (response != null && response == 'false') {
                    Swal.fire({
                        position: "center",
                        icon: "error",
                        title: "Vui lòng đăng nhập",
                        showConfirmButton: false,
                        timer: 1500
                    });
                }else if(response != null && response == 'NoPost'){
                    Swal.fire({
                        position: "center",
                        icon: "error",
                        title: "Sản Phẩm Không Đủ Số Lượng!",
                        showConfirmButton: false,
                        timer: 1500
                    });
                } else {
                    if (!idProduct.includes(id)) {
                        idProduct.push(id);
                        handleAddToCart(response);
                    }
                    console.log("Hoàn Thành Thêm vào giỏ hàng! ");
                    Swal.fire({
                        position: "center",
                        icon: "success",
                        title: "Thêm Sản Phẩm Vào Giỏ Hàng Thành Công!",
                        showConfirmButton: false,
                        timer: 1500
                    });
                }
            }
        })
    }

</script>
</html>