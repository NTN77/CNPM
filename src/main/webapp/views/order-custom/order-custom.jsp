<%@ page import="model.bean.*" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 5/27/2025
  Time: 4:54 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<% Product product = (Product) request.getAttribute("productById");%>
<% Image mainImage = (Image) request.getAttribute("mainImage");%>
<% Category categoryByProduct = (Category) request.getAttribute("categoryByProduct");%>

<%
    User sessionUser = (User) request.getSession().getAttribute("auth");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Custom</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<style>
    .product-details {
        display: flex;
        justify-content: space-evenly;
        align-items: center;
        min-height: 400px;
    }

    .mainImage {
        max-width: 80%;
        max-height: 80%;
        object-fit: cover;
        cursor: zoom-in;
    }

    .navbar1 {
        padding: 24px;
    }

    .form-details {
        min-width: 500px;
    }

    .form-group {
        padding-bottom: 10px;
    }

    .form-group label {
        margin-bottom: 8px;
    }

    .form-group input#content {
        height: 200px;
    }

    .image_desc {
        font-size: 24px;
        font-weight: bold;
        padding-left: 32%;
        margin-top: 16px;
        margin-bottom: 32px;
    }

    .contact {
        margin-bottom: 32px;
    }

    .zalo-contact {
        padding: 16px;
        background-color: #0c63e4;
        color: #fff;
        cursor: pointer;
        width: 160px;
        margin-left: 16px;
        border-radius: 8px;
        font-size: 16px;
    }

    .zalo-contact:hover {
        background-color: #0d6efd;
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 9999;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.6); /* nền mờ */
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
    }

    .qr-code {
        width: 300px;
        height: auto;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        background: white;
        padding: 16px;
    }

    .btn-qr {
        margin-top: 16px;
        padding: 8px 16px;
        border: none;
        background-color: #dc3545;
        color: white;
        cursor: pointer;
        border-radius: 8px;
    }

    .btn-qr:hover {
        background-color: #c82333;
    }
</style>
<body>
<%--Thanh điều hướng - header--%>
<%@include file="/views/MenuBar/menu.jsp" %>

<nav class="navbar1" aria-label="breadcrumb ">
    <div>
        <i class="fa-solid fa-backward p-2 fs-5" onclick="window.history.back()" style="cursor: pointer"></i>
    </div>
    <ol class="breadcrumb m-0 ">
        <li class="breadcrumb-item"><a
                href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp">Trang Chủ</a></li>
        <li class="breadcrumb-item"><a
                href="productsPage?categoryFilter=<%=categoryByProduct.getId()%>"><%=categoryByProduct.getName()%>
        </a></li>
        <li class="breadcrumb-item active" aria-current="page" style="color: #e32124"><%=product.getName()%>
        </li>
    </ol>
</nav>

<section class="product-details">

    <div class="image_container">
        <img class="mainImage" src="<%=mainImage.getPath()%>">
        <p class="image_desc">Ảnh mẫu</p>
    </div>

    <div class="form-details">
        <div class="form-title">
            <h2>
                Thông tin thêm
            </h2>
        </div>
        <form class="form-detail" action="<%=request.getContextPath()%>/order-custom" method="post" enctype="multipart/form-data">

        <input type="hidden" name="productId" value="<%=product.getId()%>">
            <div class="form-group">
                <%
                    if (product.getCategoryId() == 1) {

                %>
                <label for="imagePath">Hình ảnh</label>
                <input name="path" type="file" class="form-control" id="imagePath">
                <%
                } else if (product.getCategoryId() == 2) {
                %>
                <label for="imagePath">Hình ảnh</label>
                <input name="path" type="file" multiple class="form-control" id="imagePath">
                <% } %>
            </div>

            <div class="form-group">
                <label for="packageType">Hình thức đóng gói</label>
                <select name="packageType" id="packageType" class="form-select">
                    <option value="">-- Chọn hình thức --</option>
                    <option value="normal">Đóng gói thường</option>
                    <option value="gift_box">Hộp quà sang trọng</option>
                    <option value="eco_wrap">Đóng gói thân thiện môi trường</option>
                </select>
            </div>

            <div class="form-group">
                <label for="color">Chọn màu sắc mong muốn (nếu có)</label>
                <select name="color" id="color" class="form-select">
                    <option value="">-- Chọn màu --</option>
                    <option value="red">Đỏ</option>
                    <option value="blue">Xanh</option>
                    <option value="black">Đen</option>
                    <option value="custom">Khác (ghi chú bên dưới)</option>
                </select>
            </div>

            <div class="form-group">
                <label for="deliveryDate">Ngày giao hàng mong muốn</label>
                <input name="deliveryDate" type="date" class="form-control" id="deliveryDate">
            </div>

            <div class="form-group">
                <label>Địa chỉ</label>
                <div class="form-floating mb-3">
                    <select id="provinceDropdown" class="form-select"
                            aria-label="Chọn tỉnh thành" required name="province">
                        <option value="">Chọn tỉnh thành</option>
                    </select>
                    <label for="provinceDropdown">Tỉnh thành</label>
                </div>

                <div class="form-floating mb-3">
                    <select id="districtDropdown" class="form-select"
                            aria-label="Chọn huyện" required name="district">
                        <option value="">Chọn quận, huyện</option>
                    </select>
                    <label for="districtDropdown">Quận, Huyện</label>
                </div>

                <div class="form-floating mb-3">
                    <select id="wardDropdown" class="form-select"
                            aria-label="Chọn xã, thị trấn" required name="ward">
                        <option value="">Chọn xã, thị trấn</option>
                    </select>
                    <label for="wardDropdown">Xã, Thị Trấn</label>
                </div>
                <div class="form-floating mb-3">
                    <input id="address" name="address" type="text" class="form-control"
                           placeholder="Địa chỉ" value="" required>
                    <label for="address" class="floatingInput">Số Nhà, Tên Đường,...</label>
                </div>
            </div>


            <div class="form-group">
                <label for="note">Ghi chú</label>
                <textarea name="note" type="text" class="form-control" id="note" placeholder="Yêu cầu thêm: lời nhắn dành cho người nhận, lời chúc,..." rows="8"></textarea>
            </div>
            <div class="form-group">
                <label for="tel">Số điện thoại</label>
                <input name="tel" type="text" class="form-control" id="tel" placeholder="Số điện thoại" required>
            </div>
            <button type="submit" class="btn btn-primary">Đặt hàng</button>
        </form>
    </div>
