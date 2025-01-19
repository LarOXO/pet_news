import 'package:flutter/material.dart';

class NewsCategoryList extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const NewsCategoryList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          'general',
          'business',
          'entertainment',
          'health',
          'science',
          'sports',
          'technology',
        ].map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.grey,
              selectedColor: Colors.blue,
              label: Text(
                category.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
            ),
          );
        }).toList(),
      ),
    );
  }
}
