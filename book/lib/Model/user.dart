class ModelUser{
  final int id;
  final String tenKH;
  final String soDienThoai;
  final String diaChi;
  final String password;

  ModelUser({required this.id,required this.tenKH,required this.soDienThoai,required this.diaChi,required this.password});

  // Hàm khởi tạo từ JSON
  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      id: json["id"],
      tenKH: json["tenKH"] ?? '',
      soDienThoai: json["soDienThoai"] ?? '',
      diaChi: json["diaChi"] ?? '',
      password: json["password"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "tenKH": this.tenKH,
      "soDienThoai": this.soDienThoai,
      "diaChi": this.diaChi,
      "password": this.password,
    };
  }

}
