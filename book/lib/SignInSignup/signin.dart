import 'package:book/Controller/cart_controller.dart';
import 'package:book/Controller/user_controller.dart';
import 'package:book/PageHome/pagehome.dart';
import 'package:book/common/Common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

AuthResponse? response;

class LoginPage extends StatelessWidget {
  // final Login_Controller loginController = Get.put(Login_Controller());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final CartController cartController = Get.put(CartController());
  final UserController userController = Get.put(UserController());
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng Nhập"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            SupaEmailAuth(
                onSignInComplete: (res) {
                  Common.response = res;
                  final uid = res.user!.id;
                  userController.fetchUserByUUID(uid);
                  cartController.auth(res);
                  Get.to(() => PageHome());
                },
                onSignUpComplete: (response) {

              },
              showConfirmPasswordField: true,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
