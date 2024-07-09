import 'package:flutter/material.dart';

class StatWidget extends StatefulWidget {
  final int uptime;
  final double awakenessLevel;
  final double drowsinessLevel;
  final VoidCallback resetStat;

  const StatWidget({
    super.key,
    required this.uptime,
    required this.awakenessLevel,
    required this.drowsinessLevel,
    required this.resetStat,
  });

  @override
  State<StatWidget> createState() => _StatWidgetState();
}

class _StatWidgetState extends State<StatWidget> {
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
    String conclusion = (widget.drowsinessLevel < 0.4)
        ? "Kondisi Anda Masih Baik!"
        : "Anda Sebaiknya Istirahat!";
    return Container(
      width: 320,
      height: 220,
      decoration: BoxDecoration(
        color: Color(0x66FFB81C),
        borderRadius: BorderRadius.all(Radius.circular(30)),
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
                  "Stat",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: widget.resetStat, // Handle your callback
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
                _miniStat("Waktu\nPemakaian",
                    "${(widget.uptime / 60).toDouble().toStringAsFixed(2)}m"),
                SizedBox(width: 10),
                _miniStat("Tingkat\nKesadaran",
                    "${(widget.awakenessLevel * 100).toStringAsFixed(2)}%"),
                SizedBox(width: 10),
                _miniStat("Tingkat\nKantuk",
                    "${(widget.drowsinessLevel * 100).toStringAsFixed(2)}%"),
              ],
            ),
          ),

          // Conclusion
          Text(
            conclusion,
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
