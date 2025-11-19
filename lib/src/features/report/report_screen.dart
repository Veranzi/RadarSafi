import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/radar_button.dart';

enum VerifyCategory { image, link, email, phone }

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  VerifyCategory selectedCategory = VerifyCategory.image;
  final TextEditingController textInputController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  bool showResult = false;

  String get categoryLabel {
    switch (selectedCategory) {
      case VerifyCategory.image:
        return 'Image / Screenshot';
      case VerifyCategory.link:
        return 'Web Link';
      case VerifyCategory.email:
        return 'Email / Message';
      case VerifyCategory.phone:
        return 'Phone Number';
    }
  }

  @override
  void dispose() {
    textInputController.dispose();
    phoneController.dispose();
    institutionController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Verify data and report', style: AppTextStyles.title),
            const SizedBox(height: 6),
            Text(
              'Verify suspicious data and report if found malicious to help others.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 24),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildCategoryChips(),
            const SizedBox(height: 16),
            _buildDynamicForm(),
            const SizedBox(height: 12),
            RadarPrimaryButton(
              label: 'Submit',
              onPressed: () => setState(() => showResult = true),
            ),
            const SizedBox(height: 16),
            if (showResult) const VerificationResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VerifyCategory>(
          value: selectedCategory,
          dropdownColor: AppColors.surface,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textPrimary,
          ),
          isExpanded: true,
          items: VerifyCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(categoryLabelFor(category)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCategory = value;
                showResult = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 12,
      children: VerifyCategory.values.map((category) {
        final isSelected = category == selectedCategory;
        return ChoiceChip(
          label: Text(categoryLabelFor(category)),
          selected: isSelected,
          onSelected: (_) => setState(() => selectedCategory = category),
          selectedColor: AppColors.accentGreen.withValues(alpha: 0.2),
          backgroundColor: AppColors.surface,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.accentGreen : AppColors.textSecondary,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDynamicForm() {
    switch (selectedCategory) {
      case VerifyCategory.image:
        return _buildUploadCard('Click to browse / upload image');
      case VerifyCategory.link:
        return _buildTextField(
          controller: textInputController,
          label: 'Paste link address',
          hint: 'https://scam-link.co',
        );
      case VerifyCategory.email:
        return Column(
          children: [
            _buildTextField(
              controller: textInputController,
              label: 'Sender email address or name',
              hint: 'phisher@email.com',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: reasonController,
              label: 'Paste full message content',
              hint: 'I am a prince with a fortune...',
              maxLines: 5,
            ),
          ],
        );
      case VerifyCategory.phone:
        return Column(
          children: [
            _buildTextField(
              controller: phoneController,
              label: 'Phone Number',
              hint: '+254 712 345678',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: institutionController,
              label: 'Claimed Institution',
              hint: 'KPLC Limited',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: reasonController,
              label: 'Select reason',
              hint: 'Spam calling / impersonation',
            ),
          ],
        );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  Widget _buildUploadCard(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 42,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(label, style: AppTextStyles.body),
        ],
      ),
    );
  }

  String categoryLabelFor(VerifyCategory category) {
    switch (category) {
      case VerifyCategory.image:
        return 'Image / Screenshot';
      case VerifyCategory.link:
        return 'Web Link';
      case VerifyCategory.email:
        return 'Email / Message';
      case VerifyCategory.phone:
        return 'Phone Number';
    }
  }
}

class VerificationResultCard extends StatelessWidget {
  const VerificationResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shield, color: AppColors.accentGreen),
              SizedBox(width: 8),
              Text(
                'YourAgent',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This link is NOT legitimate.\n\nOur database shows this item has been reported 324 times as a scam. The institution confirmed that they are not running any voucher promotion online.\n\nAdvice: Do not click or forward the link. Delete it immediately.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 16),
          RadarSecondaryButton(label: 'Report this Content?', onPressed: () {}),
        ],
      ),
    );
  }
}
