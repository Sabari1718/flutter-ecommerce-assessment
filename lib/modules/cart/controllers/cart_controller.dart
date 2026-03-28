import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/local/cart_local_data_source.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final CartLocalDataSource localDataSource;
  
  CartController({required this.localDataSource});

  var cartItems = <CartItemModel>[].obs;
  
  // Max quantity limit as requested
  final int maxQuantityPerItem = 5;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
    // Save to Hive whenever cartItems changes
    ever(cartItems, (_) => _saveCart());
  }

  void _loadCart() {
    cartItems.value = localDataSource.getCart();
  }

  void _saveCart() {
    localDataSource.saveCart(cartItems);
  }

  void addToCart(ProductModel product) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (cartItems[index].quantity < maxQuantityPerItem) {
        cartItems[index].quantity++;
        cartItems.refresh();
        AppSnackbar.showSuccess('Added to Cart', 'Item quantity increased');
      } else {
        AppSnackbar.showError('Limit Reached', 'You can only add up to $maxQuantityPerItem items.');
      }
    } else {
      cartItems.add(CartItemModel(product: product, quantity: 1));
      AppSnackbar.showSuccess('Added to Cart', 'Item added successfully');
    }
  }

  void incrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (cartItems[index].quantity < maxQuantityPerItem) {
        cartItems[index].quantity++;
        cartItems.refresh();
      } else {
        AppSnackbar.showError('Limit Reached', 'You can only add up to $maxQuantityPerItem items.');
      }
    }
  }

  void decrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        // Remove if quantity becomes 0
        removeFromCart(productId);
      }
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    AppSnackbar.showInfo('Removed', 'Item removed from cart.');
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
