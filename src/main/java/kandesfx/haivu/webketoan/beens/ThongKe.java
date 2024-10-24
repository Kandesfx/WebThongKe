package kandesfx.haivu.webketoan.beens;

import lombok.Data;
@Data
public class ThongKe {
    private String luongThucLanh;
    private String luongChuaThue;
    private String thueTNCNPhaiNop;
    private String loans;
    private String expense;
    private String soTienDongBaoHiem;
    private long thoiGianTruyVan; // Tổng thời gian truy vấn
    private long thoiGianThucHienAggregation;
}
