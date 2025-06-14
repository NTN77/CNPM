<%@ page import="java.util.List" %>
<%@ page import="model.bean.Tip" %>
<%@ page import="model.service.TipService" %>
<%@ page import="model.service.BannerService" %>
<%@ page import="model.bean.BannerItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%List<Tip> tips = TipService.getInstance().getAll();%>
<%List<BannerItem> banners = BannerService.getInstance().getAll();%>
<%BannerItem currentBannerItem = (BannerItem) request.getAttribute("currentBannerItem");%>
<%Tip currentTip = (Tip) request.getAttribute("currentTip");%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Thêm sản phẩm</title>
    <style>
        #add_banner, #add_tip, #edit_banner, #edit_tip {
            position: fixed;
            top: 30%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            z-index: 9;
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
<body style="
    background-color: darkslategrey;
">
<div class="row" style="width: 100%;">
    <div class="row">
        <div class="col-6 text-center" style="font-size: 30px; font-weight: bold; color:white;">
            Banner
            <div class="float-end me-3">
                <button onclick="showAddBanner()">
                    <i class="fa-solid fa-plus" style="font-size: 40px;"></i>
                </button>
            </div>
        </div>
        <div class="col-6 text-center" style="font-size: 30px; font-weight: bold; color:white;">
            Tip
            <div class="float-end me-3">
                <button onclick="showAddTip()">
                    <i class="fa-solid fa-plus" style="font-size: 40px;"></i>
                </button>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-6 h-100" id="bannersBox">
            <%--                show banner--%>
            <form action="<%=request.getContextPath()%>/admin/bannertip" method="post" id="show_banner_form">
                <div style="overflow:auto; display: block; height: 800px">
                    <input type="hidden" name="submit_type" value="show_banner">
                    <input type="hidden" id="edit_banner_title" name="edit_banner_title" value="">
                    <% for (BannerItem b : banners) {%>
                    <div class="d-flex rounded-2 bg-light p-2 m-2 align-items-center"
                         id="<%=b.getTitle()%>"
                         onclick="submit_showEditBannerBox(event,this)"
                         style="cursor: pointer">
                        <img src="<%=request.getContextPath()+"/" + b.getImg_path()%>"
                             class="d-block rounded" alt="File không tồn tại!" height="40%" width="40%">
                        <div class="text-center">
                            <h5 class=""><%=b.getTitle()%>
                            </h5>
                            <p><%=b.getDescription()%>
                            </p>
                        </div>
                    </div>
                    <%}%>
                </div>
            </form>
        </div>
        <div class="col-6 h-100" id="tipsBox">
            <%--                show tip--%>
            <form action="<%=request.getContextPath()%>/admin/bannertip" method="post" id="show_tip_form">
                <div style="overflow:auto; display: block; height: 800px">
                    <input type="hidden" name="submit_type" value="show_tip">
                    <input type="hidden" id="edit_tip_title" name="edit_tip_title" value="">
                    <% for (Tip t : tips) {%>
                    <div class="d-flex rounded-2 bg-light p-2 m-2 align-items-center"
                         id="<%=t.getTitle()%>"
                         onclick="submit_showEditTipBox(event,this)"
                         style="cursor: pointer">
                        <img src="<%=request.getContextPath()+"/" + t.getImgPath()%>"
                             class="d-block rounded" alt="File không tồn tại!" height="40%" width="40%">
                        <div class="text-center">
                            <h5 class=""><%=t.getTitle()%>
                            </h5>
                            <p><%=t.getDescription()%>
                            </p>
                            <a href="<%=t.getVideoLink()%>" target="_blank" onclick="handleLinkClick(event)">Video hướng
                                dẫn</a>
                        </div>
                    </div>
                    <%}%>
                </div>
            </form>
        </div>
    </div>
</div>
<%--add banner box--%>
<div class="row d-flex">
    <div id="add_banner" class="w-50 bg-secondary p-3 rounded" style="display: none">
        <form action="<%=request.getContextPath()%>/admin/bannertip" method="post" enctype="multipart/form-data">
            <div class="text-center fw-bold p-3" style="font-size: 30px; color: #0dcaf0">Tạo banner mới</div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Tiêu đề</span>
                </div>
                <input name="title" type="text" class="form-control">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Mô tả</span>
                </div>
                <input name="description" type="text" class="form-control w-25">
            </div>
            <div>
                <label for="uploadImage" class="d-block">Chọn File Ảnh ít hơn 5MB</label>
                <input id="uploadImage" type="file" name="image" placeholder="Chọn File Ảnh ít hơn 5MB" accept="image/*"
                       required>
            </div>
            <div class="d-flex justify-content-end m-0">
                <button type="button" onclick="hideAddBanner()" class="btn btn-outline-warning m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Hủy bỏ
                </button>
                <button type="submit" name="submit_type" value="add_banner"
                        class="btn btn-outline-success m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Tạo
                </button>
            </div>
        </form>
    </div>
