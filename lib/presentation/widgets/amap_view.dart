import 'package:flutter/material.dart';

// 条件导入：Web / 桌面端使用 stub，移动端使用真实高德地图
import 'amap_view_stub.dart'
    if (dart.library.io) 'amap_view_mobile.dart';

/// 高德地图视图封装
///
/// - Android / iOS：渲染真实高德地图 [AMapWidget]
/// - Web / 桌面：渲染占位提示（高德原生插件不支持 Web）
class AmapView extends StatelessWidget {
  const AmapView({
    super.key,
    this.latitude = 39.909187,
    this.longitude = 116.397451,
    this.zoom = 14,
    this.showMyLocation = true,
    this.onMapCreated,
  });

  final double latitude;
  final double longitude;
  final double zoom;
  final bool showMyLocation;
  final void Function(dynamic controller)? onMapCreated;

  @override
  Widget build(BuildContext context) {
    return buildAmap(
      context: context,
      latitude: latitude,
      longitude: longitude,
      zoom: zoom,
      showMyLocation: showMyLocation,
      onMapCreated: onMapCreated,
    );
  }
}
