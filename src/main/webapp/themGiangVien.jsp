<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Giảng Viên</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- Navbar Bootstrap -->
<nav class="navbar navbar-expand-lg navbar-light bg-info">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Quản Lý Giảng Viên</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
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
    <!-- Vùng thông báo (mặc định ẩn đi) -->
    <div id="notification-area" class="mt-3" style="display: none;">
        <div id="error-alert" class="alert alert-danger" role="alert" style="display: none;">
            ${Error}
        </div>
        <div id="success-alert" class="alert alert-success" role="alert" style="display: none;">
            ${Success}
        </div>
    </div>

    <h2 class="mb-4">Nhập thông tin Giảng Viên</h2>
    <form action="themGiangVien" method="post" class="row g-3">
        <div class="col-md-6">
            <label for="hoTen" class="form-label">Họ và tên</label>
            <input type="text" class="form-control" id="hoTen" name="hoTen" required>
        </div>
        <div class="col-md-6">
            <label for="maSoGV" class="form-label">Mã số giảng viên</label>
            <input type="text" class="form-control" id="maSoGV" name="maSoGV" required>
        </div>
        <div class="col-md-6">
            <label for="boPhan" class="form-label">Bộ phận</label>
            <select class="form-select" id="boPhan" name="boPhan" required>
                <option value="">Chọn bộ phận</option>
                <option value="Teaching Department">Teaching Department</option>
                <option value="Technical Department">Technical Department</option>
                <option value="HR Department">HR Department</option>
                <option value="Production Department">Production Department</option>
                <option value="Supervision Department">Supervision Department</option>
                <option value="CEO">CEO</option>
                <option value="R&D">R&D</option>
                <option value="CFO">CFO</option>
            </select>
        </div>
        <!-- Lương cơ bản -->
        <div class="col-md-6">
            <label for="luongCoBan" class="form-label">Lương cơ bản</label>
            <div class="input-group">
                <input type="text" class="form-control" id="luongCoBan" name="luongCoBan" readonly>
                <span class="input-group-text">đ</span>
            </div>
        </div>
        <!-- Mức độ hoàn thành công việc -->
        <div class="col-md-6">
            <label for="mucDoHoanThanh" class="form-label">Mức độ hoàn thành công việc (%)</label>
            <div class="d-flex align-items-center">
                <!-- Thêm thuộc tính name vào input range -->
                <input type="range" class="form-range" id="mucDoHoanThanh" name="mucDoHoanThanh" min="0" max="100"
                       step="1" value="0" oninput="document.getElementById('mucDoHoanThanhValue').value = this.value">
                <!-- Thêm thuộc tính name vào input number -->
                <input type="number" class="form-control ms-3" id="mucDoHoanThanhValue" name="mucDoHoanThanhValue"
                       min="0" max="100" value="0"
                       oninput="document.getElementById('mucDoHoanThanh').value = this.value">
            </div>
        </div>
        <!-- Hệ số lương -->
        <div class="col-md-6">
            <label for="heSoLuong" class="form-label">Hệ số lương</label>
            <div id="heSoLuong" class="p-2 bg-light text-center border rounded">0</div>
        </div>

        <!-- Input hidden để lưu hệ số lương -->
        <input type="hidden" name="heSoLuong" id="heSoLuongInput" value="0">
        <!-- Bắt đầu phần danh sách KPI -->
        <h3>Danh sách KPI</h3>
        <div id="kpiList" class="mb-3">
            <div class="row g-3 kpi-item align-items-center">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="tenKPI" placeholder="Tên KPI" required>
                </div>
                <div class="col-md-3">
                    <input type="number" class="form-control" name="soLuong" placeholder="Số lượng" required>
                </div>
                <div class="col-md-3">
                    <input type="number" class="form-control" name="soTien" placeholder="Số tiền" required>
                </div>
            </div>
        </div>

        <!-- Nút thêm KPI -->
        <div class="text-end mb-3">
            <button type="button" id="addKPI" class="btn btn-info">Thêm KPI +</button>
        </div>

        <!-- Chọn loại thưởng -->
        <div class="col-md-6">
            <label for="loaiThuong" class="form-label">Chọn loại thưởng (optional)</label>
            <select class="form-select" id="loaiThuong" name="loaiThuong">
                <option value="">Chọn loại thưởng</option>
                <option value="Có số lớp học nhiều nhất">Có số lớp học nhiều nhất</option>
                <option value="Có số lượng học viên tham gia đầy đủ nhất">Có số lượng học viên tham gia đầy đủ nhất
                </option>
                <option value="Hoạt động giảng dạy đều đặn trong 26 ngày/tháng">Hoạt động giảng dạy đều đặn trong 26
                    ngày/tháng
                </option>
                <option value="Có số lượng sản phẩm vượt chỉ tiêu">Có số lượng sản phẩm vượt chỉ tiêu</option>
                <option value="Có số lượng sản phẩm đạt yêu cầu nhiều nhất">Có số lượng sản phẩm đạt yêu cầu nhiều
                    nhất
                </option>
                <option value="Có số lượt đăng ký nhiều buổi học nhất">Có số lượt đăng ký nhiều buổi học nhất</option>
            </select>
        </div>

        <!-- Số tiền thưởng -->
        <div class="col-md-6">
            <label for="soTienThuong" class="form-label">Số tiền thưởng</label>
            <div class="input-group">
                <input type="text" class="form-control" id="soTienThuong" name="soTienThuong" readonly>
                <span class="input-group-text">đ</span>
            </div>
        </div>
        <!-- Tỷ lệ BHXH -->
        <div class="col-md-4">
            <label for="tyLeBHXH" class="form-label">Tỷ lệ BHXH (%)</label>
            <input type="number" class="form-control" id="tyLeBHXH" name="tyLeBHXH" value="8" min="0" max="100"
                   step="0.1">
        </div>

        <!-- Tỷ lệ BHTN -->
        <div class="col-md-4">
            <label for="tyLeBHTN" class="form-label">Tỷ lệ BHTN (%)</label>
            <input type="number" class="form-control" id="tyLeBHTN" name="tyLeBHTN" value="1" min="0" max="100"
                   step="0.1">
        </div>

        <!-- Tỷ lệ BHYT -->
        <div class="col-md-4">
            <label for="tyLeBHYT" class="form-label">Tỷ lệ BHYT (%)</label>
            <input type="number" class="form-control" id="tyLeBHYT" name="tyLeBHYT" value="1.5" min="0" max="100"
                   step="0.1">
        </div>
        <!-- Thuế thu nhập cá nhân -->
        <div class="card">
            <div class="card-header">
                <h4>Thuế thu nhập cá nhân</h4>
                <div class="col-md-6">
                    <label for="giamTruBanThan" class="form-label">Giảm trừ bản thân</label>
                    <input type="number" class="form-control" id="giamTruBanThan" name="giamTruBanThan" required>
                </div>
                <!-- Thuế suất (%) -->
                <div class="col-md-6">
                    <label for="thueSuat" class="form-label">Thuế suất (%)</label>
                    <input type="number" class="form-control" id="thueSuat" name="thueSuat" readonly>
                </div>

                <!-- Khoản giảm trừ (VND) -->
                <div class="col-md-6">
                    <label for="khoanGiamTru" class="form-label">Khoản giảm trừ (VND)</label>
                    <input type="text" class="form-control" id="khoanGiamTru" name="khoanGiamTru" readonly>
                </div>
            </div>
        </div>

        <div class="container">
            <!-- Form Loans -->
            <div class="row mb-4">
                <h4>Loans</h4>

                <!-- Loan Type (Dropdown lựa chọn) -->
                <div class="col-md-6 mb-3">
                    <label for="loanType" class="form-label">Loan type</label>
                    <select class="form-select" id="loanType" name="loanType">
                        <option value="Planning">Planning</option>
                        <option value="Item">Item</option>
                    </select>
                </div>

                <!-- Thời gian đăng ký vay mượn -->
                <div class="col-md-6 mb-3">
                    <label for="thoiGianDangKy" class="form-label">Thời gian đăng ký vay mượn</label>
                    <input type="date" class="form-control" id="thoiGianDangKy" name="thoiGianDangKy" required>
                </div>

                <!-- Ngày hết hạn -->
                <div class="col-md-6 mb-3">
                    <label for="ngayHetHan" class="form-label">Ngày hết hạn</label>
                    <input type="date" class="form-control" id="ngayHetHan" name="ngayHetHan" required>
                </div>

                <!-- Số tiền vay -->
                <div class="col-md-6 mb-3">
                    <label for="soTienVay" class="form-label">Số tiền vay</label>
                    <input type="number" class="form-control" id="soTienVay" name="soTienVay"
                           placeholder="Enter loan amount" required>
                </div>

                <!-- Ngày hoàn trả -->
                <div class="col-md-6 mb-3">
                    <label for="ngayHoanTra" class="form-label">Ngày hoàn trả</label>
                    <input type="date" class="form-control" id="ngayHoanTra" name="ngayHoanTra" required>
                </div>
            </div>
        </div>

        <!-- Khấu trừ -->
        <div class="card">
            <div class="card-header">
                Khấu trừ
            </div>
            <div class="card-body">
                <!-- Số học viên không đủ chỉ tiêu -->
                <h5 class="card-title">Số học viên không đủ chỉ tiêu</h5>
                <div class="mb-3">
                    <label for="soLuongHocVien" class="form-label">Số lượng học viên</label>
                    <input type="number" class="form-control" id="soLuongHocVien" name="soLuongHocVien" required>
                </div>
                <div class="mb-3">
                    <label for="soTienPhat" class="form-label">Số tiền phạt (trên mỗi học viên)</label>
                    <input type="number" class="form-control" id="soTienPhat" name="soTienPhat" required>
                </div>

                <!-- Default Fee -->
                <h5 class="card-title">Default Fee</h5>
                <div class="mb-3">
                    <label for="phiSuDungChuongTrinh" class="form-label">Phí sử dụng chương trình</label>
                    <input type="number" class="form-control" id="phiSuDungChuongTrinh" name="phiSuDungChuongTrinh"
                           required>
                </div>

                <!-- OutSourcing -->
                <h5 class="card-title">OutSourcing</h5>
                <div class="mb-3">
                    <label for="soTienOutSourcing" class="form-label">Số tiền cho OutSourcing</label>
                    <input type="number" class="form-control" id="soTienOutSourcing" name="soTienOutSourcing" required>
                </div>
                <!-- Số Ngày Nghỉ Không Phép -->
                <h5 class="card-title mt-4">Số Ngày Nghỉ Không Phép</h5>
                <div class="mb-3">
                    <label for="soNgayNghi" class="form-label">Số Ngày nghỉ</label>
                    <input type="number" class="form-control" id="soNgayNghi" name="soNgayNghi">
                </div>
                <div class="mb-3">
                    <label for="soTienTrenNgayNghi" class="form-label">Số tiền trên một ngày nghỉ</label>
                    <input type="number" class="form-control" id="soTienTrenNgayNghi" name="soTienTrenNgayNghi">
                </div>
                <!-- Thiếu chỉ tiêu -->
                <h5 class="card-title">Thiếu chỉ tiêu</h5>
                <div id="thieuChiTieuFields" class="mt-3">
                    <div class="thieuChiTieuItem">
                        <div class="mb-3">
                            <label for="tenChiTieu" class="form-label">Tên chỉ tiêu</label>
                            <input type="text" class="form-control" id="tenChiTieu" name="tenChiTieu[]" required>
                        </div>
                        <div class="mb-3">
                            <label for="nguoiDangKy" class="form-label">Người đăng ký</label>
                            <input type="text" class="form-control" id="nguoiDangKy" name="nguoiDangKy[]" required>
                        </div>
                        <div class="mb-3">
                            <label for="soTienBoThuong" class="form-label">Số tiền bồi thường</label>
                            <input type="number" class="form-control" id="soTienBoThuong" name="soTienBoThuong[]"
                                   required>
                        </div>
                    </div>
                </div>
                <button type="button" id="addThieuChiTieu" class="btn btn-info">Thêm chỉ tiêu</button>
            </div>
        </div>
        <div class="col-12">
            <button type="submit" class="btn btn-primary">Thêm Giảng Viên</button>
        </div>
    </form>
