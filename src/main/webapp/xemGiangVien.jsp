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
        <div class="alert alert-success mt-4" role="alert">
            <strong>Giảng viên đã tìm thấy!</strong><br>
            <p><strong>Mã giảng viên:</strong> ${maSoGV}</p>
            <p><strong>Họ và tên:</strong> ${hoTen}</p>

            <!-- Nút thống kê -->
            <form action="xemGiangVien" method="post">
                <input type="hidden" name="maSoGV" value="${maSoGV}">
                <input type="hidden" name="action" value="thongKe"> <!-- Thêm trường ẩn action -->
                <button type="submit" class="btn btn-success">Thống kê</button>
            </form>
        </div>

        <!-- Hiển thị kết quả thống kê -->
        <c:if test="${not empty thongKe}">
            <div class="alert alert-info mt-4">
                <strong>Lương thực lãnh: </strong> ${thongKe.luongThucLanh}<br>
                <strong>Lương chưa thuế: </strong> ${thongKe.luongChuaThue}<br>
                <strong>Thuế TNCN phải nộp: </strong> ${thongKe.thueTNCNPhaiNop}<br>
                <strong>Khoản vay: </strong> ${thongKe.loans}<br>
                <strong>Chi phí: </strong> ${thongKe.expense}<br>
                <strong>Số tiền đóng bảo hiểm: </strong> ${thongKe.soTienDongBaoHiem}<br>
            </div>
        </c:if>

    </c:if>

    <!-- Hiển thị thông báo nếu giảng viên không tồn tại -->
    <c:if test="${!tonTai}">
        <div class="alert alert-danger mt-4" role="alert">
            Giảng viên không tồn tại.
        </div>
    </c:if>

    <a href="xemGiangVien" class="btn btn-primary mt-4">Quay lại</a>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
