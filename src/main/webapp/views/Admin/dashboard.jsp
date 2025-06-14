<%@ page import="java.time.LocalDate" %>
<%@ page import="model.adapter.InventoryProduct" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="model.service.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /**
     * FORMAT GIÁ TIỀN THEO ĐƠN VỊ CỦA VIỆT NAM.
     */
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);

    List<InventoryProduct> inventoryProducts = InventoryService.getInstance().inventorySoldoutTop();
%>
<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <title>Dashboard</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">
    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Roboto:wght@500;700&display=swap"
          rel="stylesheet">
    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Libraries Stylesheet -->
    <link href="<%=request.getContextPath()%>/views/Admin/lib/owlcarousel/assets/owl.carousel.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css"
          rel="stylesheet"/>
    <!-- Customized Bootstrap Stylesheet -->
    <link href="<%=request.getContextPath()%>/views/Admin/css/bootstrap.min.custom.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="<%=request.getContextPath()%>/views/Admin/css/style.dashboard.css" rel="stylesheet">
    <script
            src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js">
    </script>
    <style>
        .content-2 {
            margin-left: 300px;
            min-height: 100vh;
            background: var(--light);
            transition: 0.5s;
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="content-2 main-content-se row mx-2 mb-2">
    <!-- Sale & Revenue Start -->
    <div class="container-fluid pt-4 px-4">
        <div class="row g-4">
            <div class="col-sm-6 col-xl-3">
                <div class="bg-secondary rounded d-flex align-items-center justify-content-between p-4">
                    <i class="fa fa-chart-line fa-3x text-primary"></i>
                    <div class="ms-3">
                        <p class="mb-2">Số đơn hàng đang giao</p>
                        <h6 class="mb-0"><%=OrderService.getInstance().deliveringOrdersNumber()%></h6>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="bg-secondary rounded d-flex align-items-center justify-content-between p-4">
                    <i class="fa fa-chart-bar fa-3x text-primary"></i>
                    <div class="ms-3">
                        <p class="mb-2">Số khách hàng</p>
                        <h6 class="mb-0"><%=UserService.getInstance().usersNumber()%>
                        </h6>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="bg-secondary rounded d-flex align-items-center justify-content-between p-4">
                    <i class="fa fa-chart-area fa-3x text-primary"></i>
                    <div class="ms-3">
                        <p class="mb-2">Số sản phẩm</p>
                        <h6 class="mb-0"><%=ProductService.getInstance().getNumberAvailProduct()%></h6>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="bg-secondary rounded d-flex align-items-center justify-content-between p-4">
                    <i class="fa fa-chart-pie fa-3x text-primary"></i>
                    <div class="ms-3">
                        <p class="mb-2">Khuyến mãi khả dụng</p>
                        <h6 class="mb-0"><%=DiscountService.getInstance().discountOnTodayNumber()%></h6>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Sale & Revenue End -->

<%--    <!-- Sales Chart Start -->--%>
<%--    <div class="profit container-fluid pt-4 px-4 profit">--%>
<%--        <div>Doanh thu bán hàng gần nhất <%=LocalDate.now().getYear()%>--%>
<%--        </div>--%>
<%--        <hr class="line-split">--%>
<%--        <canvas id="myCharts" style="width:100%; height: 200px"></canvas>--%>
<%--    </div>--%>
    <!-- Sales Chart End -->
    <!-- Recent Sales Start -->
    <div class="container-fluid pt-4 px-4 mt-3">
        <div class="bg-secondary text-center rounded p-4">
            <div class="d-flex align-items-center justify-content-between mb-4">
                <h6 class="mb-0">Top sản phẩm bán chạy</h6>
<%--                <a href="">Show All</a>--%>
            </div>
            <div class="table-responsive">
                <table class="table text-start align-middle table-bordered table-hover mb-0">
                    <thead>
                    <tr class="text-white">
                        <th scope="col">Mã sản phẩm</th>
                        <th scope="col">Sản phẩm</th>
                        <th scope="col">Giá nhập</th>
                        <th scope="col">Giá bán</th>
                        <th scope="col">Đã bán</th>
                        <th scope="col">Lượng tồn kho</th>
                        <th scope="col">Nhập gần nhất</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (InventoryProduct o : inventoryProducts) {
                            int discountPrice = (int) (InventoryService.getInstance().productPriceIncludeDiscount(o.getId()));
                    %>
                    <tr>
                        <td class="text-info"><%=o.getId()%>
                        </td>
                        <td class="text-info"><%=o.getName()%>
                        </td>
                        <td class="text-info"><%=numberFormat.format(o.getCostPrice())%>
                        </td>
                        <%if ((discountPrice != o.getSellingPrice())) {%>
                        <td class="text-info"><%= numberFormat.format(
                                discountPrice) + " (" + numberFormat.format(
                                o.getSellingPrice()) + ")"
                        %>
                        </td>
                        <%} else {%>
                        <td class="text-info"><%=  numberFormat.format(
                                o.getSellingPrice())
                        %>
                        </td>
                        <%}%>
                        <td class="text-info"><%=o.getSoldOut()%>
                        </td>
                        <td class="text-info"><%=o.getQuantityRemaining()%>
                        </td>
                        <td class="text-info"><%=o.getLastModified()%></td>
                        <td><a class="btn btn-sm btn-primary"
                               href="<%=request.getContextPath()%>/product-detail?id=<%=o.getId()%>" target="_blank">Xem</a></td>
                    </tr>
                    <%}%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Recent Sales End -->
</div>

<%!int year = LocalDate.now().getYear();%>
<input type="hidden" id="year" value="<%=year%>">
<%!double lastyear_max = OrderService.getInstance().getMonthRevenueMax(year - 1);%>;
<input type="hidden" id="lastyear_m1" value="<%=OrderService.getInstance().getRevenueForMonth(1,year-1)%>">
<input type="hidden" id="lastyear_m2" value="<%=OrderService.getInstance().getRevenueForMonth(2,year-1)%>">
<input type="hidden" id="lastyear_m3" value="<%=OrderService.getInstance().getRevenueForMonth(3,year-1)%>">
<input type="hidden" id="lastyear_m4" value="<%=OrderService.getInstance().getRevenueForMonth(4,year-1)%>">
<input type="hidden" id="lastyear_m5" value="<%=OrderService.getInstance().getRevenueForMonth(5,year-1)%>">
<input type="hidden" id="lastyear_m6" value="<%=OrderService.getInstance().getRevenueForMonth(6,year-1)%>">
<input type="hidden" id="lastyear_m7" value="<%=OrderService.getInstance().getRevenueForMonth(7,year-1)%>">
<input type="hidden" id="lastyear_m8" value="<%=OrderService.getInstance().getRevenueForMonth(8,year-1)%>">
<input type="hidden" id="lastyear_m9" value="<%=OrderService.getInstance().getRevenueForMonth(9,year-1)%>">
<input type="hidden" id="lastyear_m10" value="<%=OrderService.getInstance().getRevenueForMonth(10,year-1)%>">
<input type="hidden" id="lastyear_m11" value="<%=OrderService.getInstance().getRevenueForMonth(11,year-1)%>">
<input type="hidden" id="lastyear_m12" value="<%=OrderService.getInstance().getRevenueForMonth(12,year-1)%>">


<%!double current_max = OrderService.getInstance().getMonthRevenueMax(year);%>
<input type="hidden" id="max" value="<%=(current_max>lastyear_max)?current_max:lastyear_max%>">
<input type="hidden" id="m1" value="<%=OrderService.getInstance().getRevenueForMonth(1,year)%>">
<input type="hidden" id="m2" value="<%=OrderService.getInstance().getRevenueForMonth(2,year)%>">
<input type="hidden" id="m3" value="<%=OrderService.getInstance().getRevenueForMonth(3,year)%>">
<input type="hidden" id="m4" value="<%=OrderService.getInstance().getRevenueForMonth(4,year)%>">
<input type="hidden" id="m5" value="<%=OrderService.getInstance().getRevenueForMonth(5,year)%>">
<input type="hidden" id="m6" value="<%=OrderService.getInstance().getRevenueForMonth(6,year)%>">
<input type="hidden" id="m7" value="<%=OrderService.getInstance().getRevenueForMonth(7,year)%>">
<input type="hidden" id="m8" value="<%=OrderService.getInstance().getRevenueForMonth(8,year)%>">
<input type="hidden" id="m9" value="<%=OrderService.getInstance().getRevenueForMonth(9,year)%>">
<input type="hidden" id="m10" value="<%=OrderService.getInstance().getRevenueForMonth(10,year)%>">
<input type="hidden" id="m11" value="<%=OrderService.getInstance().getRevenueForMonth(11,year)%>">
<input type="hidden" id="m12" value="<%=OrderService.getInstance().getRevenueForMonth(12,year)%>">

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/chart/chart.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/easing/easing.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/waypoints/waypoints.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/owlcarousel/owl.carousel.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/js/moment.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/js/moment-timezone.min.js"></script>
<script src="<%=request.getContextPath()%>/views/Admin/lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

<!-- Template Javascript -->
<script src="<%=request.getContextPath()%>/views/Admin/js/main.custom.js"></script>
<script>
    var y_last1 = parseFloat(document.getElementById("lastyear_m1").value);
    var y_last2 = parseFloat(document.getElementById("lastyear_m2").value);
    var y_last3 = parseFloat(document.getElementById("lastyear_m3").value);
    var y_last4 = parseFloat(document.getElementById("lastyear_m4").value);
    var y_last5 = parseFloat(document.getElementById("lastyear_m5").value);
    var y_last6 = parseFloat(document.getElementById("lastyear_m6").value);
    var y_last7 = parseFloat(document.getElementById("lastyear_m7").value);
    var y_last8 = parseFloat(document.getElementById("lastyear_m8").value);
    var y_last9 = parseFloat(document.getElementById("lastyear_m9").value);
    var y_last10 = parseFloat(document.getElementById("lastyear_m10").value);
    var y_last11 = parseFloat(document.getElementById("lastyear_m11").value);
    var y_last12 = parseFloat(document.getElementById("lastyear_m12").value);

    var y1 = parseFloat(document.getElementById("m1").value);
    var y2 = parseFloat(document.getElementById("m2").value);
    var y3 = parseFloat(document.getElementById("m3").value);
    var y4 = parseFloat(document.getElementById("m4").value);
    var y5 = parseFloat(document.getElementById("m5").value);
    var y6 = parseFloat(document.getElementById("m6").value);
    var y7 = parseFloat(document.getElementById("m7").value);
    var y8 = parseFloat(document.getElementById("m8").value);
    var y9 = parseFloat(document.getElementById("m9").value);
    var y10 = parseFloat(document.getElementById("m10").value);
    var y11 = parseFloat(document.getElementById("m11").value);
    var y12 = parseFloat(document.getElementById("m12").value);
    var ymax = parseFloat(document.getElementById("max").value);

    var year = parseFloat(document.getElementById("year").value);
    var lastYear = year - 1;

    var yValues = [];
    var xValues = [];

    for (var i = 1; i <= 12; i++) {
        var lastYearValue = parseFloat(document.getElementById("lastyear_m" + i).value);
        yValues.push(lastYearValue);
        xValues.push(i + "/" + lastYear);
    }

    var currentMonth = new Date().getMonth() + 1;

    for (var i = 1; i < currentMonth; i++) {
        var currentValue = parseFloat(document.getElementById("m" + i).value);
        yValues.push(currentValue);
        xValues.push(i + "/" + year);
    }

    var ymax = parseFloat(document.getElementById("max").value);

    new Chart("myCharts", {
        type: "line",
        data: {
            labels: xValues,
            datasets: [{
                fill: false,
                lineTension: 0,
                backgroundColor: "#ff0000",
                borderColor: "#1a73e8",
                data: yValues
            }]
        },
        options: {
            legend: {display: false},
            scales: {
                yAxes: [{ticks: {min: 0, max: ymax}}],
            }
        }
    });


</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>