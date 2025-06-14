<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .result-container {
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

        .result-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #dc3545, #fd79a8, #ff6b6b);
        }

        .error-icon {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #dc3545, #ff6b6b);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            animation: shake 1s ease-in-out;
        }

        .error-icon i {
            font-size: 3rem;
            color: white;
        }

        @keyframes shake {
            0%, 20%, 40%, 60%, 80% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-10px); }
        }

        .payment-details {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 1.5rem;
            margin: 2rem 0;
            border-left: 4px solid #dc3545;
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

        .error-code {
            background: #f8d7da;
            color: #721c24;
            padding: 0.5rem 1rem;
            border-radius: 10px;
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

        .btn-danger-custom {
            background: linear-gradient(135deg, #dc3545, #ff6b6b);
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

        .error-message {
            color: #dc3545;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .error-description {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        .troubleshoot-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 1rem;
            margin: 1.5rem 0;
            text-align: left;
        }

        .troubleshoot-box h5 {
            color: #856404;
            margin-bottom: 0.5rem;
        }

        .troubleshoot-box ul {
            color: #856404;
            margin: 0;
            padding-left: 1.2rem;
        }

        .troubleshoot-box li {
            margin-bottom: 0.3rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="result-container">
        <div class="error-icon">
            <i class="fas fa-times"></i>
        </div>

        <h1 class="error-message">
            <i class="fas fa-exclamation-triangle"></i> Thanh toán thất bại!
        </h1>

        <p class="error-description">
            Rất tiếc, giao dịch của bạn không thể hoàn tất.
            Vui lòng kiểm tra lại thông tin và thử lại.
        </p>

        <div class="alert alert-danger" role="alert">
            <strong><i class="fas fa-info-circle"></i> Lý do:</strong>
            <c:choose>
                <c:when test="${not empty message}">
                    ${message}
                </c:when>
                <c:otherwise>
                    Lỗi không xác định trong quá trình thanh toán
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty orderId or not empty resultCode}">
            <div class="payment-details">
                <h4 class="mb-3">
                    <i class="fas fa-receipt"></i> Chi tiết giao dịch
                </h4>

                <c:if test="${not empty orderId}">
                    <div class="detail-row">
                            <span class="detail-label">
                                <i class="fas fa-hashtag"></i> Mã đơn hàng:
                            </span>
                        <span class="detail-value">${orderId}</span>
                    </div>
                </c:if>

                <c:if test="${not empty resultCode}">
                    <div class="detail-row">
                            <span class="detail-label">
                                <i class="fas fa-code"></i> Mã lỗi:
                            </span>
                        <span class="detail-value">
                                <span class="error-code">${resultCode}</span>
                            </span>
                    </div>
                </c:if>

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
        </c:if>

        <div class="troubleshoot-box">
            <h5><i class="fas fa-tools"></i> Hướng dẫn khắc phục:</h5>
            <ul>
                <li>Kiểm tra lại số dư trong ví MoMo</li>
                <li>Đảm bảo kết nối internet ổn định</li>
                <li>Thử thanh toán bằng phương thức khác</li>
                <li>Liên hệ với ngân hàng nếu có vấn đề với thẻ</li>
                <li>Kiểm tra lại thông tin đơn hàng</li>
            </ul>
        </div>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/views/cart/checkout.jsp" class="btn btn-danger-custom">
                <i class="fas fa-redo"></i> Thử lại thanh toán
            </a>
            <a href="${pageContext.request.contextPath}/views/cart/cart.jsp" class="btn btn-outline-custom">
                <i class="fas fa-shopping-cart"></i> Về giỏ hàng
            </a>
        </div>

        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/views/home.jsp" class="btn btn-custom">
                <i class="fas fa-home"></i> Về trang chủ
            </a>
        </div>

        <div class="mt-4 text-muted">
            <small>
                <i class="fas fa-phone"></i>
                Cần hỗ trợ? Liên hệ hotline: <strong>1900-1234</strong><br>
                <i class="fas fa-envelope"></i>
                Email: <a href="mailto:support@example.com">support@example.com</a><br>
                <i class="fas fa-clock"></i>
                Thời gian hỗ trợ: 8:00 - 22:00 (Thứ 2 - Chủ nhật)
            </small>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto redirect to cart after 60 seconds
    setTimeout(function() {
        if(confirm('Bạn có muốn quay lại giỏ hàng để thử lại không?')) {
            window.location.href = '${pageContext.request.contextPath}/views/cart/cart.jsp';
        }
    }, 60000);

    // Add some interaction for better UX
    document.addEventListener('DOMContentLoaded', function() {
        // Add click effect to buttons
        const buttons = document.querySelectorAll('.btn');
        buttons.forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;

                ripple.style.cssText = `
                        position: absolute;
                        width: ${size}px;
                        height: ${size}px;
                        left: ${x}px;
                        top: ${y}px;
                        background: rgba(255,255,255,0.5);
                        border-radius: 50%;
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        pointer-events: none;
                    `;

                this.style.position = 'relative';
                this.style.overflow = 'hidden';
                this.appendChild(ripple);

                setTimeout(() => ripple.remove(), 600);
            });
        });
    });

    // Add CSS for ripple animation
    const style = document.createElement('style');
    style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
    document.head.appendChild(style);
</script>
</body>
</html>