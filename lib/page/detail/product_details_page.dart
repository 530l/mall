import 'package:flutter/material.dart';

// 商品详情页占位
class ProductDetailPage extends StatelessWidget {
  final dynamic product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Center(
        child: Text('这里是商品详情页：\n${product.title}', textAlign: TextAlign.center),
      ),
    );
  }
}
