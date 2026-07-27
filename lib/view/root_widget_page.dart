import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:order_tracker_app/services/shared_prefs_service.dart';
import 'package:order_tracker_app/view/pages/login/login_page.dart';
import 'package:order_tracker_app/view/pages/orders_list/order_list_page.dart';

class RootWidgetPage extends StatelessWidget {
  const RootWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SharedPrefsService.getUser() != null ? OrderListPage() : LoginPage(),
      );
      },
    );
  }
}