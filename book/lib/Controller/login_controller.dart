import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../PageHome/pagehome.dart';
import 'user_controller.dart';

class Login_Controller extends GetxController {
  final supabase = Supabase.instance.client;

  Future<void> login(String tenKH, String password) async {
    if (tenKH.isEmpty || password.isEmpty) {
      if (Get.context != null) {
        Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin');
      } else {
        print('Không thể hiển thị snackbar vì context null');
      }
      return;
    }

    print("Bắt đầu kiểm tra username: $tenKH - password: $password");

    try {
      final loginUser = await supabase
          .from('User') // đảm bảo bảng đúng tên
          .select()
          .eq('tenKH', tenKH)
          .eq('password', password)
          .maybeSingle();

      print("Kết quả truy vấn: $loginUser");

      if (loginUser != null) {
        final id = loginUser['id'];
        Get.find<UserController>().setUser(id);
        if (Get.context != null) {
          Get.snackbar('Thành công', 'Đăng nhập thành công');
        }
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
