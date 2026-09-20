import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../amap_view.dart';

/// 地图预览卡片（用于展示当前运单路线）
/// - Android / iOS：真实高德地图
/// - Web / 桌面：降级占位
class MapPreviewCard extends StatelessWidget {
  const MapPreviewCard({
    super.key,
    this.latitude = 39.909187,
    this.longitude = 116.397451,
    this.height = 180,
    this.title = '运输路线',
    this.onTap,
  });

  final double latitude;
  final double longitude;
  final double height;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: const Row(
                    children: [
                      Text('全屏', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                      Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height,
            child: AmapView(
              latitude: latitude,
              longitude: longitude,
              zoom: 13,
            ),
          ),
        ],
      ),
    );
  }
}
