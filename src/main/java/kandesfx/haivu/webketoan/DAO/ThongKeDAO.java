package kandesfx.haivu.webketoan.DAO;

import com.mongodb.client.MongoCollection;
import kandesfx.haivu.webketoan.beens.ThongKe;
import kandesfx.haivu.webketoan.ultills.MongoDBConnection;
import org.bson.Document;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCursor;
import static com.mongodb.client.model.Aggregates.*;
import static com.mongodb.client.model.Filters.*;
import java.util.Arrays;

public class ThongKeDAO {
    private MongoDatabase database;

    public ThongKeDAO() {
        this.database = MongoDBConnection.getDatabase(); // Sử dụng MongoDBConnection
    }

    public ThongKe aggregateThongKe(String maGiangVien) {
        MongoCollection<Document> collection = database.getCollection("giangvien");

        long startTime = System.currentTimeMillis(); // Bắt đầu tính thời gian truy vấn

        // Aggregation pipeline
        MongoCursor<Document> cursor = collection.aggregate(Arrays.asList(
                match(eq("maSoGV", maGiangVien)), // Tìm giảng viên theo mã

                // Bước 1: Tính Luong_Chua_Thue
                project(new Document("Luong_Chua_Thue",
                        new Document("$add", Arrays.asList(
                                "$luongCoBan",
                                new Document("$multiply", Arrays.asList(new Document("$sum", "$kpiList.soTien"), "$heSoLuong")),
                                "$tienBonus"
                        ))
                )),

                // Bước 2: Tính Thue_TNCN_Phai_Nop
                project(new Document("Thue_TNCN_Phai_Nop",
                        new Document("$multiply", Arrays.asList(
                                new Document("$subtract", Arrays.asList(
                                        "$Luong_Chua_Thue",
                                        "$Tien_Dong_Bao_Hiem",
                                        "$giamTruBanThan"
                                )),
                                "$heSoLuong"
                        ))
                )),

                // Bước 3: Tính Loans (soTienVay * hệ số)
                project(new Document("Loans",
                        new Document("$multiply", Arrays.asList("$soTienVay", "$heSoVay"))
                )),

                // Bước 4: Tính Luong_Dong_Bao_Hiem (luongCoBan + tổng các soTien của kpiList * heSoLuong)
                project(new Document("Luong_Dong_Bao_Hiem",
                        new Document("$add", Arrays.asList(
                                "$luongCoBan",
                                new Document("$multiply", Arrays.asList(new Document("$sum", "$kpiList.soTien"), "$heSoLuong"))
                        ))
                )),

                // Bước 5: Tính So_Tien_Dong_BaoHiem (tyLeBaoHiem * Luong_Dong_Bao_Hiem)
                project(new Document("So_Tien_Dong_BaoHiem",
                        new Document("$multiply", Arrays.asList("$tyLeBaoHiem", "$Luong_Dong_Bao_Hiem"))
                )),

                // Bước 6: Tính Expense
                project(new Document("Expense",
                        new Document("$add", Arrays.asList(
                                new Document("$multiply", Arrays.asList("$soLuongHocVien", "$soTienPhat")), // Số tiền phạt
                                "$Thue_TNCN_Phai_Nop", // Thêm thuế TNCN phải nộp
                                "$phiSuDungChuongTrinh", // Phí sử dụng chương trình
                                "$soTienOutSourcing", // Số tiền cho OutSourcing
                                new Document("$multiply", Arrays.asList("$soTienTrenNghi", "$soNgayNghi")), // Phí trên số ngày nghỉ
                                new Document("$sum", "$thieuChiTieu.soTienBoiThuong") // Tổng các số tiền bồi thường trong thieuChiTieu
                        ))
                )),

                // Bước 7: Tính Luong_Thuc_Lanh (Luong_Chua_Thue - Thue_TNCN_Phai_Nop - Loans - Expense - So_Tien_Dong_BaoHiem)
                project(new Document("Luong_Thuc_Lanh",
                        new Document("$subtract", Arrays.asList(
                                "$Luong_Chua_Thue",
                                "$Thue_TNCN_Phai_Nop",
                                "$Loans",
                                "$Expense",
                                "$So_Tien_Dong_BaoHiem"
                        ))
                ))
        )).iterator();

        long queryEndTime = System.currentTimeMillis(); // Kết thúc thời gian truy vấn
        long totalQueryTime = queryEndTime - startTime;

        // Tính thời gian aggregation
        long aggregationStartTime = System.currentTimeMillis();
        ThongKe thongKe = new ThongKe();
        if (cursor.hasNext()) {
            Document doc = cursor.next();
            thongKe.setLuongChuaThue(doc.getDouble("Luong_Chua_Thue"));
            thongKe.setLuongThucLanh(doc.getDouble("Luong_Thuc_Lanh"));
            thongKe.setThueTNCNPhaiNop(doc.getDouble("Thue_TNCN_Phai_Nop"));
            thongKe.setLoans(doc.getDouble("Loans"));
            thongKe.setExpense(doc.getDouble("Expense"));
            thongKe.setSoTienDongBaoHiem(doc.getDouble("So_Tien_Dong_BaoHiem"));
        }
        long aggregationEndTime = System.currentTimeMillis();
        long aggregationExecutionTime = aggregationEndTime - aggregationStartTime;

        thongKe.setThoiGianTruyVan(totalQueryTime);
        thongKe.setThoiGianThucHienAggregation(aggregationExecutionTime);

        return thongKe;
    }
}
