<%@ page import="model.bean.User" %>
<%@ page import="model.service.OrderService" %>
<%@ page import="logs.Log" %>
<%@ page import="logs.LoggingService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String framePath = ((String) request.getAttribute("framePath") == null) ?
        request.getContextPath() + "/views/Admin/dashboard.jsp"
        : (request.getContextPath() + (String) request.getAttribute("framePath"));
%>
<% String func = (String) request.getAttribute("func");
    func = (func == null) ? "dashboard" : func;%>
<%User u = (User) session.getAttribute("auth");%>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>ADMIN</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Roboto:wght@500;700&display=swap"
          rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Libraries Stylesheet -->
    <link href="<%=request.getContextPath()%>/views/Admin/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css"
          rel="stylesheet"/>

    <!-- Customized Bootstrap Stylesheet -->
    <link href="<%=request.getContextPath()%>/views/Admin/css/bootstrap.min.custom.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="<%=request.getContextPath()%>/views/Admin/css/style.custom.css" rel="stylesheet">
    <style>
        #frame {
            height: calc(100% - 64px);
        }



    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container-fluid position-relative d-flex p-0">
    <!-- Spinner Start -->
    <div id="spinner"
         class="show bg-dark position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    </div>
    <!-- Spinner End -->


    <!-- Sidebar Start -->
    <div class="sidebar pe-4 pb-3"
    >
        <nav class="navbar bg-secondary navbar-dark">
            <a href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp" target="_blank"
               class="navbar-brand mx-4 mb-3">
                <h3 class="text-primary">HandMadeStore</h3>
            </a>

            <div class="navbar-nav w-100">
                <a href="<%=request.getContextPath()%>/admin?func=dashboard"
                   class="nav-item nav-link
                  <%if(func.equals("dashboard")){%>
                   active
                  <%}%>">
                    <i class="fa fa-tachometer-alt me-2"></i>Dashboard</a>
                <div class="nav-item dropdown">
                    <%
                        if (func.equals("product_management") || func.equals("inventory_management")  || func.equals("category_management")
                                || func.equals("add_product") || func.equals("discount_management")) {
                    %>
                    <a href="#" class="nav-link dropdown-toggle show active" data-bs-toggle="dropdown"
                       aria-expanded="true"><i
                            class="bi bi-shop me-2"></i>Quản lý sản phẩm</a>
                    <div class="dropdown-menu bg-transparent border-0 show ms-5" data-bs-popper="none">
                        <a href="<%=request.getContextPath()%>/admin?func=inventory_management" class="dropdown-item
                                <%if(func.equals("inventory_management")){%>
                                     active
                                 <%}%>"><i class="fa-solid fa-layer-group me-2"></i>
                            Kho lưu trữ hàng
                        </a>
                        <a href="<%=request.getContextPath()%>/admin?func=category_management"
                           class="dropdown-item
                           <%if(func.equals("category_management")){%>
                                     active
                            <%}%>">
                            <i class="fa-solid fa-layer-group me-2"></i>
                            Quản lý danh mục
                        </a>
                        <a href="<%=request.getContextPath()%>/admin?func=add_product"
                           class="dropdown-item
                           <%if(func.equals("add_product")){%>
                                     active
                            <%}%> "><i class="fa-solid fa-circle-plus me-2"></i>
                            Thêm sản phẩm mới
                        </a>
                        <a href="<%=request.getContextPath()%>/admin?func=discount_management"
                           class="dropdown-item
                           <%if(func.equals("discount_management")){%>
                                     active
                            <%}%>"><i class="fa-solid fa-tag me-2"></i>
                            Quản lý khuyến mãi
                        </a>
                    </div>
                    <%} else {%>
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown"><i
                            class="bi bi-shop me-2"></i>Quản lý sản phẩm</a>
                    <div class="dropdown-menu bg-transparent border-0 ms-5">
                        <a href="<%=request.getContextPath()%>/admin?func=inventory_management" class="dropdown-item"><i class="fa-solid fa-layer-group me-2"></i>
                            Kho lưu trữ hàng
                        </a>
                        <a href="<%=request.getContextPath()%>/admin?func=category_management" class="dropdown-item"><i
                                class="fa-solid fa-layer-group me-2"></i>
                            Quản lý danh mục
                        </a>
                        <a href="<%=request.getContextPath()%>/admin?func=add_product" class="dropdown-item"><i
                                class="fa-solid fa-circle-plus me-2"></i>
                            Thêm sản phẩm mới
                        </a>
                        <a href="<%=request.getContextPath()%>/admin?func=discount_management" class="dropdown-item"><i
                                class="fa-solid fa-tag me-2"></i>
                            Quản lý khuyến mãi
                        </a>
                    </div>
                    <%}%>
                </div>


                <a href="<%=request.getContextPath()%>/admin?func=order_management"
                   class="nav-item nav-link
                    <%if(func.equals("order_management")){%>
                   active
                    <%}%>"><i
                        class="bi bi-minecart me-2"
                ></i>Quản lý đơn hàng
                    <span id="waitConfirmOrdersNumber" style="color:white; font-size:small; text-align: center">
                    <%--                new order--%>
                    <%if (OrderService.getInstance().waitConfirmOrdersNumber() > 0) {%>
                        (<%=OrderService.getInstance().waitConfirmOrdersNumber()%>)
                    <%}%>
                    </span>
                </a>

                <a href="<%=request.getContextPath()%>/admin?func=order_custom_management"
                   class="nav-item nav-link
                    <%if(func.equals("order_custom_management")){%>
                   active
                    <%}%>"><i
                        class="bi bi-minecart me-2"
                ></i>
                    Quản lý đơn hàng custom
                </a>

                <a href="<%=request.getContextPath()%>/admin?func=sentiment_manager"
                   class="nav-item nav-link
                    <%if(func.equals("sentiment_manager")){%>
                   active
                    <%}%>"><i
                        class="bi bi-minecart me-2"
                ></i>
                    Quản lý đánh giá
                </a>

                <a href="<%=request.getContextPath()%>/admin?func=customer_management"
                   class="nav-item nav-link
                   <%if(func.equals("customer_management")){%>
                   active
                    <%}%>">
                    <i class="fa-regular fa-address-book me-2"></i>Quản lý tài khoản</a>
                <a href="<%=request.getContextPath()%>/admin?func=banners_tips"
                   class="nav-item nav-link
                  <%if(func.equals("banners_tips")){%>
                                     active
                                 <%}%>"><i
                        class="fa-brands fa-gratipay me-2"
                ></i>Thay đổi banners, tips</a>

