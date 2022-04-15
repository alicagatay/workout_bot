from flask import Flask, request
import json
import os
import random
import nltk
import numpy as np
import tensorflow as tf
import pickle

models = os.path.relpath('..//models')
chatbotModel = tf.keras.models.load_model(models + '/chatbot_model.h5')

chatbotData = os.path.relpath('..//data')

chatbotIntents = json.loads(open(chatbotData + '/intents.json').read())

exerciseData = json.loads(
    open(chatbotData + '/list_of_all_exercises.json').read())
chatbotLemmatizer = nltk.stem.WordNetLemmatizer()

chatbotWords = pickle.load(open(chatbotData + '/chatbotWords.pkl', 'rb'))
chatbotClasses = pickle.load(open(chatbotData + '/chatbotClasses.pkl', 'rb'))


def clean_up_sentence(sentence):
    sentenceWords = nltk.word_tokenize(sentence)

    for word in sentenceWords:
        word = chatbotLemmatizer.lemmatize(word.lower())

    return sentenceWords


def bag_of_words(sentence):
    sentence_words = clean_up_sentence(sentence)
    bag = [0] * len(chatbotWords)
    for w in sentence_words:
        for i, word in enumerate(chatbotWords):
            if word == w:
                bag[i] = 1
    return np.array(bag)


def predict_class(sentence):
    bow = bag_of_words(sentence)
    res = chatbotModel.predict(np.array([bow]))[0]
    error_threshold = 0.50
    results = [[i, r] for i, r in enumerate(res) if r > error_threshold]
    results.sort(key=lambda x: x[1], reverse=True)
    return_list = []

    for r in results:
        return_list.append(
            {'intent': chatbotClasses[r[0]], 'probability': str(r[1])})
    return return_list


def get_response(intents_list, intents_json):
    tag = intents_list[0]['intent']
    list_of_intents = intents_json['intents']
    for i in list_of_intents:
        if i['tag'] == tag:
            result = random.choice(i['responses'])
            return result


waist_exercises_gym = []
back_exercises_gym = []
cardio_exercises_gym = []
chest_exercises_gym = []
lower_arm_exercises_gym = []
lower_leg_exercises_gym = []
neck_exercises_gym = []
shoulder_exercises_gym = []
upper_arm_exercises_gym = []
upper_leg_exercises_gym = []


waist_exercises_calisthenics = []
back_exercises_calisthenics = []
cardio_exercises_calisthenics = []
chest_exercises_calisthenics = []
lower_arm_exercises_calisthenics = []
lower_leg_exercises_calisthenics = []
neck_exercises_calisthenics = []
shoulder_exercises_calisthenics = []
upper_arm_exercises_calisthenics = []
upper_leg_exercises_calisthenics = []

for exercise in exerciseData:
    if exercise['bodyPart'] == 'back':
        if exercise['equipment'] == 'body weight':
            back_exercises_calisthenics.append(exercise)
        else:
            back_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'cardio':
        if exercise['equipment'] == 'body weight':
            cardio_exercises_calisthenics.append(exercise)
        else:
            cardio_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'chest':
        if exercise['equipment'] == 'body weight':
            chest_exercises_calisthenics.append(exercise)
        else:
            chest_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'lower arms':
        if exercise['equipment'] == 'body weight':
            lower_arm_exercises_calisthenics.append(exercise)
        else:
            lower_arm_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'lower legs':
        if exercise['equipment'] == 'body weight':
            lower_leg_exercises_calisthenics.append(exercise)
        else:
            lower_leg_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'neck':
        if exercise['equipment'] == 'body weight':
            neck_exercises_calisthenics.append(exercise)
        else:
            neck_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'shoulders':
        if exercise['equipment'] == 'body weight':
            shoulder_exercises_calisthenics.append(exercise)
        else:
            shoulder_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'waist':
        if exercise['equipment'] == 'body weight':
            waist_exercises_calisthenics.append(exercise)
        else:
            waist_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'upper arms':
        if exercise['equipment'] == 'body weight':
            upper_arm_exercises_calisthenics.append(exercise)
        else:
            upper_arm_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'upper legs':
        if exercise['equipment'] == 'body weight':
            upper_leg_exercises_calisthenics.append(exercise)
        else:
            upper_leg_exercises_gym.append(exercise)


def run_chatbot(message):
    ints = predict_class(message)
    try:
        response = get_response(ints, chatbotIntents)

        if response == 'back_gym':
            response = random.choice(back_exercises_gym)
        if response == 'cardio_gym':
            response = random.choice(cardio_exercises_gym)
        if response == 'chest_gym':
            response = random.choice(chest_exercises_gym)
        if response == 'lower_arms_gym':
            response = random.choice(lower_arm_exercises_gym)
        if response == 'lower_legs_gym':
            response = random.choice(lower_leg_exercises_gym)
        if response == 'neck_gym':
            response = random.choice(neck_exercises_gym)
        if response == 'shoulders_gym':
            response = random.choice(shoulder_exercises_gym)
        if response == 'upper_arms_gym':
            response = random.choice(upper_arm_exercises_gym)
        if response == 'upper_legs_gym':
            response = random.choice(upper_leg_exercises_gym)
        if response == 'waist_gym':
            response = random.choice(waist_exercises_gym)
        if response == 'back_calisthenics':
            response = random.choice(back_exercises_calisthenics)
        if response == 'cardio_calisthenics':
            response = random.choice(cardio_exercises_calisthenics)
        if response == 'chest_calisthenics':
            response = random.choice(chest_exercises_calisthenics)
        if response == 'lower_arms_calisthenics':
            response = random.choice(lower_arm_exercises_calisthenics)
        if response == 'lower_legs_calisthenics':
            response = random.choice(lower_leg_exercises_calisthenics)
        if response == 'neck_calisthenics':
            response = random.choice(neck_exercises_calisthenics)
        if response == 'shoulders_calisthenics':
            response = random.choice(shoulder_exercises_calisthenics)
        if response == 'upper_arms_calisthenics':
            response = random.choice(upper_arm_exercises_calisthenics)
        if response == 'upper_legs_calisthenics':
            response = random.choice(upper_leg_exercises_calisthenics)
        if response == 'waist_calisthenics':
            response = random.choice(waist_exercises_calisthenics)
    except:
        response = {
            "bodyPart": "N/A",
            "equipment": "N/A",
            "gifUrl": "https://www.iconpacks.net/icons/2/free-sad-face-icon-2691-thumb.png",
            "id": "N/A",
            "name": "N/A",
            "target": "N/A"
        }
    return response


app = Flask(__name__)


@app.route('/', methods=['GET'])
def run_bot():
    message = request.args.get('msg')
    response = run_chatbot(message)
    return response


app.run(host='localhost', port=3000)
