import 'package:flutter/material.dart';
import 'package:instagramclone/pages/feed_widget.dart';
import 'package:instagramclone/user/user.dart';
import 'package:instagramclone/widgets/HeaderWidget.dart';
import 'package:instagramclone/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeLinePage extends StatefulWidget {
  final User gCurrentUser;
  TimeLinePage({this.gCurrentUser});
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body: circularProgress(),
    );
  }
  Widget _buildHasPostBody(List<DocumentSnapshot> documents){
    final myPosts=documents
        .where((doc)=>doc['email']==widget.gCurrentUser.email)
        .take(5)
        .toList();
    final otherPosts=documents
        .where((doc)=>doc['email']!=widget.gCurrentUser.email)
        .take(10)
        .toList();
    myPosts.addAll(otherPosts);
    return ListView(
     // children: List.generate(10, (i) => i).map((doc)=>FeedWidget()).toList(),
    );
  }
}
