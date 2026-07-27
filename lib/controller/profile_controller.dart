import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_tracker_app/model/data/remote_data/profile_data.dart';
import 'package:order_tracker_app/services/shared_prefs_service.dart';
import 'package:order_tracker_app/view/pages/login/login_page.dart';
import 'package:order_tracker_app/view/pages/orders_list/order_list_page.dart';

class ProfileController extends GetxController {
  final ProfileData profileData;
  bool isObscure = true;
  bool isLoading = false;

  ProfileController({required this.profileData});

  void updateIsObscure() {
    isObscure = !isObscure;
    update();
  }

  Future<void> onLoginButtonClicked({required String email, required String password}) async {
    isLoading = true;
    update();
    try {
      final data = await profileData.login(email: email, password: password);
      if (data != null) {
        await SharedPrefsService.setUser(data);
        isLoading = false;
        update();
        Get.offUntil(MaterialPageRoute(builder: (context) {
          return OrderListPage();
        },), (route) => false,);
      } else {
        Get.snackbar("Info", "Invalid email or password");
        isLoading = false;
        update();
      }
    } catch (e) {
      debugPrint('Error on login: $e');
      isLoading = false;
      update();
      Get.snackbar("Info", "User not found");
    }
  }

  Future<void> onLogoutClicked() async {
    try {
      await SharedPrefsService.setUser(null);
      Get.offUntil(MaterialPageRoute(builder: (context) {
        return LoginPage();
      },), (route) => false,);
    } catch (e) {
      Get.snackbar("Info", e.toString());
    }
  }
}
