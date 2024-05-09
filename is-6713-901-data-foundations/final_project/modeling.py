import pandas as pd
from sklearn.metrics import precision_score, recall_score, f1_score, mean_absolute_error, mean_squared_error, r2_score, explained_variance_score
from sklearn.feature_extraction.text import CountVectorizer, TfidfTransformer
from sklearn.svm import SVC, LinearSVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score, make_scorer
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.linear_model import LogisticRegression
import warnings
import scipy.sparse as sp
import numpy as np
import re
np.random.seed(42)
import random
random.seed(42)
warnings.filterwarnings('ignore') 
pd.set_option('display.max_columns', None)
import csv

X_txt = []
y_tech = []
y_politics = []
df = pd.read_csv('data/processed/gold_standard_annotations.csv')
with open('data/processed/gold_standard_annotations.csv', newline='', encoding='utf-8') as f:
    reader = csv.reader(f)
    for row in reader:
        if row[2] == 'tech':
            continue
        elif row[3] == 'politics':
            continue
        else:
            # clean_text = re.sub('[^A-Za-z]+', ' ', row[1])
            int_text = re.sub(r'\w+:\/{2}[\d\w-]+(\.[\d\w-]+)*(?:(?:\/[^\s/]*))*', '', row[1], flags=re.MULTILINE)
            # row[1].replace("\n", "")
            x = "".join(int_text.strip())
            tech = row[2].upper()
            politics = row[3].upper()
            X_txt.append(x)
            y_tech.append(tech)
            y_politics.append(politics)
        # print(x)
        # print(row)
X_txt = np.array(X_txt)
y_tech = np.array(y_tech)
y_politics = np.array(y_politics)
df = pd.read_csv('data/processed/gold_standard_annotations.csv')

fix_list = []
for idx, row in df.iterrows():
    new = row['tech'].upper()
    fix_list.append(new)
df['tech'] = fix_list
# print(df['tech'].value_counts())
class LexiconClassifier():
    def __init__(self):
        """
            Initalize the Lexicon classifer by loading lexicons. 
        """
        self.words = list()
        for row in X_txt:
            clean = row.strip()
            self.words.append(clean)

    def count_exclamation(self, text):
        self.text = text.find("!")
        return self.text

    def length_tweet(self, text):
        self.text = text
        return len(text)
    
    def count_uppercase(self, text):
        return sum(map(str.isupper, text.split()))


# Uncomment to switch between politics/tech
train_data, test_data, train_labels, test_labels = train_test_split(df['Body'],df['tech'], test_size=0.2, random_state=42)
# train_data, test_data, train_labels, test_labels = train_test_split(df['Body'],df['politics'], test_size=0.2, random_state=42)
train_data, val_data, train_labels, val_labels = train_test_split(train_data, train_labels, test_size=0.2, random_state=42)

# Define features
train_data_with_lex = []
classif = LexiconClassifier()
for row in train_data:
    text = row.upper()
    punc = classif.count_exclamation(text)
    if punc == -1:
        punc = 0
    count = classif.length_tweet(text)
    upper = classif.count_uppercase(text)
    train_data_with_lex.append([punc])
    # train_data_with_lex.append([count])
    # train_data_with_lex.append([upper])

classif2 = LexiconClassifier()
test_data_with_lex = []
for row in test_data:
    text = row.upper()
    punc = classif2.count_exclamation(text)
    if punc == -1:
        punc = 0
    count = classif2.length_tweet(text)
    upper = classif2.count_uppercase(text)
    test_data_with_lex.append([punc])
    # test_data_with_lex.append([count])
    # test_data_with_lex.append([upper])

classif3 = LexiconClassifier()
val_data_with_lex = []
for row in val_data:
    text = row.upper()
    punc = classif3.count_exclamation(text)
    if punc == -1:
        punc = 0
    count = classif3.length_tweet(text)
    upper = classif3.count_uppercase(text)
    val_data_with_lex.append([punc])
    # val_data_with_lex.append([count])
    # val_data_with_lex.append([upper])

train_data = np.array(train_data)

