import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../../widgets/radar_background.dart';
import '../../widgets/radar_button.dart';
import '../../widgets/radar_logo.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RadarBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),
            Column(
              children: [
                const RadarLogo(size: 170),
                const SizedBox(height: 24),
                Text('RadarSafi', style: AppTextStyles.display),
                const SizedBox(height: 8),
                Text(
                  'Verify before you click\nSecurity starts with you.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                RadarPrimaryButton(
                  label: 'Log In',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                RadarSecondaryButton(
                  label: 'Create Account',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
