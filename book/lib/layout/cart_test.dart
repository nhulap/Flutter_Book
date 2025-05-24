import 'package:book/Controller/cart_controller.dart';
import 'package:book/Controller/user_controller.dart';
import 'package:book/Model/cart.dart';
import 'package:book/PageHome/pagehome.dart';
import 'package:book/SignInSignUp/signin.dart';
import 'package:book/layout/note.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PageGioHang extends StatefulWidget {
  const PageGioHang({super.key});

  @override
  State<PageGioHang> createState() => _PageGioHangState();
}

class _PageGioHangState extends State<PageGioHang> {
  final cartController = Get.put(CartController());
  final userController = Get.find<UserController>();

  Future<void>? _cartFuture;

  @override
  void initState() {
    super.initState();
    final userId = userController.userId.value;

    if (userId == 0) {
      cartController.loadLocalCart();
      cartController.update(['cart']);
      _cartFuture = Future.value();
    } else {
      _cartFuture = cartController.loadCartFromSupabase(userId);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                        return Text(
                          "${controller.totalPrice().toStringAsFixed(2)} \$",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (cartController.totalPrice() == 0) {
                    Get.snackbar("Thông báo", "Quý khách chưa chọn sản phẩm");
                    return;
                  }

                  if (userController.userId.value == 0) {
                    final result = await Get.to(() =>  LoginPage());
                    if (result == 'logged_in') {
                      Get.to(() =>  Note());
                    } else {
                      Get.snackbar("Thông báo", "Bạn cần đăng nhập để thanh toán");
                      Get.offAll(() => const PageHome());
                    }
                  } else {
                    Get.to(() =>  Note());
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
          return FutureBuilder(
            future: _cartFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Lỗi khi tải giỏ hàng"));
              } else {
                if (controller.cart.isEmpty) {
                  return const Center(child: Text("Giỏ hàng trống"));
                }
                return ListView.builder(
                  itemCount: controller.cart.length,
                  itemBuilder: (context, index) {
                    final item = controller.cart[index];
                    return GetBuilder<CartController>(
                      id: 'item$index',
                      builder: (_) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Checkbox(
                                      value: item.selected,
                                      onChanged: (_) => controller.selectedHandle(index),
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item.book.anh,
                                        height: 100,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.book.tenSach,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${item.book.gia} \$",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              await controller.decrease(index);
                                            },
                                            icon: const Icon(Icons.remove_circle_outline),
                                          ),
                                          Text("${item.sl}", style: const TextStyle(fontSize: 16)),
                                          IconButton(
                                            onPressed: () async {
                                              await controller.increase(index);
                                            },
                                            icon: const Icon(Icons.add_circle_outline),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () async {
                                              await controller.removeItem(item.book);
                                            },
                                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
