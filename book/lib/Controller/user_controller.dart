import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user.dart';

class UserController extends GetxController {
  var userId = 0.obs;
  var isLoggedIn = false.obs;

  void setUser(int id) {
    userId.value = id;
    isLoggedIn.value = true;
  }

  void clearUser() {
    userId.value = 0;
    isLoggedIn.value = false;
  }

  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> getUserWithOrders(int userId) async {
    try {
      final userData = await _client
          .from('User')
          .select('*')
          .eq('id', userId)
          .maybeSingle();

      if (userData == null) {
        return {
          'User': null,
          'Orders': [],
        };
      }

      final ordersData = await _client
          .from('Orders')
          .select('id, ngayTao, tinhTien, diaChi, '
          'Order_items(id, soLuongitem, giaBan, trangThai, '
          'Book(id, tenSach, tacGia, nhaXB, gia, anh, moTa))')
          .eq('user_id', userId);

      return {
        'User': ModelUser.fromJson(userData),
        'Orders': ordersData,
      };
    } catch (e) {
      throw Exception('Không thể tải thông tin người dùng: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getOrderDetails(int orderId) async {
    try {
      final orderDetails = await _client
          .from('Order_items')
          .select(
          'id, soLuongitem, giaBan, trangThai, book(id, tenSach, author, publisher, gia, anh, moTa)')
          .eq('order_id', orderId) as List<dynamic>?;

      return orderDetails?.map((e) => e as Map<String, dynamic>).toList() ?? [];
    } catch (e) {
      throw Exception('Không thể tải chi tiết đơn hàng: $e');
    }
  }

  Future<void> updateState(int orderItemId, String newState) async {
    try {
      await _client
          .from('Order_items')
          .update({'trangThai': newState})
          .eq('id', orderItemId);
    } catch (e) {
      throw Exception('Không thể cập nhật trạng thái: $e');
    }
  }

  Future<void> updateUser(ModelUser user) async {
    try {
      await _client
          .from('User')
          .update({
        'tenKH': user.tenKH,
        'soDienThoai': user.soDienThoai,
        'diaChi': user.diaChi,
        'email': user.email,
        'nickname': user.nickname,
        // Nếu bạn có password, hoặc các trường khác thì thêm vào đây
      })
          .eq('id', user.id);
    } catch (e) {
      throw Exception('Không thể cập nhật thông tin người dùng: $e');
    }
  }


}
