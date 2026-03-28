import 'package:hive/hive.dart';
import '../../core/constants/hive_keys.dart';
import '../models/cart_item_model.dart';

class CartLocalDataSource {
  final Box _box = Hive.box(HiveKeys.cartBox);

  Future<void> saveCart(List<CartItemModel> items) async {
    final list = items.map((e) => e.toJson()).toList();
    await _box.put('cached_cart', list);
  }

  List<CartItemModel> getCart() {
    final list = _box.get('cached_cart', defaultValue: []);
    if (list is List) {
      return list.map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }
}
