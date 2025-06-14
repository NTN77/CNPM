<%@ page import="java.util.List" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="model.bean.Discount" %>
<%@ page import="model.service.DiscountService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String productName = (String) request.getAttribute("productName");
    productName = productName != null ? productName : "";
    String quantity = (String) request.getAttribute("quantity");
    quantity = quantity != null ? quantity : "";
    String costPrice = (String) request.getAttribute("costPrice");
    costPrice = costPrice != null ? costPrice : "";
    String sellingPrice = (String) request.getAttribute("sellingPrice");
    sellingPrice = sellingPrice != null ? sellingPrice : "";
    String radio_choiceCategory = (String) request.getAttribute("choiceCategory");
    radio_choiceCategory = radio_choiceCategory != null ? radio_choiceCategory : "";
    String discount = (String) request.getAttribute("discount");
    discount = discount != null ? discount : "";
    String description = (String) request.getAttribute("description");
    description = description != null ? description : "";
    String availableCategory = (String) request.getAttribute("availableCategory");//category id
    availableCategory = availableCategory != null ? availableCategory : "";
    String newCategory = (String) request.getAttribute("newCategory");
    newCategory = newCategory != null ? newCategory : "";

    List<Category> categories = CategoryService.getInstance().getALl();
    List<Discount> discounts = DiscountService.getInstance().getAll();
%>
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
<body>

<div class="container-fluid mx-auto mt-2">
    <% String re = (String) request.getAttribute("result");
        if (re != null) {
    %>
    <div id="errorAlert" class="alert alert-warning" role="alert">
        <%=re%>
    </div>
    <%}%>
    <form action="<%=request.getContextPath()%>/addproduct" method="post" enctype="multipart/form-data"
          onsubmit="return validateForm()">
        <div class="row my-4">
            <div class="col-md-6 mb-2">
                <div class="form-floating w-75 mx-5 my-2 p-2 ">
                    <input type="text" class="form-control" id="productName" name="productName" value="<%=productName%>"
                           placeholder="Thiệp sinh nhật" oninput="validateNotEmpty(this)">
                    <label for="productName">Tên sản phẩm</label>
                </div>
                <div class="form-floating w-75 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="quantity" name="quantity" placeholder="Số lượng"
                           value="<%=quantity%>" oninput="validateDouble(this)">
                    <label for="quantity">Số lượng</label>
                </div>
                <div class="form-floating w-75 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="costPrice" name="costPrice" placeholder="Giá nhập vào"
                           value="<%=costPrice%>" oninput="validateDouble(this)">
                    <label for="costPrice">Giá nhập vào</label>
                </div>
                <div class="form-floating w-75 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="sellingPrice" name="sellingPrice"
                           placeholder="Giá bán"
                           value="<%=sellingPrice%>" oninput="validateDouble(this)">
                    <label for="sellingPrice">Giá bán</label>
                </div>
            </div>
            <%--        Choice category and create new category--%>
            <div class="col-md-6 mb-5">
                <div class="mt-4">
                    <div class="m-0 border alert alert-dismissible d-flex align-items-center w-75 mx-5 my-2 p-2">
                        <div class="me-4 ms-3">
                            <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                   name="choiceCategory" id="case1"
                                <%if (radio_choiceCategory.equals("choiceAvailableCategory")){%>
                                   checked
                                <%}%>
                                   value="choiceAvailableCategory"
                                   onclick="showAvailableCategory()">
                            <label class="form-check-label" style="cursor: pointer" for="case1">
                                Chọn danh mục có sẵn
                            </label>
                        </div>
                        <div>
                            <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                   name="choiceCategory"
                                   id="case2"
                                <%if (radio_choiceCategory.equals("choiceNewCategory")){%>
                                   checked
                                <%}%>
                                   value="choiceNewCategory"
                                   onclick="showInputToNewCategory()"
                            >
                            <label class="form-check-label" style="cursor: pointer" for="case2">
                                Tạo danh mục mới
                            </label>
                        </div>
                    </div>
                    <div class="form-floating w-75 mx-5 my-2 p-2 align-content-start" style="display: none"
                         id="showAvailableCategory">
                        <select class="form-select" id="availableCategory" name="availableCategory"
                                aria-label="Chọn danh mục liên quan">
                            <%for (Category category : categories) {%>
                            <option value="<%=category.getId()%>"><%=category.getName()%>
                            </option>
                            <%}%>
                        </select>
                        <label>Chọn danh mục liên quan</label>
                    </div>
                    <div class="form-floating w-75 mx-5 my-2 p-2 align-content-start" style="display: none"
                         id="showInputToNewCategory">
                        <input type="text" class="form-control" id="newCategory" name="newCategory"
                               value="<%=newCategory%>">
                        <label for="newCategory">Nhập tên danh mục mới</label>
                    </div>
                </div>
            </div>
            <div class="form-floating w-75 mx-5 my-2 p-2">
                <select class="form-select" id="discount" aria-label="Giảm giá áp dụng" name="discount">
                    <option value="" selected></option>
                    <%for (Discount d : discounts) {%>
                    <option value="<%=d.getId()%>"><%=d.getName()%> - giảm <%=d.getPercentageOff() * 100%>%
                    </option>
                    <%}%>
                </select>
                <label for="discount">Chọn giảm giá áp dụng</label>
            </div>
        </div>
        <div class="row my-4 mx-5 border rounded-3">
            <label for="description" class="form-label">Mô tả sản phẩm</label>
            <textarea class="form-control mx-auto w-70" style="height: 200px" id="description" name="description"
                      rows="3" oninput="validateNotEmpty(this)"><%=description%></textarea>
        </div>

        <div class="row my-4 mx-5 border rounded-3">
            <!--    input Images-->
            <div class="row">
                <p class="fw-bold">Chọn một hoặc nhiều ảnh cho sản phẩm</p>
            </div>
            <div class="row align-items-center" style="height: 100px;">
                <div class="row">
                    <div class="col-8">
                        <label for="uploadImage">Chọn File Ảnh ít hơn 5MB</label>
                        <input id="uploadImage" type="file" name="images" placeholder="Chọn File Ảnh ít hơn 5MB"
                               multiple onchange="displayFileNames(this)" accept="image/*" required>
                        <div id="fileNamesContainer"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mb-2 me-5 mb-2">
            <div class="d-flex justify-content-end m-0" id="submit">
                <button type="submit" value="addproduct" class="btn btn-outline-success m-3">Hoàn tất thêm sản phẩm mới
                </button>
            </div>
        </div>
    </form>
