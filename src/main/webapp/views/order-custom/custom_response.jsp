<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 5/30/2025
  Time: 2:21 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<%
    Boolean success = (Boolean) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>

<script>
    <% if (success != null && success) { %>
    Swal.fire({
        icon: 'success',
        title: 'Đặt hàng thành công!',
        text: 'Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ liên hệ sớm.',
        confirmButtonText: 'Trang chủ'
    }).then(() => {
        window.location.href = '<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp';
    });
    <% } else { %>
    Swal.fire({
        icon: 'error',
        title: 'Thất bại!',
        text: '<%= error %>'
    });
    <% } %>
</script>

</body>
</html>

