<%@ page import="model.service.ImageService" %>
<%@ page import="model.bean.Cart" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="<%=request.getContextPath()%>/views/bootstrap-css/bootstrap.min.css">
    <title>Đăng Nhập</title>
</head>
<body>
<%
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) {
        cart = new Cart();
    } else {
        cart.clear();
    }
%>
<div class="container">
    <form id="form" action="<%=request.getContextPath()%>/login" method="post" >
        <div class="logo">
            <img src="<%=request.getContextPath()+"/"+ImageService.getLogoImagePath()%>" width="25%">
        </div>
        <div class="title">
            <h1>Đăng Nhập</h1>
        </div>
        <div class="item email">
            <div class="icon">
                <i class='bx bx-envelope mail-icon' style="color: #6494ce"></i>
            </div>
            <div class="input email">
                <input name="email" type="email" placeholder="Email" class="email">
            </div>
        </div>
        <div class="item password">
            <div class="icon">
                <i class='bx bx-key key-icon' style="color: #6494ce"></i>
            </div>
            <div class="input email">
                <input name="password" type="password" placeholder="Mật Khẩu" class="password">
            </div>

        </div>
        <div class="forgotpassword">
            <span><a href="<%=request.getContextPath()%>/forgotpassword">Quên Mật Khẩu?</a></span>
        </div>
<%--        reCaptcha--%>
        <div class="g-recaptcha" id="reCaptcha" data-sitekey="6LcgQwQqAAAAAG3k-oxuw7EnMRr-GUOizIgmrAKf"></div>
        <div class="submit dn">
            <button type="submit">Đăng Nhập</button>
        </div>
        <%--        Check error--%>
        <div class="err">
            <%String err = request.getAttribute("errEmail") == null ? "" : request.getAttribute("errEmail").toString();%>
            <p id="errEmail"><%=err%>
            </p>
        </div>
        <div class="err">
            <% String re = request.getAttribute("result") == null ? "" : request.getAttribute("result").toString(); %>
            <p id="errPass"><%=re%>
            </p>
        </div>
        <div class="solid"></div>
        <div class="icondn">
            <div class="item-media">
                <a href="https://www.facebook.com/v19.0/dialog/oauth?scope=email&client_id=1428287761185428&redirect_uri=http://localhost:8080/HandMadeStore/LoginFaceBookHandler" class="facebook"><i class='bx bxl-facebook facebook-icon'></i></a>
            </div>
            <div class="item-media">
                <a class="google google-icon"
                   href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/HandMadeStore/LoginGoogleHandler&response_type=code&client_id=468559225769-mg6o9rdha4qnskdi68hsa7neo0c9qtq0.apps.googleusercontent.com&approval_prompt=force">
                    <i class='bx bxl-google google-icon'></i>
                </a>
            </div>


        </div>
        <div class="submit dk">
            <button><a href="<%=request.getContextPath()%>/views/Login/view_login/signup.jsp">Đăng Ký</a></button>
        </div>

    </form>

</div>
<%--reCaptcha--%>
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<script>
    window.onload = function (){
        let isValid = false;
        const form = document.getElementById("form");
        const error = document.getElementById("errEmail");

        form.addEventListener("submit",function (event){
            event.preventDefault();
            const response = grecaptcha.getResponse();
            if(response){
                form.submit();
            }else{
                error.innerHTML= "Chưa tick reCAPTCHA!";
            }
        });
    }
</script>
</body>
<style>
    body {
        margin: 0;
        padding: 0;
        background-image: url("<%=request.getContextPath()+"/"+ImageService.getBackgroundImagePath()%>");
        backdrop-filter: blur(3px);
        background-size: 100%;
        background-repeat: no-repeat;
        font-size: 15px;
        font-family: Tahoma, Arial, sans-serif;
    }

    .container {
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;

    }

    .container form {
        width: 550px;
        height: 650px;
        background-color: #afe2ea;
        margin: auto;
        border-radius: 5px;

    }

    /*Logo*/
    .container form .logo {
        text-align: center;
        height: 80px;
    }

    /*label : dang nhap*/
    .container form .title {
        text-align: center;
    }
    /*Recaptcha*/
    #reCaptcha{
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 10px;
        margin-bottom: 10px;
        margin-right: 10px;
    }

    /*email và password*/
    .container form .item {
        margin-left: 15%;
        height: 40px;
        display: flex;
        margin-bottom: 20px;
    }
    .container form .item input {
        box-sizing: border-box;
        height: 40px;
        width: 350px;
        border: none;
        font-size: 15px;
        padding: 0;
        padding-left: 10px;
        padding-right: 10px;
        outline: none;
        border-top-right-radius: 6px;
        border-bottom-right-radius: 6px;

    }

    .container form .item input:focus {
        border-bottom: 2px solid rgba(0, 0, 0, 0.55);
    }

    .container form .item .icon {
        height: 40px;
        width: 40px;
        background-color: #eae5e5;
        border-top-left-radius: 6px;
        border-bottom-left-radius: 6px;
    }

    .container form .item .icon i {
        padding: 13px;
    }

    /*quen mat khau*/
    .container form .forgotpassword {
        margin-left: 340px;
    }

    .container form .forgotpassword a {
        text-decoration: none;
        color: blue;
    }

    .container form .forgotpassword a:hover {
        text-decoration: underline;
    }

    /*nut dang nhap va dang ky*/
    .container form .submit {
        margin-top: 10px;
        text-align: center;
    }

    .container form .submit button {
        width: 150px;
        height: 50px;
        background-color: #0171d3;
        color: white;
        font-size: 15px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .container form .submit button:hover {
        background-color: #183153;
    }

    .container form .submit button a {
        text-decoration: none;
        color: white;
        padding: 15px 26px;
    }

    /*gach ngang*/
    .container form .solid {
        width: 200px;
        margin: auto;
        margin-top: 20px;
        margin-bottom: 20px;
        border: 1px double grey;
    }

    /*icon*/
    .container form .icondn {
        display: flex;
        align-items: center;
        justify-content: center;

    }

    .icondn .item-media a {
        text-decoration: none;
    }

    .icondn .item-media {
        margin: 0px 10px;
    }

    a.facebook .facebook-icon, a.google .google-icon {
        height: 60px;
        width: 60px;
        font-size: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #F8F9F9;
    }

    a.facebook .facebook-icon {
        background-color: #0171d3;
    }

    a.google .google-icon {
        background-color: #de5347;
    }

    a.facebook .facebook-icon:hover {
        background-color: #0138c3;
        color: #ffffff;
        border-color: #0171d3;

    }

    a.google .google-icon:hover {
        background-color: #ff4131;
        color: #ffffff;
    }

    .container .err {
        text-align: center;
    }

    .container .err p {
        color: red;
    }
</style>
</html>


