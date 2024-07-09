import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final String? destination;
  final VoidCallback? onTap;

  const NavButton({
    super.key,
    required this.text,
    required this.icon,
    this.destination,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (destination != null)
          ? () {
              Navigator.pushNamed(context, destination!);
            }
          : onTap,
      child: Ink(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0x66FFB81C),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
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
