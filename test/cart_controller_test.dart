import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ecom/data/local/cart_local_data_source.dart';
import 'package:ecom/data/models/cart_item_model.dart';
import 'package:ecom/data/models/product_model.dart';
import 'package:ecom/modules/cart/controllers/cart_controller.dart';

class FakeCartLocalDataSource implements CartLocalDataSource {
  List<CartItemModel> savedCart = [];

  @override
  List<CartItemModel> getCart() => savedCart;

  @override
  Future<void> saveCart(List<CartItemModel> items) async {
    savedCart = items;
  }
}

void main() {
  late CartController cartController;
  late FakeCartLocalDataSource fakeDataSource;

  setUp(() {
    fakeDataSource = FakeCartLocalDataSource();
    cartController = CartController(localDataSource: fakeDataSource);
    cartController.onInit();
    Get.testMode = true; 
  });

  tearDown(() {
    Get.reset();
  });

  final dummyProduct = ProductModel(
    id: 1,
    title: 'Test Product',
    price: 100.0,
    description: 'Test description',
    category: 'Test category',
    image: 'test_image.jpg',
    rating: Rating(rate: 4.5, count: 10),
  );

  test('Initial cart items should be empty', () {
    expect(cartController.cartItems.length, 0);
  });

  test('Add item to cart', () {
    cartController.addToCart(dummyProduct);

    expect(cartController.cartItems.length, 1);
    expect(cartController.cartItems[0].product.id, dummyProduct.id);
    expect(cartController.cartItems[0].quantity, 1);
    expect(cartController.totalItems, 1);
    expect(cartController.totalPrice, 100.0);
  });

  test('Increment item quantity', () {
    cartController.addToCart(dummyProduct);
    cartController.incrementQuantity(dummyProduct.id);

    expect(cartController.cartItems[0].quantity, 2);
    expect(cartController.totalItems, 2);
    expect(cartController.totalPrice, 200.0);
  });
  
  test('Do not increment beyond max limit', () {
    cartController.addToCart(dummyProduct);
    // Max is 5, add 1 is initial, increment 4 times
    cartController.incrementQuantity(dummyProduct.id);
    cartController.incrementQuantity(dummyProduct.id);
    cartController.incrementQuantity(dummyProduct.id);
    cartController.incrementQuantity(dummyProduct.id);
    
    // Attempt 6th
    cartController.incrementQuantity(dummyProduct.id);

    expect(cartController.cartItems[0].quantity, 5);
  });

  test('Decrement item quantity', () {
    cartController.addToCart(dummyProduct);
    cartController.incrementQuantity(dummyProduct.id); // quantity = 2
    cartController.decrementQuantity(dummyProduct.id); // quantity = 1

    expect(cartController.cartItems[0].quantity, 1);
    expect(cartController.totalPrice, 100.0);
  });

  test('Decrement to 0 removes item', () {
    cartController.addToCart(dummyProduct); // quantity is 1
    cartController.decrementQuantity(dummyProduct.id); // quantity becomes 0

    expect(cartController.cartItems.length, 0);
  });
}
