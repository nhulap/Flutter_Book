import 'package:book/Controller/user_controller.dart';  // Giữ lại import này
import 'package:book/Model/book.dart';
import 'package:book/model/user.dart';
import 'package:book/SignInSignUp/signin.dart';
import 'package:book/layout/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// cần để dùng Book.fromJson

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserController userController = Get.put(UserController());
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _userDataSnapshot();
  }

  void _userDataSnapshot() async {
    final data = await userController.getUserWithOrders(userController.userId.value);
    setState(() {
      _userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!userController.isLoggedIn.value) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _userData!['User'] as ModelUser;
    final orders = _userData!['Orders'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
        actions: [
          TextButton(
            onPressed: () {
              userController.clearUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
              );
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin người dùng
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/019/896/008/original/male-user-avatar-icon-in-flat-design-style-person-signs-illustration-png.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${user.id}', style: const TextStyle(fontSize: 16)),
                      Text('Tên: ${user.tenKH}', style: const TextStyle(fontSize: 16)),
                      Text('SĐT: ${user.soDienThoai}', style: const TextStyle(fontSize: 16)),
                      Text('Địa chỉ: ${user.diaChi}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Hóa đơn đã đặt:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: orders.isEmpty
                  ? const Center(child: Text("Bạn chưa có đơn hàng nào"))
                  : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Mã hóa đơn: ${order['id']}'),
                      subtitle: Text(
                        'Tổng giá: ${order['tinhTien']} VND\n'
                            'Địa chỉ giao hàng: ${order['diaChi'] ?? 'Chưa có'}\n'
                            'Ngày đặt: ${order['ngayTao'].toString().split('T')[0]}',
                      ),
                      onTap: () {
                        final orderItems = order['Order_items'] as List<dynamic>? ?? [];
                        if (orderItems.isNotEmpty) {
                          final bookJson = orderItems[0]['book'];
                          final book = Book.fromJson(bookJson);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(book: book),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

