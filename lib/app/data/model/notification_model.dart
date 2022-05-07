class NotificationModel {
  String notificationId;
  String title;
  String subTitle;
  String message;
  String deepLinkIos;
  String deepLinkAndroid;
  String category;
  String type;
  bool isRead;
  String createdAt;
  String? orderId;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.subTitle,
    required this.message,
    required this.deepLinkAndroid,
    required this.deepLinkIos,
    required this.category,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.orderId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json){
    return NotificationModel(
      notificationId: json['notification_id'] as String,
      createdAt: json['created_at'] as String,
      title: json['title'].toString(),
      category: json['category'].toString(),
      deepLinkAndroid: json['deeplink']['android'] as String,
      deepLinkIos: json['deeplink']['ios'] as String,
      isRead: json['is_read'] as bool,
      message: json['message'].toString(),
      subTitle: json['sub_title'].toString(),
      type: json['type'].toString(),

    );
  }
}