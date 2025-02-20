import 'package:angkas_clone_app/utils/widgets/sender_chat.dart';
import 'package:angkas_clone_app/utils/widgets/receiver_chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:angkas_clone_app/models/messaging.dart';

class ChatScreen extends StatefulWidget {
  final String personName;

  const ChatScreen({super.key, required this.personName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<ChatLog> _messages = [];
  final String myID = "Nio";
  final String senderID = "Nio";

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Function to handle sending message
  void _sendMessage(String messageStr) {
    DateTime timestamp = DateTime.now();

    ChatLog newMessage = ChatLog(
      dateTime: timestamp, // Ensure non-nullable timestamp
      messageStr: messageStr,
      senderID: senderID,
    );

    setState(() {
      _messages.add(newMessage);
      _textEditingController.clear();
    });
  }

  // Function to fetch messages (simulated)
  void _fetchMessages() async {
    List<ChatLog> fetchedMessages = [
      ChatLog(
        dateTime: DateTime.now().subtract(const Duration(minutes: 5)),
        messageStr: "Hello!",
        senderID: senderID,
      ),
      ChatLog(
        dateTime: DateTime.now().subtract(const Duration(minutes: 4)),
        messageStr: "Hi, how are you?",
        senderID: "Jeremy Habal",
      ),
    ];

    setState(() {
      _messages.addAll(fetchedMessages);
    });
  }

  // Function to format timestamp to PST (Philippine Standard Time)
  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return "Unknown"; // Handle null timestamps
    DateTime pstDateTime =
        timestamp.add(const Duration(hours: 8)); // Adjusting to PST
    return DateFormat('h:mm a').format(pstDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: Text(
            widget.personName,
            style: const TextStyle(fontSize: 26),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              itemCount: _messages.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                ChatLog message = _messages[index];
                bool isMe = message.senderID == myID;

                return isMe
                    ? SenderChat(
                        message: message.messageStr ?? '',
                        timestamp: _formatTimestamp(message.dateTime),
                      )
                    : ReceiverChat(
                        message: message.messageStr ?? '',
                        timestamp: _formatTimestamp(message.dateTime),
                      );
              },
            ),
          ),
          BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Type something here...',
                      contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 0),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(
                    Icons.send,
                    size: 30,
                  ),
                  onPressed: () {
                    String message = _textEditingController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
