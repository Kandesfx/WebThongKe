package kandesfx.haivu.webketoan.beens;

import lombok.Data;
@Data
public class ThongKe {
    private double luongChuaThue;
    private double luongThucLanh;
    private double thueTNCNPhaiNop;
    private double loans;
    private double expense;
    private double soTienDongBaoHiem;
    private long thoiGianTruyVan; // Tổng thời gian truy vấn
    private long thoiGianThucHienAggregation;
}
