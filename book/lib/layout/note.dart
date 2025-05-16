
import 'package:book/Controller/cart_controller.dart';
import 'package:book/PageHome/pagehome.dart';
import 'package:book/layout/pay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<TextEditingController> addressList = [];

class Note extends StatelessWidget {
  Note({super.key});

  final controller = Get.put(CartController());
  final TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.orange),
                padding: WidgetStatePropertyAll(EdgeInsets.all(20))),
            onPressed: () {
              controller.addressHandle(addressList, noteController.text);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentConfirmation(),
              ));
            },
            child: const Text(
              "Xác nhận địa chỉ",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 40),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.orange,
        title: const Text(
          "Thông tin giao hàng",
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 25, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
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
                    child: const Text(
                      "1",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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
                    decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.orange),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      "2",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: Colors.orange),
                    ),
                    child: const Text(
                      "3",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
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
            Container(
              padding: const EdgeInsets.only(left: 15, top: 20, bottom: 20),
              color: Colors.blueGrey[50],
              child: const Row(
                children: [
                  Text(
                    "Địa chỉ đặt hàng",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            textfield("Họ và tên người nhận", 0),
            textfield("SDT", 1),
            textfield("Quốc gia", 2),
            textfield("Tỉnh / Thành phố", 3),
            textfield("Quận / Huyện", 4),
            textfield("Phường / Xã", 5),
            textfield("Địa chỉ ", 6),
            textfield("Ghi chú đơn hàng", -1),
          ],
        ),
      ),
    );
  }
  Widget textfield(String title, int index) {
    TextEditingController controller;

    if (index == -1) {
      // Ghi chú
      controller = noteController;
    } else {
      if (addressList.length <= index) {
        addressList.insert(index, TextEditingController());
      }
      controller = addressList[index];
    }

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      subtitle: TextField(
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(width: 3, color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(width: 1, color: Colors.grey),
          ),
        ),
      ),
    );
  }

}
