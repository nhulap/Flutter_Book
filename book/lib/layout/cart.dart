
import 'package:book/Controller/cart_controller.dart';
import 'package:book/Controller/user_controller.dart';
import 'package:book/PageHome/pagehome.dart';
import 'package:book/SignInSignUp/signin.dart';
import 'package:book/layout/note.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final controller = Get.find<CartController>(); // Dùng lại instance cũ
  final UserController userController = Get.find<UserController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.black12),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thành tiền"),
                    GetBuilder<CartController>(
                      id: 'totalPrice',
                      builder: (controller) {
                        return Text("${controller.totalPrice()} \$");
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                  onPressed: () async {
                    if (controller.totalPrice() == 0) {
                      Get.snackbar("Thông báo", "Quý khách chưa chọn sản phẩm");
                      return;
                    }
                    if (userController.userId.value == 0) {
                      // Người dùng chưa đăng nhập → chuyển sang LoginPage
                      final result = await Get.to(() => LoginPage());
                      if (result == 'logged_in') {
                        Get.to(() => LoginPage());
                      } else {
                        Get.snackbar("Thông báo", "Bạn cần đăng nhập để thanh toán");
                        // Hoặc quay lại trang chính
                        Get.offAll(() => PageHome());
                      }
                    } else {
                      // Đã đăng nhập rồi, đi thẳng trang xác nhận đơn hàng
                      Get.to(() => Note());
                    }
                  },
                  child: const Text("Thanh toán"),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<CartController>(
        id: 'cart', // dùng ID chung để rebuild toàn bộ
        builder: (controller) {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.cart.length,
            itemBuilder: (context, index) {
              final item = controller.cart[index];
              return GetBuilder<CartController>(
                id: 'item$index',
                builder: (_) {
                  return Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Image.network(item.book.anh, height: 120),
                            value: item.selected,
                            onChanged: (_) => controller.selectedHandle(index),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.book.tenSach),
                              const SizedBox(height: 8),
                              Text(
                                "${item.book.gia} \$",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.increase(index);
                                      controller.update(['item$index']);
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                  Text("${item.sl}"),
                                  IconButton(
                                    onPressed: () {
                                      controller.decrease(index);
                                      controller.update(['item$index']);
                                    },
                                    icon: const Icon(Icons.remove_circle_outline),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.removeItem(item.book);
                                      controller.update(['cart']);
                                    },
                                    icon: const Icon(Icons.delete, size: 30),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),

    );
  }
}
