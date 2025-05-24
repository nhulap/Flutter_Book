import 'package:book/Controller/cart_controller.dart';
import 'package:book/Controller/user_controller.dart';
import 'package:book/Model/cart.dart';
import 'package:book/layout/completed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOrders extends StatefulWidget {
  const CheckOrders({super.key});

  @override
  State<CheckOrders> createState() => _CheckOrdersState();
}

class _CheckOrdersState extends State<CheckOrders> {
  final CartController controller = Get.put(CartController());
  final UserController userController = Get.find<UserController>();
  late List<CartItem> selectedItems;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedItems = controller.selectedItems();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = controller.selectedItems();
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kiểm tra đơn hàng",
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 25, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        backgroundColor: Colors.blue,  // đổi sang xanh dương
      ),
      bottomNavigationBar: Container(
        height: 120,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tổng số tiền",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("${controller.totalPrice() + 12.00}",
                      style: const TextStyle(fontSize: 20, color: Colors.blue))
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.blue)),  // đổi sang xanh dương
                    onPressed: () async {
                      try {
                        await GioHangSnapshot.createOrderFromCart(
                          userController.userId.value,
                          controller.address,
                          controller.note,
                          controller.name,
                          controller.phone,
                        );
                        // Xoá giỏ hàng sau khi lưu
                        controller.cart.clear();
                        controller.update(['cart', 'totalPrice']);
                        // Điều hướng sang trang Completed
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Completed(),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lưu đơn hàng thất bại! Vui lòng thử lại.')),
                        );
                      }
                    },


                    child: const Text(
                      "Xác nhận đơn hàng",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: mediaQuery.size.width,
          height: (mediaQuery.size.height - mediaQuery.padding.top),
          color: Colors.blueGrey[50],
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.blue,  // đổi sang xanh dương
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 5,
                          width: 100,
                          child: ColoredBox(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(
                          height: 5,
                          width: 100,
                          child: ColoredBox(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 3, color: Colors.blue),
                        ),
                        child: const Text(
                          "3",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Giao hàng",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text("Thanh toán", style: TextStyle(fontSize: 20)),
                      Text("Kiểm tra", style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                child: const Row(
                  children: [
                    Text(
                      "Kiểm tra lại đơn hàng",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: selectedItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final item = selectedItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.network(item.book.anh),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.book.tenSach,
                                      style: const TextStyle(fontSize: 20)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text("${item.book.gia} \$",
                                          style: const TextStyle(
                                              color: Colors.blue, fontSize: 20)),
                                    ],
                                  ),
                                  Text("Số lượng: ${item.sl}",
                                      style: const TextStyle(fontSize: 20)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                    "Tôi đồng ý với các điều kiện, chính sách của cửa hàng"),
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
