import 'package:flutter/material.dart';
import 'package:instagramclone/widgets/HeaderWidget.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: header(context,strTitle: "Notifications"),
    );
  }
}
class NotificationsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
  }
}

