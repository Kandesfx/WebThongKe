package kandesfx.haivu.webketoan.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import kandesfx.haivu.webketoan.DAO.GiangVienDAO;
import kandesfx.haivu.webketoan.beens.GiangVien;
import kandesfx.haivu.webketoan.beens.KPI;
import kandesfx.haivu.webketoan.beens.ThieuChiTieu;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/themGiangVien")
public class ThemGiangVienServlet extends HttpServlet {
    private GiangVienDAO giangVienDAO = new GiangVienDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String hoTen = request.getParameter("hoTen");
        String maSoGV = request.getParameter("maSoGV");
        String boPhan = request.getParameter("boPhan");
        String luongCoBanStr = request.getParameter("luongCoBan");
        String heSoLuongStr = request.getParameter("heSoLuong");
        String mucDoHoanThanhCongViecStr = request.getParameter("mucDoHoanThanh");
        String loaiThuong = request.getParameter("loaiThuong");
        String tienBonusStr = request.getParameter("soTienThuong");
        String soNgayNghiStr = request.getParameter("soNgayNghi");
        String soTienTrenNghiStr = request.getParameter("soTienTrenNgayNghi");
        String thueSuatStr = request.getParameter("thueSuat");
        String khoanGiamTruTNCNStr = request.getParameter("khoanGiamTru");

        // Tỷ lệ bảo hiểm
        double tyLeBHXH = Double.parseDouble(request.getParameter("tyLeBHXH"));
        double tyLeBHTN = Double.parseDouble(request.getParameter("tyLeBHTN"));
        double tyLeBHYT = Double.parseDouble(request.getParameter("tyLeBHYT"));
        double tongTyLeBaoHiem = tyLeBHXH + tyLeBHTN + tyLeBHYT;

        String giamTruBanThanStr = request.getParameter("giamTruBanThan");
        int soLuongHocVien = Integer.parseInt(request.getParameter("soLuongHocVien"));
        double soTienPhat = Double.parseDouble(request.getParameter("soTienPhat"));
        double phiSuDungChuongTrinh = Double.parseDouble(request.getParameter("phiSuDungChuongTrinh"));
        double soTienOutSourcing = Double.parseDouble(request.getParameter("soTienOutSourcing"));
        double khoanGiamTruTNCN = Double.parseDouble(khoanGiamTruTNCNStr);


        // Loan fields
        String loanType = request.getParameter("loanType");
        String thoiGianDangKy = request.getParameter("thoiGianDangKy");
        String ngayHetHan = request.getParameter("ngayHetHan");
        String soTienVayStr = request.getParameter("soTienVay");
        String ngayHoanTra = request.getParameter("ngayHoanTra");

        // Xóa dấu phẩy trước khi ép kiểu thành double
        luongCoBanStr = luongCoBanStr.replace(",", ""); // Xóa tất cả dấu phẩy
        tienBonusStr = tienBonusStr.replace(",", "");
        soTienVayStr = soTienVayStr.replace(",", "");

        // Ép kiểu thành double
        double luongCoBan = 0;
        double heSoLuong = 0;
        double tienBonus = 0;
        double soTienVay = 0;
        double giamTruBanThan = 0;
        int soNgayNghi = 0;
        double soTienTrenNghi = 0;
        int thueSuat = 0;

