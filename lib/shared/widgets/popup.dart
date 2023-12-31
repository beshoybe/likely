import 'package:flutter/material.dart';

class CPopup extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  const CPopup(
      {super.key,
      required this.title,
      required this.content,
      required this.onPressed});
  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            onPressed();
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
