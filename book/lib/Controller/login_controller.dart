import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../PageHome/pagehome.dart';
import 'user_controller.dart';
import 'package:book/Controller/cart_controller.dart';

class Login_Controller extends GetxController {
  final supabase = Supabase.instance.client;

  Future<void> login(String nickname, String password) async {
    if (nickname.isEmpty || password.isEmpty) {
      if (Get.context != null) {
        Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin');
      } else {
        print('Không thể hiển thị snackbar vì context null');
      }
      return;
    }

    print("Bắt đầu kiểm tra username: $nickname - password: $password");

    try {
      final loginUser = await supabase
          .from('User')
          .select()
          .eq('nickname', nickname)
          .eq('password', password)
          .maybeSingle();

      print("Kết quả truy vấn: $loginUser");

      if (loginUser != null) {
        final id = loginUser['id'];
        //  Cập nhật userId
        Get.find<UserController>().setUser(id);
        // Merge local cart vào Supabase
        final cartController = CartController.controller;
        await cartController.mergeLocalCartToSupabase(id);
        //  Load lại giỏ hàng từ Supabase
        await cartController.loadCartItems();
        if (Get.context != null) {
          Get.snackbar('Thành công', 'Đăng nhập thành công');
        }
        // Điều hướng về trang chủ
        Get.off(() => const PageHome());
      } else {
        if (Get.context != null) {
          Get.snackbar('Lỗi', 'Tên đăng nhập hoặc mật khẩu không đúng');
        } else {
          print('Không thể hiển thị snackbar vì context null');
        }
      }
    } catch (error) {
      print("Lỗi xảy ra: $error");
      if (Get.context != null) {
        Get.snackbar('Lỗi', 'Có lỗi xảy ra: $error');
      } else {
        print("Không thể hiện snackbar vì context null");
      }
    }
  }
}
