import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// 快捷功能入口（4 列网格）
class QuickActions extends StatelessWidget {
  const QuickActions({super.key, this.onTap});

  /// 点击回调（参数为功能名称）
  final ValueChanged<String>? onTap;

  static const List<_ActionItem> _items = [
    _ActionItem('扫码接单', Icons.qr_code_scanner, Color(0xFF2B7BFF)),
    _ActionItem('上报异常', Icons.report_problem_outlined, Color(0xFFE54848)),
    _ActionItem('运输轨迹', Icons.timeline, Color(0xFF4FE0CB)),
    _ActionItem('我的钱包', Icons.account_balance_wallet_outlined, Color(0xFFF5A623)),
    _ActionItem('电子回单', Icons.receipt_long_outlined, Color(0xFF7C5CFF)),
    _ActionItem('车辆管理', Icons.local_shipping_outlined, Color(0xFF1FA86C)),
    _ActionItem('在线客服', Icons.headset_mic_outlined, Color(0xFF2B7BFF)),
    _ActionItem('更多', Icons.grid_view, Color(0xFF8A94A6)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 4;
          return Wrap(
            runSpacing: 18,
            children: _items.map((item) => _actionButton(item, itemWidth)).toList(),
          );
        },
      ),
    );
  }

  Widget _actionButton(_ActionItem item, double width) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => onTap?.call(item.label),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}
