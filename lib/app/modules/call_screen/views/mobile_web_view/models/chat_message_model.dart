class ChatMessage {
  String name;
  String message;
  String type;
  String sender;
  String time;

  ChatMessage({
    required this.message,
    required this.type,
    required this.sender,
    required this.time,
    required this.name,
  });
}
