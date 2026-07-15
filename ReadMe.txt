lib/
├── main.dart                # 入口文件（仅做启动配置，极其精简）
│
├── core/                    # 核心基础设施（全局通用，不依赖业务）
│   ├── constants/           # 常量（颜色、字体、字符串、API地址）
│   ├── themes/              # 全局主题样式
│   ├── routes/              # 路由管理（页面跳转名称）
│   └── utils/               # 工具类（日期格式化、加密、日志）
│
├── data/                    # 数据层（负责获取数据和数据模型）
│   ├── models/              # 数据模型（UserModel, OrderModel等）
│   ├── repositories/        # 仓库（负责从本地/远程获取数据）
│   └── services/            # 网络服务（Dio封装、API接口定义）
│
├── presentation/            # 展示层（UI界面 + 状态管理）
│   ├── pages/               # 页面（一个页面一个dart文件）
│   │   ├── splash_page.dart # 启动页
│   │   ├── login_page.dart  # 登录页
│   │   └── home_page.dart   # 主页
│   ├── widgets/             # 可复用的组件（按钮、输入框、弹窗）
│   └── state/               # 状态管理（Provider/GetX/Bloc 的 controller）
│
└── utils/                   # 全局辅助函数（与 core 类似，但更偏向通用算法）
    └── validators.dart      # 表单校验（邮箱、手机号、密码强度）