import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    
    // Local state for UI responsiveness before applying
    var tempMinPrice = controller.minPrice.value.obs;
    var tempMaxPrice = controller.maxPrice.value.obs;
    var tempSelectedCategory = controller.selectedCategory.value.obs;

    double absoluteMaxPrice = 1000.0;
    if (controller.allProducts.isNotEmpty) {
      double highest = controller.allProducts.map((e) => e.price).reduce((a, b) => a > b ? a : b);
      absoluteMaxPrice = highest.ceilToDouble();
    }

    if (tempMaxPrice.value > absoluteMaxPrice) {
      tempMaxPrice.value = absoluteMaxPrice;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Obx(() {
            return Wrap(
              spacing: 8,
              children: controller.categories.map((cat) {
                final isSelected = tempSelectedCategory.value == cat || (cat == 'All' && tempSelectedCategory.value.isEmpty);
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    tempSelectedCategory.value = cat == 'All' ? '' : cat;
                  },
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 24),
          const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Obx(() {
            return Column(
              children: [
                RangeSlider(
                  values: RangeValues(tempMinPrice.value, tempMaxPrice.value),
                  min: 0,
                  max: absoluteMaxPrice > 0 ? absoluteMaxPrice : 1000,
                  divisions: 20,
                  labels: RangeLabels(
                    '\$${tempMinPrice.value.toStringAsFixed(0)}',
                    '\$${tempMaxPrice.value.toStringAsFixed(0)}',
                  ),
                  onChanged: (RangeValues values) {
                    tempMinPrice.value = values.start;
                    tempMaxPrice.value = values.end;
                  },
                ),
                Text(
                  '\$${tempMinPrice.value.toStringAsFixed(0)} - \$${tempMaxPrice.value.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                controller.updateCategory(tempSelectedCategory.value == '' ? 'All' : tempSelectedCategory.value);
                controller.updatePriceRange(tempMinPrice.value, tempMaxPrice.value);
                Get.back();
              },
              child: const Text('Apply Filters', style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}
