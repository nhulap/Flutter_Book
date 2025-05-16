
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

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.orange,
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
                      style:
                      const TextStyle(fontSize: 20, color: Colors.orange))
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<void>(
                    future: CartSnapShot.insert(
                      controller.cart,
                      (userController.userId.value),
                      controller.address,
                      controller.note,
                    ),
                    builder: (context, snapshot) {
                      return ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                              WidgetStatePropertyAll(Colors.orange)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  Completed(),
                            ));
                          },
                          child: const Text(
                            "Xác nhận đơn hàng",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ));
                    },
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
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
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
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
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
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "3",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
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
                    itemCount: controller.cart.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                    itemBuilder: (context, index) {
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
                                  child: Image.network(
                                      controller.cart[index].book.anh)),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.cart[index].book.tenSach,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${controller.cart[index].book.gia} \$",
                                          style: const TextStyle(
                                              color: Colors.orange, fontSize: 20),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    Text("Số lượng: ${controller.cart[index].sl}",
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
          )),
    );
  }
}
