<%@ page import="model.service.ImageService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Login/css/forgotpassword.css">
    <title>Đặt lại mật khẩu</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background-image: url("<%=request.getContextPath()+"/"+ImageService.getBackgroundImagePath()%>");
            background-size: 100%;
            background-repeat: no-repeat;
            font-size: 15px;
            font-family: Arial;
            display: flex;
            min-height: 100vh;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(3px);
        }
    </style>
</head>
<body>
<div class="container">
    <form id="form" action="<%=request.getContextPath()%>/forgotpassword?page=1" method="post">
        <div class="xyz">
            <a id="back_btn" onclick="goBack()"><i
                    class="fa-solid fa-arrow-left" style="color: #183153"></i>
            </a>

            <div class="logo">
                <img src="<%=request.getContextPath()+"/"+ImageService.getLogoImagePath()%>" width="25%">
            </div>

        </div>
        <div class="title">
            <h1>Đặt lại mật khẩu</h1>
        </div>

        <div class="first_input_style">
            <input type="text" name="email" id="email" placeholder="Nhập Email"
                   maxlength="128">
        </div>
        <div class="check_input_notification">
            <% String re = request.getAttribute("result") == null ? "" : request.getAttribute("result").toString(); %>

            <p id="result" name="result" style="color: red"><%=re%>
            </p>
        </div>
        <div class="submit dn">
            <button type="submit">Tiếp theo</button>
        </div>
    </form>
</div>
<script>
    function goBack() {
        window.history.back();
    }
</script>
</body>
</html>