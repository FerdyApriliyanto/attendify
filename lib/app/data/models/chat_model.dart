import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  List<String>? connections;
  List<Chat>? chat;

  ChatModel({
    this.connections,
    this.chat,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        connections: json["connections"] == null
            ? []
            : List<String>.from(json["connections"]!.map((x) => x)),
        chat: json["chat"] == null
            ? []
            : List<Chat>.from(json["chat"]!.map((x) => Chat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": connections == null
            ? []
            : List<dynamic>.from(connections!.map((x) => x)),
        "chat": chat == null
            ? []
            : List<dynamic>.from(chat!.map((x) => x.toJson())),
      };
}

class Chat {
  String? pengirim;
  String? penerima;
  String? pesan;
  String? time;
  bool? isRead;

  Chat({
    this.pengirim,
    this.penerima,
    this.pesan,
    this.time,
    this.isRead,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        pengirim: json["pengirim"],
        penerima: json["penerima"],
        pesan: json["pesan"],
        time: json["time"] == null ? null : json["time"],
        isRead: json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "pengirim": pengirim,
        "penerima": penerima,
        "pesan": pesan,
        "time": time,
        "isRead": isRead,
      };
}
