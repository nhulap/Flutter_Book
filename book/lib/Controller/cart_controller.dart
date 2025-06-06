import 'package:book/Controller/user_controller.dart';
import 'package:book/Model/book.dart';
import 'package:book/Model/cart.dart';
import 'package:book/common/Common.dart';
import 'package:book/main.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  List<CartItem> ghsp = [];
  List<CartItem> cart = [];

  String address = "";
  String note = "";
  String name = "";
  String phone = "";

  int get userId => Get.find<UserController>().userId.value;

  void auth(AuthResponse? response){
    if(response != null)
      getAll_GH(response.user!.id);
    else{
      ghsp =[];
      update(["gh"]);
    }
  }

  getAll_GH(String uuid) async{
    ghsp = await GioHangSnapshot.getALL(uuid);
    update(["gh"]);
  }

  @override
  void onInit() async {
    super.onInit();
    AuthResponse? res = Common.response;

    if (res != null) {
      ghsp = await GioHangSnapshot.getALL(res.user!.id);
    }
  }

  Future<void> addToCart(Book book, AuthResponse auth) async {

    CartItem cartItem = CartItem(book: book);
    for (var item in ghsp) {
      if (item.book.id == cartItem.book.id) {
        item.sl++;
        await GioHangSnapshot.delete(item.book.id, auth.user!.id);
        await GioHangSnapshot.update(item, auth.user!.id);
        return;
      }
    }
    ghsp.add(cartItem);
    await GioHangSnapshot.insert(cartItem, auth.user!.id);
  }

  Future<void> removeSelectedItems(String userId) async {
    final selected = ghsp.where((item) => item.selected).toList();

    for (var item in selected) {
      try {
        await GioHangSnapshot.delete(item.book.id, userId);
      } catch (e) {
        print('Lỗi khi xóa sản phẩm ${item.book.id}: $e');
      }
    }

    ghsp.removeWhere((item) => item.selected);
    update(['gh', 'totalPrice']);
  }



  Future<void> updateQuantity(int index, int newQuantity) async {
    await _client.from('Cart').update({'soLuong': newQuantity}).match({
      'user_id': userId,
      'book_id': cart[index].book.id,
    });
  }

  Future<void> removeItem(int idBook) async {
    AuthResponse res = Common.response!;
    ghsp.removeWhere((element) => element.book.id == idBook,);
    await GioHangSnapshot.delete(idBook, res.user!.id);

    update(["gh", "totalPrice"]);
  }


  void selectedHandle(int index) {
    cart[index].selected = !cart[index].selected;
    update(['item$index', 'totalPrice', 'cart']);
  }

  Future<void> increase(int idBook) async {
    AuthResponse res = Common.response!;
    CartItem item = ghsp.firstWhere((element) => element.book.id == idBook,);
    item.sl++;

    await GioHangSnapshot.delete(item.book.id, res.user!.id);
    await GioHangSnapshot.update(item, res.user!.id);

    update(["gh", "totalPrice"]);
  }

  Future<void> decrease(int idBook) async {
    AuthResponse res = Common.response!;
    CartItem item = ghsp.firstWhere((element) => element.book.id == idBook,);

    if (item.sl > 1) {
      item.sl--;
      await GioHangSnapshot.delete(item.book.id, res.user!.id);
      await GioHangSnapshot.update(item, res.user!.id);

      update(["gh", "totalPrice"]);
    }
  }

  double totalPrice() {
    double total = 0;
    for (var item in ghsp) {
      if (item.selected) {
        total += item.book.gia * item.sl;
      }
    }
    return total;
  }

  Future<void> createOrder(AuthResponse auth) async {

      // Lưu thông tin giao hàng
      final userId = auth.user!.id;
      final selectedItems = ghsp.where((item) => item.selected).toList();

      if (selectedItems.isEmpty) {
        Get.snackbar("Thông báo", "Vui lòng chọn ít nhất một sản phẩm.");
        return;
      }

      final response = await _client.from('Orders').insert({
        'user_id': supabase.auth.currentUser!.id,
        'tinhTien': totalPrice(),
        'ghiChu': note,
        'diaChi': address,
        'nguoiNhan': name,
        'phone': phone,
        'ngayTao': DateTime.now().toIso8601String(),
      }).select('id').single();
      final orderId = response['id'];
      final orderItems = selectedItems.map((item) => {
        'order_id': orderId,
        'book_id': item.book.id,
        'soLuongitem': item.sl,
        'giaBan': item.book.gia,
        'trangThai': 'chưa giao',
      }).toList();
      await _client.from('Order_items').insert(orderItems);

      // Xóa khỏi giỏ hàng sau khi đặt thành công
      await removeSelectedItems(userId);
      update(['gh', 'totalPrice']);
      Get.snackbar("Thành công", "Đơn hàng đã được tạo");

  }
}
