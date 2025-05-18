import 'package:book/Controller/cart_controller.dart';
import 'package:book/Model/cart.dart';
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
                backgroundColor: MaterialStatePropertyAll(Colors.blue), // đổi sang màu xanh
                padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
            onPressed: () {
              // Cập nhật dữ liệu vào controller (chỉ lưu tạm)
              controller.addressHandle(
                addressController.text,
                noteController.text,
                nameController.text,
                phoneController.text,
              );

              // Chuyển sang trang Check (chưa gửi dữ liệu lên Supabase)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PaymentConfirmation()),
              );
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
            Padding(
              padding:
              const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: mainBlue),
                    ),
                    child: Text(
                      "1",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: mainBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: SizedBox(
                      height: 5,
                      width: 100,
                      child: ColoredBox(
                        color: lightBlue,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: mainBlue),
                    ),
                    child: Text(
                      "2",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: mainBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 5,
                      width: 100,
                      child: ColoredBox(
                        color: lightBlue,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: mainBlue),
                    ),
                    child: Text(
                      "3",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: mainBlue,
                        fontWeight: FontWeight.bold,
                      ),
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
                controller.addressHandle(
                  addressController.text,
                  noteController.text,
                  value,                // tên vừa nhập
                  phoneController.text, // giữ số điện thoại hiện tại
                );
              },
            ),
            const SizedBox(height: 15),
            buildInputField(
              "Số điện thoại",
              phoneController,
              Icons.phone,
              mainBlue,
              onChanged: (value) {
                controller.addressHandle(
                  addressController.text,
                  noteController.text,
                  nameController.text,  // giữ tên hiện tại
                  value,                // số điện thoại vừa nhập
                );
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
        void Function(String)? onChanged,  // thêm callback onChanged tùy chọn
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
