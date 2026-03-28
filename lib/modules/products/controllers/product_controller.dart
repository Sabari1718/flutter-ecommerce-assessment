import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository repository;

  ProductController({required this.repository});

  final ScrollController scrollController = ScrollController();

  var allProducts = <ProductModel>[].obs;
  var displayedProducts = <ProductModel>[].obs;
  var categories = <String>[].obs;
  
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  // Pagination config
  final int itemsPerPage = 6;
  var currentPage = 1.obs;

  // Filters
  var searchQuery = ''.obs;
  var selectedCategory = ''.obs;
  var minPrice = 0.0.obs;
  var maxPrice = 1000.0.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
    scrollController.addListener(_onScroll);

    // Debounce search correctly
    debounce(searchQuery, (_) => _applyFilters(), time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final futures = await Future.wait([
        repository.getProducts(),
        repository.getCategories(),
      ]);

      allProducts.value = futures[0] as List<ProductModel>;
      final cat = futures[1] as List<String>;
      cat.insert(0, 'All'); // Add "All" option
      categories.value = cat;

      // Find max price for filter slider if products exist
      if (allProducts.isNotEmpty) {
        double highest = allProducts.map((e) => e.price).reduce((a, b) => a > b ? a : b);
        maxPrice.value = highest.ceilToDouble();
      }

      _applyFilters();
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      _loadNextPage();
    }
  }

  void _applyFilters() {
    var filtered = allProducts.where((product) {
      // 1. Search Query
      final matchesSearch = product.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      // 2. Category Filter
      final matchesCategory = selectedCategory.value.isEmpty || selectedCategory.value == 'All' || product.category == selectedCategory.value;
      // 3. Price Filter
      final matchesPrice = product.price >= minPrice.value && product.price <= maxPrice.value;

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    currentPage.value = 1;
    final int endIndex = (itemsPerPage < filtered.length) ? itemsPerPage : filtered.length;
    displayedProducts.value = filtered.sublist(0, endIndex);
  }

  void _loadNextPage() {
    var filtered = allProducts.where((product) {
      final matchesSearch = product.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesCategory = selectedCategory.value.isEmpty || selectedCategory.value == 'All' || product.category == selectedCategory.value;
      final matchesPrice = product.price >= minPrice.value && product.price <= maxPrice.value;
      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    final totalPages = (filtered.length / itemsPerPage).ceil();
    if (currentPage.value < totalPages) {
      currentPage.value++;
      final endIndex = (currentPage.value * itemsPerPage < filtered.length) 
          ? currentPage.value * itemsPerPage 
          : filtered.length;
          
      displayedProducts.value = filtered.sublist(0, endIndex);
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
    _applyFilters();
  }

  double _getAbsoluteMaxPrice() {
    if (allProducts.isEmpty) return 1000.0;
    return allProducts.map((e) => e.price).reduce((a, b) => a > b ? a : b).ceilToDouble();
  }

  bool get isFilterActive => 
      searchQuery.value.isNotEmpty || 
      (selectedCategory.value.isNotEmpty && selectedCategory.value != 'All') ||
      minPrice.value > 0.0 ||
      maxPrice.value < _getAbsoluteMaxPrice();

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    selectedCategory.value = '';
    minPrice.value = 0.0;
    maxPrice.value = _getAbsoluteMaxPrice();
    _applyFilters();
  }
}
