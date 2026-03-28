import 'package:get/get.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_page.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_page.dart';
import '../modules/products/bindings/product_binding.dart';
import '../modules/products/views/product_list_page.dart';
import '../modules/wishlist/views/wishlist_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartPage(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistPage(),
    ),
  ];
}