</div>
<!-- Footer -->
<footer class="bg-dark text-white text-center py-3 mt-5">
    Copyright &copy;<script>document.write(new Date().getFullYear());</script>
    All rights reserved | Made with ❤️ by <a href="https://levuhai.site" target="_blank">Le Vu Hai</a>
</footer>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- JavaScript để cập nhật lương cơ bản dựa trên bộ phận -->
<script>
    // Đối tượng chứa mức lương cơ bản cho từng bộ phận
    const luongTheoBoPhan = {
        "Teaching Department": "20,000,000",
        "Technical Department": "25,000,000",
        "HR Department": "18,000,000",
        "Production Department": "22,000,000",
        "Supervision Department": "30,000,000",
        "CEO": "50,000,000",
        "R&D": "28,000,000",
        "CFO": "35,000,000"
    };

    // Lắng nghe sự kiện thay đổi của bộ phận
    document.getElementById("boPhan").addEventListener("change", function () {
        var selectedBoPhan = this.value;
        var luongCoBanInput = document.getElementById("luongCoBan");

        // Cập nhật trường Lương cơ bản dựa trên bộ phận đã chọn
        if (selectedBoPhan in luongTheoBoPhan) {
            luongCoBanInput.value = luongTheoBoPhan[selectedBoPhan];
        } else {
            luongCoBanInput.value = "";  // Xóa nếu chưa chọn bộ phận hợp lệ
        }
    })

    // Hàm cập nhật lương cơ bản theo bộ phận và thêm ký tự "đ"
    function capNhatLuongCoBan(luong) {
        const luongCoBanField = document.getElementById("luongCoBan");
        luongCoBanField.value = luong.toLocaleString('vi-VN'); // Hiển thị định dạng tiền tệ tiếng Việt
    };
