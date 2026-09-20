// 司机主页相关数据模型（当前为静态 Mock 数据，后续对接接口）

/// 今日运单统计
class TodayOrderStats {
  const TodayOrderStats({
    required this.completed,
    required this.inProgress,
    required this.pending,
  });

  /// 已完成
  final int completed;

  /// 进行中
  final int inProgress;

  /// 待接单
  final int pending;

  /// 总计
  int get total => completed + inProgress + pending;

  /// Mock 数据
  static const TodayOrderStats mock = TodayOrderStats(
    completed: 3,
    inProgress: 1,
    pending: 2,
  );
}

/// 运单
class OrderItem {
  const OrderItem({
    required this.orderNo,
    required this.status,
    required this.fromAddress,
    required this.toAddress,
    required this.cargoName,
    required this.cargoWeight,
    required this.distance,
    required this.expectedTime,
  });

  /// 运单号
  final String orderNo;

  /// 状态：待接单 / 运输中 / 已完成
  final String status;

  /// 起点
  final String fromAddress;

  /// 终点
  final String toAddress;

  /// 货物名称
  final String cargoName;

  /// 货物重量
  final String cargoWeight;

  /// 里程
  final String distance;

  /// 预计送达时间
  final String expectedTime;

  /// Mock 当前运单
  static const OrderItem mockCurrent = OrderItem(
    orderNo: 'TMS20260916001',
    status: '运输中',
    fromAddress: '上海市浦东新区张江高科技园区',
    toAddress: '杭州市余杭区未来科技城',
    cargoName: '电子产品',
    cargoWeight: '3.5 吨',
    distance: '约 176 km',
    expectedTime: '今天 18:30 前',
  );
}

/// 司机信息
class DriverInfo {
  const DriverInfo({
    required this.name,
    required this.phone,
    required this.plateNo,
    required this.vehicleType,
    required this.online,
    required this.rating,
  });

  final String name;
  final String phone;
  final String plateNo;
  final String vehicleType;

  /// 是否在线接单
  final bool online;

  /// 评分
  final double rating;

  /// Mock 数据
  static const DriverInfo mock = DriverInfo(
    name: '张师傅',
    phone: '138****8888',
    plateNo: '沪A·88888',
    vehicleType: '重型半挂牵引车',
    online: true,
    rating: 4.9,
  );
}
