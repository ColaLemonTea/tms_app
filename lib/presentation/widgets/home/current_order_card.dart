import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/driver_home_models.dart';

/// 当前运单卡片：起点 → 终点 + 货物信息 + 导航按钮
class CurrentOrderCard extends StatelessWidget {
  const CurrentOrderCard({
    super.key,
    required this.order,
    this.onNavigate,
    this.onDetail,
  });

  final OrderItem order;
  final VoidCallback? onNavigate;
  final VoidCallback? onDetail;

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
      child: Column(
        children: [
          // 标题栏
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                const Text(
                  '当前运单',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                _statusTag(order.status),
              ],
            ),
          ),

          // 路线：起点 → 终点
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 路线指示点
                Column(
                  children: [
                    _dot(AppColors.success),
                    Container(width: 2, height: 32, color: AppColors.border),
                    _dot(AppColors.error),
                  ],
                ),
                const SizedBox(width: 12),
                // 地址
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _address('起', order.fromAddress),
                      const SizedBox(height: 20),
                      _address('终', order.toAddress),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),

          // 货物信息栏
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _infoChip(Icons.inventory_2_outlined, order.cargoName),
                const SizedBox(width: 16),
                _infoChip(Icons.scale_outlined, order.cargoWeight),
                const SizedBox(width: 16),
                _infoChip(Icons.route_outlined, order.distance),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // 底部：单号 + 操作按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '单号 ${order.orderNo}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '预计送达：${order.expectedTime}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // 导航按钮
                OutlinedButton.icon(
                  onPressed: onNavigate,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(0, 36),
                  ),
                  icon: const Icon(Icons.navigation_outlined, size: 16),
                  label: const Text('导航', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 1),
        ],
      ),
    );
  }

  Widget _address(String tag, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tag,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: tag == '起' ? AppColors.success : AppColors.error,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            address,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.3),
          ),
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _statusTag(String status) {
    Color color;
    switch (status) {
      case '运输中':
        color = AppColors.primary;
        break;
      case '已完成':
        color = AppColors.success;
        break;
      default:
        color = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
