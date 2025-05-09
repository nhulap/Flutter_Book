class User{
  final int id;
  final String tenKH;
  final int soDienThoai;
  final String diaChi;

  User({required this.id,required this.tenKH,required this.soDienThoai,required this.diaChi});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      tenKH: json["tenKH"],
      soDienThoai: json["soDienThoai"],
      diaChi: json["diaChi"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "tenKH": this.tenKH,
      "soDienThoai": this.soDienThoai,
      "diaChi": this.diaChi,
    };
  }

}
