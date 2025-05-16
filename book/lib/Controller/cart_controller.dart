import 'package:book/Model/book.dart';
import 'package:book/Model/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final List<CartItem> cart = [];

  List<String> address = []; // giữ lại 1 khai báo duy nhất
  String note = ""; // thêm ghi chú

  static CartController get controller => Get.find<CartController>();

  double totalPrice() {
    double sum = 0;
    for (CartItem cartItem in cart) {
      if (cartItem.selected) {
        sum += cartItem.sl * cartItem.book.gia;
      }
    }
    return sum;
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

  void addressHandle(List<TextEditingController> addressList, String noteText) {
    address.clear(); // Xoá địa chỉ cũ nếu có
    for (int i = 0; i < addressList.length; i++) {
      address.insert(i, addressList[i].text.trim());
    }
    note = noteText.trim();
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
    update(['cart', 'totalPrice']); // Cập nhật lại giao diện và tổng tiền
  }

  void removeItem(Book item) {
    cart.removeWhere((i) => i.book.id == item.id);
    update(['cart']);
    update(['totalPrice']);
  }
}
