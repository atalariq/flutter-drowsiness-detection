import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final String destination;

  const NavButton({
    super.key,
    required this.text,
    required this.icon,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, destination);
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0x77FFB81C),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 5),
            Text(text),
          ],
        ),
      ),
    );
  }
}
