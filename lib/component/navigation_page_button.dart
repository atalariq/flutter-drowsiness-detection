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
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, destination);
      },
      child: Ink(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0x66FFB81C),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
