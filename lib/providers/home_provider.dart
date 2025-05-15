import 'package:flutter/material.dart';
import '../models/home_data.dart';

class HomeProvider extends ChangeNotifier {
  List<BannerItem> banners = [];
  List<ProductItem> products = [];
  bool loading = false;

  Future<void> fetchHomeData() async {
    loading = true;
    notifyListeners();
    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));
    banners = [
      BannerItem(
        "https://img.zcool.cn/community/01b72057a7e0790000018c1bf4fce0.png",
      ),
      BannerItem(
        "https://img.zcool.cn/community/016a2256fb63006ac7257948f83349.jpg",
      ),
      BannerItem(
        "https://img.zcool.cn/community/01233056fb62fe32f875a9447400e1.jpg",
      ),
      BannerItem(
        "https://img.zcool.cn/community/01700557a7f42f0000018c1bd6eb23.jpg",
      ),
    ];
    products = List.generate(
      12,
      (i) => ProductItem(
        'https://img.zcool.cn/community/016a2256fb63006ac7257948f83349.jpg',
        '商品${i + 1}',
        99.0 + i,
      ),
    );
    loading = false;
    notifyListeners();
  }
}
