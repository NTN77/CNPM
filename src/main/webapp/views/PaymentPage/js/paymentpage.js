function showPoliciesAndTerms(option) {
    var s = document.getElementById("infor_center");
    var t = document.getElementById("infor_center_title");
    var c = document.getElementById("infor_center_content");
    let newContent;
    console.log(option)
    if (option == 1) {
        t.innerHTML = "Chính sách hoàn trả"
        newContent = "CHÍNH SÁCH ĐỔI TRẢ HÀNG\n" +
            "1. Đổi trả theo nhu cầu khách hàng (đổi trả hàng vì không ưng ý)\n" +
            "Tất cả mặt hàng đã mua đều có thể hoàn trả trong vòng 30 ngày kể từ ngày nhận hàng (trừ khi có quy định gì khác). Chúng tôi chỉ chấp nhận đổi trả cho các sản phẩm còn nguyên điều kiện ban đầu, còn hóa đơn mua hàng & sản phẩm chưa qua sử dụng, bao gồm:\n" +
            "- Còn nguyên đóng gói và bao bì không bị móp rách.\n" +
            "- Đầy đủ các chi tiết, phụ kiện.\n" +
            "- Tem/ phiếu bảo hành, tem thương hiệu, hướng dẫn kỹ thuật  và các quà tặng kèm theo (nếu có) v.v… phải còn đầy đủ và nguyên vẹn\n" +
            "- Không bị dơ bẩn, trầy xước, hư hỏng, có mùi lạ hoặc có dấu hiệu đã qua qua sử dụng\n" +
            "2. Đổi trả không vì lý do chủ quan từ khách hàng\n" +
            "2.1. Hàng giao không mới, không nguyên vẹn, sai nội dung hoặc bị thiếu:\n" +
            "Chúng tôi khuyến khích quý khách hàng phải kiểm tra tình trạng bên ngoài của thùng hàng và sản phẩm trước khi thanh toán để đảm bảo rằng hàng hóa được giao đúng chủng loại, số lượng, màu sắc theo đơn đặt hàng và tình trạng bên ngoài không bị tác động.\n" +
            "Nếu gặp trường hợp này, Quý khách vui lòng từ chối nhận hàng và/hoặc báo ngay cho bộ phận hỗ trợ khách hàng để chúng tôi có phương án xử lí kịp thời. (Xin lưu ý những bước kiểm tra sâu hơn như dùng thử sản phẩm chỉ có thể được chấp nhận sau khi đơn hàng được thanh toán đầy đủ).\n" +
            "Trong trường hợp khách hàng đã thanh toán, nhận hàng và sau đó phát hiện hàng hóa không còn mới nguyên vẹn, sai nội dung hoặc thiếu hàng, xin vui lòng chụp ảnh sản phẩm gửi về hộp thư của chúng tôi để được chúng tôi hỗ trợ các bước tiếp theo như đổi/trả hàng hoặc gửi sản phẩm còn thiếu đến quý khách…\n" +
            "Sau 48h kể từ ngày quý khách nhận hàng, chúng tôi có quyền từ chối hỗ trợ cho những khiếu nại theo nội dung như trên.\n" +
            "2.2. Hàng giao bị lỗi\n" +
            "Khi quý khách gặp trục trặc với sản phẩm đặt mua của chúng tôi, vui lòng thực hiện các bước sau đây:\n" +
            "- Bước 1: Kiểm tra lại sự nguyên vẹn của sản phẩm, chụp lại ảnh sản phẩm xuất hiện lỗi.\n" +
            "- Bước 2: Quý khách liên hệ với trung tâm chăm sóc khách hàng của chúng tôi để được xác nhận.\n" +
            "- Bước 3:Trong vòng 30 ngày kể từ ngày nhận hàng, nếu quý khách được xác nhận từ trung tâm chăm sóc khách hàng rằng sản phẩm bị lỗi kỹ thuật, quý khách vui lòng truy cập ngay Hướng dẫn đổi trả hàng để bắt đầu quy trình đổi trả hàng.\n" +
            "3. Phương thức hoàn tiền\n" +
            "Tùy theo lí do hoàn trả sản phẩm kết quả đánh giá chất lượng tại kho, chúng tôi sẽ có những phương thức hoàn tiền với chi tiết như sau:\n" +
            "- Hoàn tiền bằng mã tiền điện tử dùng để mua sản phẩm mới\n" +
            "- Đổi sản phẩm mới cùng loại\n" +
            "- Chuyển khoản qua ngân hàng theo thông tin của quý khách cung cấp\n" +
            "- Riêng đối với các đơn hàng thanh toán qua thẻ tín dụng quốc tế, chúng tôi sẽ áp dụng hình thức hoàn tiền vào tài khoản thanh toán của chủ thẻ.\n" +
            "- Hoàn tiền mặt trực tiếp tại văn phòng\n" +
            "Mọi chi tiết hoặc thắc mắc quý khách vui lòng liên hệ với chúng tôi qua số điện thoại hỗ trợ hoặc để lại lời nhắn tại website. Xin chân thành cảm ơn.";
        c.innerHTML = newContent;
    } else if (option == 2) {
        t.innerHTML = "Chính sách bảo mật"
        c.innerHTML =
            "CHÍNH SÁCH BẢO MẬT\n" +
            "Cám ơn quý khách đã quan tâm và truy cập vào website. Chúng tôi tôn trọng và cam kết sẽ bảo mật những thông tin mang tính riêng tư của Quý khách.\n" +
            "Chính sách bảo mật sẽ giải thích cách chúng tôi tiếp nhận, sử dụng và (trong trường hợp nào đó) tiết lộ thông tin cá nhân của Quý khách.\n" +
            "Bảo vệ dữ liệu cá nhân và gây dựng được niềm tin cho quý khách là vấn đề rất quan trọng với chúng tôi. Vì vậy, chúng tôi sẽ dùng tên và các thông tin khác liên quan đến quý khách tuân thủ theo nội dung của Chính sách bảo mật. Chúng tôi chỉ thu thập những thông tin cần thiết liên quan đến giao dịch mua bán.\n" +
            "Chúng tôi sẽ giữ thông tin của khách hàng trong thời gian luật pháp quy định hoặc cho mục đích nào đó. Quý khách có thể truy cập vào website và trình duyệt mà không cần phải cung cấp chi tiết cá nhân. Lúc đó, Quý khách đang ẩn danh và chúng tôi không thể biết bạn là ai nếu Quý khách không đăng nhập vào tài khoản của mình.\n" +
            "1. Thu thập thông tin cá nhân\n" +
            "- Chúng tôi thu thập, lưu trữ và xử lý thông tin của bạn cho quá trình mua hàng và cho những thông báo sau này liên quan đến đơn hàng, và để cung cấp dịch vụ, bao gồm một số thông tin cá nhân: danh hiệu, tên, giới tính, ngày sinh, email, địa chỉ, địa chỉ giao hàng, số điện thoại, fax, chi tiết thanh toán, chi tiết thanh toán bằng thẻ hoặc chi tiết tài khoản ngân hàng.\n" +
            "- Chúng tôi sẽ dùng thông tin quý khách đã cung cấp để xử lý đơn đặt hàng, cung cấp các dịch vụ và thông tin yêu cầu thông qua website và theo yêu cầu của bạn.\n" +
            "- Hơn nữa, chúng tôi sẽ sử dụng các thông tin đó để quản lý tài khoản của bạn; xác minh và thực hiện giao dịch trực tuyến, nhận diện khách vào web, nghiên cứu nhân khẩu học, gửi thông tin bao gồm thông tin sản phẩm và dịch vụ. Nếu quý khách không muốn nhận bất cứ thông tin tiếp thị của chúng tôi thì có thể từ chối bất cứ lúc nào.\n" +
            "- Chúng tôi có thể chuyển tên và địa chỉ cho bên thứ ba để họ giao hàng cho bạn (ví dụ cho bên chuyển phát nhanh hoặc nhà cung cấp).\n" +
            "- Chi tiết đơn đặt hàng của bạn được chúng tôi lưu giữ nhưng vì lí do bảo mật nên chúng tôi không công khai trực tiếp được. Tuy nhiên, quý khách có thể tiếp cận thông tin bằng cách đăng nhập tài khoản trên web. Tại đây, quý khách sẽ thấy chi tiết đơn đặt hàng của mình, những sản phẩm đã nhận và những sản phẩm đã gửi và chi tiết email, ngân hàng và bản tin mà bạn đặt theo dõi dài hạn.\n" +
            "- Quý khách cam kết bảo mật dữ liệu cá nhân và không được phép tiết lộ cho bên thứ ba. Chúng tôi không chịu bất kỳ trách nhiệm nào cho việc dùng sai mật khẩu nếu đây không phải lỗi của chúng tôi.\n" +
            "- Chúng tôi có thể dùng thông tin cá nhân của bạn để nghiên cứu thị trường. mọi thông tin chi tiết sẽ được ẩn và chỉ được dùng để thống kê. Quý khách có thể từ chối không tham gia bất cứ lúc nào.\n" +
            "2. Bảo mật\n" +
            "- Chúng tôi có biện pháp thích hợp về kỹ thuật và an ninh để ngăn chặn truy cập trái phép hoặc trái pháp luật hoặc mất mát hoặc tiêu hủy hoặc thiệt hại cho thông tin của bạn.\n" +
            "- Chúng tôi khuyên quý khách không nên đưa thông tin chi tiết về việc thanh toán với bất kỳ ai bằng e-mail, chúng tôi không chịu trách nhiệm về những mất mát quý khách có thể gánh chịu trong việc trao đổi thông tin của quý khách qua internet hoặc email.\n" +
            "- Quý khách tuyệt đối không sử dụng bất kỳ chương trình, công cụ hay hình thức nào khác để can thiệp vào hệ thống hay làm thay đổi cấu trúc dữ liệu. Nghiêm cấm việc phát tán, truyền bá hay cổ vũ cho bất kỳ hoạt động nào nhằm can thiệp, phá hoại hay xâm nhập vào dữ liệu của hệ thống website. Mọi vi phạm sẽ bị tước bỏ mọi quyền lợi cũng như sẽ bị truy tố trước pháp luật nếu cần thiết.\n" +
            "- Mọi thông tin giao dịch sẽ được bảo mật nhưng trong trường hợp cơ quan pháp luật yêu cầu, chúng tôi sẽ buộc phải cung cấp những thông tin này cho các cơ quan pháp luật.\n" +
            "Các điều kiện, điều khoản và nội dung của trang web này được điều chỉnh bởi luật pháp Việt Nam và tòa án Việt Nam có thẩm quyền xem xét.\n" +
            "3. Quyền lợi khách hàng\n" +
            "-Quý khách có quyền yêu cầu truy cập vào dữ liệu cá nhân của mình, có quyền yêu cầu chúng tôi sửa lại những sai sót trong dữ liệu của bạn mà không mất phí. Bất cứ lúc nào bạn cũng có quyền yêu cầu chúng tôi ngưng sử dụng dữ liệu cá nhân của bạn cho mục đích tiếp thị."
    } else if (option == 3) {
        t.innerHTML = "Điều khoản sử dụng"
        c.innerHTML = "HƯỚNG DẪN MUA HÀNG\n" +
            "Bước 1: Truy cập website và lựa chọn sản phẩm cần mua để mua hàng\n" +
            "Bước 2:  Click và sản phẩm muốn mua, màn hình hiển thị ra pop up với các lựa chọn sau:\n" +
            "Nếu bạn muốn tiếp tục mua hàng: Bấm vào phần tiếp tục mua hàng để lựa chọn thêm sản phẩm vào giỏ hàng\n" +
            "Nếu bạn muốn xem giỏ hàng để cập nhật sản phẩm: Bấm vào xem giỏ hàng\n" +
            "Nếu bạn muốn đặt hàng và thanh toán cho sản phẩm này vui lòng bấm vào: Đặt hàng và thanh toán\n" +
            "Bước 3: Lựa chọn thông tin tài khoản thanh toán\n" +
            "Nếu bạn đã có tài khoản vui lòng nhập thông tin tên đăng nhập là email và mật khẩu vào mục đã có tài khoản trên hệ thống\n" +
            "Nếu bạn chưa có tài khoản và muốn đăng ký tài khoản vui lòng điền các thông tin cá nhân để tiếp tục đăng ký tài khoản. Khi có tài khoản bạn sẽ dễ dàng theo dõi được đơn hàng của mình\n" +
            "Nếu bạn muốn mua hàng mà không cần tài khoản vui lòng nhấp chuột vào mục đặt hàng không cần tài khoản\n" +
            "Bước 4: Điền các thông tin của bạn để nhận đơn hàng, lựa chọn hình thức thanh toán và vận chuyển cho đơn hàng của mình\n" +
            "Bước 5: Xem lại thông tin đặt hàng, điền chú thích và gửi đơn hàng\n" +
            "Sau khi nhận được đơn hàng bạn gửi chúng tôi sẽ liên hệ bằng cách gọi điện lại để xác nhận lại đơn hàng và địa chỉ của bạn.\n" +
            "Trân trọng cảm ơn."
    } else {
        c.innerHTML = "null"
    }
    s.style.display = "block";
}

function hidePoliciesAndTerms() {
    document.getElementById("infor_center").style.display = "none";
}

function showBankaccount_infor() {
    document.getElementById("bankaccount_infor").style.display = "block";
}
function hideBankaccount_infor() {
    const bankAccountInfo = document.getElementById("bankaccount_infor");
    if (bankAccountInfo) {
        bankAccountInfo.style.display = "none";
    }
}
