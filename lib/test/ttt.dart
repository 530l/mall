import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class a {


  //使用 Column，直接嵌套 CustomScrollView 是不行的，因为：
  // CustomScrollView 是一个可滚动区域。
  // Column 不允许其子项无限高或具有滚动行为
  /*Widget _buildPage(BuildContext context) {
    final provider = context.read<HomeProvider>();
    return Column(
      children: [
        SearchAppBar(),
        //Stack不能和 Expanded 一起使用，因为Stack会占据尽可能多的空间。
        Stack(
          //相当于 Android中的FrameLayout
          children: [
            Image.asset("assets/images/banner_oval.png"),
            //相当于 Android中的LinearLayout
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CusTabBarView(
                  onIndexChanged: (index) {
                    print("Tab changed to: $index");
                  },
                ),

                // 为Swiper设置明确的高度
                Padding(
                  padding: EdgeInsets.all(12),
                  //Flutter的布局系统基于约束传递。父组件会向子组件传递约束，子组件根据这些约束确定自己的大小。
                  // 在Column中，子组件的宽度会被约束为Column的宽度，但高度默认是由子组件自己决定的。
                  child: SizedBox(
                    height: 150,
                    //Swiper是一个轮播组件，它需要知道自己的确切尺寸才能正确显示内容和计算滑动距离。
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return ComImage(
                          "https://img.zcool.cn/community/01b72057a7e0790000018c1bf4fce0.png",
                        );
                      },
                      itemCount: 3,
                      pagination: SwiperPagination(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }*/

}
