import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/driver_home_models.dart';

/// 司机主页顶部头部：司机信息 + 在线状态
class DriverHeader extends StatelessWidget {
  const DriverHeader({
    super.key,
    required this.driver,
    this.onToggleOnline,
  });

  final DriverInfo driver;
  final ValueChanged<bool>? onToggleOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF1E63D6)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // 头像
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 12),
            // 姓名 + 车牌
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        driver.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ratingBadge(driver.rating),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${driver.plateNo} · ${driver.vehicleType}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // 在线开关
            _onlineSwitch(),
          ],
        ),
      ),
    );
  }

  Widget _ratingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Color(0xFFFFD54F), size: 12),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _onlineSwitch() {
    return Column(
      children: [
        Transform.scale(
          scale: 0.85,
          child: Switch(
            value: driver.online,
            activeThumbColor: AppColors.primary,
            activeTrackColor: Colors.white,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
            onChanged: onToggleOnline,
          ),
        ),
        Text(
          driver.online ? '接单中' : '已收车',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
