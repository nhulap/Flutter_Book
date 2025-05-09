class Cart{
  final int idBook;
  final int idUser;
  final int soLuong;

  Cart({required this.idBook,required this.idUser,required this.soLuong});

  Map<String, dynamic> toJson() {
    return {
      "idBook": this.idBook,
      "idUser": this.idUser,
      "soLuong": this.soLuong,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      idBook: json["idBook"],
      idUser: json["idUser"],
      soLuong: json["soLuong"],
    );
  }


//
}