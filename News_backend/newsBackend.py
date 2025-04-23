from flask import Flask,request,jsonify
from newsdataapi import NewsDataApiClient
import pandas as pd
from nltk.tokenize import sent_tokenize
from pyarabic.araby import tokenize
from nltk.stem import ISRIStemmer
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.stem.snowball import SnowballStemmer
from numpy.core import numerictypes
from sklearn.cluster import KMeans
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import nltk
import re
nltk.download('stopwords')
nltk.download('punkt')
stopwords_list = stopwords.words('arabic')
from nltk.tokenize import RegexpTokenizer
from sklearn.model_selection import train_test_split
stop_words = set(stopwords.words('arabic'))
from sklearn.preprocessing import LabelEncoder
from imblearn.over_sampling import SMOTE
from sklearn.svm import LinearSVC
from sklearn.model_selection import GridSearchCV
from sklearn import metrics
from sklearn.metrics import accuracy_score
import pickle

stemmer = SnowballStemmer("arabic")

app = Flask(__name__)
data = pd.DataFrame(columns=['text', 'title', 'summary','category' ,'source' , 'date_time','imageurl','url_link'])

@app.route("/api")
def hello_world():
    d = {}
    d['Query'] = str(request.args['Query'])
    json_data = data.to_dict(orient='records')
    return jsonify(json_data)


def get_data_frame():
    data = pd.DataFrame(columns=['text', 'title', 'summary','category' ,'source' , 'date_time','imageurl','url_link'])
    api = NewsDataApiClient(apikey="pub_27382f8134471b90c6526a90b779174627d7c")

    response1 = api.news_api(category="sports", language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'],
        'title': response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'],# 'summary': 'غير محدد',
        'category': response1["results"][i]['category'][0] or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)

    response1 = api.news_api(category="technology", language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'] ,
        'title':  response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'],# 'summary': 'غير محدد',
        'category': response1["results"][i]['category'][0] or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)

    response1 = api.news_api(q="ثقافي", language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'] ,
        'title': response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'],# 'summary': 'غير محدد' ,
        'category': 'culture' or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)

    response1 = api.news_api(category="business", language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'] ,
        'title': response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'],# 'summary': 'غير محدد' ,
        'category': 'economy' or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)


    response1 = api.news_api(category="politics", language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'] ,
        'title': response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'],# 'summary': 'غير محدد',
        'category': 'politic' or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)

    response1 = api.news_api(category="world", language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'],
        'title': response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'],# 'summary': 'غير محدد',
        'category': 'internationalnews' or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)

    response1 = api.news_api(category="top" ,  language="ar")
    for i in range(0, len(response1["results"])):
        data = data.append({'text': response1["results"][i]['content'] ,
        'title': response1["results"][i]['title'] or 'غير محدد',
        'summary': response1["results"][i]['description'],# 'summary': 'غير محدد' ,
        'category': 'diverse' or 'Unknown',
        'source': response1["results"][i]['source_id'] or 'Un-Identified',
        'date_time': response1["results"][i]['pubDate'] or '2023-01-01 00:00:00',
        'imageurl': response1["results"][i]['image_url'] or 'NaN',
        'url_link': response1["results"][i]['link'] or 'https://www.damascusuniversity.edu.sy/ite/index.php?set=3&lang=1&id=385',
                }, ignore_index=True)

    print("in get data")
    return data


data = get_data_frame()
data.dropna(subset=['text'], inplace=True)
# print(data)
# data = pd.read_csv('c:\\Users\\ASUS\\Desktop\\News_backend\\output.csv')
cat_data=pd.read_csv("C:\\Users\\ASUS\\Desktop\\News_backend\\arabic_categorization_data.csv")

def remove_emoji(tweet):
    emoji = re.compile("["
        u"\U0001F600-\U0001F64F"  # emoticons
        u"\U0001F300-\U0001F5FF"  # symbols & pictographs
        u"\U0001F680-\U0001F6FF"  # transport & map symbols
        u"\U0001F1E0-\U0001F1FF"  # flags (iOS)
                           "]+", flags=re.UNICODE)
    tweet = emoji.sub(r'', tweet)
    return tweet


def del_lat(tweet):
    pattern= r"[^#\S+] | [a-z]+ |[A-Z]+ "
    tweet=re.sub(pattern, " ", tweet)
    return tweet


def norm_hamza(tweet):
     return re.sub(r"(ؤ|ئ|ء)","ء",tweet)


def norm_alef(tweet):
     return re.sub(r'(ا|أ|إ)','ا',tweet)


def delete_tatwel(tweet):
    return re.sub(r"(ـ)+" , "" , tweet)


