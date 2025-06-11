import 'package:book/Controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = Get.find<UserController>();
  final SupabaseClient client = Supabase.instance.client;

  late TextEditingController tenController;
  late TextEditingController emailController;
  late TextEditingController sdtController;
  late TextEditingController diaChiController;
  late TextEditingController nicknameController;

  @override
  void initState() {
    super.initState();
    final user = userController.userInfo.value!;
    tenController = TextEditingController(text: user.tenKH);
    emailController = TextEditingController(text: user.email);
    sdtController = TextEditingController(text: user.soDienThoai);
    diaChiController = TextEditingController(text: user.diaChi);
    nicknameController = TextEditingController(text: user.nickname ?? '');
  }

  Future<List<Map<String, dynamic>>> getLichSuGiaoDich(String uuid) async {
    final response = await client
        .from("Orders")
        .select()
        .eq("user_id", uuid)
        .order("ngayTao", ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    final user = userController.userInfo.value!;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ sơ cá nhân"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form thông tin người dùng
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: tenController,
                      decoration: const InputDecoration(labelText: 'Họ tên'),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: sdtController,
                      decoration: const InputDecoration(labelText: 'Số điện thoại'),
                    ),
                    TextFormField(
                      controller: diaChiController,
                      decoration: const InputDecoration(labelText: 'Địa chỉ'),
                    ),
                    TextFormField(
                      controller: nicknameController,
                      decoration: const InputDecoration(labelText: 'Biệt danh (nếu có)'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await userController.updateUserInfo(
                          tenKH: tenController.text.trim(),
                          email: emailController.text.trim(),
                          soDienThoai: sdtController.text.trim(),
                          diaChi: diaChiController.text.trim(),
                          nickname: nicknameController.text.trim(),
                        );
                        setState(() {}); // Cập nhật UI sau khi lưu
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Lưu thông tin"),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🧾 Lịch sử giao dịch",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: getLichSuGiaoDich(user.uuid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final orders = snapshot.data!;
                  if (orders.isEmpty) {
                    return const Center(child: Text("Chưa có đơn hàng nào."));
                  }

                  return ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final ngayTao = DateTime.tryParse(order['ngayTao']) ?? DateTime.now();
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long, color: Colors.green),
                          title: Text("Đơn hàng #${order['id']}"),
                          subtitle: Text("Ngày: ${DateFormat('dd/MM/yyyy').format(ngayTao)}"),
                          trailing: Text(
                            currencyFormat.format(order['tinhTien']),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                        ),
                      );
                    },
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
