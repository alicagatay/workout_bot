
import random
import os
import pickle
import json
import numpy as np
import nltk
import tensorflow as tf
from sklearn.model_selection import train_test_split


nltk.download('punkt')
nltk.download('wordnet')
nltk.download('omw-1.4')


chatbotData = os.path.relpath('..//data')
chatbotIntents = json.loads(
    open(chatbotData + '/intents.json', encoding='UTF-8').read())
exerciseData = json.loads(
    open(chatbotData + '/list_of_all_exercises.json', encoding='UTF-8').read())


chatbotWords = []
chatbotClasses = []
chatbotDocuments = []
ignoreLetters = ['?', '!', '.', ',', "'", '"']
for intent in chatbotIntents['intents']:
    for pattern in intent['patterns']:
        word_list = nltk.word_tokenize(pattern)
        chatbotWords.extend(word_list)
        chatbotDocuments.append((word_list, intent['tag']))
        if intent['tag'] not in chatbotClasses:
            chatbotClasses.append(intent['tag'])


chatbotLemmatiser = nltk.stem.WordNetLemmatizer()


for word in chatbotWords:
    if word not in ignoreLetters:
        word = chatbotLemmatiser.lemmatize(word)


chatbotWords = sorted(set(chatbotWords))
chatbotClasses = sorted(set(chatbotClasses))


pickle.dump(chatbotWords, open(chatbotData + '/chatbotWords.pkl', 'wb'))
pickle.dump(chatbotClasses, open(chatbotData + '/chatbotClasses.pkl', 'wb'))


chatbotData = []
output_empty = [0] * len(chatbotClasses)
for document in chatbotDocuments:
    bag = []
    wordPatterns = document[0]
    for word in wordPatterns:
        word = chatbotLemmatiser.lemmatize(word.lower())
    for word in chatbotWords:
        if word in wordPatterns:
            bag.append(1)
        else:
            bag.append(0)
    output_row = list(output_empty)
    output_row[chatbotClasses.index(document[1])] = 1
    chatbotData.append([bag, output_row])
random.shuffle(chatbotData)


training_data, testing_data = train_test_split(
    chatbotData, test_size=0.3, random_state=25)


training_data = np.array(training_data)
train_x = list(training_data[:, 0])
train_y = list(training_data[:, 1])


testing_data = np.array(testing_data)
test_x = list(testing_data[:, 0])
test_y = list(testing_data[:, 1])


chatbotModel = tf.keras.models.Sequential()
chatbotModel.add(tf.keras.layers.Dense(
    len(train_x[0]), input_shape=(len(train_x[0]),), activation='relu'))
chatbotModel.add(tf.keras.layers.Dropout(0.5))
chatbotModel.add(tf.keras.layers.Dense(len(train_x[0])/2*3, activation='relu'))
chatbotModel.add(tf.keras.layers.Dropout(0.5))
chatbotModel.add(tf.keras.layers.Dense(len(train_y[0]), activation='softmax'))


adam = tf.keras.optimizers.Adam(learning_rate=0.01)

chatbotModel.compile(loss='categorical_crossentropy',
                     optimizer=adam, metrics=['accuracy'])


model_train = chatbotModel.fit(np.array(train_x), np.array(
    train_y), epochs=200, batch_size=len(train_x[0]), verbose=1)


model_test = chatbotModel.evaluate(np.array(test_x), np.array(
    test_y), verbose=1, batch_size=len(test_x[0]))


models = os.path.relpath('..//models')
chatbotModel.save(models + '/chatbot_model.h5', model_train)
print("Done")