def delete_tashkel(tweet):
    patternH=r"(ّ|ّ|ً|ُ|ٌ|َ|ِ|ٍ|ْ)"
    return re.sub(patternH , "" , tweet)

def deletespace(tweet):
    pattern = r"( )\1{1,}"
    return re.sub(pattern , " " , tweet)


def tokinizerse(text):
    return sent_tokenize(text)


def tokinizer(text):
     tokinized=[]
     for sent in text :
          tokinized.append(tokenize(sent))
     return tokinized


def text_preprocessing(sentences: list) -> list:
    stop_words = set(stopwords.words('arabic'))

    clean_words = []

    for sent in sentences:
       words = [stemmer.stem(word)for word in sent if word.isalnum()]
       clean_words.append([word for word in words if word not in stop_words])

    return clean_words


def textcleaning( data):
    print("in textcleaning")
    data['text_to_phreses'] = data['text'].apply(tokinizerse)
    data['cleand_content'] = data['text'].apply(remove_emoji)
    data['cleand_content'] = data['cleand_content'].apply(del_lat)
    data['cleand_content'] = data['cleand_content'].apply(delete_tashkel)
    data['cleand_content'] = data['cleand_content'].apply(norm_hamza)
    data['cleand_content'] = data['cleand_content'].apply(delete_tatwel)
    data['cleand_content'] = data['cleand_content'].apply(deletespace)
    data['cleand_content'] = data['cleand_content'].apply(tokinizerse)
    data['cleand_content'] = data['cleand_content'].apply(tokinizer)
    data['cleand_content'] = data['cleand_content'].apply(text_preprocessing)

    return data 

data = textcleaning(data)
print(data)


vectorizer = TfidfVectorizer()
num_clusters =2
kmeans = KMeans(n_clusters=num_clusters, random_state=0)


print("before culstering")
for i in range(len(data)):
    print("iiii")
    print(i)
    joined_sentences = [" ".join(sentence) for sentence in data['cleand_content'][i]]
    # print(joined_sentences)
    # Calculate the TF-IDF weight of each word in the sentence
    tfidf_weights = vectorizer.fit_transform(joined_sentences)
    weights = {}
    if (len(data['text_to_phreses'][i]) > num_clusters) :
        # print(data['text_to_phreses'][i])
        print(len(data['text_to_phreses'][i]))
        print(num_clusters)
        clusters = kmeans.fit_predict(tfidf_weights)
        print("Cluster labels:")
        # print(clusters)
        centroids = kmeans.cluster_centers_

    # For each cluster, find the document closest to the centroid
        for y in range(num_clusters):
            cluster_indices = [j for j, c in enumerate(kmeans.labels_) if c == y]
            cluster_documents = tfidf_weights[cluster_indices]
            distances = [np.linalg.norm(d - centroids[y]) for d in cluster_documents]
            closest_index = cluster_indices[np.argmin(distances)]
            print("Cluster {} summary: {}".format(i+1,  data['text_to_phreses'][i][closest_index]))
            if y == 0:
              data['summary'][i] = data['text_to_phreses'][i][closest_index]
            elif y > 0 :
              data['summary'][i]= data['summary'][i] +  data['text_to_phreses'][i][closest_index]
              print(data['summary'][i])
    # else:
    #     for b in range(len(data['text_to_phreses'][i])) :
    #       if b ==0:
    #           data['summary'][i] = data['text_to_phreses'][i][b]
    #       else:
    #           data['summary'][i]= data['summary'][i] +  data['text_to_phreses'][i][b]
 
print("after")



data.dropna(subset=['summary'], inplace=True)
vectorizer = TfidfVectorizer()

# Initialize a list to store the similarity scores
similarity_scores = []

# Iterate over each pair of rows
indices_to_drop = []
print("beofre")
print(len(data))

for i in range(len(data)):
    for j in range(i + 1, len(data) -1 ):
        # Get the 'summary' values of the two rows
        summary1 = data.iloc[i]['summary']
        summary2 = data.iloc[j]['summary']
        print("-------------------------------------------------------------------")
        print(summary1)
        print("*****************************************************************************************")
        print(summary2)
    

        if data.iloc[j]['category'] == data.iloc[i]['category']:
           if(len(summary1)>=1 and len(summary2)>=1):
        # Fit and transform the 'summary' values into TF-IDF vectors
                vectors = vectorizer.fit_transform([summary1, summary2])

        # Calculate the cosine similarity between the vectors
                similarity_score = cosine_similarity(vectors[0], vectors[1])[0][0]
                if similarity_score > 0.8:
                    indices_to_drop.append(j)
                    data.fillna("nan")
                    data.drop(indices_to_drop, inplace=True)
        
