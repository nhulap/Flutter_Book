import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user.dart';

class UserController extends GetxController {
  var userId = 0.obs; // type RxInt
  void setUser(int id) {
    userId.value = id;
  }

  void clearUser() {
    userId.value = 0;
  }


}
