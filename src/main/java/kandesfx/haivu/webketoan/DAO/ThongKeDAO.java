package kandesfx.haivu.webketoan.DAO;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import kandesfx.haivu.webketoan.beens.ThongKe;
import kandesfx.haivu.webketoan.ultills.MongoDBConnection;
import org.bson.Document;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.AggregateIterable;

import java.util.Arrays;
import java.text.DecimalFormat;

public class ThongKeDAO {
    private MongoDatabase database;

    public ThongKeDAO() {
        this.database = MongoDBConnection.getDatabase(); // Sử dụng MongoDBConnection
    }

    public ThongKe aggregateThongKe(String maGiangVien) {
        MongoCollection<Document> collection = database.getCollection("giangvien");

        long startTime = System.currentTimeMillis(); // Bắt đầu tính thời gian truy vấn

        // Aggregation pipeline
        AggregateIterable<Document> result = collection.aggregate(Arrays.asList(new Document("$match",
                        new Document("maSoGV", maGiangVien)),
                new Document("$addFields",
                        new Document("Luong_Chua_Thue",
                                new Document("$add", Arrays.asList("$Thu_Nhap_Chiu_Thue.Part.luongCoBan",
                                        new Document("$multiply", Arrays.asList(new Document("$sum", "$Thu_Nhap_Chiu_Thue.KPI_List.soTien"), "$Thu_Nhap_Chiu_Thue.Balance.heSoLuong")), "$Thu_Nhap_Chiu_Thue.Bonus.tienBonus")))),
                new Document("$addFields",
                        new Document("Luong_Dong_Bao_Hiem",
                                new Document("$add", Arrays.asList("$Thu_Nhap_Chiu_Thue.Part.luongCoBan",
                                        new Document("$multiply", Arrays.asList(new Document("$sum", "$Thu_Nhap_Chiu_Thue.KPI_List.soTien"), "$Thu_Nhap_Chiu_Thue.Balance.heSoLuong")))))),
                new Document("$addFields",
                        new Document("Tien_Dong_Bao_Hiem",
                                new Document("$multiply", Arrays.asList(new Document("$divide", Arrays.asList("$Thue_Thu_Nhap_Ca_Nhan.tyLeBaoHiem", 100L)), "$Luong_Dong_Bao_Hiem")))),
                new Document("$addFields",
                        new Document("Thue_TNCN_Phai_Nop_Step1",
                                new Document("$subtract", Arrays.asList("$Luong_Chua_Thue", "$Tien_Dong_Bao_Hiem")))),
                new Document("$addFields",
                        new Document("Thue_TNCN_Phai_Nop_Step2",
                                new Document("$subtract", Arrays.asList("$Thue_TNCN_Phai_Nop_Step1", "$Thue_Thu_Nhap_Ca_Nhan.giamTruBanThan")))),
                new Document("$addFields",
                        new Document("Thue_TNCN_Phai_Nop_Step3",
                                new Document("$multiply", Arrays.asList("$Thue_TNCN_Phai_Nop_Step2",
                                        new Document("$divide", Arrays.asList("$Thue_Thu_Nhap_Ca_Nhan.thueSuat", 100L)))))),
                new Document("$addFields",
                        new Document("Thue_TNCN_Phai_Nop",
                                new Document("$subtract", Arrays.asList("$Thue_TNCN_Phai_Nop_Step3", "$Thue_Thu_Nhap_Ca_Nhan.khoanGiamTruTNCN")))),
                new Document("$addFields",
                        new Document("Loans",
                                new Document("$multiply", Arrays.asList("$Tien_Ung_Truoc.soTienVay", "$Thu_Nhap_Chiu_Thue.Balance.heSoLuong")))),
                new Document("$addFields",
                        new Document("Expense",
                                new Document("$add", Arrays.asList(new Document("$multiply", Arrays.asList("$Khau_Tru.soLuongHocVien", "$Khau_Tru.soTienPhat")), "$Thue_TNCN_Phai_Nop", "$Khau_Tru.phiSuDungChuongTrinh", "$Khau_Tru.soTienOutSourcing",
                                        new Document("$multiply", Arrays.asList("$Khau_Tru.soTienTrenNghi", "$Khau_Tru.soNgayNghi")),
                                        new Document("$sum", "$Khau_Tru.Chi_Tieu_Thieu.soTienBoiThuong"))))),
                new Document("$addFields",
                        new Document("Luong_Thuc_Lanh_Step1",
                                new Document("$subtract", Arrays.asList("$Luong_Chua_Thue", "$Thue_TNCN_Phai_Nop")))),
                new Document("$addFields",
                        new Document("Luong_Thuc_Lanh_Step2",
                                new Document("$subtract", Arrays.asList("$Luong_Thuc_Lanh_Step1", "$Loans")))),
                new Document("$addFields",
                        new Document("Luong_Thuc_Lanh_Step3",
                                new Document("$subtract", Arrays.asList("$Luong_Thuc_Lanh_Step2", "$Expense")))),
                new Document("$addFields",
                        new Document("Luong_Thuc_Lanh",
                                new Document("$subtract", Arrays.asList("$Luong_Thuc_Lanh_Step3", "$Tien_Dong_Bao_Hiem")))),
                        new Document("$merge",
                                new Document("into", "ThongKe")
                                        .append("on", "maSoGV")
                                        .append("whenMatched", "merge")
                                        .append("whenNotMatched", "insert"))));
        MongoCursor<Document> cursor = result.iterator();
        long queryEndTime = System.currentTimeMillis(); // Kết thúc thời gian truy vấn
        long totalQueryTime = queryEndTime - startTime;

        // Tính thời gian aggregation
        long aggregationStartTime = System.currentTimeMillis();
        DecimalFormat df = new DecimalFormat("#,###.####");
        ThongKe thongKe = new ThongKe();
        Document doc = cursor.next();
        double luongChuaThue = doc.getDouble("Luong_Chua_Thue");
        double thueTNCNPhaiNop = doc.getDouble("Thue_TNCN_Phai_Nop");
        double loans = doc.getDouble("Loans");
        double expense = doc.getDouble("Expense");
        double soTienDongBaoHiem = doc.getDouble("Tien_Dong_Bao_Hiem");
        double luongThucLanh = doc.getDouble("Luong_Thuc_Lanh");

        thongKe.setLuongChuaThue(df.format(luongChuaThue));
        thongKe.setThueTNCNPhaiNop(df.format(thueTNCNPhaiNop));
        thongKe.setLoans(df.format(loans));
        thongKe.setExpense(df.format(expense));
        thongKe.setSoTienDongBaoHiem(df.format(soTienDongBaoHiem));
        thongKe.setLuongThucLanh(df.format(luongThucLanh));

        long aggregationEndTime = System.currentTimeMillis();
        long aggregationExecutionTime = aggregationEndTime - aggregationStartTime;
        thongKe.setThoiGianTruyVan(totalQueryTime);
        thongKe.setThoiGianThucHienAggregation(aggregationExecutionTime);

        return thongKe;
    }
}
