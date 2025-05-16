import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:mall/page/home/product_item_view.dart';
import 'package:mall/widgets/com_image.dart';
import 'package:provider/provider.dart';
import '../../models/home_data.dart';
import 'cus_tab_bar_view.dart';
import 'search_app_bar_view.dart';
import 'home_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../widgets/sliver.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // 滚动控制器
  final ScrollController outerScrollController = ScrollController();
  late SliverObserverController observerController;

  // 用于NestedScrollView的工具类
  final nestedScrollUtil = NestedScrollUtil();

  // 全局Key
  GlobalKey nestedScrollViewKey = GlobalKey();
  GlobalKey appBarKey = GlobalKey();
  GlobalKey tabBarKey = GlobalKey();

  // TabController
  late TabController tabController;

  // 上下文引用
  BuildContext? _sliverHeaderCtx;
  BuildContext? _sliverBodyCtx;

  @override
  void initState() {
    super.initState();

    // 初始化TabController
    tabController = TabController(length: 6, vsync: this);

    // 初始化观察者控制器
    observerController = SliverObserverController(
      controller: outerScrollController,
    );

    // 设置外部滚动控制器
    nestedScrollUtil.outerScrollController = outerScrollController;
  }

  @override
  void dispose() {
    outerScrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  //使用 NestedScrollView 实现吸顶效果
  Widget _buildPage(BuildContext context) {
    final provider = context.read<HomeProvider>();

    return SliverViewObserver(
      controller: observerController,
      child: _buildNestedScrollView(),
      sliverContexts: () {
        return [
          if (_sliverHeaderCtx != null) _sliverHeaderCtx!,
          if (_sliverBodyCtx != null) _sliverBodyCtx!,
        ];
      },
      customOverlap: (sliverContext) {
        return nestedScrollUtil.calcOverlap(
          nestedScrollViewKey: nestedScrollViewKey,
          sliverContext: sliverContext,
        );
      },
      onObserveAll: (result) {
        result.forEach((key, value) {
          if (key == _sliverHeaderCtx) {
            debugPrint("SliverHeaderCtx: ${value.displayingChildIndexList}");
          } else if (key == _sliverBodyCtx) {
            debugPrint("SliverBodyCtx: ${value.displayingChildIndexList}");
          }
        });
      },
    );
  }

  Widget _buildNestedScrollView() {
    return NestedScrollView(
      key: nestedScrollViewKey,
      controller: outerScrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // 搜索栏
          SliverAppBar(
            key: appBarKey,
            toolbarHeight: 44,
            pinned: true,
            floating: false,
            backgroundColor: const Color(0xFFFCAAAF),
            flexibleSpace: const SearchAppBar(),
          ),

          // 吸顶的Tab栏
          SliverPersistentHeader(
            key: tabBarKey,
            pinned: true,
            delegate: SliverHeaderDelegate.fixedHeight(
              height: 30,
              child: Container(
                color: const Color(0xFFFCAAAF),
                child: CusTabBarView(
                  onIndexChanged: (index) {
                    print("Tab changed to: $index");
                  },
                ),
              ),
            ),
          ),
        ];
      },
      body: Builder(
        builder: (context) {
          // 获取内部滚动控制器
          final innerScrollController = PrimaryScrollController.of(context);
          if (nestedScrollUtil.bodyScrollController != innerScrollController) {
            nestedScrollUtil.bodyScrollController = innerScrollController;
          }

          return CustomScrollView(
            slivers: [
              Builder(
                builder: (ctx) {
                  if (_sliverBodyCtx != ctx) {
                    _sliverBodyCtx = ctx;
                    nestedScrollUtil.bodySliverContexts.add(ctx);
                  }
                  return SliverToBoxAdapter(child: Container());
                },
              ),
              // 轮播图
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    //希望 SizedBox 根据父容器大小按比例调整尺寸，可以考虑使用 FractionallySizedBox。
                    FractionallySizedBox(
                      widthFactor: 1.0, // 宽度因子为1表示占满父容器的宽度
                      child: SizedBox(
                        height: 160.0,
                        child: Image.asset(
                          "assets/images/banner_oval.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: SizedBox(
                            height: 166,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return ComImage(
                                  "https://img.zcool.cn/community/01b72057a7e0790000018c1bf4fce0.png",
                                );
                              },
                              itemCount: 3,
                              pagination: const SwiperPagination(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 第三个 Sliver：分类区块
              SliverToBoxAdapter(child: _buildCategoryGrid()),
              // 第四个 Sliver：今日特惠/新品
              SliverToBoxAdapter(child: _buildSpecialOffers()),
              // 第五个 Sliver：超值精选/品质精选
              SliverToBoxAdapter(child: _buildSelection()),
              // 第六个 Sliver：热卖排行榜
              SliverToBoxAdapter(child: _buildHotRank()),
              // 第七个 Sliver：限时抢购
              SliverToBoxAdapter(child: _buildFlashSale()),
              // 第八个 Sliver：一元秒杀
              SliverToBoxAdapter(child: _buildOneYuanSeckill()),
              // 第八个 Sliver：品牌专区
              SliverToBoxAdapter(child: _buildBrandSection()),
              // 第九个 Sliver：团购专区
              SliverToBoxAdapter(child: _buildGroupBuy()),
              // 添加商品展示区
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    '精心为你推荐',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _buildProductGridView(context),
            ],
          );
        },
      ),
    );
  }

  // 分类区块美化（高度还原设计稿，10个icon，两行，每行5个，卡片化、渐变、icon底色区分）
  Widget _buildCategoryGrid() {
    final icons = [
      {
        'icon': Icons.shopping_cart,
        'label': '贝贝超市',
        'bg': [Color(0xFFFE9C5E), Color(0xFFFFC371)],
        'text': Color(0xFFFE9C5E),
      },
      {
        'icon': Icons.child_care,
        'label': '母婴专区',
        'bg': [Color(0xFF6DC8F3), Color(0xFF73A1F9)],
        'text': Color(0xFF6DC8F3),
      },
      {
        'icon': Icons.rice_bowl,
        'label': '云优选米',
        'bg': [Color(0xFF8ECF6E), Color(0xFFCCE985)],
        'text': Color(0xFF8ECF6E),
      },
      {
        'icon': Icons.cake,
        'label': '玩具乐园',
        'bg': [Color(0xFFF97794), Color(0xFF623AA2)],
        'text': Color(0xFFF97794),
      },
      {
        'icon': Icons.star,
        'label': '领优惠',
        'bg': [Color(0xFFFFC371), Color(0xFFFF5F6D)],
        'text': Color(0xFFFFC371),
      },
      {
        'icon': Icons.card_giftcard,
        'label': '领红包',
        'bg': [Color(0xFF43E97B), Color(0xFF38F9D7)],
        'text': Color(0xFF43E97B),
      },
      {
        'icon': Icons.credit_card,
        'label': '充值缴费',
        'bg': [Color(0xFF667EEA), Color(0xFF764BA2)],
        'text': Color(0xFF667EEA),
      },
      {
        'icon': Icons.emoji_events,
        'label': 'PLUS会员',
        'bg': [Color(0xFFFFA8A8), Color(0xFFFFE0E0)],
        'text': Color(0xFFFFA8A8),
      },
      {
        'icon': Icons.local_florist,
        'label': '之优牧场',
        'bg': [Color(0xFFB6CEE8), Color(0xFFF578DC)],
        'text': Color(0xFFB6CEE8),
      },
      {
        'icon': Icons.local_drink,
        'label': '之优国际',
        'bg': [Color(0xFFB6CEE8), Color(0xFF6DC8F3)],
        'text': Color(0xFFB6CEE8),
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (i) {
                final item = icons[i];
                return _buildCategoryItem(item);
              }),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (i) {
                final item = icons[i + 5];
                return _buildCategoryItem(item);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: item['bg']),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (item['bg'] as List<Color>)[0].withOpacity(0.18),
                blurRadius: 8,
              ),
            ],
          ),
          padding: EdgeInsets.all(12.w),
          child: Icon(item['icon'], color: Colors.white, size: 28.w),
        ),
        SizedBox(height: 6.h),
        Text(
          item['label'],
          style: TextStyle(
            fontSize: 13.sp,
            color: item['text'],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // 今日特惠/新品
  Widget _buildSpecialOffers() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink[100]!, Colors.pink[300]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.pink[50]!, blurRadius: 4),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on, color: Colors.pink, size: 24),
                    SizedBox(width: 6),
                    Text(
                      '今日特惠\n限时抢购',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[100]!, Colors.green[300]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.green[50]!, blurRadius: 4),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.new_releases, color: Colors.green, size: 24),
                    SizedBox(width: 6),
                    Text(
                      '新品上架\n爆款推荐',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 超值精选/品质精选
  Widget _buildSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[100]!, Colors.blue[300]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.blue[50]!, blurRadius: 4),
                  ],
                ),
                child: Center(
                  child: Text(
                    '超值精选',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[100]!, Colors.purple[300]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.purple[50]!, blurRadius: 4),
                  ],
                ),
                child: Center(
                  child: Text(
                    '品质精选',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 热卖排行榜
  Widget _buildHotRank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('热卖排行榜', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: EdgeInsets.only(
                  left: index == 0 ? 12 : 8,
                  right: index == 2 ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.orange[100]!, blurRadius: 4),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.orange, size: 28),
                      SizedBox(height: 6),
                      Text(
                        '安儿宝A+幼儿配方奶粉\nTOP${index + 1}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 限时抢购美化（自适应ScreenUtil）
  Widget _buildFlashSale() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              Text(
                '限时抢购',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
              ),
              Spacer(),
              Text(
                '查看更多',
                style: TextStyle(color: Colors.blue, fontSize: 12.sp),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 180.w,
                margin: EdgeInsets.only(
                  left: index == 0 ? 12.w : 8.w,
                  right: index == 2 ? 12.w : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(color: Colors.red[100]!, blurRadius: 4),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.red, size: 22.sp),
                      SizedBox(height: 4.h),
                      Text(
                        '美赞臣安儿宝A+幼儿配方奶粉',
                        style: TextStyle(fontSize: 12.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '￥244.00',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        height: 28.h,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('去抢购', style: TextStyle(fontSize: 11.sp)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 品牌专区
  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('品牌专区', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.only(
                  left: index == 0 ? 12 : 8,
                  right: index == 2 ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('品牌${index + 1}', textAlign: TextAlign.center),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 一元秒杀
  Widget _buildOneYuanSeckill() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('一元秒杀', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: EdgeInsets.only(
                  left: index == 0 ? 12 : 8,
                  right: index == 1 ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '美赞臣安儿宝A+幼儿配方奶粉\n￥244.00',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 优选拼团
  Widget _buildGroupBuy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text('优选拼团', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: EdgeInsets.only(
                  left: index == 0 ? 12 : 8,
                  right: index == 1 ? 12 : 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '美赞臣安儿宝A+幼儿配方奶粉\n￥244.00',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  SliverGrid _buildProductGridView(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 每行显示的商品数量
        childAspectRatio: 0.75, // 控制子项的宽高比
        mainAxisSpacing: 10.0, // 主轴（垂直）间距
        crossAxisSpacing: 10.0, // 横轴（水平）间距
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 示例数据，实际使用时请替换为你的数据源
          return ProductItemView(
            imageUrl:
                "https://img.zcool.cn/community/016a2256fb63006ac7257948f83349.jpg",
            title: "产品名称 $index",
            price: "¥${(index + 1) * 10}.00",
          );
        },
        childCount: 10, // 商品总数
      ),
    );
  }

  // 计算持久化头部的高度
  double calcPersistentHeaderExtent(double offset, {required bool isBody}) {
    double value = ObserverUtils.calcPersistentHeaderExtent(
      key: appBarKey,
      offset: offset,
    );
    if (isBody) {
      value += ObserverUtils.calcPersistentHeaderExtent(
        key: tabBarKey,
        offset: offset,
      );
    }
    return value;
  }

  // 滚动到指定位置
  void scrollTo({
    required NestedScrollUtilPosition position,
    required int index,
    required BuildContext? sliverContext,
    bool withAnimation = true,
  }) {
    bool isBody = NestedScrollUtilPosition.body == position;
    if (withAnimation) {
      nestedScrollUtil.animateTo(
        nestedScrollViewKey: nestedScrollViewKey,
        observerController: observerController,
        position: position,
        index: index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        sliverContext: sliverContext,
        offset: (targetOffset) {
          return calcPersistentHeaderExtent(targetOffset, isBody: isBody);
        },
      );
    } else {
      nestedScrollUtil.jumpTo(
        nestedScrollViewKey: nestedScrollViewKey,
        observerController: observerController,
        position: position,
        index: index,
        sliverContext: sliverContext,
        offset: (targetOffset) {
          return calcPersistentHeaderExtent(targetOffset, isBody: isBody);
        },
      );
    }
  }
}
