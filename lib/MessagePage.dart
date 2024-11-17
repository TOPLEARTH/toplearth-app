import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final String payload;

  const MessagePage({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message Page"),
      ),
      body: Center(
        child: Text(payload),
      ),
    );
  }
}
