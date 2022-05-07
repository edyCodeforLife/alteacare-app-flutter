class CMSBlock {
  String id;
  String title;
  String type;
  String text;

  CMSBlock({
    required this.id,
    required this.title,
    required this.type,
    required this.text,
  });

  factory CMSBlock.fromJson(Map<String, dynamic> json) {
    return CMSBlock(
      id: json['block_id'].toString(),
      title: json['title'].toString(),
      type: json['type'].toString(),
      text: json['text'].toString(),
    );
  }
}
