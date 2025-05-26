import 'package:book/Controller/user_controller.dart';
import 'package:book/Model/book.dart';
import 'package:book/Model/cart.dart';
import 'package:book/common/Common.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartController extends GetxController {
  final box = GetStorage();
  final SupabaseClient _client = Supabase.instance.client;
  List<CartItem> ghsp = [];
  List<CartItem> cart = []; // Giỏ hàng tạm khi chưa đăng nhập
  String address = "";
  String note = "";
  String name = "";
  String phone = "";

  static CartController get controller => Get.find<CartController>();
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

  // giỏ hàng local
  void loadLocalCart() {
    final data = box.read<List>('local_cart');
    if (data != null) {
      cart.clear();
      cart.addAll(data.map((e) => CartItem.fromJson(e)));
    }
  }

  void saveLocalCart() {
    final jsonList = cart.map((item) => item.toJson()).toList();
    box.write('local_cart', jsonList);
  }

  void addToLocalCart(Book book, int sl) {
    final existingIndex = cart.indexWhere((item) => item.book.id == book.id);
    if (existingIndex != -1) {
      cart[existingIndex].sl += sl;
    } else {
      cart.add(CartItem(book: book, sl: sl, selected: true));
    }
    Get.snackbar("Đã thêm vào giỏ hàng tạm", "");
  }

  // Future<void> mergeLocalCartToSupabase(int userId) async {
  //   final existingCartItems = await GioHangSnapshot.getALL(userId);
  //   for (var item in cart) {
  //     final existing = existingCartItems.firstWhereOrNull(
  //             (e) => e.book.id == item.book.id);
  //     if (existing != null) {
  //       existing.sl += item.sl;
  //       await GioHangSnapshot.update(existing, userId);
  //     } else {
  //       await GioHangSnapshot.insert(item, userId);
  //     }
  //   }
  //   cart.clear();
  // }

  // giỏ hàng trong supabase
  Future<void> loadCartItems() async {
    try {
      final data = await _client
          .from('Cart')
          .select('soLuong, Book(*)')
          .eq('user_id', userId);
      cart.clear();
      cart.addAll(
        (data as List).map((e) {
          final book = Book.fromJson(e['Book']);
          return CartItem(book: book, sl: e['soLuong'], selected: true);
        }).toList(),
      );
      update(['cart', 'totalPrice']);
    } catch (e) {
      print('Lỗi khi tải giỏ hàng: $e');
    }
  }

  Future<void> loadCartFromSupabase(int userId) async {
    // final List<CartItem> fetchedCart = await GioHangSnapshot.getALL(userId);
    // cart.clear();
    // cart.addAll(fetchedCart);
    // update(['cart']);
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
    // if (userId == 0) {
    //   addToLocalCart(book, sl);
    //   update(['cart', 'totalPrice']);
    //   return;
    // }
    //
    // final existingIndex = cart.indexWhere((item) => item.book.id == book.id);
    // try {
    //   if (existingIndex != -1) {
    //     final newQuantity = cart[existingIndex].sl + sl;
    //     await _client
    //         .from('Cart')
    //         .update({'soLuong': newQuantity})
    //         .eq('user_id', userId)
    //         .eq('book_id', book.id);
    //   } else {
    //     await _client.from('Cart').insert({
    //       'user_id': userId,
    //       'book_id': book.id,
    //       'soLuong': sl,
    //     });
    //   }
    //   await loadCartItems();
    // } catch (e) {
    //   print('Lỗi thêm/sửa sản phẩm vào giỏ hàng: $e');
    // }
    // update(['cart', 'totalPrice']);
  }

  Future<void> removeSelectedItems() async {
    final selected = cart.where((item) => item.selected).toList();
    for (var item in selected) {
      try {
        await _client
            .from('Cart')
            .delete()
            .eq('user_id', userId)
            .eq('book_id', item.book.id);
      } catch (e) {
        print('Lỗi khi xóa sản phẩm: $e');
      }
    }
    cart.removeWhere((item) => item.selected);
    update(['cart', 'totalPrice']);
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

  // chức năng trong giỏ hàng
  void refreshCart() {
    if (userId == 0) {
      loadLocalCart();
    } else {
      loadCartFromSupabase(userId);
    }
  }

  // void toggleSelectAll(bool selectAll) {
  //   for (var item in cart) {
  //     item.selected = selectAll;
  //   }
  //   update(['cart', 'totalPrice']);
  // }

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

  List<CartItem> selectedItems() {
    return cart.where((item) => item.selected).toList();
  }

  // Orders và và đia chỉ
  Future<void> addressHandle(String address, String note, String name, String phone) async {
    if (userId == 0) {
      Get.snackbar("Lỗi", "Vui lòng đăng nhập để lưu thông tin giao hàng");
      return;
    }

    try {
      await _client.from('User').update({
        'address': address,
        'note': note,
        'name': name,
        'phone': phone,
      }).eq('id', userId);
      Get.snackbar("Thành công", "Đã lưu thông tin giao hàng");
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể lưu thông tin: $e");
    }
  }

  Future<void> createOrder() async {
    final selected = selectedItems();
    if (selected.isEmpty) {
      Get.snackbar("Lỗi", "Không có sản phẩm nào được chọn để đặt hàng");
      return;
    }

    try {
      final orderRes = await _client.from('Orders').insert({
        'user_id': userId,
        'tinhTien': totalPrice(),
        'ghiChu': note,
        'address': address,
        'nguoiNhan': name,
        'phone': phone,
        'trangThai': 'pending',
        'ngayTao': DateTime.now().toIso8601String(),
      }).select().single();

      final orderId = orderRes['id'];

      for (var item in selected) {
        await _client.from('Order_items').insert({
          'order_id': orderId,
          'book_id': item.book.id,
          'soLuongitem': item.sl,
          'giaBan': item.book.gia,
        });
      }

      await removeSelectedItems();
      update(['cart', 'totalPrice']);
      Get.snackbar("Thành công", "Đơn hàng đã được tạo");
    } catch (e) {
      print("Lỗi tạo đơn hàng: $e");
      Get.snackbar("Lỗi", "Không thể tạo đơn hàng: $e");
    }
  }
}
