<%@ page import="java.util.List" %>
<%@ page import="model.bean.Discount" %>
<%@ page import="model.service.DiscountService" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.adapter.InventoryProduct" %>
<%@ page import="model.service.InventoryService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%List<Discount> discounts = DiscountService.getInstance().getAll();%>

<%String discountAction = (String) request.getAttribute("discountAction");%>
<%
    String editDiscountId = (String) request.getAttribute("editDiscountId");
    Discount editDiscount = (editDiscountId != null) ? DiscountService.getInstance().getDiscountById(editDiscountId) : null;//null ->ko bắt ex thì nó che lỗi .getName() :)))
%>
<%String editStt = (String) request.getAttribute("editStt");%>
<%
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>

<%List<InventoryProduct> products = InventoryService.getInstance().showDiscountView();%>
<%List<Category> categories = CategoryService.getInstance().getALl();%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý khuyến mãi</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Admin/css/table_style.css">
    <!--https://datatables.net/download/-->
    <%--    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">--%>
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <link
            href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.3.2/mdb.min.css"
            rel="stylesheet"
    />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <!--https://releases.jquery.com/-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"
            integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct"
            crossorigin="anonymous"></script>
    <style>
        #add_discount, #edit_discount, #choice_products_discount {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -60%);
            overflow: auto;
            display: none;
            z-index: 9;
            background-color: #2c3e50; /* Adjust the background color as needed */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Optional: Add a box shadow for a subtle effect */
        }

        .dt-empty, .dt-info {
            display: none;
        }

        #data_wrapper {
            width: 100%;
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<form action="<%=request.getContextPath()%>/admin/discount" method="post">
    <input type="hidden" id="current_discountId">
    <div class="container">
        <div class="row">
            <div class="col-11">
                <div class="err">
                    <% String re = request.getAttribute("result") == null ? "" : request.getAttribute("result").toString(); %>
                    <p style="color: red"><%=re%>
                    </p>
                </div>
            </div>
            <div class="col-1">
                <button type="button" onclick="showAddDiscount()"><i class="fa-regular fa-square-plus"
                                                                     style="font-size: 50px; color: #0dcaf0"></i>
                </button>
            </div>
        </div>
        <div class="row mb-5 mt-2">
            <div class="col-md-12">
                <div class="card px-3 py-1" style="background: #c5ffff">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-1 d-flex justify-content-center">
                                <strong>STT</strong>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <strong>Tên khuyến mãi</strong>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <strong>Ngày bắt đầu</strong>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center ">
                                <strong>Ngày kết thúc</strong>
                            </div>
                            <div class="col-md-1 d-flex justify-content-center">
                                <strong>Tỉ lệ giảm giá(%)</strong>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <strong>Danh sách sản phẩm đang áp dụng</strong>
                            </div>
                            <div class="col-md-2 d-flex justify-content-center">
                                <strong>Thao tác</strong>
                            </div>
                        </div>
                        <%int stt = 0;%>
                        <%for (Discount d : discounts) {%>
                        <%stt++;%>
                        <div class="row border rounded">
                            <div class="col-1 text-center"><%=stt%>
                            </div>
                            <div class="col-md-2 text-center"><%=d.getName()%>
                            </div>
                            <div class="col-md-2 text-center"><%=d.getStartDate()%>
                            </div>
                            <div class="col-md-2 text-center"><%=d.getEndDate()%>
                            </div>
                            <div class="col-md-1 text-center"><%=d.getPercentageOff() * 100%>
                            </div>
                            <div class="col-md-1 text-center align-items-center ms-4 mt-2">
                                <button type="button" onclick="showChoiceForDiscount(<%=d.getId()%>)">
                                    <i class="fa-solid fa-list-check"></i>
                                </button>
                            </div>
                            <div class="col-md-2 text-center d-flex justify-content-center text-center mt-2 ms-5">
                                <a
                                        href="<%=request.getContextPath()%>/admin/discount?discountAction=edit&editDiscountId=<%=d.getId()%>&editStt=<%=stt%>"
                                        class="mx-4">
                                    <i class="fa-solid fa-pen fs-4" style="color: #5c7093;"></i>
                                </a>
                                <a
                                        href="<%=request.getContextPath()%>/admin/discount?deleteDiscountId=<%=d.getId()%>"
                                        class="mx-4">
                                    <i class="fa-solid fa-trash-can fs-4" style="color: #5c7093;"></i>
                                </a>
                            </div>
                        </div>
                        <%}%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--    Add Box--%>
    <div class="row d-flex justify-content-center">
        <div id="add_discount" class="w-50 bg-dark p-3 rounded">
            <div class="text-center fw-bold p-3 text-info" style="font-size: 30px">Thêm khuyến mãi giảm giá</div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold text-danger">Tên khuyến mãi</span>
                </div>
                <input name="discount_name" type="text" class="form-control" placeholder="Sinh nhật HandmadeStore">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold text-danger">Giảm giá(%)</span>
                </div>
                <input name="percentageOff" type="number" class="form-control w-25 percentageOff" placeholder="15" min="0" max="100">
            </div>
            <div class="input-group">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold text-danger">Ngày bắt bắt đầu và ngày kết thúc</span>
                </div>
                <input name="startDate" type="date" class="form-control">
                <input name="endDate" type="date" class="form-control">
            </div>
            <div class="error-message" style="color: red;"></div>
            <div class="d-flex justify-content-end m-0">
                <button type="button" onclick="hideAddDiscount()" class="btn btn-outline-warning m-3 fs-5 fw-bold text-warning"
                        style="color: #eeeeee">Hủy bỏ
                </button>
                <button type="submit" name="submit_2_adddiscount" value="adddiscount"
                        class="btn btn-outline-success m-3 fs-5 fw-bold text-success"
                        style="color: #eeeeee">Hoàn tất
                </button>
            </div>
        </div>
    </div>
    <%--    Edit Box--%>
    <div class="row d-flex justify-content-center ">
        <div id="edit_discount" class="w-50 bg-dark p-3 rounded overlay"
                <%if (discountAction != null && discountAction.equals("edit")) {%>
             style="display: block"
                <%} else {%>
             style="display: none"
                <%}%>>
            <%if (editDiscount != null) {%>
            <div class="text-center fw-bold p-3" style="font-size: 30px; color: #0dcaf0">
                Chỉnh sửa khuyến mãi giảm giá
            </div>
            <div class="fw-bold p-3" style="color: #0dcaf0">
                <p>STT: <%=editStt%>
                </p>
                <p>Tên khuyến mãi: <%=editDiscount.getName()%>
                </p>
            </div>
            <div class="input-group mb-3" >
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold text-danger">Tên khuyến mãi</span>
                </div>
                <input type="text" name="editDiscountId" value="<%=editDiscountId%>" style="display:none;">
                <input name="edit_discount_name" type="text" class="form-control" value="<%=editDiscount.getName()%>">
            </div>
            <div class="input-group mb-3">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold text-danger">Giảm giá(%)</span>
                </div>
                <input name="edit_percentageOff" type="number" class="form-control w-25 percentageOff" min="0" max="100"
                       value="<%=editDiscount.getPercentageOff()*100%>">
            </div>
            <div class="input-group">
                <div class="input-group-prepend me-3">
                    <span class="input-group-text fw-bold text-danger">Ngày bắt bắt đầu và ngày kết thúc</span>
                </div>
                <%
                    // Định dạng ngày theo "yyyy-MM-dd"
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                %>
                <input name="edit_startDate" type="date" class="form-control"
                       value=<%=dateFormat.format(editDiscount.getStartDate())%>>
                <input name="edit_endDate" type="date" class="form-control"
                       value=<%=dateFormat.format(editDiscount.getEndDate())%>>
            </div>
            <div class="error-message" style="color: red;"></div>
            <div class="d-flex justify-content-end m-0">
                <button type="button" onclick="hideEditDiscount()" class="btn btn-outline-warning m-3 fs-5 fw-bold text-warning"
                        style="color: #eeeeee">Hủy bỏ
                </button>
                <button type="submit" name="submit_3_editdiscount" value="editdiscount"
                        class="btn btn-outline-success m-3 fs-5 fw-bold text-success"
                        style="color: #eeeeee">Hoàn tất
                </button>
            </div>
            <%}%>
        </div>
    </div>
    <%-- choice box    --%>
    <div class="row justify-content-center">
        <div id="choice_products_discount" class="w-100 h-100 bg-secondary p-3 rounded" style="margin-top: 60px">
            <div>
                <div class="container-fluid">
                    <button class="w-100 btn btn-success" onclick="hideChoiceForDiscount()">Thoát</button>
                    <%--chọn theo danh mục--%>
                    <div class="m-4 fs-6 d-flex align-items-center">
                        <div class="dropdown">
                            <button data-mdb-button-init data-mdb-ripple-init data-mdb-dropdown-init
                                    class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton"
                                    data-mdb-toggle="dropdown" aria-expanded="false">
                                Áp dụng theo danh mục
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                <li>
                                    <div class="dropdown-item" href="#">
                                        <%for (Category c : categories) {%>
                                        <div class="form-check form-switch">
                                            <input class="form-check-input category" type="checkbox"
                                                   onchange="changeSelectByCategory(this,<%=c.getId()%>)"
                                                   id="c_<%=c.getId()%>">
                                            <label class="form-check-label" for="c_<%=c.getId()%>"><%=c.getName()%>
                                            </label>
                                        </div>
                                        <%}%>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="mx-3">
                            <button class="btn btn-primary" type="button" onclick="selectAllProductForDiscount()">
                                Áp dụng cho tất cả
                            </button>
                        </div>
                        <div>
                            <button class="btn btn-primary" type="button" onclick="deSelectAllProductForDiscount()">
                                Bỏ áp dụng cho tất cả
                            </button>
                        </div>
                    </div>
