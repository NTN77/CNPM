<%@ page import="model.service.ImageService" %>
<%@ page import="java.util.Map" %><%--
  Created by IntelliJ IDEA.
  User: Kien Nguyen
  Date: 11/26/2023
  Time: 5:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>


<html>
<head>
    <title>SIGN UP FORM</title>
    <meta charset="UTF-8">

    <!-- Boxicons Css-->
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Tahoma, Arial, sans-serif;


        }

        body {
            background-image: url("<%=request.getContextPath()+"/"+ImageService.getBackgroundImagePath()%>");
            backdrop-filter: blur(3px);

        }

        .container {
            height: 100vh;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;

        }

        .main-logo {
            height: 36px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;

        }

        img.logo {
            border-radius: 50%;
            height: 125px;
            position: absolute;

        }


        .form {
            background: #afe2ea;
            max-width: 430px;
            width: 100%;
            padding: 30px;
            border-radius: 6px;

        }


        header {
            font-size: 30px;
            font-weight: 600;
            text-align: center;


        }


        /*form {*/
        /*    margin-top: 20px;*/

        /*}*/
        form .infor {
            display: flex;
            justify-content: space-around;
            align-items: center;


        }

        .infor-sub:first-child {
            margin-right: 5px;
        }

        .form .field {
            height: 40px;
            width: 100%;
            margin-top: 20px;
            position: relative;
            border-radius: 6px;
        }


        .mail-icon, .key-icon {
            padding: 12px;
            font-size: 15px;
            background-color: #eae5e5;
            border-top-left-radius: 6px;
            border-bottom-left-radius: 6px;
            box-sizing: border-box;
            border: 1px solid #CACACA;
            color: #6494ce;

        }


        .field input, .field button {
            width: 100%;
            height: 100%;
            border: none;
            font-size: 15px;
            font-weight: 400;
            border-radius: 6px;
        }

        .field input {
            border: 1px solid #CACACA;
            padding: 0 52px;
            padding-right: 20px;
            outline: none;
        }

        .field input:focus {
            border-bottom: 2px solid rgba(0, 0, 0, 0.55);
        }

        .infor-sub input {
            padding: 0 10px;
        }

        .mail-icon, .key-icon {
            position: absolute;
            top: 50%;
            /*left: 10px;*/
            left: 0px;
            transform: translateY(-50%);
        }

        /*.eye-icon {*/
        /*    font-size: 18px;*/
        /*    color: #8b8b8b;*/
        /*    position: absolute;*/
        /*    top: 50%;*/
        /*    right: 10px;*/
        /*    transform: translateY(-50%);*/
        /*    cursor: pointer;*/
        /*    padding: 5px;*/
        /*}*/

        .field button {
            background-color: #0171d3;
            color: #fff;
            cursor: pointer;
        }

        .field button:hover {
            background-color: #183153;

        }


        .form-link {
            text-align: center;
            margin-top: 10px;
        }

        .form-link span, .form-link a {
            font-size: 14px;
            font-weight: 400;
            color: #232836;
        }


        .form a {
            text-decoration: none;
            color: #0171d3;
        }

        .form-content a:hover {
            text-decoration: underline;
        }

        .warning {
            color: red;
            font-style: italic;
        }


    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            //Kiểm tra xác thực lại mật khẩu ngay tại trang jsp
            function validatePassword() {
                var password = document.getElementById("pass").value.trim();
                var verifyPassword = document.getElementById("verify").value.trim();
                var errorMessageElement = document.getElementById("verify-error");

                if(password !== verifyPassword) {
                    errorMessageElement.innerHTML = "Xác thực mật khẩu không khớp";
                }
                else {
                    errorMessageElement.innerHTML = "";
                }

            }




            document.getElementById("verify").addEventListener("input", validatePassword);

                });
        function validatePhoneNumber() {
            var phoneNumber = document.getElementById("tel").value.trim();
            var errorMessageElement = document.getElementById("phoneError");
            var registerButton = document.getElementById("submit_button");

            if (phoneNumber.length <10) {
                errorMessageElement.innerHTML = "Số điện thoại phải đủ 10 số!";
                registerButton.disabled = true; // Vô hiệu hóa nút "Đăng ký"
            } else {
                errorMessageElement.innerHTML = "";
                registerButton.disabled = false; // Cho phép nút "Đăng ký" được click
            }
        }


        function validateCharacter() {
            var password = document.getElementById("pass").value.trim();
            var errorMessageElement = document.getElementById("passwordError");
            var registerButton = document.getElementById("submit_button");

            // Biểu thức chính quy kiểm tra xem mật khẩu có chứa ít nhất một ký tự đặc biệt hay không
            var specialCharRegex = /[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]/;

            if (password.length < 6 || !specialCharRegex.test(password)) {
                errorMessageElement.innerHTML = "Mật khẩu phải có ít nhất 8 ký tự và chứa ít nhất một ký tự đặc biệt";
                registerButton.disabled = true; // Vô hiệu hóa nút "Đăng ký"
            } else {
                errorMessageElement.innerHTML = "";
                registerButton.disabled = false; // Cho phép nút "Đăng ký" được click
            }
        }



      function formatPhone(input) {
          var phoneNum = input.value.replace(/\D/g, '');
           phoneNum = phoneNum.replace(/(\d{4})(\d{3})(\d{3})/, '$1 $2 $3');
          input.value = phoneNum
      }

    function validateForm() {
            return validatePhoneNumber() && validateCharacter();
    }

        </script>
