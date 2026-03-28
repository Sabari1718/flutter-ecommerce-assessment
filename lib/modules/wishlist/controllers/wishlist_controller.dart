import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/local/wishlist_local_data_source.dart';
import '../../../data/models/product_model.dart';

class WishlistController extends GetxController {
  final WishlistLocalDataSource localDataSource;

  WishlistController({required this.localDataSource});

  var wishlistItems = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadWishlist();
    ever(wishlistItems, (_) => _saveWishlist());
  }

  void _loadWishlist() {
    wishlistItems.value = localDataSource.getWishlist();
  }

  void _saveWishlist() {
    localDataSource.saveWishlist(wishlistItems);
  }

  bool isWishlisted(int productId) {
    return wishlistItems.any((item) => item.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    if (isWishlisted(product.id)) {
      wishlistItems.removeWhere((item) => item.id == product.id);
      AppSnackbar.showInfo('Removed', '${product.title} removed from wishlist.');
    } else {
      wishlistItems.add(product);
      AppSnackbar.showSuccess('Added', '${product.title} added to wishlist.');
    }
  }
}
