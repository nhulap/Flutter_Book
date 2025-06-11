import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user.dart';

class UserController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  var uuid = ''.obs; // UUID từ Supabase Auth
  var userInfo = Rxn<ModelUser>(); // Dữ liệu người dùng

  Future<void> fetchUserByUUID(String uid) async {
    final res = await _client
        .from("User")
        .select()
        .eq("uuid", uid)
        .maybeSingle();

    if (res != null) {
      userInfo.value = ModelUser.fromJson(res);
      uuid.value = uid;
    } else {
      // Có thể tự động tạo bản ghi nếu chưa có
    }
  }

  void clearUser() {
    uuid.value = '';
    userInfo.value = null;
  }

  Future<void> updateUserInfo({
    required String tenKH,
    required String email,
    required String soDienThoai,
    required String diaChi,
    required String nickname,
  }) async {
    final user = userInfo.value;
    if (user == null) return;

    try {
      await Supabase.instance.client
          .from("User")
          .update({
        "tenKH": tenKH,
        "email": email,
        "soDienThoai": soDienThoai,
        "diaChi": diaChi,
        "nickname": nickname,
      })
          .eq("uuid", user.uuid);

      // Cập nhật local
      userInfo.value = user.copyWith(
        tenKH: tenKH,
        email: email,
        soDienThoai: soDienThoai,
        diaChi: diaChi,
        nickname: nickname,
      );
      Get.snackbar("Thành công", "Đã cập nhật thông tin");
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể cập nhật: $e");
    }
  }

}
