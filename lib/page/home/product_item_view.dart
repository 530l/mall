import 'package:flutter/material.dart';
import 'package:mall/widgets/com_image.dart';

class ProductItemView extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const ProductItemView({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ComImage(imageUrl,width: 60,height: 89,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(fontSize: 18, color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
