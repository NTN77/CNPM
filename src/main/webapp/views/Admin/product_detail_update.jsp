<%@ page import="model.adapter.InventoryProduct" %>
<%@ page import="model.bean.Image" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.bean.Discount" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="java.util.List" %>
<%@ page import="model.service.DiscountService" %><%--
  Created by IntelliJ IDEA.
  User: trung
  Date: 2024-07-08
  Time: 12:32 SA
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /**
     * FORMAT GIÁ TIỀN THEO ĐƠN VỊ CỦA VIỆT NAM.
     */
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);

    List<Category> categories = CategoryService.getInstance().getALl();

%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
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
<body>
    <%InventoryProduct ipd = (InventoryProduct) request.getAttribute("product_detail");
%>
<div class="detail-info w-80 mx-2 my-2">
    <form id="productForm" action="<%=request.getContextPath()%>/admin/inventory"  method="post" enctype="multipart/form-data"

          accept-charset="UTF-8"
          onsubmit="return false;">
        <div id="edit_product" class="w-100 p-3 rounded "
             style="display: block">
            <h3 class="text-center fw-bold p-3">Thông tin chi tiết sản phẩm #<%=ipd.getId()%>
            </h3>

<%--            <div class="err">--%>
<%--                <p id="errPass" class="text-center" style="color: red">Code đang lỗi--%>
<%--                </p>--%>
<%--            </div>--%>
            <div class="row mt-4">
                <div class="col-md-6 mb-2">
                    <h4 class="text-center">Thông tin chung</h4>
                    <hr>
                    <div class="image-area m-2">
                        <div class="d-flex justify-content-start pt-2">
                            <%for (Image image : ImageService.getImagesForProduct(ipd.getId() + "")) {%>
                            <div class="mx-3" id="image_<%=image.getId()%>">
                                <%--                                haha--%>
                                <div class="text-danger fw-bold text-end" style="cursor: pointer"
                                     onclick="showDeleteImageBox(<%=image.getId()%>)">Xóa
                                </div>
                                <img class="border-2" width="80px" , height="80px"
                                     src="<%=request.getContextPath()%>/<%=image.getPath()%>">
                            </div>
                            <%}%>
                        </div>
                        <div class="col-12 p-2">
                            <label for="uploadImage">Chọn File Ảnh ít hơn 5MB</label>
                            <input id="uploadImage" type="file" name="images" placeholder="Chọn File Ảnh ít hơn 5MB"
                                   multiple onchange="displayFileNames(this)" accept="image/*">
                            <div id="fileNamesContainer"></div>
                        </div>
                    </div>
                    <div class="form-floating w-100 my-2 p-2 ">
                        <input type="text" class="form-control" name="last_edit_product_id"
                               value="<%=ipd.getId()%>" style="display: none">
                        <input type="text" class="form-control" id="productName" name="productName"
                               value="<%=ipd.getName()%>" oninput="validateCharacter()" >
                        <label for="productName">Tên sản phẩm</label>
                        <span id="productNameError" style="color: #FF5733; font-size: 11px; font-weight: bold"></span>

                    </div>
                    <div class="w-100 my-2 p-2 quantity_statistic">
                        <div class="quantity-label d-flex flex-row">

                            <span> Số lượng : <strong><%=ipd.getSoldOut() + ipd.getQuantityRemaining()%></strong> </span>
                            <div class="vertical-line"></div>
                            <span>  Đã bán : <strong><%=ipd.getSoldOut()%></strong>  </span>
                            <div class="vertical-line"></div>
                            <span>  Còn lại: <strong><%=ipd.getQuantityRemaining()%></strong> </span>
                        </div>


                        <div class="progress mt-2" role="progressbar" aria-label="Success example" aria-valuenow="25"
                             aria-valuemin="0" aria-valuemax="100">
                            <%double ratioValue = (ipd.getSoldOut() *100) / (ipd.getSoldOut() + ipd.getQuantityRemaining());%>
                            <div class="progress-bar bg-success" style="width: <%=ratioValue%>%"><%=ratioValue%>%</div>
                        </div>
                    </div>
                    <div class="quantity_statistic d-flex flex-row">
                        <div class="form-floating my-2 p-2 col-6">
                            <span>Giá nhập hiện tại: </span> <strong><%=numberFormat.format(ipd.getCostPrice())%></strong> <br/>
                            <span>Lần nhập gần nhất: </span> <strong><%=ipd.getLastModified()%></strong><br/>
                            <span>Lợi nhuận hiện tại: </span> <strong id="profit"><%=numberFormat.format(ipd.getSellingPrice() - ipd.getCostPrice())%></strong><br/>
                            <span>Giá bán thực tế: </span> <strong id="realPrice"><%=numberFormat.format(ipd.getSellingPrice() - ipd.getCostPrice())%></strong><br/>


                        </div>
                        <div class="form-floating my-2 p-2 col-6">
                            <input type="number" class="form-control" id="sellingPrice" name="sellingPrice"
                                   value="<%=ipd.getSellingPrice()%>"
                                   style = "width: 115%"

                                   oninput="validatePrice()" required


                            >
                            <label for="sellingPrice">Giá bán (Không gồm khuyến mãi)</label>
                            <span id="sellingError" style="color: #FF5733; font-size: 11px; font-weight: bold"></span>
                        </div>
                    </div>
                </div>
                <%--        Choice category and create new category--%>
                <div class="col-md-6 mb-5">
                    <div >
                        <h4 class="text-center">Phân loại sản phẩm</h4>
                        <hr>
                        <div class="form-floating  mx-5 my-2 p-2">
                            <select class="form-select" id="isSale" aria-label="Tình trạng bán hàng" name="isSale">
                                <option value="0" <%= ipd.getIsSale() == 0 ? "selected" : "" %>>Ngừng kinh doanh</option>
                                <option value="2" <%= ipd.getIsSale() == 2 ? "selected" : "" %>>Tạm hết hàng</option>
                                <option value="1" <%= ipd.getIsSale() == 1 ? "selected" : "" %>>Có sẵn</option>
                                <option value="3" <%= ipd.getIsSale() == 3 ? "selected" : "" %>>Đặt trước</option>
                            </select>
                            <input type="hidden" id="selectedIsSale" name="selectedIsSale" value="<%= ipd.getIsSale() %>">
                            <label for="isSale">Trạng thái sản phẩm</label>
                        </div>


                        <div class="m-0 border alert alert-dismissible d-flex align-items-center  mx-5 my-2">
                            <div class="me-4 ms-3">
                                <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                       name="choiceCategory" id="case1"
                                    <%if (ipd.getCategoryId()>0){%>
                                       checked
                                    <%}%>
                                       value="choiceAvailableCategory"
                                       onclick="showAvailableCategory()">
                                <label class="form-check-label" style="cursor: pointer" for="case1">
                                    Danh mục có sẵn
                                </label>
                            </div>
                            <div>

                                <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                       name="choiceCategory"
                                       id="case2"
                                    <%if (ipd.getCategoryId()<=0){%>
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
                                <%if (ipd.getCategoryId() > 0) {%>
                             style="display: block"
                                <%} else {%>
                             style="display: none"
                                <%}%>
                             id="showAvailableCategory">
                            <select class="form-select" id="availableCategory" name="availableCategory"
                                    aria-label="Chọn danh mục liên quan">
                                <%for (Category category : categories) {%>
                                <option value="<%=category.getId()%>"
                                        <% if (ipd.getCategoryId() == category.getId()) {%>
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
                                <%if (ipd.getCategoryId() > 0) {%>
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
                                        <%if (ipd.getDiscountId() == d.getId()) {%>
                                        selected
                                        <%}%>
                                >
                                    <%=d.getName()%> - giảm <%=d.getPercentageOff() * 100%>%
                                </option>
                                <%}%>
                            </select>
                            <label for="discountId">Chọn giảm giá áp dụng</label>
                        </div>
<%--                        <div class="mx-5 border">--%>
<%--                            <h4 class="p-2 text-center">Tổng doanh thu hiện tại <br/>80.000 đ</h4>--%>
<%--                        </div>--%>
                        <div id="delete_image_box" style="background: black"></div>
                    </div>
                </div>
            </div>
            <div class="row me-4 mx-2 rounded-3">
                <label for="description" class="form-label text-center">Mô tả sản phẩm :</label>
                <textarea class="form-control mx-auto w-70"
                          style="height: 200px; white-space: nowrap; overflow: auto; resize: none;"
                          id="description" name="description"
                          rows="3"
                          oninput="validateCharacter()"
                ><%=ipd.getDescription()%></textarea>
                <span id="descriptionError" style="color: #FF5733; font-size: 11px; font-weight: bold"></span>
            </div>
            <div class="d-flex justify-content-end m-0">
                <button type="button" onclick="hideEditProduct()" class="btn btn-outline-warning m-3 fs-5 fw-bold"
                        style="color: #000000">Thoát
                </button>
                <button id="updateButton" type="submit" onclick="submitForm()"
                        class="btn btn-outline-success m-3 fs-5 fw-bold"
                        style="color: #000000"
                        title="Hoàn tất nếu bạn chắc chắn đã điền đầy đủ thông tin">Hoàn tất chỉnh sửa
                </button>
            </div>

        </div>
    </form>
</div>
<script>

    $(document).ready(function() {
        $('#isSale').change(function() {
            var selectedValue = $(this).val();
            $('#selectedIsSale').val(selectedValue);
            console.log(selectedValue)
        });
    });


    function submitForm() {
        var formData = new FormData($('#productForm')[0]);

        $.ajax({
            url: '<%=request.getContextPath()%>/admin/inventory',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                // Handle success logic here
                if (response.status === "error") {
                    Swal.fire({
                        position: "center",
                        icon: "error",
                        title: "Vui lòng nhập đúng định dạng yêu cầu!",
                        showConfirmButton: true,
                    });


                } else {
                    Swal.fire({
                    position: "center",
                    icon: "success",
                    title: "Chỉnh sửa sản phẩm thành công!",
                    showConfirmButton: true
                }).then((result) => {
                        if (result.isConfirmed) {
                            // Chuyển hướng đến trang khác khi người dùng nhấn "OK"
                            window.location.href = '<%=request.getContextPath()%>/views/Admin/inventory_management.jsp';
                        }
                    });;
            }},
            error: function() {
                // Handle error logic here
                Swal.fire({
                    position: "center",
                    icon: "error",
                    title: "Vui lòng nhập đúng định dạng yêu cầu!",
                    showConfirmButton: true,
                });
            }
        });






    }
//     Xử lý input tiền :
    function validatePrice() {
        var sellingPrice = document.getElementById("sellingPrice").value.trim();
        var errorMessageElement = document.getElementById("sellingError");
        var updateButton = document.getElementById("updateButton");

        if (sellingPrice < <%=ipd.getCostPrice()%>) {
            console.log(sellingPrice + "gia tri");
            errorMessageElement.innerHTML = "Tiền bán không được phép nhỏ hơn tiền nhập!";
            updateButton.disabled = false; // Vô hiệu hóa nút "Đăng ký"
        } else {
            errorMessageElement.innerHTML = "";
            updateButton.disabled = true; // Cho phép nút "Đăng ký" được click
        }
    }
// Xử lý 2 trường ten & description

    function validateCharacter() {
        var name = document.getElementById("productName").value.trim();
        var description = document.getElementById("description").value.trim();
        var productNameError = document.getElementById("productNameError");
        var descriptionError = document.getElementById("descriptionError");
        var updateButton = document.getElementById("updateButton");

        if(name === ""|| description===""|| newcategory==="") {
            productNameError.innerHTML = name === "" ? "Không được bỏ trống trường này" : "";
            descriptionError.innerHTML = description === "" ? "Không được bỏ trống trường này" : "";
            updateButton.disabled = false;
        }
        else {
            productNameError.innerHTML = "";
            descriptionError.innerHTML = "";
            updateButton.disabled = true;
        }

    }
    function showDeleteImageBox(imageId) {
        const container = document.getElementById('delete_image_box');
        container.innerHTML = `
        <div style = "background: black">
            <h4 class="text-danger">Bạn sẽ không thể hoàn tác thao tác này!</h1>
            <button type="button" class="btn btn-outline-info" onclick="removeDeleteImageBox()">Hủy</button>
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
</script>
</body>
</html>
