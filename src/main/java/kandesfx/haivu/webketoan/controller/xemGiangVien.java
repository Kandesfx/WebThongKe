package kandesfx.haivu.webketoan.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import kandesfx.haivu.webketoan.DAO.GiangVienDAO;
import kandesfx.haivu.webketoan.DAO.ThongKeDAO;
import kandesfx.haivu.webketoan.beens.GiangVien;
import kandesfx.haivu.webketoan.beens.ThongKe;
import java.io.IOException;

@WebServlet("/xemGiangVien")
public class xemGiangVien extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển tiếp tới trang JSP để hiển thị giao diện nhập mã giảng viên
        request.getRequestDispatcher("/xemGiangVien.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String maSoGV = request.getParameter("maSoGV");

        // Tạo đối tượng DAO để kiểm tra mã giảng viên
        GiangVienDAO giangVienDAO = new GiangVienDAO();
        GiangVien giangVien = giangVienDAO.timGiangVienTheoMa(maSoGV);

        if (giangVien != null) {
            // Giảng viên tồn tại, truyền thông tin text qua JSP
            request.setAttribute("tonTai", true);
            request.setAttribute("hoTen", giangVien.getHoTen());
            request.setAttribute("maSoGV", maSoGV);
        } else {
            // Giảng viên không tồn tại
            request.setAttribute("tonTai", false);
        }
        // Kiểm tra nếu người dùng ấn nút "Thống kê"
        String action = request.getParameter("action");
        if ("thongKe".equals(action)) {
            // Tính toán thống kê
            ThongKeDAO thongKeDAO = new ThongKeDAO();
            ThongKe thongKe = thongKeDAO.aggregateThongKe(maSoGV);

            if (thongKe != null) {
                // Nếu thống kê thành công, trả kết quả về JSP
                request.setAttribute("thongKe", thongKe);
            } else {
                // Nếu thống kê thất bại, hiển thị thông báo lỗi
                request.setAttribute("error", "Không thể tính toán thống kê.");
            }
        }
        // Chuyển tiếp dữ liệu qua trang JSP
        request.getRequestDispatcher("/xemGiangVien.jsp").forward(request, response);
    }
}
