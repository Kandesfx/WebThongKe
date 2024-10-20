package kandesfx.haivu.webketoan.beens;
import lombok.*;

import java.util.Date;
import java.util.List;

@Data
public class GiangVien {
    private String hoTen;
    private String maSoGV;
    private String boPhan;
    private double luongCoBan;
    private int mucDoHoanThanhCongViec;
    private double heSoLuong;
    private String loaiThuong;
    private double tienBonus;
    private List<KPI> kpiList;
    private double tyLeBaoHiem;
    private double giamTruBanThan;
    private String loanType;
    private Date thoiGianDangKy;
    private Date ngayHetHan;
    private double soTienVay;
    private Date ngayHoanTra;
    private int soLuongHocVien;
    private double soTienPhat;
    private double phiSuDungChuongTrinh;
    private double soTienOutSourcing;
    private int soNgayNghi;
    private double soTienTrenNghi;
    private List<ThieuChiTieu> thieuChiTieuList;

}
