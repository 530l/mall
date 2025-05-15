import 'package:flutter/material.dart';

// 定义回调函数类型
typedef IndexChangedCallback = void Function(int index);

class CusTabBarView extends StatefulWidget {
  // 添加回调函数参数
  final IndexChangedCallback? onIndexChanged;

  // 可选的初始索引
  final int initialIndex;

  const CusTabBarView({super.key, this.onIndexChanged, this.initialIndex = 0});

  @override
  State<CusTabBarView> createState() => _CusTabBarViewState();
}

class _CusTabBarViewState extends State<CusTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['推荐', '喂养用品', '洗护用品', '营养奶粉', '营养辅食', '尿裤'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    // 添加监听器
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // 在Tab开始切换时触发回调（indexIsChanging为true）
    if (_tabController.indexIsChanging) {
      // 调用回调函数
      if (widget.onIndexChanged != null) {
        widget.onIndexChanged!(_tabController.index);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white.withOpacity(0.7),
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white, width: 3.0)),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 14),
      tabs: _tabs.map((String tab) => Tab(text: tab)).toList(),
      padding: EdgeInsets.zero,
      indicatorPadding: EdgeInsets.zero,
      tabAlignment: TabAlignment.start,
    );
  }
}
