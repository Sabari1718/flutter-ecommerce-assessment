import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/local/product_local_data_source.dart';
import '../../../data/remote/product_remote_data_source.dart';
import '../../../data/repositories/product_repository.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DioClient.getDio());
    Get.lazyPut(() => ProductLocalDataSource());
    Get.lazyPut(
      () => ProductRemoteDataSource(dio: Get.find()),
    );
    Get.lazyPut(
      () => ProductRepository(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );
    Get.lazyPut(() => ProductController(repository: Get.find()));
  }
}
