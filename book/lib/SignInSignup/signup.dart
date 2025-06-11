import 'package:book/PageHome/Pagehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../Async/asyncwidget.dart';
import '../layout/profile.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SupaEmailAuth(
                showConfirmPasswordField: true,
                onSignInComplete: (_) => Navigator.pop(context),
                onSignUpComplete: (res) {
                  if (res.user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PageVerifyOTP(
                          email: res.user!.email!,
                          name: _nameController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageVerifyOTP extends StatelessWidget {
  final String email;
  final String name;

  const PageVerifyOTP({super.key, required this.email, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xác thực OTP")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtpTextField(
            numberOfFields: 6,
            borderColor: const Color(0xFF512DA8),
            showFieldAsBox: true,
            onSubmit: (code) async {
              try {
                final res = await Supabase.instance.client.auth.verifyOTP(
                  email: email,
                  token: code,
                  type: OtpType.email,
                );

                final user = res.user;
                if (user != null) {
                  // Lưu user vào bảng User (với tên không null)
                  await Supabase.instance.client.from('User').upsert({
                    'uuid': user.id,
                    'email': user.email,
                    'tenKH': 'Chưa đặt tên',
                    'soDienThoai': '',
                    'diaChi': '',
                    'password': '',
                    'nickname': '',
                  });

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PageHome()),
                  );
                } else {
                  _showError(context, "Không xác thực được. Vui lòng kiểm tra mã OTP.");
                }
              } catch (e) {
                _showError(context, "Xác thực thất bại: $e");
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              showSnackBar(context, message: "Đang gửi OTP...", seconds: 600);
              await Supabase.instance.client.auth.signInWithOtp(email: email);
              showSnackBar(context, message: "Mã OTP đã gửi lại tới $email", seconds: 3);
            },
            child: const Text("Gửi lại OTP"),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: const Text("Lỗi"), content: Text(message)),
    );
  }
}
