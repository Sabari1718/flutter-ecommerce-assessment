import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/hive_keys.dart';
import 'data/local/cart_local_data_source.dart';
import 'data/local/wishlist_local_data_source.dart';
import 'modules/cart/controllers/cart_controller.dart';
import 'modules/wishlist/controllers/wishlist_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await _initHive();

  runApp(const MyApp());
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.productBox);
  await Hive.openBox(HiveKeys.cartBox);
  await Hive.openBox(HiveKeys.wishlistBox);
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartLocalDataSource(), permanent: true);
    Get.put(CartController(localDataSource: Get.find()), permanent: true);
    
    Get.put(WishlistLocalDataSource(), permanent: true);
    Get.put(WishlistController(localDataSource: Get.find()), permanent: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.productList,
      getPages: AppPages.pages,
    );
  }
}
