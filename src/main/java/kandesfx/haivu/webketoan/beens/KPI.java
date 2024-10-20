package kandesfx.haivu.webketoan.beens;

import lombok.*;

@Data
public class KPI {
    private String tenKPI;
    private int soLuong;
    private double soTien;

    public KPI(String tenKPI, int soLuong, double soTien) {
        this.tenKPI = tenKPI;
        this.soLuong = soLuong;
        this.soTien = soTien;
    }
}
