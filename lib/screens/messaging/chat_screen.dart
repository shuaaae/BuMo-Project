import 'package:angkas_clone_app/utils/widgets/sender_chat.dart';
import 'package:angkas_clone_app/utils/widgets/receiver_chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:angkas_clone_app/models/messaging.dart';
import 'package:intl/intl.dart';

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

  final String myID2 = "Jeremy Habal";
  final String senderID2 = "Jeremy Habal";

  final String myID3 = "Dreyber SweetLober";
  final String senderID3 = "Dreyber SweetLober";

  final String messagingID = "Mess#1";
  final String messagingID2 = "Mess#2";
  final String messagingID3 = "Mess#3";

  final String chatID = "Chat#1";
  final String chatID2 = "Chat#2";
  final String chatID3 = "Chat#3";

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
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);

    ChatLog newMessage = ChatLog(
      dateTime: timestamp,
      messageStr: messageStr,
      senderID: senderID,
    );

    setState(() {
      _messages.add(newMessage);
      _textEditingController.clear();
    });

    // Save to Firebase
    FirebaseFirestore.instance
        .collection('messaging')
        .doc(messagingID2)
        .collection(chatID2)
        .add(newMessage.toMap());
  }

  // Function to fetch messages from Firestore
  void _fetchMessages() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('messaging')
        .doc(messagingID2)
        .collection(chatID2)
        .orderBy('dateTime')
        .get();

    List<ChatLog> fetchedMessages = snapshot.docs.map((doc) {
      return ChatLog.fromSnapShot(doc); // Use fromSnapShot method instead
    }).toList();

    setState(() {
      _messages.addAll(fetchedMessages);
    });
  }

  // Function to format timestamp to PST (Philippine Standard Time)
  String _formatTimestamp(Timestamp timestamp) {
    DateTime utcDateTime = timestamp.toDate();
    DateTime pstDateTime =
        utcDateTime.add(const Duration(hours: 8)); // Adjusting to PST
    String formattedDate = DateFormat('h:mm a').format(pstDateTime);
    return formattedDate;
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
                return const SizedBox(
                    height: 10); // Add spacing of 10 between items
              },
              itemBuilder: (context, index) {
                ChatLog message = _messages[index];
                // Check if the sender ID matches your ID
                bool isMe = message.senderID == myID;

                return isMe
                    ? SenderChat(
                        message: message.messageStr ?? '',
                        timestamp: _formatTimestamp(message.dateTime!),
                      )
                    : ReceiverChat(
                        message: message.messageStr ?? '',
                        timestamp: _formatTimestamp(message.dateTime!),
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
                    maxLines: null, // Allow up to 5 lines
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
