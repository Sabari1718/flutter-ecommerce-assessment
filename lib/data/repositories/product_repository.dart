import 'package:connectivity_plus/connectivity_plus.dart';
import '../local/product_local_data_source.dart';
import '../models/product_model.dart';
import '../remote/product_remote_data_source.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<ProductModel>> getProducts() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      final cached = localDataSource.getCachedProducts();
      if (cached.isEmpty) {
        throw Exception('No internet connection and no cached data available.');
      }
      return cached;
    }

    try {
      final products = await remoteDataSource.getProducts();
      await localDataSource.cacheProducts(products);
      return products;
    } catch (e) {
      final cached = localDataSource.getCachedProducts();
      if (cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw Exception('No internet connection.');
    }
    return await remoteDataSource.getCategories();
  }
}
