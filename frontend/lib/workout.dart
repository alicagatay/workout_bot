/// The implementation of the Workout class.
///
/// This file contains the definition of the Workout class.

class Workout {
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String id;
  final String name;
  final String target;

  ///Creates a new Workout object.
  ///
  /// The constructor takes in the following parameters:
  /// - [id]: The id of the workout.
  /// - [name]: The name of the workout.
  /// - [bodyPart]: The body part of the workout.
  /// - [equipment]: The equipment needed for the workout.
  /// - [gifUrl]: The url of the gif for the workout.
  /// - [target]: The target muscle of the workout.
  Workout({
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.id,
    required this.name,
    required this.target,
  });

  /// Converts the json file into a Workout object.
  ///
  /// This method takes in a json file and converts it into a Workout object.
  factory Workout.fromJson(Map<dynamic, dynamic> json) {
    return Workout(
        bodyPart: json["bodyPart"],
        equipment: json["equipment"],
        gifUrl: json["gifUrl"],
        id: json["id"],
        name: json["name"],
        target: json["target"]);
  }
}
