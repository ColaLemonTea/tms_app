import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/driver_home_models.dart';

/// "运单" 标签页：展示运单列表（静态示例）
class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  /// Mock 运单列表
  static const List<OrderItem> _mockOrders = [
    OrderItem(
      orderNo: 'TMS20260916001',
      status: '运输中',
      fromAddress: '上海市浦东新区张江高科技园区',
      toAddress: '杭州市余杭区未来科技城',
      cargoName: '电子产品',
      cargoWeight: '3.5 吨',
      distance: '约 176 km',
      expectedTime: '今天 18:30 前',
    ),
    OrderItem(
      orderNo: 'TMS20260916002',
      status: '待接单',
      fromAddress: '苏州市工业园区星湖街',
      toAddress: '南京市江宁区经济开发区',
      cargoName: '汽车配件',
      cargoWeight: '5.0 吨',
      distance: '约 210 km',
      expectedTime: '明天 10:00 前',
    ),
    OrderItem(
      orderNo: 'TMS20260915008',
      status: '已完成',
      fromAddress: '无锡市新吴区太湖大道',
      toAddress: '常州市武进区龙江路',
      cargoName: '冷链食品',
      cargoWeight: '2.0 吨',
      distance: '约 95 km',
      expectedTime: '昨天 16:00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _mockOrders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _orderTile(_mockOrders[index]),
    );
  }

  Widget _orderTile(OrderItem order) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order.orderNo,
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
              const Spacer(),
              _statusTag(order.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _dot(AppColors.success),
                  Container(width: 2, height: 26, color: AppColors.border),
                  _dot(AppColors.error),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.fromAddress,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                    const SizedBox(height: 18),
                    Text(order.toAddress,
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          Row(
            children: [
              _infoChip(Icons.inventory_2_outlined, order.cargoName),
              const SizedBox(width: 16),
              _infoChip(Icons.scale_outlined, order.cargoWeight),
              const Spacer(),
              Text(order.expectedTime,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
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
