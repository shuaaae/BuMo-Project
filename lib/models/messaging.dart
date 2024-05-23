import 'package:cloud_firestore/cloud_firestore.dart';

class Messaging {
  String? messagingID;
  String? driverID;
  String? passengerID;
  List<ChatLog>? chatLogs;

  Messaging({
    this.messagingID,
    this.driverID,
    this.passengerID,
    this.chatLogs,
  });

  Map<String, dynamic> toMap() {
    return {
      'driverID': driverID,
      'passengerID': passengerID,
      // Wa diri ang logs kay sub-collection man ito
    };
  }

  factory Messaging.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Messaging(
      messagingID: snapshot.id,
      driverID: data['driverID'],
      passengerID: data['passengerID'],
    );
  }
}

class ChatLog {
  String? chatLogID;
  Timestamp? dateTime;
  String? messageStr;
  String? senderID;

  ChatLog({
    this.chatLogID,
    this.dateTime,
    this.messageStr,
    this.senderID,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'messageStr': messageStr,
      'senderID': senderID,
    };
  }

  factory ChatLog.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ChatLog(
      chatLogID: snapshot.id,
      dateTime: data['dateTime'],
      messageStr: data['messageStr'],
      senderID: data['senderID'],
    );
  }
}
