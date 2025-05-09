
class Book {
  final int id;
  final String tenSach;
  final DateTime ngayXB;
  final String tacGia;
  final String nhaXB;
  final int loaiID;
  final double gia;
  final String moTa;
  final int soLuong;
  final String anh;

  Book({
    required this.id,
    required this.tenSach,
    required this.ngayXB,
    required this.tacGia,
    required this.nhaXB,
    required this.gia,
    required this.moTa,
    required this.soLuong,
    required this.anh,
    required this.loaiID,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "tenSach": this.tenSach,
      "ngayXB": this.ngayXB.toIso8601String(),
      "tacGia": this.tacGia,
      "nhaXB": this.nhaXB,
      "loaiID": this.loaiID,
      "gia": this.gia,
      "moTa": this.moTa,
      "soLuong": this.soLuong,
      "anh": this.anh,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      tenSach: json["tenSach"],
      ngayXB: DateTime.parse(json["ngayXB"]),
      tacGia: json["tacGia"],
      nhaXB: json["nhaXB"],
      loaiID: json["loaiID"],
      gia: json["gia"].toDouble(),
      moTa: json["moTa"],
      soLuong: json["soLuong"],
      anh: json["anh"],
    );
  }

  // Danh sách sách bán chạy
  static List<Book> get bestSellerBooks => [
    Book(
      id: 1,
      tenSach: 'Sapiens: Lược sử loài người',
      ngayXB: DateTime(2014),
      tacGia: 'Yuval Noah Harari',
      nhaXB: 'NXB Tri Thức',
      loaiID: 1,
      gia: 200000,
      moTa: '',
      soLuong: 100,
      anh: 'https://cdn0.fahasa.com/media/catalog/product/2/0/2021sapiens-truyen-tranh-bia1_tap-2.jpg',
    ),
    Book(
      id: 2,
      tenSach: 'Đắc Nhân Tâm',
      ngayXB: DateTime(1936),
      tacGia: 'Dale Carnegie',
      nhaXB: 'NXB Tổng hợp',
      loaiID: 1,
      gia: 150000,
      moTa: '',
      soLuong: 100,
      anh: 'https://image.slidesharecdn.com/dacnhantam-130711230742-phpapp02/95/dac-nhan-tam-1-638.jpg?cb=1386407165',
    ),
    Book(
      id: 3,
      tenSach: 'Nhà Giả Kim',
      ngayXB: DateTime(1988),
      tacGia: 'Paulo Coelho',
      nhaXB: 'NXB Văn học',
      loaiID: 1,
      gia: 180000,
      moTa: '',
      soLuong: 100,
      anh: 'https://toplist.vn/images/800px/nha-gia-kim-paulo-coelho-4777.jpg',
    ),
    Book(
      id: 4,
      tenSach: 'Tư Duy Nhanh Và Chậm',
      ngayXB: DateTime(2011),
      tacGia: 'Daniel Kahneman',
      nhaXB: 'NXB Thế Giới',
      loaiID: 1,
      gia: 250000,
      moTa: '',
      soLuong: 100,
      anh: 'https://product.hstatic.net/200000654445/product/tu-duy-nhanh-va-cham-3_f20312ad5f1f48f085f8aedd439b4861_master.jpg',
    ),
    Book(
      id: 5,
      tenSach: 'Khi Hơi Thở Hóa Thinh Không',
      ngayXB: DateTime(2016),
      tacGia: 'Paul Kalanithi',
      nhaXB: 'NXB Thế Giới',
      loaiID: 1,
      gia: 120000,
      moTa: '',
      soLuong: 100,
      anh: 'https://imgv2-1-f.scribdassets.com/img/document/618926741/original/0ef38b48b1/1677826398?v=1',
    ),
    Book(
      id: 6,
      tenSach: 'Bí Mật Của May Mắn',
      ngayXB: DateTime(2004),
      tacGia: 'Rhonda Byrne',
      nhaXB: 'NXB Lao Động',
      loaiID: 1,
      gia: 150000,
      moTa: '',
      soLuong: 100,
      anh: 'https://cdn0.fahasa.com/media/catalog/product/b/i/bi_mat_cua_may_man.jpg',
    ),
  ];
}
