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

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController nicknameController;

  @override
  void initState() {
    super.initState();
    _userDataSnapshot();
  }


  void _userDataSnapshot() async {
    final data = await userController.getUserWithOrders(userController.userId.value);
    final user = data['User'] as ModelUser;
    setState(() {
      _userData = data;
      // nicknameController chứa tên
      nicknameController = TextEditingController(text: user.tenKH);
      // nameController chứa nickname
      nameController = TextEditingController(text: user.nickname);
      phoneController = TextEditingController(text: user.soDienThoai);
      addressController = TextEditingController(text: user.diaChi);
      emailController = TextEditingController(text: user.email);
    });

  }

  void _saveChanges() async {
    final updatedUser = ModelUser(
      id: userController.userId.value,
      tenKH: nicknameController.text,   // Lưu tên lấy từ trường "Tên"
      soDienThoai: phoneController.text,
      diaChi: addressController.text,
      email: emailController.text,
      nickname: nameController.text,    // Lưu nickname lấy từ trường "Nickname"
      password: '',
    );

    await userController.updateUser(updatedUser);
    Get.snackbar('Thành công', 'Thông tin đã được cập nhật');
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://th.bing.com/th/id/OIP.PKJ8TgPSGpaH01VGkwvQNgHaHa?w=163&h=180&c=7&r=0&o=5&cb=iwc2&dpr=1.3&pid=1.7'
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Hiển thị ID người dùng
            Text(
              'ID: ${_userData!['User'].id}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Các trường thông tin theo thứ tự: Nickname, Tên, SĐT, Địa chỉ, Email
            _buildEditableField('Nickname:', nameController),
            _buildEditableField('Tên:', nicknameController),
            _buildEditableField('SĐT:', phoneController),
            _buildEditableField('Địa chỉ:', addressController),
            _buildEditableField('Email:', emailController),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Lưu thay đổi'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            const Divider(height: 40),
            const Text(
              'Hóa đơn đã đặt:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...(_userData!['Orders'] as List<dynamic>)
                .map((order) => _buildOrderCard(order))
                .toList(),
          ],
        ),
      ),

    );
  }


  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final bookJson = (order['Order_items'] as List).isNotEmpty
        ? order['Order_items'][0]['book']
        : null;

    return Card(
      child: ListTile(
        title: Text('Mã đơn: ${order['id']}'),
        subtitle: Text(
          'Tổng: ${order['tinhTien']} VND\nĐịa chỉ: ${order['diaChi']}\nNgày: ${order['ngayTao'].toString().split('T')[0]}',
        ),
        onTap: () {
          if (bookJson != null) {
            final book = Book.fromJson(bookJson);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => Detail(book: book)));
          }
        },
      ),
    );
  }
}


