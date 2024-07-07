import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late String _cameraMode;
  late bool _cameraPreview;
  late String _alarmSound;
  late int _alarmInterval;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Loads preferences asynchronously and sets the value of _showIntroPage based on the 'isFirstLaunch' key in SharedPreferences.
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _cameraMode = prefs.getString('cameraMode') ?? 'front';
    _cameraPreview = prefs.getBool('cameraPreview') ?? true;
    _alarmSound = prefs.getString('alarmSound') ?? 'default';
    _alarmInterval = prefs.getInt('alarmInterval') ?? 5;
  }

  void _resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cameraMode', 'front');
    prefs.setBool('cameraPreview', true);
    prefs.setString('alarmSound', 'default');
    prefs.setInt('alarmInterval', 5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
            ),
          ),

          // Settings
          SettingsList(
            sections: [
              SettingsSection(
                tiles: [
                  SettingsTile(
                    title: Text('Mode Kamera'),
                    description: Text(
                      "Atur penggunaan mode kamera depan/belakang",
                    ),
                    value: Text(_cameraMode),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile.switchTile(
                    title: Text('Pratinjau Kamera'),
                    description: Text(
                        'Tampilkan pratinjau secara bawaan\n(Nonaktifkan untuk menghemat baterai)'),
                    initialValue: _cameraPreview,
                    onToggle: (bool value) {},
                  ),
                  SettingsTile(
                    title: Text('Interval Peringatan'),
                    description: Text(
                      "Atur jeda alarm peringatan ketika terdeteksi",
                    ),
                    value: Text(_alarmInterval.toString()),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: Text('Bunyi Alarm'),
                    description: Text(
                      "Atur bunyi alarm yang digunakan",
                    ),
                    value: Text(_alarmSound),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: Text('Atur Ulang'),
                    description: Text(
                      "Kembalikan ke pengaturan awal",
                    ),
                    onPressed: (BuildContext context) {
                      _resetPreferences();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
