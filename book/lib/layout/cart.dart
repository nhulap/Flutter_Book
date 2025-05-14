
import 'package:book/Controller/cart_controller.dart';
import 'package:book/PageHome/pagehome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final controller = Get.put(CartController());

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
                onPressed: () {
                  if (controller.totalPrice() == 0) {
                    Get.snackbar("Thông báo", "Qúy khách chưa chọn sản phẩm");
                  } else {
                    Navigator.of(context).push(
                      // MaterialPageRoute(builder: (context) => AddressPage()),
                      MaterialPageRoute(builder: (context) => PageHome()),
                    );
                  }
                },
                child: const Text("Thanh toán"),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<CartController>(
        id: 'cart',
        builder: (controller) {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.cart.length,
            itemBuilder: (context, index) {
              final item = controller.cart[index];
              return Card(
                child: Row(
                  children: [
                    Expanded(
                      child: GetBuilder<CartController>(
                        id: 'selected$index',
                        builder: (_) {
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Image.network(item.book.anh, height: 120),
                            value: item.selected,
                            onChanged: (_) => controller.selectedHandle(index),
                          );
                        },
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
                                onPressed: () => controller.increase(index),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              Text("${item.soLuong}"),
                              IconButton(
                                onPressed: () => controller.decrease(index),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              IconButton(
                                onPressed: () => controller.removeItem(item.book),
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
      ),
    );
  }
}
