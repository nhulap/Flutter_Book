import 'package:book/Controller/user_controller.dart';
import 'package:book/Model/book.dart';
import 'package:book/Model/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  List<CartItem> cart = [];

  String address = "";
  String note = "";
  String name = "";
  String phone = "";
  static CartController get controller => Get.find<CartController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    UserController userController = Get.find<UserController>();
    cart = GioHangSnapshot.getALL(userController.userId.value) as List<CartItem>;
  }

  double totalPrice() {
    double total = 0;
    for (var item in cart) {
      if (item.selected) {
        total += item.book.gia * item.sl;
      }
    }
    return total;
  }


  void increase(int index) {
    cart[index].sl++;
    update(['count']);
    update(['totalPrice']);
  }

  void decrease(int index) {
    if (cart[index].sl > 1) {
      cart[index].sl--;
      update(['count']);
      update(['totalPrice']);
    }
  }

  void addressHandle(String addressText, String noteText, String nameText, String phoneText) {
    address = addressText.trim();
    note = noteText.trim();
    name = nameText.trim();
    phone = phoneText.trim();

    print("Thông tin giao hàng cập nhật:");
    print("Địa chỉ: $address");
    print("Ghi chú: $note");
    print("Tên: $name");
    print("Số điện thoại: $phone");

    update(['address', 'note', 'name', 'phone']); // notify UI nếu cần
  }




  void addToCart(Book book, int sum) {

    for (var item in cart) {
      if (item.book.id == book.id) {
        item.sl += sum;
        Get.snackbar("Đã thêm vào giỏ hàng", "");

        return;
      }
    }
    cart.add(CartItem(book: book, sl: sum, selected: true));
    Get.snackbar("Đã thêm vào giỏ hàng", "");
  }

  void selectedHandle(int index) {
    cart[index].selected = !cart[index].selected;
    update(['item$index', 'totalPrice', 'cart']); // thêm 'cart' nếu cần reload cả danh sách
  }


  List<CartItem> selectedItems() {
    return cart.where((item) => item.selected).toList();
  }


  void removeItem(Book item) {
    cart.removeWhere((i) => i.book.id == item.id);
    update(['cart']);
    update(['totalPrice']);
  }
}