<%--                    <div class="m-4 fs-6 d-flex align-items-center">--%>
<%--                        <div class="d-flex">--%>
<%--                            <div class="form-group">--%>
<%--                                <input type="number" class="form-control" id="number"--%>
<%--                                       placeholder="Nhập số lượng có sẵn">--%>
<%--                                <div class="text-danger" id="numberValid"></div>--%>
<%--                            </div>--%>
<%--                            <div class="mx-2">--%>
<%--                                <div class="form-check">--%>
<%--                                    <input class="form-check-input" type="radio" name="comparison"--%>
<%--                                           id="flexRadioDefault1" value="1" checked>--%>
<%--                                    <label class="form-check-label" for="flexRadioDefault1">--%>
<%--                                        Dựa vào số lượng lớn hơn--%>
<%--                                    </label>--%>
<%--                                </div>--%>
<%--                                <div class="form-check">--%>
<%--                                    <input class="form-check-input" type="radio" name="comparison"--%>
<%--                                           id="flexRadioDefault3" value="0">--%>
<%--                                    <label class="form-check-label" for="flexRadioDefault3">--%>
<%--                                        Dựa vào số lượng tương ứng--%>
<%--                                    </label>--%>
<%--                                </div>--%>
<%--                                <div class="form-check">--%>
<%--                                    <input class="form-check-input" type="radio" name="comparison"--%>
<%--                                           id="flexRadioDefault2" value="-1">--%>
<%--                                    <label class="form-check-label" for="flexRadioDefault2">--%>
<%--                                        Dựa vào số lượng ít hơn--%>
<%--                                    </label>--%>
<%--                                </div>--%>
<%--                            </div>--%>

