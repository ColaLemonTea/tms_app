import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/driver_home_models.dart';
import '../widgets/home/driver_header.dart';
import '../widgets/home/order_stats_card.dart';
import '../widgets/home/current_order_card.dart';
import '../widgets/home/map_preview_card.dart';
import '../widgets/home/quick_actions.dart';
import '../widgets/home/orders_tab.dart';
import '../widgets/home/profile_tab.dart';

/// 司机主页（静态内容，后续对接接口）
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const OrdersTab(),
          ProfileTab(onLogout: _handleLogout),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ==================== 首页 Tab ====================
  Widget _buildHomeTab() {
    return Column(
      children: [
        // 顶部司机信息（含状态栏避让）
        DriverHeader(
          driver: DriverInfo.mock,
          onToggleOnline: (v) => setState(() {}),
        ),
        // 内容区（可滚动）
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => Future.delayed(const Duration(milliseconds: 800)),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: const [
                SizedBox(height: 16),
                OrderStatsCard(stats: TodayOrderStats.mock),
                SizedBox(height: 16),
                CurrentOrderCard(order: OrderItem.mockCurrent),
                SizedBox(height: 16),
                MapPreviewCard(),
                SizedBox(height: 16),
                QuickActions(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==================== 底部导航 ====================
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textHint,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: '运单'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '我的'),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.auth,
                (route) => false,
              );
            },
            child: const Text('确定', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
