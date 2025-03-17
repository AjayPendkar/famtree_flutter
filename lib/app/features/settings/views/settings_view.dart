import 'package:famtreeflutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSectionHeader('settings.account'.tr),
            _buildSettingItem(
              icon: Icons.person_outline,
              title: 'settings.profile_info'.tr,
              subtitle: 'settings.profile_info_subtitle'.tr,
              onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: 'settings.privacy'.tr,
              subtitle: 'settings.privacy_subtitle'.tr,
              onTap: () => controller.handlePrivacySettings(),
            ),
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              trailing: Obx(() => Switch(
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
              )),
            ),

            // App Settings
            _buildSectionHeader('App Settings'),
            _buildSettingItem(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'Change app language',
              trailing: DropdownButton<String>(
                value: controller.selectedLanguage.value,
                items: [
                  'language.english'.tr,
                  'language.hindi'.tr,
                  'language.telugu'.tr,
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: controller.changeLanguage,
              ),
            ),
            _buildSettingItem(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Toggle dark theme',
              trailing: Obx(() => Switch(
                value: controller.darkModeEnabled.value,
                onChanged: controller.toggleDarkMode,
              )),
            ),
            _buildSettingItem(
              icon: Icons.font_download_outlined,
              title: 'Text Size',
              subtitle: 'Adjust app text size',
              trailing: Obx(() => DropdownButton<String>(
                value: controller.selectedTextSize.value,
                items: ['Small', 'Medium', 'Large'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: controller.changeTextSize,
              )),
            ),

            // Privacy & Security
            _buildSectionHeader('Privacy & Security'),
            _buildSettingItem(
              icon: Icons.security,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () => controller.handleChangePassword(),
            ),
            _buildSettingItem(
              icon: Icons.phone_android,
              title: 'Two-Factor Authentication',
              subtitle: 'Add extra security to your account',
              trailing: Obx(() => Switch(
                value: controller.twoFactorEnabled.value,
                onChanged: controller.toggleTwoFactor,
              )),
            ),

            // Support & About
            _buildSectionHeader('Support & About'),
            _buildSettingItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help or contact us',
              onTap: () => controller.handleHelpSupport(),
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'About App',
              subtitle: 'Version information and details',
              onTap: () => controller.handleAboutApp(),
            ),
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () => controller.handlePrivacyPolicy(),
            ),
            _buildSettingItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms of service',
              onTap: () => controller.handleTermsOfService(),
            ),

            // Danger Zone
            _buildSectionHeader('Danger Zone', color: AppColors.error),
            _buildSettingItem(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () => controller.handleDeleteAccount(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: textColor?.withOpacity(0.7) ?? AppColors.textSecondary,
        ),
      ),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
} 