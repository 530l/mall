import 'package:flutter/material.dart';
import 'package:mall/page/cart/cart_page.dart';
import 'package:mall/page/category/category_page.dart';
import 'package:mall/page/home/home_view.dart';
import 'package:mall/page/profile/profile_page.dart';
import 'package:mall/test/nested_scrollview_demo_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _pages = [
    const HomePage(),
    const NestedScrollViewDemoPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("MainPage build");
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(), // 禁用左右滑动
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, -1),
              blurRadius: 4,
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: EdgeInsets.zero,
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(icon: Icon(Icons.home), text: '首页'),
            Tab(icon: Icon(Icons.category), text: '分类'),
            Tab(icon: Icon(Icons.shopping_cart), text: '购物车'),
            Tab(icon: Icon(Icons.person), text: '我的'),
          ],
        ),
      ),
    );
  }
}
