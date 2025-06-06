import 'package:book/Controller/cart_controller.dart';
import 'package:book/Model/cart.dart';
import 'package:book/common/Common.dart';
import 'package:book/layout/completed.dart';
import 'package:book/layout/pay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<TextEditingController> addressList = [];

class Note extends StatelessWidget {
  Note({super.key});

  final controller = Get.put(CartController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mainBlue = Colors.blue[700]!;
    final lightBlue = Colors.blue[200]!;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
                padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
            onPressed: () async {
              final auth = Common.response;
              if (auth != null) {
                controller.name = nameController.text;
                controller.phone = phoneController.text;
                controller.address = addressController.text;
                controller.note = noteController.text;

                await controller.createOrder(auth);

                // Nếu muốn chuyển trang sau khi tạo đơn hàng
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Completed(),
                  ),
                );
              } else {
                Get.snackbar("Lỗi", "Vui lòng đăng nhập để đặt hàng");
              }
            },

            child: const Text(
              "Thanh toán",
              style: TextStyle(color: Colors.white, fontSize: 25),
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
        backgroundColor: mainBlue,
        title: const Text(
          "Thông tin giao hàng",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Giao hàng", style: TextStyle(fontSize: 20)),
                  Text("Thanh toán", style: TextStyle(fontSize: 20)),
                  Text("Kiểm tra", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Thông tin giao hàng",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            buildInputField(
              "Họ và tên",
              nameController,
              Icons.person,
              mainBlue,
              onChanged: (value) {
                controller.name = nameController.text;
                controller.phone = phoneController.text;
                controller.address = addressController.text;
                controller.note = noteController.text;
              },

            ),
            const SizedBox(height: 15),
            buildInputField(
              "Số điện thoại",
              phoneController,
              Icons.phone,
              mainBlue,
              onChanged: (value) {
                controller.name = nameController.text;
                controller.phone = phoneController.text;
                controller.address = addressController.text;
                controller.note = noteController.text;
              },
            ),
            const SizedBox(height: 15),
            buildInputField(
                "Địa chỉ nhận hàng", addressController, Icons.location_on, mainBlue),
            const SizedBox(height: 15),
            buildInputField("Ghi chú đơn hàng", noteController, Icons.note, mainBlue),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
      String label,
      TextEditingController controller,
      IconData icon,
      Color mainBlue, {
        void Function(String)? onChanged,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,   // thêm onChanged ở đây
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: mainBlue),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: mainBlue, width: 2),
          ),
        ),
      ),
    );
  }

}
