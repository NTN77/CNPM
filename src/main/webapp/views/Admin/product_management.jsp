<%@ page import="java.util.List" %>
<%@ page import="model.bean.Product" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="model.service.DiscountService" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.bean.Discount" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="model.bean.Image" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>
<%List<Product> products = (List<Product>) request.getAttribute("products");%>
<%products = (products == null) ? ProductService.getInstance().getAllProducts() : products;%>
<%List<Category> categories = (List<Category>) request.getAttribute("categories");%>
<%categories = (categories == null) ? CategoryService.getInstance().getALl() : categories;%>
<%
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    selectedCategory = (selectedCategory == null) ? "all" : selectedCategory;
%>
<% Product edit_product = (Product) request.getAttribute("edit_product");%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý sản phẩm</title>
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
            z-index: 1000;
        }

        .dt-empty, .dt-info {
            display: none;
        }

        #edit_product {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            display: none;
            z-index: 1030;
            background-color: #2c3e50; /* Adjust the background color as needed */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Optional: Add a box shadow for a subtle effect */
        }

        #delete_image_box, #delete_product_box {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            display: none;
            z-index: 1033;
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
<%--edit--%>
<%if (edit_product != null) {%>
<form action="<%=request.getContextPath()%>/admin/product" method="post" enctype="multipart/form-data">
    <div id="edit_product" class="w-100 bg-secondary p-3 rounded"
         style="display: block">
        <div class="text-center fw-bold p-3" style="font-size: 30px; color: #0dcaf0">Chỉnh sửa thông tin sản phẩm có
            mã: <%=edit_product.getId()%>
        </div>

        <div class="err">
            <% String re = request.getAttribute("result") == null ? "" : request.getAttribute("result").toString(); %>
            <p id="errPass" class="text-center" style="color: red"><%=re%>
            </p>
        </div>
        <div class="row my-4">
            <div class="col-md-6 mb-2">
                <div class="form-floating w-100 mx-5 my-2 p-2 ">
                    <input type="text" class="form-control" name="last_edit_product_id"
                           value="<%=edit_product.getId()%>" style="display: none">
                    <input type="text" class="form-control" id="productName" name="productName"
                           value="<%=edit_product.getName()%>">
                    <label for="productName">Tên sản phẩm (Lưu ý: Không nên chứa ký tự '#')</label>
                </div>
                <div class="form-floating w-100 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="quantity" name="quantity"
                           value="<%="Đang lỗi nha"%>">
                    <label for="quantity">Số lượng</label>
                </div>
                <div class="form-floating w-100 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="costPrice" name="costPrice"
                           value="<%="Đang lỗi nha"%>">
                    <label for="costPrice">Giá nhập vào</label>
                </div>
                <div class="form-floating w-100 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="sellingPrice" name="sellingPrice"
                           value="<%=edit_product.getSellingPrice()%>">
                    <label for="sellingPrice">Giá bán</label>
                </div>
            </div>
            <%--        Choice category and create new category--%>
            <div class="col-md-6 mb-5">
                <div class="mt-4">
                    <div class="m-0 border alert alert-dismissible d-flex align-items-center  mx-5 my-2 p-2">
                        <div class="me-4 ms-3">
                            <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                   name="choiceCategory" id="case1"
                                <%if (edit_product.getCategoryId()>0){%>
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
                                <%if (edit_product.getCategoryId()<=0){%>
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
                    <div class="form-floating  mx-5 my-2 p-2 align-content-start"
                            <%if (edit_product.getCategoryId() > 0) {%>
                         style="display: block"
                            <%} else {%>
                         style="display: none"
                            <%}%>
                         id="showAvailableCategory">
                        <select class="form-select" id="availableCategory" name="availableCategory"
                                aria-label="Chọn danh mục liên quan">
                            <%for (Category category : categories) {%>
                            <option value="<%=category.getId()%>"
                                    <% if (edit_product.getCategoryId() == category.getId()) {%>
                                    selected
                                    <%}%>
                            >
                                <%=category.getName()%>
                            </option>
                            <%}%>
                        </select>
                        <label>Chọn danh mục liên quan</label>
                    </div>
                    <div class="form-floating  mx-5 my-2 p-2 align-content-start"
                            <%if (edit_product.getCategoryId() > 0) {%>
                         style="display: none"
                            <%} else {%>
                         style="display: block"
                            <%}%>
                         id="showInputToNewCategory">
                        <input type="text" class="form-control" id="newCategory" name="newCategory">
                        <label for="newCategory">Nhập tên danh mục mới</label>
                    </div>
                    <div class="form-floating  mx-5 my-2 p-2">
                        <select class="form-select" id="discountId" aria-label="Giảm giá áp dụng" name="discount">
                            <option value="" selected></option>
                            <%for (Discount d : DiscountService.getInstance().getAll()) {%>
                            <option value="<%=d.getId()%>"
                                    <%if (edit_product.getDiscountId() == d.getId()) {%>
                                    selected
                                    <%}%>
                            >
                                <%=d.getName()%> - giảm <%=d.getPercentageOff() * 100%>%
                            </option>
                            <%}%>
                        </select>
                        <label for="discountId">Chọn giảm giá áp dụng</label>
                    </div>
                    <div class="mx-5" style=" display: block;position: relative;height: 110px;overflow: auto;">
                        <div class="d-flex justify-content-start">
                            <%for (Image image : ImageService.getImagesForProduct(edit_product.getId() + "")) {%>
                            <div class="mx-3" id="image_<%=image.getId()%>">
                                <%--                                haha--%>
                                <div class="text-danger fw-bold text-end" style="cursor: pointer"
                                     onclick="showDeleteImageBox(<%=image.getId()%>)">Xóa
                                </div>
                                <img class="border-2" width="80px" , height="80px"
                                     src="<%=request.getContextPath()%>/<%=image.getPath()%>">
                            </div>
                            <%}%>
                            <div class="col-8">
                                <label for="uploadImage">Chọn File Ảnh ít hơn 5MB</label>
                                <input id="uploadImage" type="file" name="images" placeholder="Chọn File Ảnh ít hơn 5MB"
                                       multiple onchange="displayFileNames(this)" accept="image/*">
                                <div id="fileNamesContainer"></div>
                                <%--                                <button class="mt-3 border-2 btn btn-outline-dark" style="width: 80px; height: 80px;"><i--%>
                                <%--                                        style="font-size: 30px" class="fa-solid fa-circle-plus"></i></button>--%>
                            </div>
                        </div>
                    </div>
                    <div id="delete_image_box"></div>
                </div>
            </div>
        </div>
        <div class="row my-4 mx-5 border rounded-3">
            <label for="description" class="form-label">Mô tả sản phẩm</label>
            <textarea class="form-control mx-auto w-70"
                      style="height: 200px; white-space: nowrap; overflow: auto; resize: none;"
                      id="description" name="description"
                      rows="3"><%=edit_product.getDescription()%></textarea>
        </div>
        <div class="d-flex justify-content-end m-0">
            <button type="button" onclick="hideEditProduct()" class="btn btn-outline-warning m-3 fs-5 fw-bold"
                    style="color: #eeeeee">Thoát
            </button>
            <button type="submit"
                    class="btn btn-outline-success m-3 fs-5 fw-bold"
                    style="color: #eeeeee"
                    title="Hoàn tất nếu bạn chắc chắn đã điền đầy đủ thông tin">Hoàn tất chỉnh sửa
            </button>
        </div>
        <input type="hidden" name="currentPageNumber"
               value="<%=request.getAttribute("currentPageNumber")==null?0:request.getAttribute("currentPageNumber")%>">
    </div>
</form>
<script>
    function showAvailableCategory() {
        document.getElementById("showInputToNewCategory").style.display = "none";
        document.getElementById("showAvailableCategory").style.display = "block";
    }

    function showInputToNewCategory() {
        document.getElementById("showAvailableCategory").style.display = "none";
        document.getElementById("showInputToNewCategory").style.display = "block";
    }

    function hideEditProduct() {
        document.getElementById("edit_product").style.display = "none";
    }
</script>
<%}%>
<%--main--%>
<div class="container-fluid mx-auto mt-2">
    <div class="row m-4 fs-6">
        <div class="col-6 align-content-center">
            <select class="form-select form-select-lg" id="optionFunction" onchange="location=this.value;">
                </option>
                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=all"
                        <%if (selectedCategory == null || selectedCategory.equals("all")) {%>
                        selected
                        <%}%>
                >Tất cả sản phẩm
                </option>

                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=isSaleTrue"
                        <%if (selectedCategory != null && selectedCategory.equals("isSaleTrue")) {%>
                        selected
                        <%}%>
                >Sản phẩm đang kinh doanh
                </option>

                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=isSaleFalse"
                        <%if (selectedCategory != null && selectedCategory.equals("isSaleFalse")) {%>
                        selected
                        <%}%>
                >Sản phẩm ngừng kinh doanh
                </option>
                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=hasDiscountTrue"
                        <%if (selectedCategory != null && selectedCategory.equals("hasDiscountTrue")) {%>
                        selected
                        <%}%>
                >Sản phẩm đang áp dụng giảm giá
                </option>
                </option>
                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=hasDiscountFalse"
                        <%if (selectedCategory != null && selectedCategory.equals("hasDiscountFalse")) {%>
                        selected
                        <%}%>
                >Sản phẩm không áp dụng giảm giá nào
                </option>

                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=nullQuantity"
                        <%if (selectedCategory != null && selectedCategory.equals("nullQuantity")) {%>
                        selected
                        <%}%>
                >Sản phẩm hết hàng
                </option>

                <%for (Category c : categories) {%>
                <option class="fst-italic"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=<%=c.getId()%>"
                        <%if (selectedCategory != null && selectedCategory.equals(c.getId() + "")) {%>
                        selected
                        <%}%>
                ><%=c.getName()%>
                </option>
                <%}%>
                <option
                    <%if (request.getAttribute("nameFilter") != null) {%>
                        selected
                    <%}%>
                        disabled
                >
            </select>
        </div>
        <%--        THANH TÌM KIẾM THEO TÊN         --%>
        <div class="col-6">
            <div class="input-group justify-content-end">
                <div>
                    <div class="d-flex">
                        <input type="text" class="form-control" placeholder="Nhập mã sản phẩm"
                               name="searchInput"
                               id="searchInput">
                    </div>
                    <input type="text" name="func" value="product_management" style="display: none">
                </div>
            </div>
        </div>
    </div>

    <%--    BẢNG SẢN PHẨM CHÍNH.--%>
    <div class="table-wrapper-scroll-y my-custom-scrollbar  d-flex justify-content-center">
        <table id="data" class="table table-striped table-hover">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap fix-column" scope="col"
                    style=" position: sticky;left: 0;z-index: 1;"
                >Mã
                </th>
                <th scope="col">Tên sản phẩm</th>
                <th class="text-nowrap" scope="col">Có sẵn</th>
                <th class="text-nowrap" scope="col">Đã bán</th>
                <th class="text-nowrap" scope="col">Giá nhập</th>
                <th class="text-nowrap" scope="col">Giá bán</th>
                <th class="text-nowrap" scope="col">Giảm giá</th>
                <th class="text-nowrap" scope="col">Giá sản phẩm</th>
                <th class="text-nowrap" scope="col">
                    Trạng thái kinh doanh
                </th>
                <th class="text-nowrap" scope="col">Chức năng</th>
            </tr>
            </thead>
            <tbody>
            <%for (Product p : products) {%>
            <tr class="text-center">
                <td
                >
                    <%--                        show--%>
                    <a href="<%=request.getContextPath()%>/product-detail?id=<%=p.getId()%>" target="_blank"
                       class="px-2 btn btn-primary">
                        <%=p.getId()%>
                    </a>
                </td>
                <td><%=p.getName()%>
                </td>
                <td><%="Đang lỗi nha"%>
                </td>
                <td><%="Đang lỗi nha"%>
                </td>
                <td><%="Đang lỗi nha"%>
                </td>
                <td><%=numberFormat.format(p.getSellingPrice())%>
                </td>
                <%!double finalSellingPrice;%>
                <%finalSellingPrice = ProductService.getInstance().productPriceIncludeDiscount(p);%>
                <td>

                    <%Discount d = DiscountService.getInstance().getDiscountById(p.getDiscountId() + "");%>
                    <%if (finalSellingPrice == p.getSellingPrice()) {%>
                    <del style="text-decoration-color: red;">
                        <%=(d == null) ? "" : d.getName() + " - giảm " + (d.getPercentageOff() * 100) + "%"%>
                    </del>
                    <%} else {%>
                    <%=(d == null) ? "" : d.getName() + " - giảm " + (d.getPercentageOff() * 100) + "%"%>
                    <%}%>
                </td>
                <td><%=numberFormat.format(finalSellingPrice)%>
                <td>
                    <%if (p.getIsSale() == 0) {%>
                    <%--0: false--%>
                    <button title="Nhấp vào để: Tiếp tục kinh doanh sản phẩm này" class="btn btn-outline-primary"
                            onclick="switchProductIsSale(<%=p.getId()%>, this)">
                        <i class="fa-solid fa-xmark fs-4" style="color: red"></i>
                    </button>
                    <%} else {%>
                    <%--1: true--%>
                    <button title="Nhấp vào để: Ngừng kinh doanh sản phẩm này" class="btn btn-outline-primary"
                            onclick="switchProductIsSale(<%=p.getId()%>, this)">
                        <i class="fa-solid fa-check fs-4"></i>
                    </button>
                    <%}%>
                </td>
                 <td>
                    <button onclick="showEdit(<%=p.getId()%>)"
                            class="px-2">
                        <i class="fa-solid fa-pen fs-4" style="color: #5c7093;"></i></button>
                </td>
            </tr>
            <%}%>
            </tbody>
        </table>
        <div id="delete_product_box"></div>
    </div>
    <input type="hidden" id="currentPageNumber" name="currentPageNumber"
           value="<%=request.getAttribute("currentPageNumber")==null?0:request.getAttribute("currentPageNumber")%>">
</div>
<script>
    const searchInput = document.querySelector('#searchInput');
    let table;
    $(document).ready(function () {
        table = $('#data').DataTable({
            "searching": true, // Không có tính năng tìm kiếm
            "lengthChange": false, // Không cho phép thay đổi số lượng bản ghi trên mỗi trang
            "pageLength": 10,
            "infor": false,
            "displayStart": document.getElementById("currentPageNumber").value * 10,
            language: {
                search: "Nhập từ khóa tìm kiếm"
            }
        });
        table.on('page.dt', function () {
            let pageInfo = table.page.info();
            document.getElementById("currentPageNumber").value = pageInfo.page;
        });
        if (searchInput) {
            searchInput.addEventListener('input', function () {
                const searchValue = this.value;
                table.columns(0).search(searchValue).draw();
            });
        }
    });

    function showEdit(productId) {
        let currentPageNumber = document.getElementById("currentPageNumber").value;
        window.location.href = "<%=request.getContextPath()%>/admin/product?func=product_management&edit_product_id=" + productId + "&currentPageNumber=" + currentPageNumber;
    }

    function showDeleteImageBox(imageId) {
        const container = document.getElementById('delete_image_box');
        container.innerHTML = `
        <div>
            <h4 class="text-danger">Bạn sẽ không thể hoàn tác thao tác này!</h1>
            <button type="button" class="btn btn-outline-secondary" onclick="removeDeleteImageBox()">Hủy</button>
            <button type="button" class="btn btn-outline-danger" onclick="deleteImageBox(${imageId})">Tiếp tục xóa ảnh</button>
        </div>`;
        container.style.display = 'block';
    }

    function removeDeleteImageBox() {
        const container = document.getElementById('delete_image_box');
        if (container) {
            while (container.firstChild) {
                container.removeChild(container.firstChild);
            }
        }
        container.style.display = 'none';
    }

    function deleteImageBox(imageId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/image-ajax-handle",
            data: {
                action: "deleteImage",
                imageId: imageId
            },
            success: function (response) {
                const imageDiv = document.getElementById('image_' + response);
                if (imageDiv) {
                    imageDiv.remove();
                }
                removeDeleteImageBox();
            },
            error: function () {
                alert("lỗi")
            }
        })
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


    function switchProductIsSale(productId, button) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/product-ajax-handle",
            data: {
                action: "switchProductIsSale",
                productId: productId
            },
            success: function (response) {
                // Kiểm tra trạng thái hiện tại của sản phẩm và cập nhật nút
                if (response.isSale === 1) {
                    button.title = "Nhấp vào để: Ngừng kinh doanh sản phẩm này";
                    button.innerHTML = '<i class="fa-solid fa-check fs-4"></i>';
                } else {
                    button.title = "Nhấp vào để: Tiếp tục kinh doanh sản phẩm này";
                    button.innerHTML = '<i class="fa-solid fa-xmark fs-4" style="color: red"></i>';
                }
            },
            error: function () {
                alert("Lỗi khi cập nhật trạng thái sản phẩm");
            }
        });
    }

</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>