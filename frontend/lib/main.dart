/// The async package.
///
/// The [dart:async] library is used to enable asynchronous programming in the project.
import 'dart:async';

/// The convert package.
///
/// The [dart:convert] package is used to encode and decode different kind of data types into each other.
import 'dart:convert';

/// The material package.
///
/// The [material.dart] package is used to create the design of the application.
import 'package:flutter/material.dart';

/// The [Workout] class
///
/// The [workout.dart] file is imported in order to be able to use the [Workout] class.
import 'package:frontend/workout.dart';

/// The [ChatMessage] class
///
/// The chat_message_model file is imported in order to be able to use the [ChatMessage] class.
import 'chat_message_model.dart';

/// The http.dart package.
///
/// The [http.dart] package is imported in order to be able to do get requests in the software.
import 'package:http/http.dart' as http;

/// Calls the runApp() method.
///
/// This method calls the runApp() method in order to call the [MaterialApp] class,
/// which then calls the [MainScreen] class.
void main() {
  runApp(
    const MaterialApp(
      home: MainScreen(),
    ),
  );
}

/// Creates a new MainScreen class.
///
/// This class creates a new [MainScreen] class, which provides the homescreen of the frontend.
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override

  /// Creates a new MainScreenState state.
  _MainScreenState createState() => _MainScreenState();
}

/// Creates a new _MainScreenState state.
///
/// This class creates a new [_MainScreenState] state, which defines the initial state of the application when opened.
class _MainScreenState extends State<MainScreen> {
  /// Stores the requested workout as a [Future]<Workout> variable.
  ///
  /// The [Future]<Workout> variable stores the workout which will be requested by the user in a get request.
  /// It is defined as a [Future], as the variable will be defined in the future, when the get request is made.
  late Future<Workout> futureWorkout;

  /// Stores the message entered by the user.
  ///
  /// The messageController variable stores the message which the user entered inside the [TextField] widget.
  /// It is stored as a TextEditingController, as its value is taken from a [TextField] widget.
  TextEditingController messageController = TextEditingController();