</div>
<%--add tip box--%>
<div class="row d-flex">
    <div id="add_tip" class="w-50 bg-secondary p-3 rounded" style="display: none">
        <form action="<%=request.getContextPath()%>/admin/bannertip" method="post" enctype="multipart/form-data">
            <div class="text-center fw-bold p-3" style="font-size: 30px; color: #0dcaf0">Tạo tip mới</div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Tiêu đề</span>
                </div>
                <input name="title" type="text" class="form-control">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Mô tả</span>
                </div>
                <input name="description" type="text" class="form-control w-25">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Link hướng dẫn</span>
                </div>
                <input name="video_link" type="text" class="form-control w-25">
            </div>
            <div>
                <label for="uploadTipImage" class="d-block">Chọn File Ảnh ít hơn 5MB</label>
                <input id="uploadTipImage" type="file" name="image" placeholder="Chọn File Ảnh ít hơn 5MB"
                       accept="image/*"
                       required>
            </div>
            <div class="d-flex justify-content-end m-0">
                <button type="button" onclick="hideAddTip()" class="btn btn-outline-warning m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Hủy bỏ
                </button>
                <button type="submit" name="submit_type" value="add_tip"
                        class="btn btn-outline-success m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Tạo
                </button>
            </div>
        </form>
    </div>
</div>
<%--edit banner box--%>
<%if (currentBannerItem != null) {%>
<div class="row d-flex">
    <div id="edit_banner" class="w-50 bg-secondary p-3 rounded">
        <form action="<%=request.getContextPath()%>/admin/bannertip" method="post" enctype="multipart/form-data">
            <div class="text-center fw-bold p-3" style="font-size: 30px; color: #0dcaf0">Xóa, sửa banner</div>
            <input type="hidden" name="oldTitle" value="<%=currentBannerItem.getTitle()%>">
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Tiêu đề</span>
                </div>
                <input name="title" type="text" value="<%=currentBannerItem.getTitle()%>" class="form-control">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Mô tả</span>
                </div>
                <input name="description" value="<%=currentBannerItem.getDescription()%>" type="text"
                       class="form-control w-25">
            </div>
            <div class="d-flex justify-content-end m-0">
                <button type="button" onclick="hideEditBanner()" class="btn btn-outline-warning m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Hủy bỏ
                </button>
                <a type="button"
                   href="<%=request.getContextPath()%>/admin/bannertip?submit_type=delete_banner&delete_banner_title=<%=currentBannerItem.getTitle()%>"
                   class="btn btn-outline-danger m-3 fs-5 fw-bold"
                   style="color: #eeeeee">Xóa
                </a>
                <button type="submit" name="submit_type" value="edit_banner"
                        class="btn btn-outline-success m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>
<%}%>

<%--edit tip box--%>
<%if (currentTip != null) {%>
<div class="row d-flex">
    <div id="edit_tip" class="w-50 bg-secondary p-3 rounded">
        <form action="<%=request.getContextPath()%>/admin/bannertip" method="post" enctype="multipart/form-data">
            <div class="text-center fw-bold p-3" style="font-size: 30px; color: #0dcaf0">Xóa, sửa tip</div>
            <input type="hidden" name="oldTitle" value="<%=currentTip.getTitle()%>">
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Tiêu đề</span>
                </div>
                <input name="title" type="text" value="<%=currentTip.getTitle()%>" class="form-control">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Mô tả</span>
                </div>
                <input name="description" value="<%=currentTip.getDescription()%>" type="text"
                       class="form-control w-25">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold">Link hướng dẫn</span>
                </div>
                <input name="video_link" type="text" class="form-control w-25" value="<%=currentTip.getVideoLink()%>">
            </div>
            <div class="d-flex justify-content-end m-0">
                <button type="button" onclick="hideEditTip()" class="btn btn-outline-warning m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Hủy bỏ
                </button>

                <a type="button"
                   href="<%=request.getContextPath()%>/admin/bannertip?submit_type=delete_tip&delete_tip_title=<%=currentTip.getTitle()%>"
                   class="btn btn-outline-danger m-3 fs-5 fw-bold"
                   style="color: #eeeeee">Xóa
                </a>
                <button type="submit" name="submit_type" value="edit_tip"
                        class="btn btn-outline-success m-3 fs-5 fw-bold"
                        style="color: #eeeeee">Lưu thay đổi
                </button>
            </div>
        </form>
    </div>
</div>
<%}%>
<script>
    function handleLinkClick(event) {
        event.stopPropagation(); // Chặn sự kiện lan truyền lên đến thẻ cha
    }

    function showAddBanner() {
        hideAddTip();
        hideEditTip();
        hideEditBanner();
        document.getElementById("add_banner").style.display = "block";
    }

    function showAddTip() {
        hideAddBanner();
        hideEditTip();
        hideEditBanner();
        document.getElementById("add_tip").style.display = "block";
    }

    function hideAddBanner() {
        document.getElementById("add_banner").style.display = "none";
    }

    function hideAddTip() {
        document.getElementById("add_tip").style.display = "none";
    }

    function submit_showEditBannerBox(event, clickedElement) {
        hideAddTip();
        hideAddBanner()
        hideEditTip();

        event.preventDefault();
        var edit_banner_title = clickedElement.id;
        //set cho hide input
        document.getElementById("edit_banner_title").value = edit_banner_title;
        document.getElementById("show_banner_form").submit();
    }

    function submit_showEditTipBox(event, clickedElement) {
        hideAddTip();
        hideAddBanner()
        hideEditBanner();

        event.preventDefault();
        var edit_tip_title = clickedElement.id;
        //set cho hide input
        document.getElementById("edit_tip_title").value = edit_tip_title;
        document.getElementById("show_tip_form").submit();
    }

    function hideEditBanner() {
        var editTipElement = document.getElementById("edit_banner");
        if (editTipElement) {
            editTipElement.style.display = "none";
        }
    }

    function hideEditTip() {
        var editTipElement = document.getElementById("edit_tip");
        if (editTipElement) {
            editTipElement.style.display = "none";
        }
    }

</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>