import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 19, vertical: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(0),
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                currentIndex == 0
                    ? 'assets/icons/news_select.svg'
                    : 'assets/icons/news_disable.svg',
                width: 40,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(1),
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                currentIndex == 1
                    ? 'assets/icons/news_favorite_select.svg'
                    : 'assets/icons/news_favorite_disable.svg',
                width: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
