# WorkoutBot | Workout Recommender Chatbot

WorkoutBot is a workout recommender chatbot system that recommends workouts based on the user's requests.

## Architecture

WorkoutBot consists of both a frontend and a backend architecture.

The frontend consists of a mobile application built with Flutter. It consists of 4 files, `main.dart`, `chat_message_model.dart`, `workout_page.dart` and `workout.dart`. The file `main.dart` is the main layout file. It determines the main messagin layout of the UI. The file `chat_message_model.dart` is the file that contains the class ChatMessage, that contains the properties of a message. The file `workout.dart` is the file that contains the class Workout, in which helps the frontend to convert the workout recommendation that comes from the backend to a list in order to show it to the user. The file `workout_page.dart` is the file that contains the class WorkoutPage, which has a role of displaying the requested workout in a new page.

The backend consists of both the deep learning model that is used to train the chatbot and the server that is used to communicate with the frontend. The deep learning model is a simple Feed Forward Neural Network, built using Python and Tensorflow, that is trained using the file `intents.json` file. The backend server is a simple REST API that is used to communicate with the frontend. It is built using Python and Flask.

## Installation

Right now, because the software has not been published with any official release, the only way to install the software for testing purposes is to clone the source code from the Github repository.

```
git clone https://github.com/alicagatay/workout_bot.git
```

## Setup

The software is setup using the following steps:

In order to setup the frontend, you need to install the Flutter SDK by following the steps on the [Flutter website](https://flutter.dev/docs/get-started/install/).

In order to setup the backend, first ensure that you have installed Python. Then, install the following Python dependencies:

1. Tensorflow
2. Flask
3. Numpy
4. NLTK
5. Scikit-learn

## Usage

In order to test run the software, you first need to run the backend server. To do this, run the file `server.py` inside backend>scripts with the following command:

```
python server.py
```

After running the server, you can test the frontend by opening the folder named frontend and running the following commands:

```
flutter pub get
```

```
flutter run
```