<%--                <a href="<%=request.getContextPath()%>/admin?func=support"--%>
<%--                   class="nav-item nav-link--%>
<%--                    <%if(func.equals("support")){%>--%>
<%--                   active--%>
<%--                    <%}%>"--%>
<%--                ><i--%>
<%--                        class="fa-solid fa-phone me-2"></i>Hỗ trợ</a>--%>
            </div>
        </nav>
    </div>
    <!-- Sidebar End -->


    <!-- Content Start -->
    <div class="content">
        <!-- Navbar Start -->
        <nav class="navbar navbar-expand bg-info navbar-dark sticky-top px-4 py-0">
            <a href="#" class="sidebar-toggler flex-shrink-0">
                <i class="fa fa-bars"></i>
            </a>

            <div class="navbar-nav align-items-center ms-auto">
                <div class="nav-item dropdown">
                    <div class="nav-link dropdown-toggle" style="cursor: default" data-bs-toggle="dropdown">
                        <i class="fa-solid fa-scroll me-lg-2"></i>
                        <span class="d-none d-lg-inline-flex">Lịch sử hệ thống</span>
                    </div>
                    <div id="logs" class="dropdown-menu dropdown-menu-end bg-secondary border-0 rounded-0 rounded-bottom m-0">
                        <%for (Log log : LoggingService.getInstance().getThreeLogs()) {%>
                        <div class="dropdown-item">
                            <div class="d-flex align-items-center">
                                <div class="fs-5">

                                    <%if (log.isINFORMLevel()) {%>
                                    <i class="text-info fa-solid fa-info"></i>
                                    <%} else if (log.isALERTLevel()) {%>
                                    <i class="text-info fa-solid fa-circle-info"></i>
                                    <%} else if (log.isWARNINGLevel()) {%>
                                    <i class="text-warning fa-solid fa-triangle-exclamation"></i>
                                    <%} else if (log.isDANGERLevel()) {%>
                                    <i class="text-danger fa-solid fa-circle-exclamation"></i>
                                    <%}%>
                                </div>
                                <div class="ms-2">
                                    <h6 style="text-wrap: initial" class="fw-normal mb-0"><%=log.getMessage()%>
                                    </h6>
                                    <small style="color: rgb(128,128,128)"><%=log.getFormattedCreatedTime()%>
                                    </small>
                                </div>
                            </div>
                        </div>
                        <hr class="dropdown-divider">
                        <%}%>
                        <a href="<%=request.getContextPath()%>/admin?func=logs"
                           class="dropdown-item text-center">Xem tất cả</a>
                    </div>
                </div>
                <div class="nav-item dropdown">
                    <div style="cursor: default" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                        <i class="rounded-circle me-lg-2 fa-solid fa-user"
                           style="width: 40px; height: 40px;">
                        </i>
                        <span class="d-none d-lg-inline-flex"><%= u.getName()%></span>
                    </div>
                    <div class="dropdown-menu dropdown-menu-end bg-secondary border-0 rounded-0 rounded-bottom m-0">
                        <a href="<%=request.getContextPath()%>/changeUserInfo" class="dropdown-item">Tài khoản cá
                            nhân</a>
                        <a href="<%=request.getContextPath()%>/login" class="dropdown-item">Đăng xuất</a>
                    </div>
                </div>
            </div>
        </nav>
        <!-- Navbar End -->
        <iframe src="<%=framePath%>"
                frameborder="0" name="content" id="frame" width="100%"
                scrolling="yes"
                class="container-fluid "
        ></iframe>
    </div>
    <!-- Content End -->
</div>

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/chart/chart.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/easing/easing.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/waypoints/waypoints.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/owlcarousel/owl.carousel.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/js/moment.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/js/moment-timezone.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

<!-- Template Javascript -->
<script src="<%=request.getContextPath()%>/views/Admin/js/main.custom.js"></script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>