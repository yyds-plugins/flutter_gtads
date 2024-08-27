import 'package:flutter/foundation.dart';

class LogUtil {
  /// 调试模式打印
  static void p(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  /// 调试模式打印
  static void dp(Object? object) {
    if (kDebugMode) {
      debugPrint(object?.toString());
    }
  }
}
