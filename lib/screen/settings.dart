import 'package:flutter/material.dart';
import '../component/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          SettingsItem(
            title: 'Notifications',
            subtitle: 'Enable or disable notifications',
            onTap: () {
              // Navigate to notifications settings page
            },
          ),
          SettingsItem(
            title: 'Privacy',
            subtitle: 'Manage your privacy settings',
            onTap: () {
              // Navigate to privacy settings page
            },
          ),
          SettingsItem(
            title: 'About',
            subtitle: 'Learn more about the app',
            onTap: () {
              // Navigate to about page
            },
          ),
        ],
      ),
    );
  }
}
