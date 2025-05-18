class ModelUser{
  final int id;
  final String tenKH;
  final String soDienThoai;
  final String diaChi;
  final String password;
  final String nickname;
  final String email;

  ModelUser({required this.id,required this.tenKH,required this.soDienThoai,required this.diaChi,required this.password,required this.email,required this.nickname});

  // Hàm khởi tạo từ JSON
  factory ModelUser.fromJson(Map<String, dynamic> json) {
    return ModelUser(
      id: json["id"],
      tenKH: json["tenKH"] ?? '',
      soDienThoai: json["soDienThoai"] ?? '',
      diaChi: json["diaChi"] ?? '',
      password: json["password"] ?? '',
      nickname: json["nickname"] ?? '',
      email: json["email"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "tenKH": this.tenKH,
      "soDienThoai": this.soDienThoai,
      "diaChi": this.diaChi,
      "password": this.password,
      "nickname": this.nickname,
      "email": this.email,
    };
  }

}
