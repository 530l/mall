import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mall/extension/context_extension.dart';

/// 图片组件
///
/// 用于显示网络图片或本地图片，支持占位图、错误图、圆角等属性
class ComImage extends StatelessWidget {
  /// 图片源地址，可以是网络URL或本地资源路径
  final String src;

  /// 图片宽度，可选
  final double? width;

  /// 图片高度，可选
  final double? height;

  /// 图片最小宽度，默认为50
  final double minWidth;

  /// 图片最小高度，默认为50
  final double minHeight;

  /// 图片圆角半径，为null时使用主题基础圆角
  final double? radius;

  /// 图片填充模式，默认为BoxFit.cover
  final BoxFit fit;

  /// 自定义占位图组件，可选
  final Widget? placeholder;

  /// 自定义错误显示组件，可选
  final Widget? errorBuilder;

  /// 构造函数
  ///
  /// [src] 图片源地址，必需
  /// [width] 图片宽度，可选
  /// [height] 图片高度，可选
  /// [radius] 图片圆角半径，可选
  /// [fit] 图片填充模式，默认为BoxFit.cover
  /// [minWidth] 图片最小宽度，默认为50
  /// [minHeight] 图片最小高度，默认为50
  /// [placeholder] 自定义占位图组件，可选
  /// [errorBuilder] 自定义错误显示组件，可选
  const ComImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.radius,
    this.fit = BoxFit.cover,
    this.minWidth = 50,
    this.minHeight = 50,
    this.placeholder,
    this.errorBuilder,
  });

  /// 构建图片组件
  ///
  /// 根据图片源类型选择不同的加载方式，支持网络图片和本地图片
  /// [context] 构建上下文
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(radius ?? context.comTheme.shapes.baseRadius),
      child: Container(
        constraints: BoxConstraints(
          minWidth: width ?? minWidth,
          minHeight: height ?? minHeight,
        ),
        child: src.isEmpty
            ? _buildDefaultPlaceholder(context)
            : isNetworkImage(src)
                ? CachedNetworkImage(
                    imageUrl: src,
                    placeholder: (context, url) =>
                        placeholder ?? _buildDefaultPlaceholder(context),
                    errorWidget: (context, url, error) =>
                        errorBuilder ?? _buildDefaultPlaceholder(context),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    fadeInDuration: const Duration(milliseconds: 500),
                    fit: fit,
                    width: width,
                    height: height,
                  )
                : Image.asset(
                    src,
                    fit: fit,
                    width: width,
                    height: height,
                    errorBuilder: (context, url, error) =>
                        errorBuilder ?? _buildDefaultPlaceholder(context),
                  ),
      ),
    );
  }

  /// 判断图片源是否为网络图片
  ///
  /// 通过解析URL的scheme判断是否为http或https链接
  /// [src] 图片源地址
  /// 返回布尔值，true表示是网络图片
  bool isNetworkImage(String src) {
    final uri = Uri.tryParse(src);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  /// 构建默认占位图
  ///
  /// 当图片加载失败或未提供自定义占位图时使用
  /// [context] 构建上下文
  /// 返回默认占位图组件
  Widget _buildDefaultPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Icon(
        Icons.terrain,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

/// 图片叠加组件
///
/// 用于创建带有背景图片和叠加内容的容器，支持颜色滤镜、边框、形状等属性
class ComImageOverlay extends StatelessWidget {
  /// 构造函数
  ///
  /// [height] 容器高度，可选
  /// [width] 容器宽度，可选，默认为无限宽
  /// [color] 容器背景颜色，可选
  /// [padding] 容器内边距，可选
  /// [margin] 容器外边距，可选
  /// [image] 背景图片，必需
  /// [child] 叠加在图片上的子组件，默认为空组件
  /// [alignment] 子组件在容器内的对齐方式，可选
  /// [borderRadius] 容器圆角，可选
  /// [colorFilter] 图片颜色滤镜，默认为半透明黑色
  /// [boxFit] 图片填充模式，默认为BoxFit.cover
  /// [border] 容器边框，可选
  /// [shape] 容器形状，默认为矩形
  const ComImageOverlay({
    super.key,
    this.height,
    this.width,
    this.color,
    this.padding,
    this.margin,
    required this.image,
    this.child = const SizedBox.shrink(),
    this.alignment,
    this.borderRadius,
    this.colorFilter = const ColorFilter.mode(Colors.black54, BlendMode.darken),
    this.boxFit = BoxFit.cover,
    this.border,
    this.shape = BoxShape.rectangle,
  });

  /// 容器高度，可选
  final double? height;

  /// 容器宽度，可选，默认为无限宽
  final double? width;

  /// 容器背景颜色，可选
  final Color? color;

  /// 容器外边距，可选
  final EdgeInsetsGeometry? margin;

  /// 容器内边距，可选
  final EdgeInsetsGeometry? padding;

  /// 背景图片，必需
  final ImageProvider image;

  /// 叠加在图片上的子组件，默认为空组件
  final Widget child;

  /// 子组件在容器内的对齐方式，可选
  final AlignmentGeometry? alignment;

  /// 图片填充模式，默认为BoxFit.cover
  final BoxFit? boxFit;

  /// 图片颜色滤镜，默认为半透明黑色
  final ColorFilter? colorFilter;

  /// 容器圆角，可选
  final BorderRadiusGeometry? borderRadius;

  /// 容器边框，可选
  final Border? border;

  /// 容器形状，默认为矩形
  final BoxShape shape;

  /// 构建图片组件
  ///
  /// 根据图片源类型选择不同的加载方式，支持网络图片和本地图片
  /// [context] 构建上下文
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      width: width ?? double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: borderRadius,
        border: border,
        color: color,
        image: DecorationImage(
          fit: boxFit,
          colorFilter: colorFilter,
          image: image,
        ),
      ),
      child: child,
    );
  }
}
