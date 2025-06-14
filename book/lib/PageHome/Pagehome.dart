import 'package:book/Controller/cart_controller.dart';
import 'package:book/Controller/user_controller.dart';
import 'package:book/common/Common.dart';
import 'package:book/layout/cart_test.dart';
import 'package:book/layout/detail.dart';
import 'package:book/SignInSignUp/signin.dart';
import 'package:book/SignInSignUp/signup.dart';
import 'package:book/layout/menu.dart';
import 'package:book/layout/profile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../Model/book.dart';
import '../Controller/book_controller.dart';
import 'package:get/get.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final List<String> imageUrls = [
    'https://static.vecteezy.com/system/resources/previews/021/916/224/non_2x/promo-banner-with-stack-of-books-globe-inkwell-quill-plant-lantern-ebook-world-book-day-bookstore-bookshop-library-book-lover-bibliophile-education-for-poster-cover-advertising-vector.jpg',
    'https://static.vecteezy.com/system/resources/previews/026/311/103/large_2x/literature-themed-banner-featuring-a-bookshelf-stack-of-hardcovered-books-and-copy-space-ai-generated-photo.jpg',
    'https://riskmanaged.com.au/wp-content/uploads/2017/10/books_banner_opt.jpg',
  ];

  final Book_Controller bookController = Get.put(Book_Controller());
  final UserController userController = Get.put(UserController());
  final CartController cartController = Get.put(CartController());


  @override
  Widget build(BuildContext context) {
    AuthResponse? res = Common.response;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Trang Chủ"),
        actions: [
            res == null ?
              // Chưa đăng nhập: hiện Sign In + Sign Up
              Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(width: 6),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              )
            :
              // Đã đăng nhập: hiện nút Profile và Sign Out
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.red, size: 28),
                    tooltip: 'Hồ sơ',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),

                  const SizedBox(width: 6),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        Common.response = null;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã đăng xuất')),
                      );
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel banner
            CarouselSlider(
              options: CarouselOptions(
                height: 100.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 16 / 9,
                autoPlayInterval: Duration(seconds: 3),
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Menu()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sản phẩm',
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.only(right: 100.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Các sản phẩm bán chạy trong tháng",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sử dụng FutureBuilder để lấy danh sách sách bán chạy
            FutureBuilder<List<Book>>(
              future: bookController.bestSellerBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có sản phẩm nào'));
                } else {
                  final books = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: books.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
                        final book = books[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detail(book: book),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    book.anh,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.tenSach,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.tacGia,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currencyFormat.format(book.gia),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthResponse? res = Common.response;
          if (res == null) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginPage(),)
            );
            return;
          }

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PageGioHang(),)
          );
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
