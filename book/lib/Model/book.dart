class Book{
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

//
}