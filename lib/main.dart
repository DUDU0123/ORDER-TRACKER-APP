import 'package:flutter/material.dart';
import 'package:order_tracker_app/core/constants/supabase_datas.dart';
import 'package:order_tracker_app/services/shared_prefs_service.dart';
import 'package:order_tracker_app/view/root_widget_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  await Supabase.initialize(
    url: SupabaseDatas.supabaseDataApiUrl,
    publishableKey: SupabaseDatas.supabaseKey
  );
  runApp(const RootWidgetPage());
}

