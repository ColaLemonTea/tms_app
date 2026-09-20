import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import '../../core/constants/amap_config.dart';

/// Android / iOS 端真实高德地图实现
Widget buildAmap({
  required BuildContext context,
  required double latitude,
  required double longitude,
  required double zoom,
  required bool showMyLocation,
  void Function(dynamic controller)? onMapCreated,
}) {
  final cameraPosition = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: zoom,
  );

  return AMapWidget(
    // 隐私合规声明（不配置将无法显示地图）
    privacyStatement: AMapPrivacyStatement(
      hasContains: true,
      hasShow: true,
      hasAgree: AmapConfig.privacyAgreed,
    ),
    apiKey: const AMapApiKey(
      androidKey: AmapConfig.androidKey,
      iosKey: AmapConfig.iosKey,
    ),
    initialCameraPosition: cameraPosition,
    myLocationStyleOptions: showMyLocation
        ? MyLocationStyleOptions(true)
        : null,
    onMapCreated: onMapCreated == null ? null : (controller) => onMapCreated(controller),
    // 地图 UI 控件
    compassEnabled: false,
    scaleEnabled: false,
    rotateGesturesEnabled: true,
    tiltGesturesEnabled: true,
  );
}