</script>
<!-- JavaScript để cập nhật hệ số lương dựa trên Mức độ hoàn thành công việc -->
<script>
    document.getElementById("mucDoHoanThanh").addEventListener("input", function () {
        var completionValue = parseInt(this.value);
        var heSoLuongElement = document.getElementById("heSoLuong");
        var heSoLuongInputElement = document.getElementById("heSoLuongInput");
        var heSoLuong;

        if (completionValue <= 54) {
            heSoLuong = 0;
        } else if (completionValue <= 70) {
            heSoLuong = 0.6;
        } else if (completionValue <= 90) {
            heSoLuong = 0.8;
        } else {
            heSoLuong = 1.1;
        }

        // Cập nhật hệ số lương trên UI
        heSoLuongElement.innerText = heSoLuong;
        // Cập nhật giá trị cho input hidden
        heSoLuongInputElement.value = heSoLuong;
    });
</script>
<!-- JavaScript để thêm và xóa KPI -->
<script>
    // Thêm KPI mới
    document.getElementById('addKPI').addEventListener('click', function () {
        var kpiList = document.getElementById('kpiList');
        var newKPI = document.createElement('div');
        newKPI.classList.add('row', 'g-3', 'kpi-item', 'align-items-center');
        newKPI.innerHTML = `
            <div class="col-md-4">
                <input type="text" class="form-control" name="tenKPI" placeholder="Tên KPI" required>
            </div>
            <div class="col-md-3">
                <input type="number" class="form-control" name="soLuong" placeholder="Số lượng" required>
            </div>
            <div class="col-md-3">
                <input type="number" class="form-control" name="soTien" placeholder="Số tiền" required>
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-danger remove-kpi-btn">Xoá</button>
            </div>
        `;
        kpiList.appendChild(newKPI);
        attachRemoveEvent(newKPI.querySelector('.remove-kpi-btn'));
    });

    // Gán sự kiện xóa cho các nút thùng rác
    function attachRemoveEvent(button) {
        button.addEventListener('click', function () {
            button.parentElement.parentElement.remove();
        });
    }

    // Gán sự kiện cho các KPI có sẵn
    document.querySelectorAll('.remove-kpi-btn').forEach(function (button) {
        attachRemoveEvent(button);
    });
