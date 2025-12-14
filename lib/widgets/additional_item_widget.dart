import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  const CardWidget({super.key, required this.title, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return    Column(

      children: [
        Icon(
          icon, size: 32,
        ),
        const SizedBox(height: 8,),
        Text(title, style: const TextStyle(
          fontSize: 16,

        ),),
        const SizedBox(height: 8,),
        Text(value, style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),),
      ],
    );
  }
}