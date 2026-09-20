import 'package:flutter/material.dart';

/// Web / 桌面端占位实现
/// 高德地图原生插件（amap_flutter_map）不支持 Web 与桌面平台，
/// 因此在这些平台上渲染一个降级占位视图。
Widget buildAmap({
  required BuildContext context,
  required double latitude,
  required double longitude,
  required double zoom,
  required bool showMyLocation,
  void Function(dynamic controller)? onMapCreated,
}) {
  return _MapPlaceholder(latitude: latitude, longitude: longitude);
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F4F8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 48, color: Color(0xFFB0B7C3)),
            const SizedBox(height: 12),
            const Text(
              '地图仅在 Android / iOS 端显示',
              style: TextStyle(fontSize: 14, color: Color(0xFF8A94A6)),
            ),
            const SizedBox(height: 4),
            Text(
              '当前位置: $latitude, $longitude',
              style: const TextStyle(fontSize: 12, color: Color(0xFFB0B7C3)),
            ),
          ],
        ),
      ),
    );
  }
}