print("after cosine")
print(len(data))
data['imageurl'] = data['imageurl'].fillna('NaN')
# data.to_csv("c:\\Users\\ASUS\\Desktop\\News_backend\\output.csv")
json_string =data.to_json( orient='records', force_ascii=False)


def without_stop_word(tweet):
    st=" ".join([w for w in str(tweet).split() if not w in stopwords_list])
    return st

def stemming(word):
    ar_stemmer= stemmer('arabic')
    words=tokenizer.tokenize(word)
    for i in words:
        if re.match(r"[ا-ي]+", i):
            word= re.sub(i , ar_stemmer.stemWord(i),word)
    return word

def remove_diacritics(text):
    arabic_diacritics = re.compile("""     | # Tashdid
                                 | # Fatha
                                 | # Tanwin Fath
                                 | # Damma
                                 | # Tanwin Damm
                                 | # Kasra
                                 | # Tanwin Kasr
                                 | # Sukun
                             ـ     # Tatwil/Kashida
                         """, re.VERBOSE)
    text = re.sub(arabic_diacritics, '', str(text))
    return text

def remove_emoji(text):
    regrex_pattern = re.compile(pattern = "["
        u"\U0001F600-\U0001F64F"  # emoticons
        u"\U0001F300-\U0001F5FF"  # symbols & pictographs
        u"\U0001F680-\U0001F6FF"  # transport & map symbols
        u"\U0001F1E0-\U0001F1FF"  # flags (iOS)
                           "]+", flags = re.UNICODE)
    return regrex_pattern.sub(r'',text)

def clean_text(text):
    #ext = "".join([word for word in text if word not in string.punctuation])
    #ext = remove_emoji(text)
    #text = remove_diacritics(text)
    tokens = word_tokenize(text)
    text = ' '.join([word for word in tokens if word not in stop_words])
    return text

def cat_classification():
    cat_data['cleaned_text'] = cat_data['text'].apply(clean_text)
    List = []
    for row in cat_data.itertuples():
         List.append(re.sub(r'[\W\s]', ' ', row.text))
    cat_data['attempt_million_cleaned'] = List

    label_encoder = LabelEncoder()
    cat_data['encodedLabel'] = label_encoder.fit_transform(cat_data['type'])
    local_news_indices = cat_data[cat_data['type'] == 'localnews'].index
    drop_indices = np.random.choice(local_news_indices, size=3000, replace=True)
    cat_data = cat_data.drop(drop_indices)
    class_counts = cat_data['type'].value_counts()
    X_cla = cat_data['attempt_million_cleaned']
    y_cla = cat_data['encodedLabel']
    smote = SMOTE()
    X_train, X_test, y_train, y_test = train_test_split(X_cla, y_cla, test_size=0.33, random_state=42)
    X_train_tfidf = vectorizer.fit_transform(X_train)
    X_test_tfidf = vectorizer.transform(X_test)
    X_train_tfidf.shape
    X_resampled, y_resampled = smote.fit_resample(X_train_tfidf, y_train)
    param_grid = {'C': np.logspace(-4, 4, 9)}
    grid_search = GridSearchCV(LinearSVC(), param_grid, cv=7)
    grid_search.fit(X_resampled, y_resampled)
    print("Best parameter: ", grid_search.best_params_)
    print("Best score: ", grid_search.best_score_)
    best_estimator = grid_search.best_estimator_
    pickle.dump(best_estimator, file)

def makeclassification():
  with open('saved_model.pkl', 'rb') as file:
    loaded_model = pickle.load(file)
    cat_data['cleaned_text'] = cat_data['text'].apply(clean_text)
    List = []
    for row in cat_data.itertuples():
         List.append(re.sub(r'[\W\s]', ' ', row.text))
    cat_data['attempt_million_cleaned'] = List

    label_encoder = LabelEncoder()
    cat_data['encodedLabel'] = label_encoder.fit_transform(cat_data['type'])
    local_news_indices = cat_data[cat_data['type'] == 'localnews'].index
    drop_indices = np.random.choice(local_news_indices, size=3000, replace=True)
    cat_data = cat_data.drop(drop_indices)
    class_counts = cat_data['type'].value_counts()
    X_cla = cat_data['attempt_million_cleaned']
    y_cla = cat_data['encodedLabel']
    smote = SMOTE()
    X_train, X_test, y_train, y_test = train_test_split(X_cla, y_cla, test_size=0.33, random_state=42)
    X_train_tfidf = vectorizer.fit_transform(X_train)
    summaries = data['summary']
    vectorized_summaries = vectorizer.transform(summaries)
    predictions = loaded_model.predict(vectorized_summaries)
    data['category'] = predictions
    data['category'] = label_encoder.inverse_transform(data['category'])


if __name__ == "__main__":
    app.run(debug = True, port = 8000)