import 'package:book/PageHome/PageHome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Pagehome(),)
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Đăng ký thất bại. Vui lòng thử lại.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang Đăng Ký"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Email"),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Nhập email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            const Text("Mật khẩu"),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Nhập mật khẩu',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: _loading ? null : _signUp,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Đăng ký"),
            ),
          ],
        ),
      ),
    );
  }
}
// phan biet
