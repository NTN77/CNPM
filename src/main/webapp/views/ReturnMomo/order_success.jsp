<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .success-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 3rem;
            margin: 2rem auto;
            max-width: 600px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .success-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #28a745, #20c997, #17a2b8);
        }

        .success-icon {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            animation: pulse 2s infinite;
        }

        .success-icon i {
            font-size: 3rem;
            color: white;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .order-details {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 1.5rem;
            margin: 2rem 0;
            border-left: 4px solid #28a745;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #495057;
        }

        .detail-value {
            color: #212529;
            font-weight: 500;
        }

        .amount-highlight {
            font-size: 1.2rem;
            color: #28a745;
            font-weight: bold;
        }

        .btn-custom {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            color: white;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            margin: 0.5rem;
            transition: all 0.3s ease;
        }

        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            color: white;
        }

        .btn-outline-custom {
            border: 2px solid #667eea;
            background: transparent;
            color: #667eea;
        }

        .btn-outline-custom:hover {
            background: #667eea;
            color: white;
        }

        .success-message {
            color: #28a745;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .thank-you-text {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check"></i>
        </div>

        <h1 class="success-message">
            <i class="fas fa-check-circle"></i> Thanh toán thành công!
        </h1>

        <p class="thank-you-text">
            Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ của chúng tôi.
            Đơn hàng của bạn đã được xử lý thành công.
        </p>

        <div class="order-details">
            <h4 class="mb-3">
                <i class="fas fa-receipt"></i> Chi tiết đơn hàng
            </h4>

            <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-hashtag"></i> Mã đơn hàng:
                    </span>
                <span class="detail-value">${orderId}</span>
            </div>

            <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-credit-card"></i> Mã giao dịch:
                    </span>
                <span class="detail-value">${transId}</span>
            </div>

            <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-dollar-sign"></i> Số tiền:
                    </span>
                <span class="detail-value amount-highlight">
                        <fmt:formatNumber value="${amount}" type="currency" currencyCode="VND"/>
                    </span>
            </div>

            <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-clock"></i> Thời gian:
                    </span>
                <span class="detail-value">
                        <fmt:formatDate value="<%=new java.util.Date()%>" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </span>
            </div>

            <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-credit-card"></i> Phương thức:
                    </span>
                <span class="detail-value">MoMo Wallet</span>
            </div>
        </div>

        <div class="alert alert-success" role="alert">
            <i class="fas fa-info-circle"></i>
            <strong>Thông báo:</strong> Đơn hàng của bạn sẽ được xử lý và giao hàng trong thời gian sớm nhất.
            Chúng tôi sẽ gửi thông tin chi tiết qua email hoặc SMS.
        </div>

        <div class="mt-4">
            <a href="http://localhost:8080/HandMadeStore/views/Admin/changeUserInfo.jsp" class="btn btn-custom">
                <i class="fas fa-list"></i> Xem đơn hàng của tôi
            </a>
            <a href="http://localhost:8080/HandMadeStore/views/MainPage/view_mainpage/mainpage.jsp" class="btn btn-outline-custom">
                <i class="fas fa-home"></i> Về trang chủ
            </a>
        </div>

        <div class="mt-4 text-muted">
            <small>
                <i class="fas fa-envelope"></i>
                Nếu có thắc mắc, vui lòng liên hệ:
                <a href="mailto:support@example.com">support@example.com</a>
                hoặc hotline: <strong>1900-1234</strong>
            </small>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto redirect after 30 seconds
    setTimeout(function() {
        if(confirm('Bạn có muốn chuyển về trang chủ không?')) {
            window.location.href = '${pageContext.request.contextPath}/views/home.jsp';
        }
    }, 30000);

    // Print receipt function
    function printReceipt() {
        window.print();
    }
</script>
</body>
</html>