def test_models():

    # stop_words = ['and', 'the', 'to', 'that', 'in', 'lp', 'yup', 'per', 'lpg', 'lqi', 'lt', 'lte', 'ltmprod', 'luchador', 'll', 'You', 'They', 'There', 'If', 'It', 'That', 'The', 'But', 'www', 'https']
    vectorizer = CountVectorizer(stop_words='english', lowercase=False, max_features=300)
    X_train = vectorizer.fit_transform(train_data)
    X_train = np.array(X_train).reshape(-1,1)
    X_test = vectorizer.transform(test_data)
    X_val = vectorizer.transform(val_data)
    X_train_w_lex = sp.hstack([train_data_with_lex, X_train.all()])
    X_test_w_lex = sp.hstack([test_data_with_lex ,X_test])
    val_w_lex = sp.hstack([val_data_with_lex, X_val])
    print(vectorizer.vocabulary_)
    
    # Initialize the classifier LinearSVC 
    classifier = LinearSVC(random_state=42)
    # classifier = LogisticRegression()

    # Create the params with the C values
    params = {'C': [0.01,0.1,1,10]}

    # Initialize GridSearchCV
    grid = GridSearchCV(estimator=classifier, param_grid=params, scoring='f1_micro', cv=5)

    # "fit" the model  on X_train_w_lex
    grid.fit(X_train_w_lex, train_labels)

    best_est = grid.best_estimator_

    validation_score = grid.cv_results_['mean_test_score'][grid.best_index_]
    print("Validation F1: {:.4f}".format(validation_score))

    val_predictions = best_est.predict(val_w_lex)
    df = pd.DataFrame()
    
    df['Body'] = val_data
    df['Val_Annotations'] = val_labels
    df['Val_Predictions'] = val_predictions
    precision = precision_score(val_labels, val_predictions, average='micro') # Get scores using svm_val_predictions and val_labels with the precision_score method
    recall = recall_score(val_labels, val_predictions, average='micro')
    f1 = f1_score(val_labels, val_predictions, average='micro')
    print("Micro Precision: {:.4f}".format(precision))
    print("Micro Recall: {:.4f}".format(recall))
    print("Micro F1: {:.4f}".format(f1))
    macro_precision = precision_score(val_labels, val_predictions, average='macro') # Get scores using svm_val_predictions and val_labels with the precision_score method
    macro_recall = recall_score(val_labels, val_predictions, average='macro')
    macro_f1 = f1_score(val_labels, val_predictions, average='macro')
    print("Macro Precision: {:.4f}".format(macro_precision))
    print("Macro Recall: {:.4f}".format(macro_recall))
    print("Macro F1: {:.4f} \n".format(macro_f1))

    svm_lex_test_predictions = best_est.predict(X_test_w_lex) # Get predictions on X_test_w_lex
    test_df = pd.DataFrame()
    test_df['Body'] = test_data
    test_df['Test_Annotations'] = test_labels
    test_df['Test_Predictions'] = svm_lex_test_predictions
    print(test_df['Test_Predictions'].value_counts())
    # test_df.to_csv('best_model.csv', index=False)
    # print(test_df)
    final_df = pd.concat([df, test_df])
    # final_df.to_csv('tech_length_tweet.csv', index=False)
    # print(final_df)
    precision = precision_score(test_labels, svm_lex_test_predictions, average='micro') # Get scores using svm_test_predictions and test_labels with the precision_score method
    recall = recall_score(test_labels, svm_lex_test_predictions, average='micro')
    f1 = f1_score(test_labels, svm_lex_test_predictions, average='micro')
    print("Micro Precision: {:.4f}".format(precision))
    print("Micro Recall: {:.4f}".format(recall))
    print("Micro F1: {:.4f}".format(f1))
    macro_precision = precision_score(test_labels, svm_lex_test_predictions, average='macro') # Get scores using svm_test_predictions and test_labels with the precision_score method
    macro_recall = recall_score(test_labels, svm_lex_test_predictions, average='macro')
    macro_f1 = f1_score(test_labels, svm_lex_test_predictions, average='macro')
    print("Macro Precision: {:.4f}".format(macro_precision))
    print("Macro Recall: {:.4f}".format(macro_recall))
    print("Macro F1: {:.4f}".format(macro_f1))

