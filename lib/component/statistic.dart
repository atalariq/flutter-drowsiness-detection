import 'package:flutter/material.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key});

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  String _conclusion = "Kondisi Anda Masih Baik!";
  String _uptime = "00:00:00";
  int _awakeness = 100;
  int _sleepiness = 0;

  void _resetStats() {
    // Implement your reset logic here
    setState(() {
      _conclusion = "Kondisi Anda Masih Baik!";
      _uptime = "00:00";
      _awakeness = 100;
      _sleepiness = 0;
    });
  }

  // Stat Widget helper
  Widget _miniStat(String title, String value) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Color(0x66FFB81C),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Color(0x66FFB81C),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and Reset Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Stats",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: _resetStats, // Handle your callback
                  child: Ink(
                    width: 75,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Color(0x66FFB81C),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.history,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Reset",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // Stats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _miniStat("Waktu\nPemakaian", _uptime),
                SizedBox(width: 10),
                _miniStat("Tingkat\nKesadaran", "${_awakeness.toString()}%"),
                SizedBox(width: 10),
                _miniStat("Tingkat\nKantuk", "${_sleepiness.toString()}%"),
              ],
            ),
          ),

          // Conclusion
          Text(
            _conclusion,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
