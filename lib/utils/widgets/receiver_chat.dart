import 'package:flutter/material.dart';

class ReceiverChat extends StatelessWidget {
  final String message;
  final String timestamp;

  const ReceiverChat({
    super.key,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 250),
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding:
              const EdgeInsets.fromLTRB(15, 15, 15, 15), // Adjusted padding
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 52, 52, 53),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
            width: 10), // Spacing between the message container and timestamp
        Text(
          timestamp,
          style: const TextStyle(
            color: Color.fromARGB(179, 0, 0, 0),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
