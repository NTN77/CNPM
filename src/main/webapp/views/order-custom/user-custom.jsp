        <%@ page import="model.bean.User" %>
<%@ page import="model.bean.OrderImage" %>
<%@ page import="model.service.OrderService" %>
<%@ page import="java.util.List" %>
        <%@ page import="model.service.UserService" %><%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 6/2/2025
  Time: 4:55 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Custom</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <!--https://www.bootstrapcdn.com/-->
    <%--    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"--%>
    <%--          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">--%>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
</head>
<%
    User user = (User) (request.getSession().getAttribute("auth"));
    List<OrderImage> orders = null;
    if (user != null) {
        orders = OrderService.getInstance().getOrderCustomByCustomerId(user.getId());
    }
%>
<body>
<div class="container p-4 rounded">
    <div class="fw-bold text-start" style="font-size: 30px; color: #0dcaf0">
        <a class="btn btn-primary" href="/HandMadeStore/views/MainPage/view_mainpage/mainpage.jsp" role="button">Trang chủ</a>
        <div>
            <i onclick="goBack()"
               class="fa-solid fa-arrow-left" style="color: #183153; cursor: pointer"></i>
        </div>
    </div>

    <div class="table-wrapper-scroll-y my-custom-scrollbar d-flex justify-content-center mt-3">
        <table id="data" class="table table-striped table-hover" style="min-width: 1000px; width: 100%;">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap">Mã ĐH</th>
                <th class="text-nowrap">Ảnh custom</th>
                <th class="text-nowrap">Ngày Đặt Hàng</th>
                <th class="text-nowrap">Ngày giao hàng</th>
                <th class="text-nowrap">Địa chỉ</th>
                <th class="text-nowrap">Tùy chọn</th>
                <th class="text-nowrap">Số điện thoại</th>
                <th class="text-nowrap">Ghi chú</th>
                <th class="text-nowrap">Trạng Thái</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (OrderImage o : orders) {
                    if (o != null) {
            %>
            <tr class="text-center" style=" cursor: pointer;"
                id="<%=o.getId()%>"
            >
                <td class="text-center"><%=o.getId()%>
                </td>
                <td class="text-start">
                    <img src="<%=request.getContextPath() + "/" + o.getImagePath()%>" width="100px" height="100px">
                </td>
                <td class="text-start"><%=o.getOrderDate()%>
                </td>
                <td class="text-start"><%=o.getRecieveDate()%>
                </td>
                <td class="text-start"><%=o.getAddress()%>
                </td>
                <td class="text-start"><%=o.getOtherCustom()%>
                </td>
                <td class="text-start"><%=o.getTel()%>
                </td>
                <td class="text-start"><%=o.getNote() == null ? "" : o.getNote()%>
                </td>
                <td>
                    <span class="badge" style="background-color:<%=o.getStatusAsColor()%>;">
                        <%=o.getStatusAsName()%>
                    </span>
                </td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>
</div>
</body>

<script>
    function goBack() {
        const previousPage = document.referrer;
        if (previousPage) {
            window.location.href = previousPage;
        } else {
            window.history.href = "/";
        }
    }
</script>
</html>
