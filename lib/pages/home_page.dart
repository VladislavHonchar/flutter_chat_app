import 'package:flutter/material.dart';
import 'package:mini_mes/components/my_drawer.dart';
import 'package:mini_mes/components/my_user_tile.dart';
import 'package:mini_mes/pages/chat_page.dart';
import 'package:mini_mes/services/auth/auth_service.dart';
import 'package:mini_mes/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }


  // build a list of users exept for the current logged in user

Widget _buildUserList(){
  return StreamBuilder(
    stream: _chatService.getUsersStream(), 
    builder: (context, snapshot) {
      // error
      if(snapshot.hasError){
        return const Text("Error");
      }

      // loading...
      if(snapshot.connectionState == ConnectionState.waiting){
        return const CircularProgressIndicator.adaptive();
      }

      // return list view

      return ListView(
        children: 
          snapshot.data!
          .map<Widget>((userData) => _buildUserListItem(userData, context))
          .toList(),
      );
    },
    );
}

// build individual list tile for user

Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
  //display all users except current user
  if(userData["email"] != _authService.getCurrentUser()!.email){
    return UserTile(
    text: userData["email"], 
    onTap: () {
      // tapped on a user -> go to chat page
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
        recieverEmail: userData["email"],
        receiverID: userData["uid"],
      ),
      )
      );
    }
    );
  } else {
    return Container();
  }

}

}

