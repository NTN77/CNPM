<%@ page import="java.util.List" %>
<%@ page import="model.bean.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.service.RoleService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%List<User> users = (List<User>) request.getAttribute("users");%>
<%User user = (User) session.getAttribute("auth");%>
<% users = (users == null && user != null) ? UserService.getInstance().getAllUsers(user.getId() + "") : users;%>
<%
    String currentFilter = (String) request.getAttribute("currentFilter");
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý khách hàng</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Admin/css/table_style.css">
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <!--https://www.bootstrapcdn.com/-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <style>
        .pagination {
            position: fixed;
            overflow: auto;
            bottom: 20%;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9;
        }

        .dt-empty, .dt-info {
            display: none;
        }

        #add_user {
            position: fixed;
            top: 40%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            z-index: 9999;
            background-color: #2c3e50; /* Adjust the background color as needed */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Optional: Add a box shadow for a subtle effect */
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container-fluid mx-auto mt-2 ps-4">
    <%--        Find--%>
    <form action="<%=request.getContextPath()%>/admin/customer">
        <input type="text" name="func" value="customer_management" style="display: none"></p>
        <input type="text" name="filter" value="findCustomer" style="display: none"></p>

        <div class="row input-group mb-3 justify-content-center">
            <div class="d-flex justify-content-center mb-2">
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=allCustomer"
                   class="btn btn-outline-secondary " type="button"><i class="fa-solid fa-users-line"></i> Tất cả</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=owner"
                   class="btn btn-outline-info ms-2" type="button"><i class="fa-solid fa-crown"></i> Chủ hệ thống</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=admin"
                   class="btn btn-outline-success ms-2" type="button"><i class="fa-solid fa-user-tie"></i> Quản lý</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=user"
                   class="btn btn-outline-warning ms-2" type="button"><i class="fa-solid fa-users"></i> Người dùng</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=lockUsers"
                   class="btn btn-outline-danger ms-2" type="button"><i class="fa-solid fa-user-lock"></i> Người dùng đã khóa</a>
            </div>
            <%if (user.isOwn()) {%>
            <button
                    class="btn btn-outline-primary col-lg-2" type="button" onclick="showAddUserBox()"><i class="fa-solid fa-user-plus"></i> Thêm tài khoản
            </button>
            <div id="add_user" class="w-50 p-3 rounded mt-5" style="display: none;   background: #accfee">
                <div class="form-group">
                    <label for="name">Họ và tên</label>
                    <input type="text" class="form-control" id="name" name="name" oninput="checkName()" required>
                    <div class="text-danger" id="resultValidName"></div>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Số điện thoại</label>
                    <input type="text" class="form-control" id="phoneNumber" name="phoneNumber"
                           oninput="checkPhoneNumber()" required>
                    <div class="text-danger" id="resultValidPhoneNumber"></div>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" oninput="checkEmail()" required>
                    <div class="text-danger" id="resultValidEmail"></div>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" class="form-control" id="password" name="password" oninput="checkPassword()"
                           required>
                    <div class="text-danger" id="resultValidPassword"></div>
                </div>
                <div class="field">
                    <label for="rePassword">Nhập lại mật khẩu</label>
                    <input type="password"  class="form-control" name="rePassword" id="rePassword" oninput="checkRePassword()" required>
                    <div class="text-danger" id="resultValidRePassword"></div>
                </div>
                <div class="form-group">
                    <label for="roleId">Quyền hạn</label>
                    <select class="form-control" id="roleId" name="roleId">
                        <option value="0">Quản lý</option>
                        <option value="-1">Chủ hệ thống</option>
                    </select>
                </div>
                <div class="text-warning" id="validateResult"></div>
                <button type="button" class="btn btn-primary" onclick="addUser()">Thêm tài khoản</button>
                <button
                        class="btn btn-dark" type="button" onclick="hideAddUserBox()">Thoát
                </button>
            </div>
            <%}%>
        </div>
    </form>
    <%--        table--%>
    <div class="table-wrapper-scroll-y my-custom-scrollbar d-flex justify-content-center w-100">
        <table id="data" class="table table-striped table-hover">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap">STT</th>
                <th class="text-nowrap">
                    Họ Và Tên
                </th>
                <th class="text-nowrap">Quyền hạn</th>
                <th class="text-nowrap">Số điện thoại</th>
                <th class="text-nowrap">Địa chỉ email</th>
                <th class="text-nowrap">
                    Ngày đăng ký
                </th>
                <th scope="col"><i class="fa-solid fa-user-pen fs-4"></i></th>
            </tr>
            </thead>
            <tbody>
            <%int stt = 0;%>
            <% for (User u : users) {
                stt++;
            %>
            <tr class="text-center"
                    <%
                        if (user.getId() == u.getId()) {
                    %>
                style="font-weight: bold"
                    <%}%>
            >
                <td class="text-center"><%=stt%>
                </td>
                <td class="text-center"><%=u.getName()%>
                </td>
                <td class="text-center"><%=u.nameAsRole()%>
                </td>
                <td class="text-center"><%=u.getPhoneNumber()%>
                </td>
                <td class="text-center"><%=u.getEmail()%>
                </td>
                <td class="text-center"><%=u.getCreateDate()%>
                </td>
                <td class="text-center">
                    <%if (user.isOwn() && !u.isOwn()) {%>
                    <%if (!u.isLock()) {%>
                    <i title="Khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-unlock fs-4"></i>
                    <%} else {%>
                    <i title="Bỏ khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-lock fs-4 text-danger"></i>
                    <%}%>
                    <%} else if (user.isAdmin() && u.isUser()) {%>
                    <%if (!u.isLock()) {%>
                    <i title="Khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-unlock fs-4"></i>
                    <%} else {%>
                    <i title="Bỏ khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-lock fs-4 text-danger"></i>
                    <%}%>
                    <%}%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
    <input type="hidden" id="currentPageNumber" name="currentPageNumber"
           value="<%=request.getAttribute("currentPageNumber")==null?0:request.getAttribute("currentPageNumber")%>">
</div>
<script>
    $(document).ready(function () {
        var table = $('#data').DataTable({
            "searching": true, // Không có tính năng tìm kiếm
            "lengthChange": false, // Không cho phép thay đổi số lượng bản ghi trên mỗi trang
            "pageLength": 10,
            "displayStart": document.getElementById("currentPageNumber").value,
            language: {
                search: "Nhập từ khóa tìm kiếm"
            }
        });

        function getCurrentPage() {
            let pageInfo = table.page.info();
            document.getElementById("currentPageNumber").value = pageInfo.page;
        }
    });

    function toggleLock(userId, element) {
        // Gọi hàm lockOrUnLock với userId
        lockOrUnLock(userId);

        // Kiểm tra trạng thái hiện tại của biểu tượng
        if (element.classList.contains('fa-unlock')) {
            // Nếu hiện tại là mở khóa, đổi sang khóa
            element.classList.remove('fa-unlock');
            element.classList.add('fa-lock');
            element.classList.add('text-danger');
            element.parentElement.setAttribute('title', 'Bỏ khóa tải khoản');
        } else {
            // Nếu hiện tại là khóa, đổi sang mở khóa
            element.classList.remove('fa-lock');
            element.classList.add('fa-unlock');
            element.classList.remove('text-danger');
            element.parentElement.setAttribute('title', 'Khóa tải khoản');
        }
    }

    function lockOrUnLock(userId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/user-ajax-handle",
            data: {
                action: "lockOrUnLock",
                userId: userId
            },
            success: function (response) {
                // reload log gui
                reloadGUI();
            },
            error: function () {
                alert("error")
            }
        })
    }

    <%if(user.isOwn()){%>

    function showAddUserBox() {
        document.getElementById("add_user").style.display = "block";
    }

    function hideAddUserBox() {
        document.getElementById("add_user").style.display = "none";
    }

    function addUser() {
        const name = document.getElementById("name").value;
        const phoneNumber = document.getElementById("phoneNumber").value;
        const email = document.getElementById("email").value;
        const password = document.getElementById("password").value;
        const rePassword = document.getElementById("rePassword").value;
        const roleId = document.getElementById("roleId").value
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/user-ajax-handle",
            data: {
                action: "addUser",
                name: name,
                phoneNumber: phoneNumber,
                email: email,
                password: password,
                rePassword: rePassword,
                roleId: roleId
            },
            success: function (response) {
                alert(response)
                document.getElementById("validateResult").innerHTML = response;
                window.location.reload();
            },
            error: function () {
                alert("error" + this.error)
            }
        })
    }

    <%}%>

    function checkName() {
        let name = document.getElementById("name").value;
        let regex = /^.+$/;
        if (!name.match(regex)) {
            document.getElementById("resultValidName").textContent = "Tên không được bỏ trống"
        } else {
            document.getElementById("resultValidName").textContent = " "
        }
    }

    function checkPhoneNumber() {
        let phoneNumber = document.getElementById("phoneNumber").value;
        let regex = /^0\d{2}\d{3}\d{4}$/;
        if (!phoneNumber.match(regex)) {
            document.getElementById("resultValidPhoneNumber").textContent = "Số điện thoại không hợp lệ"
        } else {
            document.getElementById("resultValidPhoneNumber").textContent = " "
        }
    }

    function checkEmail() {
        let email = document.getElementById("email").value;
        let regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (!email.match(regex)) {
            document.getElementById("resultValidEmail").textContent = "Email không hợp lệ"
        } else {
            document.getElementById("resultValidEmail").textContent = " "
        }
    }

    function checkPassword() {
        let pw = document.getElementById("password").value;
        // >8 ký tự, ít nhất 1 Hoa, 1 ký tự đặc biệt
        let regex = /^(?=.*[A-Z])(?=.*[\W_])(?=.*[a-z]).{8,}$/;
        if (!pw.match(regex)) {
            document.getElementById("resultValidPassword").textContent = "Mật khẩu bao gồm ít nhất 8 ký tự, có ít nhất 1 ký tự in hoa và 1 ký tự đặc biệt"
        } else {
            document.getElementById("resultValidPassword").textContent = " "
        }
    }

    function checkRePassword() {
        let pw = document.getElementById("password").value;
        let rePw = document.getElementById("rePassword").value;
        if (pw !== rePw) {
            document.getElementById("resultValidRePassword").textContent = "Mật khẩu không khớp"
        } else {
            document.getElementById("resultValidRePassword").textContent = ""
        }
    }
</script>
<script src="<%=request.getContextPath()%>/views/Admin/js/logging.reload.js"></script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>