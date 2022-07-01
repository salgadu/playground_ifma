import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Column(
        children: [
          Image.asset(
            'assets/images/ifma_logo.png',
            width: 100,
          ),
          const SizedBox(height: 15),
          const Text(
            "Ticket IFMA",
            style: TextStyle(
              color: Colors.teal,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
