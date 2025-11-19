import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/radar_background.dart';
import '../../widgets/radar_button.dart';
import '../../widgets/radar_text_field.dart';
import '../root/root_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
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
              Text('Register Now', style: AppTextStyles.title),
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
              const SizedBox(height: 16),
              RadarTextField(
                label: 'Confirm Password',
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              RadarPrimaryButton(
                label: 'Create Account',
                onPressed: _handleRegister,
              ),
              const SizedBox(height: 18),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.body,
                      children: [
                        TextSpan(
                          text: 'Log In',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (_) {},
                    activeColor: AppColors.accentGreen,
                    side: const BorderSide(color: AppColors.outline),
                  ),
                  Expanded(
                    child: Text(
                      'By continuing you agree to the RadarSafi Terms of Service and Privacy Policy.',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
