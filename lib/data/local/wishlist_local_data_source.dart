import 'package:hive/hive.dart';
import '../../core/constants/hive_keys.dart';
import '../models/product_model.dart';

class WishlistLocalDataSource {
  final Box _box = Hive.box(HiveKeys.wishlistBox);

  Future<void> saveWishlist(List<ProductModel> items) async {
    final list = items.map((e) => e.toJson()).toList();
    await _box.put('cached_wishlist', list);
  }

  List<ProductModel> getWishlist() {
    final list = _box.get('cached_wishlist', defaultValue: []);
    if (list is List) {
      return list.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }
}