# test_models()

def selectkbest():
    pipe = Pipeline([('vec', CountVectorizer(stop_words='english')),
                 ('skb', SelectKBest()),
                ('clf', LinearSVC(random_state=42))])

    params = {"clf__C": [0.01, 0.1, 1., 10., 100.],
            "skb__k": [10, 1000, 10000, 15000, 'all'],
            "vec__ngram_range": [(1,1), (1,2)]}
    # params = {"clf__C": [100.],
    #         "skb__k": [10],
    #         "vec__ngram_range": [(1,1)]}

    clf = GridSearchCV(pipe, params, cv=5, scoring='f1_micro')
    clf.fit(train_data, train_labels)
    # print(clf.feature_names_in_)
    # preds = clf.predict(test_data)
    # print(pipe.get_feature_names_out())

    val_preds = clf.predict(val_data)
    precision = precision_score(val_labels, val_preds, average='micro') # Get scores using svm_val_predictions and val_labels with the precision_score method
    recall = recall_score(val_labels, val_preds, average='micro')
    f1 = f1_score(val_labels, val_preds, average='micro')
    print("Micro Precision: {:.4f}".format(precision))
    print("Micro Recall: {:.4f}".format(recall))
    print("Micro F1: {:.4f}".format(f1))
    macro_precision = precision_score(val_labels, val_preds, average='macro') # Get scores using svm_val_predictions and val_labels with the precision_score method
    macro_recall = recall_score(val_labels, val_preds, average='macro')
    macro_f1 = f1_score(val_labels, val_preds, average='macro')
    print("Macro Precision: {:.4f}".format(macro_precision))
    print("Macro Recall: {:.4f}".format(macro_recall))
    print("Macro F1: {:.4f}".format(macro_f1))

    test_preds = clf.predict(test_data)
    test_df = pd.DataFrame()
    test_df['Body'] = test_data
    test_df['Test_Annotations'] = test_labels
    test_df['Test_Predictions'] = test_preds
    test_df.to_csv('model4_predictions.csv', index=False)
    precision = precision_score(test_labels, test_preds, average='micro') # Get scores using svm_test_predictions and test_labels with the precision_score method
    recall = recall_score(test_labels, test_preds, average='micro')
    f1 = f1_score(test_labels, test_preds, average='micro')
    print("Micro Precision: {:.4f}".format(precision))
    print("Micro Recall: {:.4f}".format(recall))
    print("Micro F1: {:.4f}".format(f1))
    macro_precision = precision_score(test_labels, test_preds, average='macro') # Get scores using svm_test_predictions and test_labels with the precision_score method
    macro_recall = recall_score(test_labels, test_preds, average='macro')
    macro_f1 = f1_score(test_labels, test_preds, average='macro')
    print("Macro Precision: {:.4f}".format(macro_precision))
    print("Macro Recall: {:.4f}".format(macro_recall))
    print("Macro F1: {:.4f}".format(macro_f1))
    print('Best Score:', clf.best_score_)
    print('Best Params:', clf.best_params_)

# selectkbest() 


def errorAnalysis():
    df = pd.read_csv('model4_predictions.csv')
    print(df.columns)
    new_pred = []
    new_ann = []
    for idx, row in df.iterrows():
        if row['Test_Annotations'] == 'Y':
            new = 1
            new_ann.append(new)
        else:
            new = 0
            new_ann.append(new)
        if row['Test_Predictions'] == 'Y':
            newp = 1
            new_pred.append(newp)
        else:
            newp = 0
            new_pred.append(newp)
    df['Test_Annotations'] = new_ann
    df['Test_Predictions'] = new_pred
        

    print(df)
    y_true = df['Test_Annotations']
    y_pred = df['Test_Predictions']
    acu = accuracy_score(y_true, y_pred)
    # print(acu)
    r_sq = r2_score(y_true, y_pred)
    mse = mean_squared_error(y_true, y_pred)
    var = explained_variance_score(y_true, y_pred)
    print(mse)

errorAnalysis()