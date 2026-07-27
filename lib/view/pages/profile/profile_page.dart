import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:order_tracker_app/controller/profile_controller.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';
import 'package:order_tracker_app/core/constants/app_constraints.dart';
import 'package:order_tracker_app/services/shared_prefs_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Avatar
              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 55,
                ),
              ),

              AppConstraints.kHeight20,

              // Name
              Text(
                SharedPrefsService.getUser()?.name ?? "Unknown User",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              AppConstraints.kHeight8,

              // Email
              Text(
                SharedPrefsService.getUser()?.email ?? "Unknown Email",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey.shade600,
                ),
              ),

              AppConstraints.kHeight40,

              InkWell(
                onTap: () {
                  Get.find<ProfileController>().goToWebsite();
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.workspace_premium,
                          size: 40.sp,
                          color: Colors.blue,
                        ),
                        AppConstraints.kHeight12,
                        Text(
                          "Built for Digital Heroes\nTraining Task",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.find<ProfileController>().onLogoutClicked();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}