</script>
<script>
    // Object containing the bonus amount for each reward type
    const thuongTheoLoai = {
        "Có số lớp học nhiều nhất": "1,000,000",
        "Có số lượng học viên tham gia đầy đủ nhất": "700,000",
        "Hoạt động giảng dạy đều đặn trong 26 ngày/tháng": "500,000",
        "Có số lượng sản phẩm vượt chỉ tiêu": "1,500,000",
        "Có số lượng sản phẩm đạt yêu cầu nhiều nhất": "900,000",
        "Có số lượt đăng ký nhiều buổi học nhất": "500,000"
    };

    // Listen for changes in the reward type selection
    document.getElementById("loaiThuong").addEventListener("change", function () {
        var selectedLoaiThuong = this.value;
        var soTienThuongInput = document.getElementById("soTienThuong");

        // Update the "Số tiền thưởng" field based on the selected reward type
        if (selectedLoaiThuong in thuongTheoLoai) {
            soTienThuongInput.value = thuongTheoLoai[selectedLoaiThuong];
        } else {
            soTienThuongInput.value = "0";  // If no reward type is selected, set the bonus amount to 0
        }
    });
</script>
<!-- JavaScript để thêm/bỏ trường thiếu chỉ tiêu -->
<!-- JavaScript để thêm và xóa trường thiếu chỉ tiêu -->
<script>
    // Thêm trường chỉ tiêu thiếu
    document.getElementById("addThieuChiTieu").addEventListener("click", function () {
        var container = document.getElementById("thieuChiTieuFields");
        var newFields = `
            <div class="thieuChiTieuItem">
                <div class="mb-3">
                    <label for="tenChiTieu" class="form-label">Tên chỉ tiêu</label>
                    <input type="text" class="form-control" name="tenChiTieu[]" required>
                </div>
                <div class="mb-3">
                    <label for="nguoiDangKy" class="form-label">Người đăng ký</label>
                    <input type="text" class="form-control" name="nguoiDangKy[]" required>
                </div>
                <div class="mb-3">
                    <label for="soTienBoThuong" class="form-label">Số tiền bồi thường</label>
                    <input type="number" class="form-control" name="soTienBoThuong[]" required>
                </div>
                <button type="button" class="btn btn-danger removeThieuChiTieu">Xóa</button>
            </div>
        `;
        container.insertAdjacentHTML('beforeend', newFields);
    });

    // Xóa trường chỉ tiêu thiếu
    document.getElementById("thieuChiTieuFields").addEventListener("click", function (event) {
        if (event.target.classList.contains('removeThieuChiTieu')) {
            var thieuChiTieuItem = event.target.closest('.thieuChiTieuItem');
            thieuChiTieuItem.remove();
        }
    });
