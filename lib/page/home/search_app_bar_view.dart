import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/com_image.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCAAAF),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Row(
            children: [
              ComImage(
                "assets/images/icon_crop_free.png",
                width: 24.w,
                height: 24.w,
              ),

              // Search bar
              Expanded(
                child: Container(
                  height: 32.w,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ComImage(
                        "assets/images/icon_search.png",
                        width: 24.w,
                        height: 24.w,
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        '大家都在搜: 惠氏',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Message icon with notification badge
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFAA33),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '4',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Menu icon
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.menu, color: Colors.white, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
