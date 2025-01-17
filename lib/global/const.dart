import 'package:flutter/foundation.dart';

class Const {
  // 设计图宽度 dp
  static const double uiWidth = 375;

  // 设计图高度 dp
  static const double uiHeight = 812;

  static const String groupAll = "all";
  static const String groupUs = "μ's";
  static const String groupAqours = "Aqours";
  static const String groupSaki = "Nijigasaki";
  static const String groupLiella = "Liella!";
  static const String groupCombine = "Combine";

  // Logan 加密键值对
  static const String aesKey = "0123456789012345";
  static const String iV = "0123456789012345";

  // 暂无歌曲时使用炫彩模式要显示的颜色值
  static const int noMusicColorfulSkin = 0x4DFFAE00;

  /// sp
  static const String spAllowPermission = "SP_ALLOW_PERMISSION";
  static const String spDark = "SP_IS_DARK";
  static const String spColorful = "SP_IS_COLORFUL";
  static const String spWithSystemTheme = "SP_With_System_Theme";
  static const String spAIPicture = "SP_AI_PICTURE";
  static const String spLoopMode = "SP_LOOP_MODE";
  static const String spDataVersion = "SP_DATA_VERSION";

  // 默认的资源oss，无法在线获取时用于离线加载网络图片
  static String ossUrl =
      "https://video-file-upload.oss-cn-hangzhou.aliyuncs.com/";

  // 自己的oss
  static const String ownOssUrl =
      "https://zhushenwudi1.oss-cn-hangzhou.aliyuncs.com/LLMP-M/data/";

  // 动态获取资源oss的url和开屏图配置
  static const String splashConfigUrl = "${ownOssUrl}splash_config.json";

  static String splashUrl = "${ownOssUrl}LLMP-M/splash_bg/";

  static const env = kReleaseMode ? "prod" : "pre";

  // 数据更新桥文件
  static String dataUrl = "$ownOssUrl$env/data.json";

  // 歌手文件
  static String artistModelUrl = "$ownOssUrl$env/artist.json";

  // 版本更新文件
  static String updateUrl = "$ownOssUrl$env/version.json";
}
