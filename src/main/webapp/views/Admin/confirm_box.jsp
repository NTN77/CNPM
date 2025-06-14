<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String title = (String) request.getAttribute("title");%>
<%String message = (String) request.getAttribute("message");%>
<%String ok_link = (String) request.getAttribute("ok_link");%>
<%String cancel_link = (String) request.getAttribute("cancel_link");%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Thêm sản phẩm</title>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body style="background-color: rgba(0, 0, 0, .75);">
<div class="container rounded p-2" style="background-color: #eeeeee; margin-top: 15%">
    <div class="d-flex align-items-center p-3 rounded-3" style="font-size: 30px; background-color: #347AB6">
        <div class="me-3">
            <i class="fa-solid fa-question p-2 rounded-circle" style="background-color: #eeeeee"></i>
        </div>
        <div style="color: #eeeeee">
            <%=title%>
        </div>
    </div>
    <div class="row my-5">
        <h4><%=message%>
        </h4>
    </div>
    <div class="text-end">
        <a href="<%=request.getContextPath()%>/<%=ok_link%>" class="btn btn-warning my-3 rounded-3 me-3">Tiếp tục</a>
        <a href="<%=request.getContextPath()%>/<%=cancel_link%>" class="btn btn-secondary rounded-3">Hủy bỏ</a>
    </div>
</div>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath()+"/login");
    }%>
</html>