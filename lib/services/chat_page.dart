import 'package:chat_jasoo/components/chat_bubble.dart';
import 'package:chat_jasoo/components/my_textfield.dart';
import 'package:chat_jasoo/services/auth/auth_servise.dart';
import 'package:chat_jasoo/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

   ChatPage({
    super.key,
     required this.receiverEmail,
     required this.receiverID,
      });
   @override 
   State<ChatPage> createState() => _ChatPageState();
}

   class _ChatPageState extends State<ChatPage> {
  
      //text controller
  final TextEditingController _messageController= TextEditingController();

  // chat 
  final ChatService _chatService= ChatService();
  final AuthServise _authServise= AuthServise();

  // for textfield focus
  FocusNode myFocusNode=FocusNode();

  @override
  void initState() {
   super.initState();

    // add listen
    myFocusNode.addListener((){
      if (myFocusNode.hasFocus){
      // cause a delai
      // then the abaut
      // thr sckro;
      Future.delayed(
        const Duration(
          milliseconds:500 ),
          () => scrollDown(),
          );
      }

    
  });
  // wait a bit
  // Future.delayed(g
  //   const Duration(milliseconds: 500),
  //   ()=>scrollDown(),
  // );
  }
  @override
  void dispose() {
  myFocusNode.dispose();
  _messageController.dispose();
    super.dispose();
  }
  // scrolcontroller
  final ScrollController _scrollController =ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
       duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
    );
  }
  // sed message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // senjnk
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      //clear text controller
      _messageController.clear();
    }
  
   scrollDown();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors. grey ,
        elevation: 0,
      ),
        body: Column(
          children: [
            //display all messages
            Expanded(child: _buildMessageList(),
            ),
            _buildUserInput(),

          ],)
    );
  }

  //build the message list
  Widget _buildMessageList() {
    String senderID= _authServise.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          controller: _scrollController,
          children: 
              snapshot.data!.docs.map((doc)=> _buildMessageItem(doc)).toList(),
        );
      },
    );
  }
  //build 
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data =doc.data( ) as Map<String, dynamic>;
    //icurrent user
    bool isCurrentUser = data['senderID'] == _authServise.getCurrentUser()!.uid;

    // align messa to the rigct if
    var alignment =
     isCurrentUser ? Alignment.centerRight: Alignment.centerLeft;

    return Container(
      alignment:alignment,
      child: Column(
        crossAxisAlignment: 
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
             isCurrentUser: isCurrentUser)
        ],
      )
      );
 }

 //build message input
 Widget _buildUserInput() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 50.0),
    child: Row(
       children: [
         // textfiled shouduld tske
         Expanded(
          child: MyTextfield(
          controller:  _messageController,
          hintText: "Type a message",
          obscureText: false,
          focusNode: myFocusNode,
    
         ),
         ),
         // 
         //send button
         Container(
          decoration:const BoxDecoration(
            color: Colors.green,
            shape :BoxShape.circle,
          ),
          margin:const EdgeInsets.only(right:25),
           child: IconButton(
            onPressed:sendMessage,
            icon:const Icon(
             Icons.arrow_upward,
             color: Colors.white,
            ),
           ),
         ),
       ],
      ),
  );
 }
}
