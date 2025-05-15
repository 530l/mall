import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'main_page.dart';
import 'providers/home_provider.dart';

/// 理解Flutter的构建机制
// 重要的是要理解，在Flutter中，Widget的build方法被调用多次是完全正常的。
// Flutter的设计理念是"廉价构建"，这意味着构建Widget树应该是快速且无副作用的。
// 因此，最佳实践是：
// 1.不要在build方法中执行昂贵的操作**：如网络请求、复杂计算等
// 2.不要在build方法中依赖执行次数**：如计数器、累加器等
// 3.将有状态的逻辑放在initState或其他生命周期方法中**：这些方法只会执行一次

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 892),
      builder:
          (context, child) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: const MainPage(),
          ),
    );
  }
}
