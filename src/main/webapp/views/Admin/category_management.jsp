<%@ page import="java.util.List" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.service.CategoryService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%List<Category> categories = CategoryService.getInstance().getALl();%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý danh mục</title>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container p-4">
    <form action="<%=request.getContextPath()%>/admin/category" method="post" id="categoryForm"
          onsubmit="submitForm(event)">
        <div class="row mb-3">
            <div class="col-2 text-center fs-5 fw-bold">STT</div>
            <div class="col-10 text-center fs-5 fw-bold">Thao tác</div>
        </div>

        <%
            int stt = 0;
            for (Category category : categories) {
                stt++;
        %>
        <div class="row mb-3">
            <div class="col-2 text-center d-flex justify-content-center align-items-center fs-5 fw-bold"><%=stt%></div>
            <div class="col-10">
                <div class="input-group">
                    <input type="text" class="form-control"
                           disabled
                           id="input_<%=category.getId()%>"
                           name="<%=category.getId()%>"
                           value="<%=category.getName()%>">

                    <div class="input-group-append">
                        <button class="btn btn-outline-success" type="button"
                                onclick="editCategory(<%=category.getId()%>)"
                                id="edit_<%=category.getId()%>"
                        >Thay đổi
                        </button>
                        <%--                        edit--%>
                        <button class="btn btn-outline-warning" type="submit"
                                onclick="saveCategory('<%=category.getId()%>')"
                                style="display: none"
                                id="save_<%=category.getId()%>"
                                value="<%=category.getId()%>"
                        >Lưu thay đổi
                        </button>
                        <%--                        delete--%>
                        <%if (CategoryService.getInstance().checkNoUsedCategoryById(category.getId())) {%>
                        <a href="<%=request.getContextPath()%>/admin/category?deleteCategoryId=<%=category.getId()%>">
                            <div class="btn btn-outline-danger ms-2" type="button">Xóa
                            </div>
                        </a>
                        <%} else {%>
                        <div class="btn ms-2" type="button"
                             disabled
                             style="color: #ffffff; border: none"
                             title="Chỉ có thể xóa khi danh mục trống">Xóa
                        </div>
                        <%}%>
                    </div>
                </div>
            </div>
        </div>
        <%}%>
        <!-- Thêm trường ẩn để chứa categoryId -->
        <input type="hidden" id="currentEditCategoryId" name="currentEditCategoryId" value=""/>
        <!-- Thêm alert để hiển thị lỗi -->
        <div id="errorAlert" class="alert alert-danger" role="alert" style="display: none;">
            Các trường không được để trống!
        </div>
    </form>
</div>

<script>
    <!--    edit button-->
    function editCategory(category_id) {
        document.getElementById('input_' + category_id).disabled = false;
        document.getElementById('save_' + category_id).style.display = 'inline';
        document.getElementById('edit_' + category_id).style.display = 'none';
    }

    function saveCategory(category_id) {
        document.getElementById('save_' + category_id).style.display = 'none';
        document.getElementById('edit_' + category_id).style.display = 'inline';
    }

    function submitForm(event) {
        event.preventDefault();  // Ngăn chặn form từ việc tự động submit

        // Tìm button đã được click
        var clickedButton = document.activeElement;
        var categoryId = clickedButton.value;
        var inputField = document.getElementById('input_' + categoryId);

        // Kiểm tra xem input có trống không
        if (inputField && inputField.value.trim() === '') {
            document.getElementById('errorAlert').style.display = 'block';
            editCategory(categoryId)
        }else {
            // Ẩn alert lỗi nếu không có lỗi
            document.getElementById('errorAlert').style.display = 'none';

            // Cập nhật giá trị của trường ẩn
            document.getElementById("currentEditCategoryId").value = categoryId;

            // Tiếp tục submit form nếu cần
            document.getElementById("categoryForm").submit();
        }
    }
</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>
