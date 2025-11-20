import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/radar_logo.dart';
import '../../widgets/radar_text_field.dart';
import '../root/root_shell.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _agreeToTerms = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.backgroundMid, AppColors.backgroundDeep],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo and Brand Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const RadarLogo(size: 50),
                      const SizedBox(width: 12),
                      const Text(
                        'RadarSafi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // Register Title
                  const Text('Register Now', style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your email and password',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 32),
                  // Email Field
                  RadarTextField(
                    label: 'Email Address',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  RadarTextField(
                    label: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password Field
                  RadarTextField(
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 48),
                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_agreeToTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please agree to the Terms of Service and Privacy Policy',
                              ),
                            ),
                          );
                          return;
                        }
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const RootShell(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.backgroundDeep,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Already have account link
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have account? ',
                        style: AppTextStyles.body,
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.accentGreen,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Terms and Privacy Policy Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.accentBlue,
                        checkColor: Colors.white,
                        side: const BorderSide(color: AppColors.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text.rich(
                            TextSpan(
                              text: 'By continuing you agree to the chat GPT ',
                              style: AppTextStyles.caption,
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Handle Terms of Service tap
                                    },
                                    child: const Text(
                                      'Term of Service',
                                      style: TextStyle(
                                        color: AppColors.accentGreen,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Handle Privacy Policy tap
                                    },
                                    child: const Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        color: AppColors.accentGreen,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

