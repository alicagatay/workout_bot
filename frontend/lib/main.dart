import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/workout_page.dart';
import 'chat_message_model.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MainScreen(),
    ),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static String message = '';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController messageController = TextEditingController();

  List messages = [
    ChatMessage(
      messageContent: 'Hey there, welcome to WorkoutBot!',
      sentfromWho: 'receiver',
    ),
    ChatMessage(
        messageContent:
            'To get started, just ask me for a workout for a body part, and also tell me if you want to work out at the gym or at home , and then watch the magic in your eyes.',
        sentfromWho: 'receiver'),
    ChatMessage(
        messageContent:
            'Available body parts are: back, cardio, chest, lower arm, lower leg, neck, shoulder, upper arm, upper leg and waist.',
        sentfromWho: 'receiver'),
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 350, top: 50),
            itemCount: messages.length,
            shrinkWrap: true,
            controller: _scrollController,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].sentfromWho == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].sentfromWho == "receiver"
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10, bottom: 15, top: 10, right: 10),
              height: 75,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Write a message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                      controller: messageController,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      MainScreen.message = messageController.text;
                      setState(() {
                        messages.add(ChatMessage(
                          messageContent: messageController.text,
                          sentfromWho: "sender",
                        ));

                        messages.add(ChatMessage(
                          messageContent: "Loading the workout...",
                          sentfromWho: "receiver",
                        ));
                      });
                      setState(() {
                        messageController.clear();
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });

                      Future(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutPage(),
                          ),
                        );
                      });
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
