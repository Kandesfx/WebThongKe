<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem Giảng Viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<!-- Navbar Bootstrap -->
<nav class="navbar navbar-expand-lg navbar-light bg-info">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Quản Lý Giảng Viên</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link active" href="themGiangVien.jsp">Thêm Giảng Viên</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="xemGiangVien">Xem Giảng Viên</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <!-- Form nhập mã giảng viên -->
    <form action="xemGiangVien" method="post" class="mt-4">
        <div class="mb-3">
            <label for="maSoGV" class="form-label">Mã giảng viên</label>
            <input type="text" id="maSoGV" name="maSoGV" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary">Tìm</button>
    </form>

    <br>

    <!-- Hiển thị kết quả khi giảng viên tồn tại -->
    <c:if test="${tonTai}">
        <div class="alert alert-success mt-4" role="alert" id="result">
            <strong>Giảng viên đã tìm thấy!</strong><br>
            <p><strong>Mã giảng viên:</strong> ${maSoGV}</p>
            <p><strong>Họ và tên:</strong> ${hoTen}</p>

            <!-- Nút thống kê -->
            <form action="xemGiangVien" method="post">
                <input type="hidden" name="maSoGV" value="${maSoGV}">
                <input type="hidden" name="action" value="thongKeSubmit"> <!-- Thêm trường ẩn action -->
                <button type="submit" class="btn btn-success">Thống kê</button>
            </form>
        </div>

        <!-- Hiển thị kết quả thống kê -->
        <c:if test="${isThongKe}">
            <div class="alert alert-info mt-4" id="thongKeResult">
                <strong>Lương chưa thuế: </strong> ${thongKe.luongChuaThue}<br>
                <strong>Thuế TNCN phải nộp: </strong> ${thongKe.thueTNCNPhaiNop}<br>
                <strong>Khoản vay: </strong> ${thongKe.loans}<br>
                <strong>Chi phí khấu trừ: </strong> ${thongKe.expense}<br>
                <strong>Số tiền đóng bảo hiểm: </strong> ${thongKe.soTienDongBaoHiem}<br>
                <strong>Lương thực lãnh: </strong> ${thongKe.luongThucLanh}<br>
                <strong>Thời gian truy vấn(ms): </strong> ${thongKe.thoiGianTruyVan}<br>
                <strong>Thời gian thực hiện Aggregation(ms): </strong> ${thongKe.thoiGianThucHienAggregation}<br>
            </div>
        </c:if>

    </c:if>

    <!-- Hiển thị thông báo nếu giảng viên không tồn tại -->
    <c:if test="${!tonTai}">
        <div class="alert alert-danger mt-4" role="alert" id="notFound">
            Giảng viên không tồn tại.
        </div>
    </c:if>
</div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const result = document.getElementById("resul");
        const thongKeResult = document.getElementById("thongKeResul");
        const notFound = document.getElementById("notFoun");

        // Hide all notifications initially
        result.style.display = "none";
        thongKeResult.style.display = "none";
        notFound.style.display = "none";

        // Show notifications based on server-side conditions
        <% if (request.getAttribute("tonTai") != null && (boolean) request.getAttribute("tonTai")) { %>
        result.style.display = "block";
        document.getElementById("maSoGVResult").textContent = "<%= request.getAttribute("maSoGV") %>";
        document.getElementById("hoTenResult").textContent = "<%= request.getAttribute("hoTen") %>";
        document.getElementById("maSoGVHidden").value = "<%= request.getAttribute("maSoGV") %>";

        <% if (request.getAttribute("thongKe") != null && (boolean) request.getAttribute("isThongKe")) { %>
        thongKeResult.style.display = "block";
        document.getElementById("luongChuaThue").textContent = "<%= request.getAttribute("luongChuaThue")%>";
        document.getElementById("thueTNCNPhaiNop").textContent = "<%= request.getAttribute("thueTNCNPhaiNop")%>";
        document.getElementById("loans").textContent = "<%= request.getAttribute("loans")%>";
        document.getElementById("expense").textContent = "<%= request.getAttribute("expense")%>";
        document.getElementById("soTienDongBaoHiem").textContent = "<%= request.getAttribute("soTienDongBaoHiem")%>";
        document.getElementById("luongThucLanh").textContent = "<%= request.getAttribute("luongThucLanh")%>";
        document.getElementById("thoiGianTruyVan").textContent = "<%= request.getAttribute("thoiGianTruyVan")%>";
        document.getElementById("thoiGianThucHienAggregation").textContent = "<%= request.getAttribute("thoiGianThucHienAggregation")%>";
        <% } %>
        <% } else if (request.getAttribute("tonTai") != null && !(boolean) request.getAttribute("tonTai")) { %>
        notFound.style.display = "block";
        <% } %>
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
