import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:order_tracker_app/controller/profile_controller.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';
import 'package:order_tracker_app/core/components/common_text_form_field_widget.dart';
import 'package:order_tracker_app/core/constants/app_constraints.dart';
import 'package:order_tracker_app/core/utils/app_common_methods.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 20.h,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.inventory_2_rounded,
                      size: 70,
                    ),

                    AppConstraints.kHeight24,

                    Text(
                      "Welcome Back",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    AppConstraints.kHeight8,

                    Text(
                      "Sign in to manage orders",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.kGrey.withAlpha(200),
                      ),
                    ),

                    AppConstraints.kHeight40,

                    CommonTextFormFieldWidget(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixWidget: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      validator: (value) {
                        return AppCommonMethods.emailValidator(value: value);
                      },
                    ),

                    AppConstraints.kHeight20,

                    GetBuilder<ProfileController>(
                      builder: (profileController) {
                        return CommonTextFormFieldWidget(
                          controller: passwordController,
                          obscureText: profileController.isObscure,
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixWidget: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              Get.find<ProfileController>().updateIsObscure();
                            },
                          icon: Icon(
                              profileController.isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                              ),
                            ),
                          validator: (value) {
                            return AppCommonMethods.passwordValidator(value: value);
                          },
                        );
                      }
                    ),
                    AppConstraints.kHeight32,
                    GetBuilder<ProfileController>(
                      builder: (profileController) {
                        return SizedBox(
                          width: double.infinity,
                          height: 54.h,
                          child: FilledButton(
                            onPressed: profileController.isLoading ? null : () {
                              if (!_formKey.currentState!.validate()) return;
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              Get.find<ProfileController>().onLoginButtonClicked(
                                email: email,
                                password: password,
                              );
                            },
                            child: profileController.isLoading
                                ?  SizedBox(
                                    height: 22.h,
                                    width: 22.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppColors.kWhite,
                                    ),
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}