</head>
<body>

<%
    Map<String, String> listNull = (Map<String, String>) request.getAttribute("errors") ;
    String email = request.getParameter("email") == null ? "" : request.getParameter("email");
    String name = request.getParameter("name") == null ? "" : request.getParameter("name");
    String tel = request.getParameter("tel") == null ? "" : request.getParameter("tel");
    String errorVerify = request.getAttribute("errorVerify")==null?"" : (String) request.getAttribute("errorVerify") ;
    String erDuplicateEmail = request.getAttribute("erDuplicateEmail")==null?"" : (String) request.getAttribute("erDuplicateEmail") ;
    String erPhoneExist = request.getAttribute("erPhoneExist")==null?"" : (String) request.getAttribute("erPhoneExist");

%>


<section class="container forms">

    <!--SIGN UP-->

    <div class="form signup">
        <div class="main-logo">
            <img src="<%=request.getContextPath()+"/"+ImageService.getLogoImagePath()%>" alt="" class="logo">
        </div>

        <div class="form-content">
            <header>Đăng Ký</header>
            <!--    </div>-->
            <form method="post" action="<%=request.getContextPath()%>/login.jsp"
                  onsubmit="return validateForm(); ">


                <div class="infor">
                    <div class="field input-field infor-sub">
                        <input  type="text" placeholder="Tên hiển thị*" value="<%=name%>" class="input" name="name" id="name">
                        <% if (listNull != null && listNull.containsKey("name")) { %>
                        <span class="error-message warning" style="font-size: 11px"><%= listNull.get("name") %></span>
                        <% } %>
                    </div>





                    <div class="field input-field infor-sub">
                        <input type="tel" value="<%=tel%>" placeholder="Số điện thoại*" class="input phone_vn"
                               name="tel" id="tel"
                               maxlength="12"


                               oninput="validatePhoneNumber()" required


                        >
                        <% if (listNull != null && listNull.containsKey("tel")) { %>
                        <span class="error-message warning" style="font-size: 11px"><%= listNull.get("tel") %></span>
                        <% } %>
                        <span class="error-message warning" style="font-size: 11px"> <%=erPhoneExist%></span>
                        <span id="phoneError" style="color: #FF5733; font-size: 11px"></span>


                    </div>


                </div>
                <div class="field input-field">
                    <input type="email" placeholder="Nhập email*" value="<%=email%>" class="input" name="email">
                    <i class='bx bx-envelope mail-icon'></i>
                    <% if (listNull != null && listNull.containsKey("email")) { %>
                    <span class="error-message warning" style="font-size: 11px"><%= listNull.get("email") %></span>
                    <% } %>
                    <span class="error-message warning" style="font-size: 11px"> <%=erDuplicateEmail%></span>
                </div>



                <div class="field input-field">
                    <input type="password"  placeholder="Nhập mật khẩu*" class="password"
                           name="pass"
                           id="pass"
                            required
                    oninput="validateCharacter()">

                    <i class='bx bx-key key-icon'></i>
                    <% if (listNull != null && listNull.containsKey("pass")) { %>
                    <span class="error-message warning" style="font-size: 11px"><%= listNull.get("pass") %></span>
                    <% } %>


                    <span id="passwordError" style="color: #FF5733; font-size: 11px"></span>

                </div>


                <div class="field input-field">

                    <input type="password" placeholder="Xác thực mật khẩu*" class="password" name="verify" id="verify">
                    <i class='bx bx-key key-icon'></i>
                    <span class="error-message warning" id="verify-error" style="font-size: 11px"> </span>
                    <% if (listNull != null && listNull.containsKey("verify")) { %>
                    <span class="error-message warning" style="font-size: 11px"><%= listNull.get("verify") %></span>
                    <% } %>

                    <span class="error-message warning" style="font-size: 11px"><%=errorVerify%></span>

                </div>

                <div class="field button-field">
                    <button type="submit" id = "submit_button" value="Register" disabled>Đăng Ký</button>
                </div>

            </form>


            <div class="form-link">
                <span>Bạn đã có tài khoản? <a href="<%=request.getContextPath()%>/login" class="login-link">Đăng Nhập</a></span>
            </div>
        </div>


    </div>
</section>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</body>
</html>