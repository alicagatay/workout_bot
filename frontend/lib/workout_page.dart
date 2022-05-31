import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/workout.dart';

class WorkoutPage extends StatelessWidget {
  WorkoutPage({Key? key}) : super(key: key);

  Future<Workout> fetchWorkout() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/?msg=${MainScreen.message}')); //the url is localhost for ios and 10.0.2.2 for android

    if (response.statusCode == 200) {
      return Workout.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load workout');
    }
  }

  late Future<Workout> futureWorkout;

  @override
  Widget build(BuildContext context) {
    futureWorkout = fetchWorkout();
    return Scaffold(
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
                  'Workout name: ' + snapshot.data!.name,
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
                  'Equipment needed: ' + snapshot.data!.equipment,
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
                  'Target body part: ' + snapshot.data!.bodyPart,
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
                  'Target muscle: ' + snapshot.data!.target,
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
    );
  }
}
