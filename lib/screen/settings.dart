import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _previewEnabled;
  late int _cameraModeIndex;
  late int _alarmInterval;
  late String _alarmSound;

  final List<String> _alarmSounds = [
    'alarm1',
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
      _cameraModeIndex = prefs.getInt('cameraMode') ?? 1;
      _alarmInterval = prefs.getInt('alarmInterval') ?? 3;
      _alarmSound = prefs.getString('alarmSound') ?? _alarmSounds.first;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('previewEnabled', _previewEnabled);
    await prefs.setInt('cameraMode', _cameraModeIndex);
    await prefs.setInt('alarmInterval', _alarmInterval);
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

  TextStyle titleTextStyle = TextStyle(
    fontFamily: "Roboto",
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.black,
  );

  TextStyle subtitleTextStyle = TextStyle(
    fontFamily: "Roboto",
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: Colors.black,
  );

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
      body: Container(
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
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Mode Kamera', style: titleTextStyle),
                    subtitle: Text('Atur penggunaan kamera depan/belakang',
                        style: subtitleTextStyle),
                    trailing: DropdownButton<int>(
                      value: _cameraModeIndex,
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text('Belakang'),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Depan'),
                        ),
                      ],
                      onChanged: (int? newValue) async {
                        if (newValue != null) {
                          setState(() {
                            _cameraModeIndex = newValue;
                          });
                          await _saveSettings();
                        }
                      },
                    ),
                  ),
                  SwitchListTile(
                    title: Text('Pratinjau Kamera', style: titleTextStyle),
                    subtitle: Text(
                      'Tampilkan pratinjau secara bawaan\n(Nonaktifkan untuk menghemat baterai)',
                      style: subtitleTextStyle,
                    ),
                    value: _previewEnabled,
                    onChanged: (value) async {
                      setState(() {
                        _previewEnabled = value;
                      });
                      await _saveSettings();
                    },
                  ),
                  ListTile(
                    title: Text('Interval Peringatan', style: titleTextStyle),
                    subtitle: Text(
                        'Atur jeda alarm peringatan ketika terdeteksi (detik)',
                        style: subtitleTextStyle),
                    trailing: DropdownButton<int>(
                      value: _alarmInterval,
                      items: [1, 2, 3, 4, 5].map((int value) {
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
                          await _saveSettings();
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Bunyi Alarm', style: titleTextStyle),
                    subtitle: Text('Atur bunyi alarm yang digunakan',
                        style: subtitleTextStyle),
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
                  ListTile(
                    title: Text('Atur Ulang', style: titleTextStyle),
                    subtitle: Text(
                      'Tekan lama untuk kembali ke pengaturan awal',
                      style: subtitleTextStyle,
                    ),
                    onLongPress: () async {
                      _resetSettings();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Settings reset to default')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