        try {
            luongCoBan = Double.parseDouble(luongCoBanStr);
            heSoLuong = Double.parseDouble(heSoLuongStr);
            tienBonus = Double.parseDouble(tienBonusStr);
            soTienVay = Double.parseDouble(soTienVayStr);
            giamTruBanThan = Double.parseDouble(giamTruBanThanStr);
            soNgayNghi = Integer.parseInt(soNgayNghiStr);
            soTienTrenNghi = Double.parseDouble(soTienTrenNghiStr);
            thueSuat = Integer.parseInt(thueSuatStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            // Xử lý lỗi ép kiểu
            request.setAttribute("error", "Lỗi định dạng số!");
            request.getRequestDispatcher("/themGiangVien.jsp").forward(request, response);
            return;
        }

        // Xử lý danh sách KPI
        List<KPI> kpiList = new ArrayList<>();
        String[] tenKPIs = request.getParameterValues("tenKPI");
        String[] soLuongs = request.getParameterValues("soLuong");
        String[] soTiens = request.getParameterValues("soTien");
        // Xử lý các chỉ tiêu thiếu nếu có
        String[] tenChiTieu = request.getParameterValues("tenChiTieu[]");
        String[] nguoiDangKy = request.getParameterValues("nguoiDangKy[]");
        String[] soTienBoThuongStr = request.getParameterValues("soTienBoThuong[]");

        if (tenKPIs != null && soLuongs != null && soTiens != null) {
            for (int i = 0; i < tenKPIs.length; i++) {
                String tenKPI = tenKPIs[i];
                int soLuong = Integer.parseInt(soLuongs[i]);
                double soTien = Double.parseDouble(soTiens[i]);

                KPI kpi = new KPI(tenKPI, soLuong, soTien);
                kpiList.add(kpi);
            }
        }

        List<ThieuChiTieu> thieuChiTieuList = new ArrayList<>();
        if (tenChiTieu != null && nguoiDangKy != null && soTienBoThuongStr != null) {
            for (int i = 0; i < tenChiTieu.length; i++) {
                ThieuChiTieu thieuChiTieu = new ThieuChiTieu();
                thieuChiTieu.setTenChiTieu(tenChiTieu[i]);
                thieuChiTieu.setNguoiDangKy(nguoiDangKy[i]);
                thieuChiTieu.setSoTienBoThuong(Double.parseDouble(soTienBoThuongStr[i]));
                thieuChiTieuList.add(thieuChiTieu);
            }
        }

        // Kiểm tra mã số giảng viên đã tồn tại chưa
        if (giangVienDAO.kiemTraMaSoTonTai(maSoGV)) {
            // Nếu mã số đã tồn tại, trả về thông báo lỗi
            request.setAttribute("Error", "Mã số giảng viên đã tồn tại!");
            request.getRequestDispatcher("/themGiangVien.jsp").forward(request, response);
        } else {
            // Nếu chưa tồn tại, tạo đối tượng giảng viên và lưu vào database
            GiangVien giangVien = new GiangVien();
            giangVien.setHoTen(hoTen);
            giangVien.setMaSoGV(maSoGV);
            giangVien.setBoPhan(boPhan);
            giangVien.setLuongCoBan(luongCoBan);
            giangVien.setKpiList(kpiList);
            giangVien.setHeSoLuong(heSoLuong);
            giangVien.setMucDoHoanThanhCongViec(Integer.parseInt(mucDoHoanThanhCongViecStr));
            giangVien.setLoaiThuong(loaiThuong);
            giangVien.setTienBonus(tienBonus);
            giangVien.setTyLeBaoHiem(tongTyLeBaoHiem);
            giangVien.setGiamTruBanThan(giamTruBanThan);
            giangVien.setThueSuat(thueSuat);
            giangVien.setKhoanGiamTruTNCN(khoanGiamTruTNCN);
            giangVien.setLoanType(loanType);
            giangVien.setThoiGianDangKy(Date.valueOf(thoiGianDangKy));
            giangVien.setNgayHetHan(Date.valueOf(ngayHetHan));
            giangVien.setSoTienVay(soTienVay);
            giangVien.setNgayHoanTra(Date.valueOf(ngayHoanTra));
            giangVien.setSoLuongHocVien(soLuongHocVien);
            giangVien.setSoTienPhat(soTienPhat);
            giangVien.setPhiSuDungChuongTrinh(phiSuDungChuongTrinh);
            giangVien.setSoTienOutSourcing(soTienOutSourcing);
            giangVien.setThieuChiTieuList(thieuChiTieuList);
            giangVien.setSoNgayNghi(soNgayNghi);
            giangVien.setSoTienTrenNghi(soTienTrenNghi);

            // Lưu giảng viên vào MongoDB thông qua DAO
            giangVienDAO.themGiangVien(giangVien);

            // Hiển thị thông báo thành công và chuyển hướng trở lại trang themGiangVien.jsp
            request.setAttribute("Success", "Thêm giảng viên thành công!");
            request.getRequestDispatcher("/themGiangVien.jsp").forward(request, response);
        }
    }
}
