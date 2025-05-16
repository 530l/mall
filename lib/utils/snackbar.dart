/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/fluttercandies/flutter_scrollview_observer
 * @Date: 2023-10-29 12:44:03
 */

// 导入Flutter的基础材料设计库
import 'package:flutter/material.dart';

/// SnackBar工具类
/// 提供显示SnackBar的便捷方法
/// 用于在应用底部显示简短的消息提示
class SnackBarUtil {
  /// 显示SnackBar消息
  ///
  /// 在显示新消息前会清除当前显示的所有SnackBar
  ///
  /// @param context 构建上下文，用于获取ScaffoldMessenger
  /// @param text 要显示的文本内容
  static showSnackBar({
    required BuildContext context,
    required String text,
  }) {
    // 清除当前显示的所有SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();
    // 显示新的SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // 设置SnackBar的内容为文本
        content: Text(text),
        // 设置显示时长为2秒
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}
