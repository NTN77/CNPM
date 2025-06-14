<%--<%@ page import="model.bean.User" %>--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%String result = (String) request.getAttribute("result");%>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"--%>
<%--          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">--%>
<%--    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->--%>
<%--    <title>Title</title>--%>
<%--</head>--%>
<%--<%--%>
<%--    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));--%>
<%--    if (isAdmin) {--%>
<%--%>--%>
<%--<body class="justify-content-center mx-5" style="margin-top: 15%">--%>
<%--<form action="<%=request.getContextPath()%>/admin/support" method="post">--%>
<%--    <div class="row">--%>
<%--        <div class="col-6">--%>
<%--            <input type="hidden" name="userId"--%>
<%--                   value="<%=((User) request.getSession().getAttribute("auth")).getId()%>">--%>
<%--            <div class="form-group">--%>
<%--                <label>Bạn gặp vấn đề gì?</label>--%>
<%--                <input type="text" class="form-control" name="problemTitle">--%>
<%--            </div>--%>
<%--            <div class="form-group">--%>
<%--                <label for="exampleFormControlTextarea1">Mô tả vấn đề</label>--%>
<%--                <textarea class="form-control" id="exampleFormControlTextarea1" rows="3" name="desc"></textarea>--%>
<%--            </div>--%>
<%--            <div class="d-flex justify-content-start">--%>
<%--                <button type="submit" class="btn btn-info mt-2" id="confirmButton" onclick="loadingConfirm()">Gửi cho--%>
<%--                    chúng tôi--%>
<%--                </button>--%>
<%--            </div>--%>
<%--            <div id="loadingConfirmBox" style="display:none;">--%>
<%--                <span class="spinner-border spinner-border-sm" role="status"--%>
<%--                      aria-hidden="true"></span>--%>
<%--                Đang gởi--%>
<%--            </div>--%>
<%--            <div class="text-center fw-bold fs-3"><%=(result != null) ? result : ""%>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--        <div class="col-6 rounded" style="background-color: #0dcaf0">--%>
<%--            <div class="m-5 fs-5">--%>
<%--                <div class="d-flex mb-3">--%>
<%--                    <i class="fa-solid fa-location-dot me-3 mt-1" style="color: #eeeeee"></i>--%>
<%--                    <div style="color: #eeeeee"><strong>Địa Chỉ: </strong>Đại Học Nông Lâm TPHCM</div>--%>
<%--                </div>--%>
<%--                <div class="d-flex mb-3">--%>
<%--                    <i class="fa-solid fa-phone me-3 mt-1" style="color: #eeeeee"></i>--%>
<%--                    <div style="color: #eeeeee"><strong>Số điện thoại: </strong>033.66.77.141</div>--%>
<%--                </div>--%>
<%--                <div class="d-flex mb-3">--%>
<%--                    <i class="fa-regular fa-envelope me-3 mt-1" style="color: #eeeeee"></i>--%>
<%--                    <div style="color: #eeeeee"><strong>Email: </strong>DH21DTC2023</div>--%>
<%--                </div>--%>
<%--                <div class="d-flex mb-3">--%>
<%--                    <i class="fa-solid fa-globe me-3 mt-1" style="color: #eeeeee"></i>--%>
<%--                    <div style="color: #eeeeee"><strong>Website: </strong><a>DH21DTC2025.com</a></div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</form>--%>
<%--<script>--%>
<%--    function loadingConfirm() {--%>
<%--        document.getElementById("confirmButton").style.display = "none";--%>
<%--        // Hiển thị thẻ loading--%>
<%--        document.getElementById('loadingConfirmBox').style.display = 'block';--%>
<%--        // Thực hiện công việc cần thiết ở đây, có thể làm gì đó mất vài giây--%>

<%--        // Sau khi hoàn thành công việc, ẩn thẻ loading--%>
<%--        setTimeout(function () {--%>
<%--            document.getElementById('loadingConfirmBox').style.display = 'none';--%>
<%--        }, 5000); // Đặt thời gian (2 giây) tùy thuộc vào công việc cần thực hiện--%>
<%--    };--%>
<%--</script>--%>
<%--</body>--%>
<%--<%--%>
<%--    } else {--%>
<%--        response.sendRedirect(request.getContextPath() + "/login");--%>
<%--    }--%>
<%--%>--%>
<%--</html>--%>