import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/driver_home_models.dart';

/// "我的" 标签页
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, this.onLogout});

  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final driver = DriverInfo.mock;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // 个人信息卡
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 34),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver.phone,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver.plateNo,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 菜单列表
          Container(
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
                _menuItem(Icons.person_outline, '个人资料'),
                _menuItem(Icons.local_shipping_outlined, '我的车辆'),
                _menuItem(Icons.verified_user_outlined, '资质证照'),
                _menuItem(Icons.settings_outlined, '系统设置'),
                _menuItem(Icons.info_outline, '关于我们', showDivider: false),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 退出登录
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onLogout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('退出登录', style: TextStyle(fontSize: 15)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.textSecondary, size: 22),
          title: Text(title, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
          trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textHint),
          onTap: () {},
        ),
        if (showDivider)
          const Divider(height: 1, indent: 52, endIndent: 16, color: AppColors.border),
      ],
    );
  }
}
