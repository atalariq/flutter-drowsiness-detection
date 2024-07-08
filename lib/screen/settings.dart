import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../detector.dart';

class SettingsPage extends StatefulWidget {
  final DrowsinessDetector drowsinessDetector;

  const SettingsPage({super.key, required this.drowsinessDetector});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late int _cameraModeIndex;
  late bool _previewEnabled;
  late int _alarmInterval;
  late String _alarmSound;

  final List<String> _alarmSounds = [
    'alarm1',
    'alarm2',
    'alarm3',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _previewEnabled = prefs.getBool('previewEnabled') ?? true;
      _cameraModeIndex = prefs.getInt('cameraMode') ?? 0;
      _alarmInterval = prefs.getInt('drowsinessInterval') ?? 5;
      _alarmSound = prefs.getString('alarmSound') ?? _alarmSounds.first;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('previewEnabled', _previewEnabled);
    await prefs.setInt('cameraMode', _cameraModeIndex);
    await prefs.setInt('drowsinessInterval', _alarmInterval);
    await prefs.setString('alarmSound', _alarmSound);
  }

  void _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _loadSettings();
  }

  Future<void> updateDrowsinessInterval(int interval) async {
    _alarmInterval = interval;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('alarmInterval', interval);
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

          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text('Enable Camera Preview'),
                  value: _previewEnabled,
                  onChanged: (value) async {
                    setState(() {
                      _previewEnabled = value;
                    });
                    await widget.drowsinessDetector.togglePreview();
                    await _saveSettings();
                  },
                ),
                ListTile(
                  title: Text('Camera Mode'),
                  subtitle: Text(_cameraModeIndex == 0 ? 'Front' : 'Back'),
                  trailing: DropdownButton<int>(
                    value: _cameraModeIndex,
                    items: [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Front'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Back'),
                      ),
                    ],
                    onChanged: (int? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          _cameraModeIndex = newValue;
                        });
                        await widget.drowsinessDetector.toggleMode();
                        await _saveSettings();
                      }
                    },
                  ),
                ),
                ListTile(
                  title: Text('Drowsiness Interval (seconds)'),
                  trailing: DropdownButton<int>(
                    value: _alarmInterval,
                    items: [3, 5, 7, 10].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          _alarmInterval = newValue;
                        });
                        await widget.drowsinessDetector
                            .updateDrowsinessInterval(newValue);
                        await _saveSettings();
                      }
                    },
                  ),
                ),
                ListTile(
                  title: Text('Alarm Sound'),
                  trailing: DropdownButton<String>(
                    value: _alarmSound,
                    items: _alarmSounds.map((String sound) {
                      return DropdownMenuItem<String>(
                        value: sound,
                        child: Text(sound),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      if (newValue != null) {
                        setState(() {
                          _alarmSound = newValue;
                        });
                        await _saveSettings();
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    _resetSettings();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Settings reset to default')),
                    );
                  },
                  child: Text('Reset Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
