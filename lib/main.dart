import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:order_tracker_app/controller/profile_controller.dart';
import 'package:order_tracker_app/controller/order_controller.dart';
import 'package:order_tracker_app/core/constants/supabase_datas.dart';
import 'package:order_tracker_app/model/data/offline_data/local_storage_service.dart';
import 'package:order_tracker_app/model/data/remote_data/order_data.dart';
import 'package:order_tracker_app/model/data/remote_data/profile_data.dart';
import 'package:order_tracker_app/services/shared_prefs_service.dart';
import 'package:order_tracker_app/view/root_widget_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  await Supabase.initialize(
    url: SupabaseDatas.supabaseDataApiUrl,
    publishableKey: SupabaseDatas.supabasePublishableKey
  );
  await Hive.initFlutter();

  await Hive.openBox('orders');
  await Hive.openBox('profile');
  Get.put<ProfileController>(ProfileController(profileData: ProfileData()));
  Get.put<OrderController>(OrderController(orderData: OrderData(local: LocalStorageService())));
  runApp(const RootWidgetPage());
}