</div>
<script>
    function showAvailableCategory() {
        document.getElementById("showInputToNewCategory").style.display = "none";
        document.getElementById("showAvailableCategory").style.display = "block";
    }

    function showInputToNewCategory() {
        document.getElementById("showAvailableCategory").style.display = "none";
        document.getElementById("showInputToNewCategory").style.display = "block";
    }

    function displayFileNames(input) {
        var fileNamesContainer = document.getElementById("fileNamesContainer");
        fileNamesContainer.innerHTML = "";

        if (input.files.length > 0) {
            for (var i = 0; i < input.files.length; i++) {
                var fileName = input.files[i].name;
                var fileNameElement = document.createElement("span");
                fileNameElement.textContent = fileName + "; ";
                fileNamesContainer.appendChild(fileNameElement);
            }
        } else {
            fileNamesContainer.innerHTML = "Không có file được chọn";
        }
    }

    function validateForm() {
        var fileInput = document.getElementById('uploadImage');
        var maxSize = 5 * 1024 * 1024; // 5 MB

        if (fileInput.files.length > 0) {
            for (var i = 0; i < fileInput.files.length; i++) {
                if (fileInput.files[i].size > maxSize) {
                    alert('Kích thước tệp ảnh không được vượt quá 5 MB.');
                    return false;
                }
            }
        }
        return true;
    }

    function validateNotEmpty(inputElement) {
        if (inputElement.value.trim() === "") {
            document.getElementById("errorAlert").textContent = "Trường không được bỏ trống."
            inputElement.setCustomValidity('Trường này không được bỏ trống.');
        } else {
            document.getElementById("errorAlert").textContent = ""
            inputElement.setCustomValidity('');
        }
    }

    function validateDouble(inputElement) {
        if (parseFloat(inputElement.value) <= 0) {
            document.getElementById("errorAlert").textContent = "Giá trị không nhỏ hơn 0."
            inputElement.setCustomValidity('Giá trị không nhỏ hơn 0');
        } else {
            document.getElementById("errorAlert").textContent = ""
            inputElement.setCustomValidity('');
        }
    }
</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>
