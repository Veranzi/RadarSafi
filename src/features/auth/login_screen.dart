import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/radar_background.dart';
import '../../widgets/radar_button.dart';
import '../../widgets/radar_text_field.dart';
import '../root/root_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadarBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text('Welcome back', style: AppTextStyles.title),
              const SizedBox(height: 4),
              Text('Enter your email and password', style: AppTextStyles.body),
              const SizedBox(height: 32),
              RadarTextField(
                label: 'Email Address',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'name@email.com',
              ),
              const SizedBox(height: 16),
              RadarTextField(
                label: 'Password',
                controller: passwordController,
                obscureText: true,
                hintText: 'Create a strong password',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: RadarGhostButton(
                  label: 'Forgot Password?',
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 16),
              RadarPrimaryButton(label: 'Log In', onPressed: _handleLogin),
              const SizedBox(height: 18),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: 'New to RadarSafi? ',
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(
                          text: 'Create Account',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'By continuing you agree to the RadarSafi Terms of Service and Privacy Policy.',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
