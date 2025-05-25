import 'package:book/Controller/cart_controller.dart';
import 'package:book/Controller/user_controller.dart';
import 'package:book/Model/cart.dart';
import 'package:book/PageHome/pagehome.dart';
import 'package:book/SignInSignUp/signin.dart';
import 'package:book/common/Common.dart';
import 'package:book/layout/note.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';


class PageGioHang extends StatefulWidget {
  const PageGioHang({super.key});

  @override
  State<PageGioHang> createState() => _PageGioHangState();
}

class _PageGioHangState extends State<PageGioHang> {
  final cartController = Get.find<CartController>();
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
                    Get.to(() =>  Note());
                },
                child: const Text("Thanh toán"),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<CartController>(
        id: "gh",
        init: cartController,
        builder: (controller) {
          AuthResponse response = Common.response!;
          return FutureBuilder<List<CartItem>>(
            future: GioHangSnapshot.getALL(response.user!.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Text("Loi cmnr"),
                );
              }
              else if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                List<CartItem> data = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
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
                                // Hình ảnh + Checkbox
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
                                // Thông tin sách + hành động
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              controller.decrease(index);
                                              controller.update(['item$index']);
                                            },
                                            icon: const Icon(Icons.remove_circle_outline),
                                          ),
                                          Text(
                                            "${item.sl}",
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              controller.increase(index);
                                              controller.update(['item$index']);
                                            },
                                            icon: const Icon(Icons.add_circle_outline),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              controller.removeItem(item.book);
                                              controller.update(['cart']);
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
