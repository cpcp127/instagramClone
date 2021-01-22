import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagramclone/pages/CreateAccountPage.dart';
import 'package:instagramclone/pages/NotificationPage.dart';
import 'package:instagramclone/pages/ProfilePage.dart';
import 'package:instagramclone/pages/SearchPage.dart';
import 'package:instagramclone/pages/TimeLinePage.dart';
import 'package:instagramclone/pages/UploadPage.dart';
import 'package:instagramclone/user/user.dart';

final GoogleSignIn gSignIn=GoogleSignIn();
final userReference = Firestore.instance.collection("users");
final StorageReference storageReference=FirebaseStorage.instance.ref().child("Post Pictures");
final postsReference = Firestore.instance.collection("posts");
final DateTime timestamp=DateTime.now();
User currentUser;
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isSignedIn=false;
  PageController pageController;
  int getPageIndex=0;
  void initState(){
    super.initState();
    pageController=PageController();
    gSignIn.onCurrentUserChanged.listen((gSigninAccount){
      controlSignIn(gSigninAccount);
    },onError: (gError){
      print("Error Message: "+gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error Message: "+gError);
    });
  }
  controlSignIn(GoogleSignInAccount signInAccount)async{
    if(signInAccount !=null){
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn=true;
      });
    }
    else{
      setState(() {
        isSignedIn=false;
      });
    }
  }
  saveUserInfoToFireStore() async{
    final GoogleSignInAccount gCurrentUser=gSignIn.currentUser;
    DocumentSnapshot documentSnapshot= await userReference.document(gCurrentUser.id).get();

    if(!documentSnapshot.exists){
      final username=await Navigator.push(context,MaterialPageRoute(builder: (context)=>CreateAccount()));
      userReference.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "",
        "timestamp": timestamp,
      });
      documentSnapshot=await userReference.document(gCurrentUser.id).get();
    }
    currentUser=User.fromDocument(documentSnapshot);
  }
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  loginUser(){
    gSignIn.signIn();
  }
  logoutUser(){
    gSignIn.signOut();
  }
  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex=pageIndex;
    });
  }
  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
  }
  Scaffold buildHomeScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLinePage(gCurrentUser: currentUser),
          //RaisedButton.icon(onPressed: logoutUser,icon: Icon(Icons.close),label: Text("Sign Out")),
          SearchPage(),
          UploadPage(gCurrentUser: currentUser,),
          NotificationPage(),
          ProfilePage(userProfileId: currentUser.id,),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 37.0,)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  Scaffold buildSignInScreen(){
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("JunstaGram",style: TextStyle(fontSize: 90.0,color: Colors.white,fontFamily: "Signatra"),),
              GestureDetector(
                onTap: (){
                  loginUser();
                },
                child: Container(
                  width: 270.0,
                  height: 65.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/google_sign_logo.png"),

                    )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(isSignedIn)
      {
        return buildHomeScreen();
      }
    else{
      return buildSignInScreen();
    }
  }
}
