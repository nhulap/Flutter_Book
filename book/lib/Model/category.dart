class Category{
  final int id;
  final String tenTheLoai;

  Category({required this.id,required this.tenTheLoai});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      tenTheLoai: json["tenTheLoai"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "tenTheLoai": this.tenTheLoai,
    };
  }

}