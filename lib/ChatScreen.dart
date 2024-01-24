import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ApiService.dart';
import 'ChatMessage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool isLoading = false;

  Future<void> _sendMessage() async {
    ChatMessage _message = ChatMessage(
      text: controller.text,
      sender: 'User',
    );
    setState(() {
      _messages.insert(0, _message);
      isLoading = true;
    });
    ApiServices.generateResponces(controller.text).then((value) {
      setState(() {
        ChatMessage _message = ChatMessage(
          text: value,
          sender: 'Bots',
        );
        _messages.insert(0, _message);
        isLoading = false;
      });
    });
    controller.clear();
  }

  Widget messageListView(ChatMessage chatMessage, int index) {
    return Align(
        alignment: chatMessage.sender == 'bots'
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: chatMessage.sender == 'bots'
                ? const Color.fromRGBO(59, 60, 75, 1.0)
                : const Color(0xFF343541),
          ),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade50,
                  child: Text(chatMessage.sender[0]),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatMessage.sender,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    child: Text(chatMessage.text,style: const TextStyle(color:Colors.white,),),
                  )
                ],
              ))
            ],
          ),
        ),

    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF343541),
      appBar: const CupertinoNavigationBar(
        backgroundColor: Color.fromRGBO(16, 163,127, 1),
        middle: Text("ChatGpt",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.separated(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return messageListView(_messages[index], index);
                },
                itemCount: _messages.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  color:  Color(0xFF444654),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        onSubmitted: (value) =>  isLoading ? (){} : _sendMessage(),
                        decoration:  InputDecoration.collapsed(
                            hintText:  isLoading ? "Please wait for Response" :"Send a Message",
                        hintStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.normal),
                        focusColor: Colors.white,),
                        controller: controller,
                            style: const TextStyle(color: Colors.white,),
                      )),
                      isLoading ? const CircularProgressIndicator(color: Colors.white,):
                      IconButton(
                          onPressed: () => _sendMessage(),
                          icon: const Icon(Icons.send,color: Colors.white,))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