  /// Stores the messages which are sent by the user.
  ///
  /// The messages variable stores the messages which are both sent by the user and the backend in a [List] variable
  /// called [messages]. The messages are defined in the [ChatMessage] class, and this list is already initiated
  /// by 3 chat messages as an introduction to the user.
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
    /// Stores the response.
    ///
    /// The response value of the get request is stored in the [response] variable.
    /// The response is a JSON object and stored in the [response] variable.
    /// The [response] variable is specified as final.
    final response = await http.get(Uri.parse(
        'http://localhost:3000/?msg=${messageController.text}')); //the url is localhost for ios and 10.0.2.2 for android

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Workout.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load workout');
    }
  }

  /// Controls the scrolling
  ///
  /// The _scrollController is a [ScrollController] variable which is used to control the scrolling of the
  /// messages inside the [ListView] class.
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ///Creates the main skeleton of the application with a [Scaffold] widget.
    return Scaffold(
      backgroundColor: Colors.white,

      ///Creates a [Stack] widget on top of the [Scaffold] widget in order to ensure
      ///easy layouting of the widgets.
      ///
      /// The [Stack] widget contains 2 children:
      /// - A Listview.builder widget which is used to display the messages.
      /// - An [Align] widget which is used to pin the [TextField] widget into the bottom of the screen.
      /// The [Align] widget also has a child as a [Container] widget, which contains a [Column] widget in it.
      /// The [Row] widget at the end contains a [TextField] widget to write messages and a [FloatingActionButton]
      /// widget which is used to send the messages into the backend server.
      body: Stack(
        ///Creates a [ListView] widget which is used to display the messages.
        ///
        /// The [ListView] widget is used to display the messages inside the [ListView] widget.
        /// It also controls the scrolling of the messages with a [ScrollController].
        children: <Widget>[
          ListView.builder(
            /// Adds padding.
            ///
            /// Adds padding between each message to ensure that the messages are not overlapping.
            padding: const EdgeInsets.only(bottom: 350, top: 50),

            /// Sets the item count.
            ///
            /// Set the item count of the builder to the item count of the messages list.
            itemCount: messages.length,

            /// Sets [shrinkWrap] to true.
            ///
            /// Make sure the ListView variable only occupies the space it needs.
            shrinkWrap: true,

            /// Sets up the controller.
            ///
            /// Set the controller of the ListView variable to the _scrollController variable.
            controller: _scrollController,

            /// Sets the [ListView] widget as scrollable.
            physics: const ScrollPhysics(),

            /// Displays each message inside the [messages] list.
            ///
            /// The itemBuilder function is used to display each message inside the [messages] list.
            /// It takes the index of the message as a parameter and returns a [ChatMessage] inside a
            /// [Container] widget. It displays the messages either on the left or on the right side
            /// of the screen based on their sentfromWho.
            itemBuilder: (context, index) {
              return Container(
                /// Adds padding to the message.
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),

                /// Aligns the message.
                ///
                /// The [Align] widget is used to align the message to the left or right side of the screen
                /// based on their [sentfromWho].
                child: Align(
                  /// Aligns the message to a direction.
                  ///
                  /// If the sentfromWho is receiver, align the message to the left side of the screen.
                  /// Otherwise, align the message to the right side of the screen.
                  alignment: (messages[index].sentfromWho == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      /// Sets the color of the message.
                      ///
                      /// If the sentfromWho is receiver, set the background color to Colors.grey.shade200
                      /// Otherwise, set the background color to Colors.blue[200]
                      color: (messages[index].sentfromWho == "receiver"
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),

                    /// Displays the message.
                    ///
                    /// Creates a [Text] widget inside the [Align] widget which displays the
                    /// [messageContent] of the [ChatMessage].
                    child: Text(
                      messages[index].messageContent,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),

          /// Aligns the messaging field.
          ///
          /// Creates a [Align] widget which is used to pin the [Container]
          /// widget that contains the [TextField] into the bottom of the screen.
          Align(
            /// Aligns the widget to the bottom of the screen.
            alignment: Alignment.bottomCenter,

            /// Creates the surroundings of the messaging field.
            ///
            /// Creates a [Container] widget which contains a [Row] widget.
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10, bottom: 15, top: 10, right: 10),
              height: 75,
              width: double.infinity,
              color: Colors.white,

              /// Creates the messaging field.
              ///
              /// Creates a [Row] widget which contains a:
              /// - [TextField] widget to write the message.
              /// - [FloatingActionButton] widget that sends that text into the backend using a http get request.
              child: Row(
                children: <Widget>[
                  /// Adds padding to the left side of the text field.
                  const SizedBox(
                    width: 15,
                  ),

                  /// Covers the [TextField] widget with an [Expanded] widget.
                  Expanded(
                    child: TextField(
                      /// Creates the background of the text field.
                      ///
                      /// Sets the background color and shape of the [TextField] widget
                      /// by using an [InputDecoration] widget.
                      decoration: const InputDecoration(
                        hintText: "Write a message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                      controller: messageController,
                    ),
                  ),

                  /// Adds padding to the right side of the text field.
                  const SizedBox(
                    width: 15,
                  ),

                  /// Creates the send button.
                  ///
                  /// Creates a [FloatingActionButton] widget which sends the message into the backend
                  /// system by using a http get request.
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        /// Add a message to the messages list.
                        ///
                        /// Creates a [ChatMessage] object and adds it to the messages list.
                        /// The [ChatMessage] object contains the text user writes as a
                        /// [messageController.text] variable and has a [sentfromWho] variable
                        /// as "sender".
                        messages.add(ChatMessage(
                          messageContent: messageController.text,
                          sentfromWho: "sender",
                        ));

                        /// Add a message to the messages list.
                        ///
                        /// Creates a [ChatMessage] object and adds it to the messages list.
                        /// The [ChatMessage] object contains a reply from the system as a
                        /// [messageController.text] variable and has a [sentfromWho] variable
                        /// as "receiver".
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

                      /// Wait for 3 seconds before navigating to the next screen.
                      Future.delayed(
                        const Duration(seconds: 3),
                        (() {
                          /// Navigates to the next screen.
                          ///
                          /// [Navigator.push] widget makes the program navigate to the next screen,
                          /// where the information about the workout is displayed.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              /// Build the next screen.
                              ///
                              /// The [builder] function is used to build the next screen.
                              builder: (context) =>

                                  /// Displays the information about the workout.
                                  ///
                                  /// The following [Scaffold] widget is used to display the information
                                  /// about the requested workout. The following properties are displayed
                                  /// inside a [ListView] widget:
                                  /// - Name of the workout.
                                  /// - Required equipment.
                                  /// - The targeted body part.
                                  /// - The targeted muscle group.
                                  /// - A gif image of the workout to show the user how it is done.
                                  Scaffold(
                                backgroundColor: Colors.white,
                                body: ListView(
                                  children: [
                                    /// Displays the workout name
                                    ///
                                    /// Creates a [Text] widget which displays the name of the workout.
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

                                    /// Displays the required equipments name
                                    ///
                                    /// Creates a [Text] widget which displays the name of the required equipments.
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

                                    /// Displays the name of the targeted body part
                                    ///
                                    /// Creates a [Text] widget which displays the name of the targeted body part.
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

                                    /// Displays the name of the targeted muscle group
                                    ///
                                    /// Creates a [Text] widget which displays the name of the targeted muscle group.
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

                                    /// Displays the gif image of the workout
                                    ///
                                    /// Creates a [Image] widget which displays the gif image of the workout
                                    /// that is obtained from the internet
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

                    /// Adds icon to the [FloatingActionButton] widget.
                    ///
                    /// Creates a [Icon] widget which displays
                    /// the Icons.send icon of the [FloatingActionButton].
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
