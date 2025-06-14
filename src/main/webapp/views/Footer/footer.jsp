<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 12/18/2023
  Time: 9:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/MainPage/css/mainpage.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>footer</title>
</head>
<body>
<!--    Footer-->
<div id="footer">
    <ul class="d-flex ">
        <li class="content_footer col-6">
            <img src="<%=request.getContextPath()%>/images/logo.png" width="30%">
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
<style>
    body{
        margin: 0;
        padding: 0;
        font-size: 15px;
    }
    #footer {
        background: linear-gradient(90deg, rgba(80, 82, 84, 0.7), rgba(44, 43, 43, 0.7)),
        url("<%=request.getContextPath()%>/images/background.jpg");
        background-repeat: no-repeat;
        background-size: 100%;

    }
    #footer ul li p{
        color: white;
    }
    #footer ul li {
        list-style-type: none;
    }
    #footer ul .contact .content_footer {
        color: #8fcc8f;
    }
    #footer .solid{
        width: 70%;
        height: 2px;
        background: #858282;
    }
    #footer .content_end p{
        color: rgba(245, 241, 241, 0.7);
    }
</style>
</html>
