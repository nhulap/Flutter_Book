
import 'package:book/Model/book.dart';
import 'package:book/Model/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final List<CartItem> cart = [];
  final List<String> address = [];

  static CartController get controller => Get.find<CartController>();

  double totalPrice() {
    double sum = 0;
    for (CartItem cartItem in cart) {
      if (cartItem.selected) {
        sum += cartItem.soLuong * cartItem.book.gia;
      }
    }
    return sum;
  }

  void increase(int index) {
    cart[index].soLuong++;
    update(['count']);
    update(['totalPrice']);
  }

  void decrease(int index) {
    if (cart[index].soLuong > 1) {
      cart[index].soLuong--;
    } else {
      cart.removeAt(index);
    }
    update(['count']);
    update(['totalPrice']);
  }

  void addressHandle(List<TextEditingController> addressList) {
    for (int i = 0; i < addressList.length; i++) {
      address.insert(i, addressList[i].text.toString());
    }
  }

  void addToCart(Book book, int sum) {
    for (var item in cart) {
      if (item.book.id == book.id) {
        item.soLuong += sum;
        Get.snackbar("Đã thêm vào giỏ hàng", "");
        update(['cart', 'totalPrice']);
        return;
      }
    }
    cart.add(CartItem(book: book, selected: true, soLuong: sum));
    Get.snackbar("Đã thêm vào giỏ hàng", "");
    update(['cart', 'totalPrice']);
  }

  void selectedHandle(int index) {
    cart[index].selected = !cart[index].selected;
    update(['selected$index']);
    update(['totalPrice']);
  }

  void removeItem(Book item) {
    cart.removeWhere((i) => i.book.id == item.id);
    update(['cart']);
    update(['totalPrice']);
  }
}

class GetXControllerIDCart extends GetxController {
  int count = 1;

  void increase() {
    count++;
    update(['count']);
  }

  void decrease() {
    if (count > 1) count--;
    update(['count']);
  }

  void setStart() {
    count = 1;
    update(['count']);
  }
}