</section>

<section class="contact" style="display:flex; align-items: center">
    <p style="font-size: 16px; font-weight: 600; padding-left: 12px">Nếu có nhu cầu thêm về sản phẩm vui lòng: </p>
    <div class="zalo-contact">
        Liên hệ qua Zalo
    </div>
</section>

<div class="modal">
    <img class="qr-code" src="<%=request.getContextPath()%>/images/qr-code.png" alt="">
    <button class="btn-qr">
        Đóng
    </button>
</div>

<!--    Footer-->
<%@include file="/views/Footer/footer.jsp" %>

</body>
<script>
    const btnZalo = document.querySelector(".zalo-contact");
    const btnClose = document.querySelector(".btn-qr");
    const modal = document.querySelector(".modal");

    btnZalo.addEventListener("click", showQR);
    btnClose.addEventListener("click", hideQR);

    function showQR(){
        modal.style.display = "flex";
    }

    function hideQR(){
        modal.style.display = "none";
    }


    const citySelect =  document.querySelector("#provinceDropdown")
    const districtSelect = document.querySelector("#districtDropdown")
    const wardSelect = document.querySelector("#wardDropdown")

    const  valuesOfGoodsInput = document.querySelector('#valueOfGoods')
    const ship = document.getElementById("shippingFeeInput")
    const shipResults = document.getElementById("shippingFeeResult")

    const totalAmount = document.getElementById("totalAmountInput")
    const totalAmountResults = document.getElementById("totalAmount")
    fetch("https://open.oapi.vn/location/provinces?page=0&size=100")
        .then(res => res.json())
        .then(data => {
            data.data.forEach(province => {
                const option = document.createElement("option");
                option.value = province.name;
                option.text = province.name;
                option.setAttribute("data-province-id", province.id); // Lưu id thay vì provinceId
                citySelect.appendChild(option);
            });
        });
    citySelect.addEventListener("change", () => {
        const selectedOption = citySelect.options[citySelect.selectedIndex];
        const provinceId = selectedOption.getAttribute("data-province-id");
        districtSelect.innerHTML = "<option value=''>Chọn Huyện / Quận</option>";
        wardSelect.innerHTML = "<option value=''>Chọn Xã / Phường</option>";

        fetch(`https://open.oapi.vn/location/districts/${provinceId}?page=0&size=100`)
            .then(res => res.json())
            .then(data => {
                data.data.forEach(district => {
                    const option = document.createElement("option");
                    option.value = district.name;
                    option.text = district.name;
                    option.setAttribute("data-district-id", district.id); // Lưu id thay vì districtId
                    districtSelect.appendChild(option);
                });
            });
    });
    districtSelect.addEventListener("change", () => {
        const selectedOption = districtSelect.options[districtSelect.selectedIndex];
        const districtId = selectedOption.getAttribute("data-district-id"); // Lấy id từ data attribute

        const selectedProvinceOption = citySelect.options[citySelect.selectedIndex];
        const selectedDistrictOption = districtSelect.options[districtSelect.selectedIndex];

        const provinceName = selectedProvinceOption.text
        const districtName = selectedDistrictOption.text
        wardSelect.innerHTML = "<option value=''>Chọn Xã / Phường</option>";

        fetch(`https://open.oapi.vn/location/wards/${districtId}?page=0&size=100`)
            .then(res => res.json())
            .then(data => {
                data.data.forEach(ward => {
                    const option = document.createElement("option");
                    option.value = ward.name;
                    option.text = ward.name;
                    option.setAttribute("data-ward-id", ward.id); // Lưu id thay vì wardId
                    wardSelect.appendChild(option);
                });
                calculateFeeShip(provinceName, districtName);
            });
    });

</script>
</html>