<%--                            <div>--%>
<%--                                <button class="btn btn-primary" type="button" onclick="selectByQuantity()">--%>
<%--                                    Áp dụng--%>
<%--                                </button>--%>
<%--                                <button class="btn btn-primary" type="button" onclick="unSelectByQuantity()">--%>
<%--                                    Hủy bỏ áp dụng--%>
<%--                                </button>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
                    <%--search--%>
                    <div class="row m-4 fs-6 d-flex align-items-center">
                        <div class="col">
                            <input type="text" class="form-control" placeholder="Nhập mã sản phẩm"
                                   name="searchById"
                                   id="searchById"/>
                        </div>
                    </div>
                    <%--table--%>
                    <div class="d-flex">
                        <table id="data" class="table table-striped table-hover" style="width: 100%;">
                            <thead>
                            <tr class="text-center sticky-top">
                                <th class="text-center" scope="col"
                                    style=" position: sticky;left: 0;z-index: 1;"
                                >Mã
                                </th>
                                <th style="width: 30%">Tên sản phẩm</th>
                                <th class="text-center" scope="col">Có sẵn</th>
                                <th class="text-center" scope="col">Đã bán</th>
                                <th class="text-center" scope="col">Giá nhập</th>
                                <th class="text-center" scope="col">Giá bán</th>
                                <th class="text-center" scope="col">Giảm giá</th>
                                <th class="text-center" scope="col">Giá sản phẩm</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%for (InventoryProduct p : products) {%>
                            <tr class="text-center">
                                <td class="d-flex align-items-center">
                                    <div class="me-2 form-check form-switch">
                                        <input class="form-check-input p_all p_<%=p.getCategoryId()%> pquantity_<%="Lỗi"%>"
                                               type="checkbox"
                                               id="p_<%=p.getId()%>"
                                               onclick="changeSelectByProduct(this, <%=p.getCategoryId()%>, <%=p.getId()%>)"
                                               onchange="reloadGUI(this,<%=p.getId()%>, <%=p.getSellingPrice()%>)"
                                            <%if(p.getDiscountId()!=0){%>
                                               checked
                                            <%}%>
                                        >
                                    </div>
                                    <a href="<%=request.getContextPath()%>/product-detail?id=<%=p.getId()%>"
                                       target="_blank"
                                       class="px-2 btn btn-primary">
                                        <%=p.getId()%>
                                    </a>
                                </td>
                                <td><%=p.getName()%>
                                </td>
                                <td><%=p.getQuantityRemaining()%>
                                </td>
                                <td><%=p.getSoldOut()%>
                                </td>
                                <td><%=p.getCostPrice()%>
                                </td>
                                <td><%=numberFormat.format(p.getSellingPrice())%>
                                </td>
                                <%!double finalSellingPrice;%>

                                <%

                                    Product productById = ProductService.getInstance().getProductById(p.getId());
                                    finalSellingPrice = ProductService.getInstance().productPriceIncludeDiscount(productById);%>
                                <td id="discount_for_<%=p.getId()%>">
                                    <%
                                        Discount d = DiscountService.getInstance().getDiscountById(p.getDiscountId() + "");%>
                                    <%if (finalSellingPrice == p.getSellingPrice()) {%>
                                    <del style="text-decoration-color: red;">
                                        <%=(d == null) ? "" : d.getName() + " - giảm " + (d.getPercentageOff() * 100) + "%"%>
                                    </del>
                                    <%} else {%>
                                    <%=(d == null) ? "" : d.getName() + " - giảm " + (d.getPercentageOff() * 100) + "%"%>
                                    <%}%>
                                </td>
                                <td id="newFinalSellingPrice_<%=p.getId()%>"><%=numberFormat.format(finalSellingPrice)%>
                            </tr>
                            <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<script>
    const searchById = document.querySelector('#searchById');
    let table;

    $(document).ready(function () {
        table = $('#data').DataTable({
            "paging": true,
            "searching": true,
            "lengthChange": false,
            "pageLength": 5,
            "info": false,
            language: {
                search: "Nhập từ khóa tìm kiếm"
            }
        });

        if (searchById) {
            searchById.addEventListener('input', function () {
                const searchValue = this.value;
                table.columns(0).search(searchValue).draw();
            });
        }
    });

    function reloadGUI(checkbox, productId, sellingPrice) {
        const current_discountId = document.getElementById("current_discountId").value;
        const discountTdE = $('#discount_for_' + productId);
        const newFinalSellingPriceTdE = $('#newFinalSellingPrice_' + productId);
        const isChecked = checkbox.checked;
        if (isChecked) {
            $.ajax({
                method: "POST",
                url: "/HandMadeStore/discount-ajax-handle",
                data: {
                    action: "reloadGUI",
                    productId: productId,
                    discountId: current_discountId
                },
                success: function (response) {
                    let discountHtml = `<div>`;
                    if (response.isAvailable == false) {
                        discountHtml += `<del style="text-decoration-color: red;">${response.asTextForShow}</del>`;
                    } else {
                        discountHtml += `${response.asTextForShow}`;
                    }
                    discountHtml += `</div>`;
                    discountTdE.html(discountHtml);
                    newFinalSellingPriceTdE.html(
                        `<div>
                        ${formattedPrice(response.finalPrice)}
                    </div>`
                    );
                },
                error: function () {
                    alert("Thay đổi không thành công!");
                }
            })
        } else {
            $.ajax({
                method: "POST",
                url: "/HandMadeStore/discount-ajax-handle",
                data: {
                    action: "unDiscountForProduct",
                    discountId: current_discountId,
                    productId: productId
                },
                success: function (response) {
                    discountTdE.html(`<div></div>`);
                    newFinalSellingPriceTdE.html(
                        `<div>
                        ` + formattedPrice(sellingPrice) + `
                    </div>`
                    );
                },
                error: function () {
                    alert("Thay đổi không thành công!");
                }
            })
        }
    }

    function ajaxSellectAll(discountId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/discount-ajax-handle",
            data: {
                action: "discountForAll",
                discountId: discountId
            },
            success: function (response) {
                const p_checkboxes = document.querySelectorAll('.p_all');
                for (let i = 0; i < p_checkboxes.length; i++) {
                    let id = p_checkboxes[i].id;
                    if (p_checkboxes[i].type == 'checkbox') {
                        p_checkboxes[i].checked = true;
                        p_checkboxes[i].onchange();
                    }
                }
                const categories = document.querySelectorAll('.category');
                for (let i = 0; i < categories.length; i++) {
                    let id = categories[i].id;
                    if (categories[i].type == 'checkbox')
                        categories[i].checked = true;
                }
            },
            error: function () {
                alert("Thay đổi không thành công!");
            }
        })
    }

    function ajaxUnSellectAll(discountId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/discount-ajax-handle",
            data: {
                action: "unDiscountForAll",
                discountId: discountId
            },
            success: function (response) {
                const p_checkboxes = document.querySelectorAll('.p_all');
                for (let i = 0; i < p_checkboxes.length; i++) {
                    let id = p_checkboxes[i].id;
                    if (p_checkboxes[i].type == 'checkbox') {
                        p_checkboxes[i].checked = false;
                        p_checkboxes[i].onchange();
                    }
                }
                const categories = document.querySelectorAll('.category');
                for (let i = 0; i < categories.length; i++) {
                    let id = categories[i].id;
                    if (categories[i].type == 'checkbox')
                        categories[i].checked = false;
                }
            },
            error: function () {
                alert("Thay đổi không thành công!");
            }
        })
    }

    function ajaxSelectByCategory(discountId, categoryId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/discount-ajax-handle",
            data: {
                action: "discountByCategory",
                discountId: discountId,
                categoryId: categoryId
            },
            success: function (response) {
                const p_checkboxes = document.querySelectorAll('.p_' + categoryId);
                for (let i = 0; i < p_checkboxes.length; i++) {
                    if (p_checkboxes[i].type == 'checkbox') {
                        p_checkboxes[i].checked = true;
                        p_checkboxes[i].onchange();
                    }
                }
            },
            error: function () {
                alert("Thay đổi không thành công!");
            }
        })
    }

    function ajaxUnSelectByCategory(discountId, categoryId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/discount-ajax-handle",
            data: {
                action: "unDiscountByCategory",
                discountId: discountId,
                categoryId: categoryId
            },
            success: function (response) {
                const p_checkboxes = document.querySelectorAll('.p_' + categoryId);
                for (let i = 0; i < p_checkboxes.length; i++) {
                    if (p_checkboxes[i].type == 'checkbox') {
                        p_checkboxes[i].checked = false;
                        p_checkboxes[i].onchange();
                    }
                }
            },
            error: function () {
                alert("Thay đổi không thành công!");
            }
        })
    }

    function ajaxSelectByProduct(checkbox, discountId, productId, categoryId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/discount-ajax-handle",
            data: {
                action: "discountForProduct",
                discountId: discountId,
                productId: productId
            },
            success: function (response) {

            },
            error: function () {
                alert("Thay đổi không thành công!");
            }
        })
    }

    function ajaxUnSelectByProduct(checkbox, discountId, productId, categoryId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/discount-ajax-handle",
            data: {
                action: "unDiscountForProduct",
                discountId: discountId,
                productId: productId
            },
            success: function (response) {
                const categories_checkboxes = document.querySelectorAll('.category');
                for (let i = 0; i < categories_checkboxes.length; i++) {
                    let id = categories_checkboxes[i].id;
                    if (categories_checkboxes[i].type == 'checkbox' && id == ('c_' + categoryId))
                        categories_checkboxes[i].checked = false;
                }
            },
            error: function () {
                alert("Thay đổi không thành công!");
            }
        })
    }


    function showAddDiscount() {
        hideEditDiscount();
        document.getElementById("add_discount").style.display = "block";
    }

    function hideAddDiscount() {
        document.getElementById("add_discount").style.display = "none";
    }

    function hideEditDiscount() {
        document.getElementById("edit_discount").style.display = "none";
    }

    function showChoiceForDiscount(discountId) {
        document.getElementById("current_discountId").value = discountId;
        document.getElementById("choice_products_discount").style.display = "block";
    }

    function hideChoiceForDiscount() {
        document.getElementById("choice_products_discount").style.display = "none";
    }

    function selectAllProductForDiscount() {
        const current_discountId = document.getElementById("current_discountId").value;
        ajaxSellectAll(current_discountId);
    }

    function deSelectAllProductForDiscount() {
        const current_discountId = document.getElementById("current_discountId").value;
        ajaxUnSellectAll(current_discountId)
    }

    function changeSelectByCategory(categoryCheckbox, categoryId) {
        const current_discountId = document.getElementById("current_discountId").value;
        const isChecked = categoryCheckbox.checked;
        if (isChecked) {
            ajaxSelectByCategory(current_discountId, categoryId)
        } else {
            ajaxUnSelectByCategory(current_discountId, categoryId)
        }
    }

    function changeSelectByProduct(checkbox, categoryId, productId) {
        const isChecked = checkbox.checked;
        const current_discountId = document.getElementById("current_discountId").value;
        if (isChecked) {
            ajaxSelectByProduct(checkbox, current_discountId, productId, categoryId)
        } else {
            ajaxUnSelectByProduct(checkbox, current_discountId, productId, categoryId)
        }
    }

    function selectByQuantity() {
        const current_discountId = document.getElementById("current_discountId").value;
        // comparison
        const radios = document.getElementsByName('comparison');
        let selectedValue = null;
        radios.forEach(radio => {
            if (radio.checked) {
                selectedValue = radio.value;
            }
        });
        // number
        const number = document.getElementById("number").value;
        if (number == undefined || number == null || number < 0) {
            document.getElementById("numberValid").innerHTML = "Số lượng có sẵn không khả dụng";
        } else {
            document.getElementById("numberValid").innerHTML = "";
            $.ajax({
                method: "POST",
                url: "/HandMadeStore/discount-ajax-handle",
                data: {
                    action: "discountByQuantity",
                    discountId: current_discountId,
                    number: number,
                    comparison: selectedValue
                },
                success: function (response) {
                    // Lấy tất cả các thẻ input có class p_all và là loại checkbox
                    const inputs = document.querySelectorAll('input.p_all[type="checkbox"]');
                    const filteredInputs = [];
                    inputs.forEach(input => {
                        const classList = input.classList;
                        classList.forEach(cls => {
                            if (cls.startsWith('pquantity_')) {
                                const value = parseInt(cls.split('_')[1], 10);
                                console.log("input 1", value)
                                if (!isNaN(value) &&
                                    ((value > number && selectedValue == 1) ||
                                        (value == number && selectedValue == 0) ||
                                        (value < number && selectedValue == -1))) {
                                    console.log("2", input)
                                    input.checked = true;
                                    input.onchange();
                                }
                            }
                        });
                    });
                },
                error: function () {
                    alert("Thay đổi không thành công!");
                }
            })
        }
    }

    function unSelectByQuantity() {
        const current_discountId = document.getElementById("current_discountId").value;
        // comparison
        const radios = document.getElementsByName('comparison');
        let selectedValue = null;
        radios.forEach(radio => {
            if (radio.checked) {
                selectedValue = radio.value;
            }
        });
        // number
        const number = document.getElementById("number").value;
        if (number == undefined || number == null || number < 0) {
            document.getElementById("numberValid").innerHTML = "Số lượng có sẵn không khả dụng";
        } else {
            $.ajax({
                method: "POST",
                url: "/HandMadeStore/discount-ajax-handle",
                data: {
                    action: "unDiscountByQuantity",
                    discountId: current_discountId,
                    number: number,
                    comparison: selectedValue
                },
                success: function (response) {
                    // Lấy tất cả các thẻ input có class p_all và là loại checkbox
                    const inputs = document.querySelectorAll('input.p_all[type="checkbox"]');
                    const filteredInputs = [];
                    inputs.forEach(input => {
                        const classList = input.classList;
                        classList.forEach(cls => {
                            if (cls.startsWith('pquantity_')) {
                                const value = parseInt(cls.split('_')[1], 10);
                                if (!isNaN(value) &&
                                    ((value > number && selectedValue == 1) ||
                                        (value == number && selectedValue == 0) ||
                                        (value < number && selectedValue == -1))) {
                                    input.checked = false;
                                    input.onchange();
                                }
                            }
                        });
                    });
                },
                error: function () {
                    alert("Thay đổi không thành công!");
                }
            })
        }
    }

    function formattedPrice(value) {
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(value);
        return formattedPrice;
    }

    document.querySelector('.percentageOff').addEventListener('submit', function(event) {
        const numberInput = document.querySelector('.number-input');
        const errorMessage = document.querySelector('.error-message');

        // Clear previous error message
        errorMessage.textContent = '';

        const value = parseFloat(numberInput.value);

        if (value < 0 || value > 100) {
            event.preventDefault();
            errorMessage.textContent = 'Giá trị phải nằm trong khoảng từ 0 đến 100.';
        }
    });

</script>
<script
        type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/7.3.2/mdb.umd.min.js"
></script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>