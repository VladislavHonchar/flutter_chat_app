import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_mes/components/chat_bubble.dart';
import 'package:mini_mes/components/my_textfield.dart';
import 'package:mini_mes/services/auth/auth_service.dart';
import 'package:mini_mes/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {

  final String recieverEmail;
  final String receiverID;

  
  ChatPage({
    super.key,
    required this.recieverEmail,
    required this.receiverID,
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services 
  final ChatService _chatService = ChatService();
  final AuthService _auth = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        // cause a so that th keyboard has time yo show up
        // then tje amount of remaining space will be calculated,
        // then the scroll down
        Future.delayed(const Duration(milliseconds: 500), 
        () => scrollDown(),
        );
      }
    });


    // wait a bit for listview to be built, then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown()
      );

  }

 


  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1), 
      curve: Curves.fastOutSlowIn,
      );
  }

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if(_messageController.text.isNotEmpty){
      // send nessage
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      // clear text controller
      _messageController.clear(); 
      
    }
    scrollDown();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
       body: Column(
          children: [
            // display all messages
            Expanded(child: _buildMessageList()),

            // user input
            _buildUserInput(),
          ],
        ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderID = _auth.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID), 
      builder: (context, snapshot) {
        // errors
        if(snapshot.hasError){
          return const Text("ERROR!");
        }

        // loading...
        if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator.adaptive();
        }

        // return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
      );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // is current user
    bool isCurrentUser = data['senderID'] == _auth.getCurrentUser()!.uid;

    // align message to the right if sender is the current user, otherwise left
    var aligment = 
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;


    return Container(
      alignment: aligment,
      child: ChatBubble(
        message: data["message"], 
        isCurrentUser: isCurrentUser
        )
      );
  }

  // build message input
  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: MyTextField(
              focusNode: myFocusNode,
              hintText: "Type a message", 
              obscureText: false, 
              controller: _messageController
              ), 
            ),
      
          // send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(Icons.arrow_upward, color: Colors.white,)
              ),
          ),
        ],
      ),
    );
  }
}