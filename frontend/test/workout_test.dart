import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/workout.dart';

void main() {
  group('Converting requests as Workout objects', () {
    test('Test 1: Chest Workout', () {
      final request = {
        "bodyPart": "chest",
        "equipment": "barbell",
        "gifUrl": "http://d205bpvrqc9yn1.cloudfront.net/1256.gif",
        "id": "1256",
        "name": "barbell reverse grip decline bench press",
        "target": "pectorals"
      };

      final workoutObject = Workout.fromJson(request);

      expect(workoutObject.bodyPart, equals("chest"));
      expect(workoutObject.equipment, equals("barbell"));
      expect(workoutObject.gifUrl,
          equals("http://d205bpvrqc9yn1.cloudfront.net/1256.gif"));
      expect(workoutObject.id, equals("1256"));
      expect(workoutObject.name,
          equals("barbell reverse grip decline bench press"));
      expect(workoutObject.target, equals("pectorals"));
    });

    test('Test 2: Upper Arm Workout', () {
      final request = {
        "bodyPart": "upper arms",
        "equipment": "dumbbell",
        "gifUrl": "http://d205bpvrqc9yn1.cloudfront.net/1731.gif",
        "id": "1731",
        "name": "dumbbell close grip press",
        "target": "triceps"
      };

      final workoutObject = Workout.fromJson(request);

      expect(workoutObject.bodyPart, equals("upper arms"));
      expect(workoutObject.equipment, equals("dumbbell"));
      expect(workoutObject.gifUrl,
          equals("http://d205bpvrqc9yn1.cloudfront.net/1731.gif"));
      expect(workoutObject.id, equals("1731"));
      expect(workoutObject.name, equals("dumbbell close grip press"));
      expect(workoutObject.target, equals("triceps"));
    });
    test('Test 3: Back Workout', () {
      final request = {
        "bodyPart": "back",
        "equipment": "stability ball",
        "gifUrl": "http://d205bpvrqc9yn1.cloudfront.net/1343.gif",
        "id": "1343",
        "name": "exercise ball prone leg raise",
        "target": "spine"
      };

      final workoutObject = Workout.fromJson(request);

      expect(workoutObject.bodyPart, equals("back"));
      expect(workoutObject.equipment, equals("stability ball"));
      expect(workoutObject.gifUrl,
          equals("http://d205bpvrqc9yn1.cloudfront.net/1343.gif"));
      expect(workoutObject.id, equals("1343"));
      expect(workoutObject.name, equals("exercise ball prone leg raise"));
      expect(workoutObject.target, equals("spine"));
    });
  });
}
