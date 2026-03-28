import 'package:hive/hive.dart';
import '../../core/constants/hive_keys.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  final Box _box = Hive.box(HiveKeys.productBox);

  Future<void> cacheProducts(List<ProductModel> products) async {
    final list = products.map((e) => e.toJson()).toList();
    await _box.put('cached_products', list);
  }

  List<ProductModel> getCachedProducts() {
    final list = _box.get('cached_products', defaultValue: []);
    if (list is List) {
      return list.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }
}
