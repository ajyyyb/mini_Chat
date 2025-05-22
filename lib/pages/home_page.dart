import 'package:chat_jasoo/components/my_drawer.dart';
import 'package:chat_jasoo/components/user_tile.dart';
import 'package:chat_jasoo/services/auth/auth_servise.dart';
import 'package:chat_jasoo/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../services/chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat & auth service
  final ChatService _chatService = ChatService();
  final AuthServise _authService = AuthServise();

  void logout() {
    final auth = AuthServise();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors. grey ,
        elevation: 0,
        actions: [],
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(context),
    );
  }

  // build
  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        // loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Zagruzks");
        }

        // return list view
        return ListView(
          children: snapshot.data!
          .map<Widget>((userData) => _buildUserListItem(userData, context))
          .toList(),
        );
      },
    );
  }

  // build individual list tile for user
  Widget _buildUserListItem(
     Map<String, dynamic> userData,BuildContext context) {
    // display
  if (userData["email"]!= _authService.getCurrentUser()!.email){
      return UserTile(
        text: userData['email'],
        onTap: () {
          // navigate to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
            ),
          ),
          );
        },
      );
    } else  {
      return Container ();
    }
 }
}