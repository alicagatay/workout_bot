import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/workout.dart';
import 'chat_message_model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(
      home: MainScreen(),
    ),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<Workout> futureWorkout;

  TextEditingController messageController = TextEditingController();

  List messages = [
    ChatMessage(
      messageContent: 'Hey there, ready for an amazing workout session?',
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

  Future<Workout> fetchWorkout() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/?msg=${messageController.text}')); //the url is localhost for ios and 10.0.2.2 for android

    if (response.statusCode == 200) {
      return Workout.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load workout');
    }
  }

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
                        futureWorkout = fetchWorkout();
                        messageController.clear();
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      });

                      Future.delayed(
                        const Duration(seconds: 3),
                        (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                backgroundColor: Colors.white,
                                body: ListView(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                      alignment: Alignment.center,
                                      child: FutureBuilder<Workout>(
                                        future: futureWorkout,
                                        builder: (context, snapshot) {
                                          return Text(
                                            'Workout name: ' +
                                                snapshot.data!.name,
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                      alignment: Alignment.center,
                                      child: FutureBuilder<Workout>(
                                        future: futureWorkout,
                                        builder: (context, snapshot) {
                                          return Text(
                                            'Equipment needed: ' +
                                                snapshot.data!.equipment,
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                      alignment: Alignment.center,
                                      child: FutureBuilder<Workout>(
                                        future: futureWorkout,
                                        builder: (context, snapshot) {
                                          return Text(
                                            'Target body part: ' +
                                                snapshot.data!.bodyPart,
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                      alignment: Alignment.center,
                                      child: FutureBuilder<Workout>(
                                        future: futureWorkout,
                                        builder: (context, snapshot) {
                                          return Text(
                                            'Target muscle: ' +
                                                snapshot.data!.target,
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    FutureBuilder<Workout>(
                                      future: futureWorkout,
                                      builder: (context, snapshot) {
                                        return Image.network(
                                          snapshot.data!.gifUrl,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
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
