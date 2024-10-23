package kandesfx.haivu.webketoan.DAO;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import kandesfx.haivu.webketoan.beens.GiangVien;
import kandesfx.haivu.webketoan.beens.KPI;
import kandesfx.haivu.webketoan.beens.ThieuChiTieu;
import kandesfx.haivu.webketoan.ultills.MongoDBConnection;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class GiangVienDAO {
    private MongoCollection<Document> collection;

    public GiangVienDAO() {
        MongoDatabase database = MongoDBConnection.getDatabase();
        collection = database.getCollection("giangvien");
    }

    public boolean kiemTraMaSoTonTai(String maSoGV) {
        Document query = new Document("maSoGV", maSoGV);
        return collection.find(query).first() != null;
    }

    public GiangVien timGiangVienTheoMa(String maSoGV) {
        Document query = new Document("maSoGV", maSoGV);
        Document result = collection.find(query).first();

        if (result != null) {
            // Chuyển đổi Document MongoDB thành đối tượng GiangVien
            GiangVien giangVien = new GiangVien();
            giangVien.setMaSoGV(result.getString("maSoGV"));
            giangVien.setHoTen(result.getString("hoTen"));
            return giangVien;
        }
        return null; // Trả về null nếu không tìm thấy
    }

    public void themGiangVien(GiangVien giangVien) {
        Document doc = new Document("hoTen", giangVien.getHoTen())
                .append("maSoGV", giangVien.getMaSoGV());
        Document Part = new Document("boPhan", giangVien.getBoPhan())
                .append("luongCoBan", giangVien.getLuongCoBan());
        List<Document> kpiDocs = new ArrayList<>();
        for (KPI kpi : giangVien.getKpiList()) {
            Document kpiDoc = new Document("tenKPI", kpi.getTenKPI())
                    .append("soLuong", kpi.getSoLuong())
                    .append("soTien", kpi.getSoTien());
            kpiDocs.add(kpiDoc);
        }
        Document Balance = new Document("mucDoHoanThanhCongViec", giangVien.getMucDoHoanThanhCongViec())
                .append("heSoLuong", giangVien.getHeSoLuong());
        Document Bonus = new Document("loaiThuong", giangVien.getLoaiThuong())
                .append("tienBonus", giangVien.getTienBonus());
        Document thuNhapChiuThue = new Document("Part",Part)
                .append("KPI_List", kpiDocs)
                .append("Balance", Balance)
                .append("Bonus", Bonus);
        doc.append("Thu_Nhap_Chiu_Thue", thuNhapChiuThue);
        Document thueThuNhapCaNhan = new Document("tyLeBaoHiem", giangVien.getTyLeBaoHiem())
                .append("giamTruBanThan", giangVien.getGiamTruBanThan())
                .append("thueSuat", giangVien.getThueSuat())
                .append("khoanGiamTruTNCN", giangVien.getKhoanGiamTruTNCN());
        doc.append("Thue_Thu_Nhap_Ca_Nhan", thueThuNhapCaNhan);
        Document loansDoc = new Document("loanType", giangVien.getLoanType())
                .append("thoiGianDangKy", giangVien.getThoiGianDangKy())
                .append("ngayHetHan", giangVien.getNgayHetHan())
                .append("soTienVay", giangVien.getSoTienVay())
                .append("ngayHoanTra", giangVien.getNgayHoanTra());
        doc.append("Tien_Ung_Truoc", loansDoc);
        List<Document> thieuChiTieuDocs = new ArrayList<>();
        for (ThieuChiTieu tct : giangVien.getThieuChiTieuList()) {
            Document thieuChiTieuDoc = new Document("tenChiTieu", tct.getTenChiTieu())
                    .append("nguoiDangKy", tct.getNguoiDangKy())
                    .append("soTienBoiThuong", tct.getSoTienBoThuong());
            thieuChiTieuDocs.add(thieuChiTieuDoc);
        }
        Document Expense = new Document("soLuongHocVien", giangVien.getSoLuongHocVien())
                .append("soTienPhat", giangVien.getSoTienPhat())
                .append("phiSuDungChuongTrinh", giangVien.getPhiSuDungChuongTrinh())
                .append("soTienOutSourcing", giangVien.getSoTienOutSourcing())
                .append("soNgayNghi", giangVien.getSoNgayNghi())
                .append("soTienTrenNghi", giangVien.getSoTienTrenNghi())
                .append("Chi_Tieu_Thieu", thieuChiTieuDocs);
        doc.append("Khau_Tru", Expense);
        collection.insertOne(doc);
    }
}
