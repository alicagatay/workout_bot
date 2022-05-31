import json
import os
import random
import pickle
import nltk
from flask import Flask, request
import numpy as np
import tensorflow as tf


models = os.path.relpath('..//models')
chatbotModel = tf.keras.models.load_model(models + '/chatbot_model.h5')


chatbotData = os.path.relpath('..//data')
chatbotIntents = json.loads(
    open(chatbotData + '/intents.json', encoding='UTF-8').read())
exerciseData = json.loads(
    open(chatbotData + '/list_of_all_exercises.json', encoding='UTF-8').read())


chatbotLemmatizer = nltk.stem.WordNetLemmatizer()

chatbotWords = pickle.load(open(chatbotData + '/chatbotWords.pkl', 'rb'))


chatbotClasses = pickle.load(open(chatbotData + '/chatbotClasses.pkl', 'rb'))


def clean_up_sentence(sentence):
    sentence_words = nltk.word_tokenize(sentence)
    for word in sentence_words:
        word = chatbotLemmatizer.lemmatize(word.lower())
    return sentence_words


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
    BW = 'body weight'
    if exercise['bodyPart'] == 'back':
        if exercise['equipment'] == BW:
            back_exercises_calisthenics.append(exercise)
        else:
            back_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'cardio':
        if exercise['equipment'] == BW:
            cardio_exercises_calisthenics.append(exercise)
        else:
            cardio_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'chest':
        if exercise['equipment'] == BW:
            chest_exercises_calisthenics.append(exercise)
        else:
            chest_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'lower arms':
        if exercise['equipment'] == BW:
            lower_arm_exercises_calisthenics.append(exercise)
        else:
            lower_arm_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'lower legs':
        if exercise['equipment'] == BW:
            lower_leg_exercises_calisthenics.append(exercise)
        else:
            lower_leg_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'neck':
        if exercise['equipment'] == BW:
            neck_exercises_calisthenics.append(exercise)
        else:
            neck_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'shoulders':
        if exercise['equipment'] == BW:
            shoulder_exercises_calisthenics.append(exercise)
        else:
            shoulder_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'waist':
        if exercise['equipment'] == BW:
            waist_exercises_calisthenics.append(exercise)
        else:
            waist_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'upper arms':
        if exercise['equipment'] == BW:
            upper_arm_exercises_calisthenics.append(exercise)
        else:
            upper_arm_exercises_gym.append(exercise)
    if exercise['bodyPart'] == 'upper legs':
        if exercise['equipment'] == BW:
            upper_leg_exercises_calisthenics.append(exercise)
        else:
            upper_leg_exercises_gym.append(exercise)


def get_workout(response):
    answer_dict = {
        'back_gym': random.choice(back_exercises_gym),
        'back_calisthenics': random.choice(back_exercises_calisthenics),
        'cardio_gym': random.choice(cardio_exercises_gym),
        'cardio_calisthenics': random.choice(cardio_exercises_calisthenics),
        'chest_gym': random.choice(chest_exercises_gym),
        'chest_calisthenics': random.choice(chest_exercises_calisthenics),
        'lower_arms_gym': random.choice(lower_arm_exercises_gym),
        'lower_arms_calisthenics': random.choice(lower_arm_exercises_calisthenics),
        'lower_legs_gym': random.choice(lower_leg_exercises_gym),
        'lower_legs_calisthenics': random.choice(lower_leg_exercises_calisthenics),
        'neck_calisthenics': random.choice(neck_exercises_calisthenics),
        'shoulders_gym': random.choice(shoulder_exercises_gym),
        'shoulders_calisthenics': random.choice(shoulder_exercises_calisthenics),
        'waist_gym': random.choice(waist_exercises_gym),
        'waist_calisthenics': random.choice(waist_exercises_calisthenics),
        'upper_arms_gym': random.choice(upper_arm_exercises_gym),
        'upper_arms_calisthenics': random.choice(upper_arm_exercises_calisthenics),
        'upper_legs_gym': random.choice(upper_leg_exercises_gym),
        'upper_legs_calisthenics': random.choice(upper_leg_exercises_calisthenics)
    }

    return answer_dict[response]


def run_chatbot(message):
    ints = predict_class(message)
    try:
        response = get_response(ints, chatbotIntents)
        response = get_workout(response)
    except LookupError:
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


@ app.route('/', methods=['GET'])
def run_bot():
    message = request.args.get('msg')
    response = run_chatbot(message)
    return response


app.run(host='localhost', port=3000)