</script>
<script>
    // Function to calculate taxable income
    function calculateTaxableIncome() {
        const luongCoBan = parseFloat(document.getElementById("luongCoBan").value.replace(/,/g, '')) || 0;
        const heSoLuong = parseFloat(document.getElementById("heSoLuongInput").value) || 0;
        const soTienThuong = parseFloat(document.getElementById("soTienThuong").value.replace(/,/g, '')) || 0;

        let tongSoTienKPI = 0;
        document.querySelectorAll("#kpiList .kpi-item").forEach(item => {
            const soTien = parseFloat(item.querySelector("input[name='soTien']").value) || 0;
            tongSoTienKPI += soTien;
        });

        const thuNhapChiuThue = luongCoBan + (tongSoTienKPI * heSoLuong) + soTienThuong;
        return thuNhapChiuThue;
    }

    // Function to update tax rate and deduction based on taxable income
    function updateTaxFields() {
        const thuNhapChiuThue = calculateTaxableIncome();

        let thueSuat = 0;
        let khoanGiamTru = 0;

        if (thuNhapChiuThue <= 5000000) {
            thueSuat = 5;
            khoanGiamTru = 0;
        } else if (thuNhapChiuThue <= 10000000) {
            thueSuat = 10;
            khoanGiamTru = 250000;
        } else if (thuNhapChiuThue <= 18000000) {
            thueSuat = 15;
            khoanGiamTru = 750000;
        } else if (thuNhapChiuThue <= 32000000) {
            thueSuat = 20;
            khoanGiamTru = 1650000;
        } else if (thuNhapChiuThue <= 52000000) {
            thueSuat = 25;
            khoanGiamTru = 3250000;
        } else if (thuNhapChiuThue <= 80000000) {
            thueSuat = 30;
            khoanGiamTru = 5850000;
        } else {
            thueSuat = 35;
            khoanGiamTru = 9850000;
        }

        document.getElementById("thueSuat").value = thueSuat;
        document.getElementById("khoanGiamTru").value = khoanGiamTru;
    }

    // Event listeners to update tax fields when relevant inputs change
    document.getElementById("boPhan").addEventListener("change", updateTaxFields);
    document.getElementById("mucDoHoanThanh").addEventListener("input", updateTaxFields);
    document.getElementById("loaiThuong").addEventListener("change", updateTaxFields);
    document.getElementById("kpiList").addEventListener("input", updateTaxFields);

    // Initial calculation on page load
    window.onload = updateTaxFields;
</script>
<!-- JavaScript để hiển thị thông báo và cuộn lên trên -->
<script>
    window.onload = function () {
        // Kiểm tra xem có thông báo nào không
        var error = "${Error}";
        var success = "${Success}";
        var notificationArea = document.getElementById("notification-area");
        var errorAlert = document.getElementById("error-alert");
        var successAlert = document.getElementById("success-alert");

        if (error) {
            errorAlert.style.display = "block";
            notificationArea.style.display = "block";
            window.scrollTo(0, 0);  // Cuộn lên đầu trang
        }

        if (success) {
            successAlert.style.display = "block";
            notificationArea.style.display = "block";
            window.scrollTo(0, 0);  // Cuộn lên đầu trang
        }
    };
</script>
</body>
</html>
