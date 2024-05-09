import pandas as pd

from sklearn.metrics import cohen_kappa_score
from sklearn.feature_extraction import DictVectorizer
from sklearn.feature_extraction.text import CountVectorizer, TfidfTransformer
from sklearn.svm import SVC, LinearSVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.pipeline import Pipeline
import warnings
import numpy as np
np.random.seed(42)
import random
random.seed(42)
warnings.filterwarnings('ignore') 
pd.set_option('display.max_columns', None)

def merge_annotations():
    group1 = pd.read_csv('data/raw/group1_annotations.csv')
    group1_encode = []
    for idx, row in group1.iterrows():
        converted = row['Body'].encode("ascii", "ignore")
        group1_encode.append(converted)
    # print(group1_encode)
    # print(group1['Body'].tail(3))
    group1['Body'] = group1_encode
    group1 = group1.rename(columns={
        'Tech Related': 'group1_tech',
        'Politics Related': 'group1_politics'
    })
    # print(group1)
    # group1.to_csv('test_set.csv', index=False)

    group2 = pd.read_csv('data/raw/group2_annotations.csv')
    group2_encode = []
    for idx, row in group2.iterrows():
        converted = row['Body'].encode("ascii", "ignore")
        group2_encode.append(converted)
    # print(group2_encode)
    group2['Body'] = group2_encode
    group2 = group2[['parent_id', 'Body', 'Tech Related', 'Politics Related']].rename(columns={
        'Tech Related': 'group2_tech',
        'Politics Related': 'group2_politics'
    })
    # print(group2)
    # group2.to_csv('training_set.csv', index=False)
    merged_df = pd.merge(group1, group2, on=['parent_id', 'Body'])
    return merged_df

def filter_annotator_disagreements():
    df = merge_annotations() 
    tech_df = df[['parent_id', 'Body', 'group1_tech', 'group2_tech']]
    tech_df['group1_tech'] = tech_df['group1_tech'].astype(str)
    tech_df['group2_tech'] = tech_df['group2_tech'].astype(str)
    tech_df.to_csv('data/processed/tech__annotations.csv', index=False)

    # print(tech_df.dtypes)
    count_tech = 0
    parentid_list = []
    body_list = []
    group1_list = []
    group2_list = []
    for idx, row in tech_df.iterrows():
        # if row['group1_tech'].upper().strip() != row['group2_tech'].upper().strip():
        #     parentid_list.append(row['parent_id'])
        #     body_list.append(row['Body'])
        #     group1_list.append(row['group1_tech'])
        #     group2_list.append(row['group2_tech'])
        #     count_tech += 1
        # else: continue
        if row['group1_tech'].upper().strip() == row['group2_tech'].upper().strip():
            parentid_list.append(row['parent_id'])
            body_list.append(row['Body'])
            group1_list.append(row['group1_tech'])
            group2_list.append(row['group2_tech'])
            count_tech += 1
        else: continue
    # print(count_tech)
    # print(count_tech)
    tech_missing_df = pd.DataFrame()
    tech_missing_df['parent_id'] = parentid_list
    tech_missing_df['Body'] = body_list
    tech_missing_df['group1_tech'] = group1_list
    tech_missing_df['group2_tech'] = group2_list
    tech_missing_df.to_csv('tech_annotator_agreements.csv', index=False)
    # print(tech_missing_df)


    # print(count_tech)
    gparentid_list = []
    gbody_list = []
    ggroup1_list = []
    ggroup2_list = []
    politics_df = df[['parent_id', 'Body', 'group1_politics', 'group2_politics']]
    politics_df.to_csv('data/processed/politics_annotations.csv')
    count_politics = 0
    for idx, row in politics_df.iterrows():
        if row['group1_politics'].upper().strip() != row['group2_politics'].upper().strip():
            gparentid_list.append(row['parent_id'])
            gbody_list.append(row['Body'])
            ggroup1_list.append(row['group1_politics'])
            ggroup2_list.append(row['group2_politics'])
            count_politics += 1
    print(count_politics)
    politics_missing_df = pd.DataFrame()
    politics_missing_df['parent_id'] = gparentid_list
    politics_missing_df['Body'] = gbody_list
    politics_missing_df['group1_politics'] = ggroup1_list
    politics_missing_df['group2_politics'] = ggroup2_list
    # politics_missing_df.to_csv('politics_annotator_disagreements.csv', index=False)
    # print(politics_missing_df)
    # print(count_politics)

# filter_annotator_disagreements()

def add_final_adjudications():
    # filter_annotator_disagreements()
    politics_adj_df = pd.read_csv('data/processed/adjudicated_politics_annotations.csv')
    politics_adj_df = politics_adj_df[['parent_id', 'Final']]
    print(politics_adj_df)
    og = merge_annotations()
    og = og[['parent_id', 'Body', 'group1_politics', 'group2_politics']]
    print(og)
    merge_df = pd.merge(og, politics_adj_df, on=['parent_id'], how='outer')
    merge_df = merge_df.drop_duplicates()
    print(merge_df)

    count = 0
    final_politics = []
    for idx, row in merge_df.iterrows():
        if row['group1_politics'] != row['group2_politics']: final_politics.append(row['Final'])
        else: final_politics.append(row['group1_politics'])
        count += 1
    merge_df['final_politics_annotations'] = final_politics
    return merge_df

# add_final_adjudications()

def removeDuplicatesAddTweets():
    og = pd.read_csv('data/raw/group1_annotations.csv').drop_duplicates()
    parent_ids = og['parent_id'].tolist()
    df = pd.read_json('/Users/c2cypher/Downloads/small_sample(1).json', lines=True)
    df = df[['parent_id', 'body']].drop_duplicates()
    # print(df.loc[df['parent_id'].notnull()])
    count=0
    parent_id_list = []
    body_list = []
    for idx, row in df.iterrows():
        if row['parent_id'] > 0:
            parent_id_list.append(row['parent_id'])
            body_list.append(row['body'])
            count += 1
            # print(row)
    not_null_df = pd.DataFrame()
    not_null_df['parent_id'] = parent_id_list
    not_null_df['Body'] = body_list
    not_null_df = not_null_df.loc[~not_null_df['parent_id'].isin(parent_ids)]
    not_null_df = not_null_df.head(52)

    final_dataset = pd.concat([og, not_null_df])
    final_dataset = final_dataset.loc[final_dataset['Tech Related'].isnull()]
    # print(final_dataset)
    # final_dataset.to_csv('data/processed/v2_remove_duplicates.csv', index=False)

def finalPolitics():
    # removeDuplicatesAddTweets()
    df = pd.read_csv('data/processed/remove_duplicates.csv')
    adf_df = add_final_adjudications()
    g1 = pd.read_csv('data/raw/group1_annotations.csv').drop_duplicates()
    # g1 = g1[['parent_id', 'Body', 'Tech Related']]
    g1_final = pd.concat([g1,df]).drop(['Politics Related', 'final_politics_annotations'], axis=1)
    # print(g1_final)

    final_df = pd.concat([adf_df, df])
    # print(final_df)
    final_df = final_df[['parent_id', 'final_politics_annotations']]
    merge_df = pd.merge(g1_final, final_df, on='parent_id').drop_duplicates()
    merge_df['Tech Related'] = merge_df['Tech Related'].astype(str).str.upper()
    # merge_df = merge_df['Tech Related'].upper()
    merge_df.to_csv('corrected_politics.csv', index=False)
    print(merge_df)

    X_txt = []
    y_tech = []
    y_politics = []
    for idx, row in merge_df.iterrows():
        X_txt.append(row['Body'])
        y_tech.append(row['Tech Related'])
        y_politics.append(row['final_politics_annotations'])

    # print(X_txt)

    X_txt_train, X_txt_test, y_train, y_test = train_test_split(X_txt, y_tech, test_size=0.2, random_state=42)
    # print(X_txt_train)

    pipe = Pipeline([('vec', CountVectorizer()),
                    ('clf', LinearSVC(random_state=42))])

    params = {"clf__C": [0.01, 0.1, 1., 10., 100., 1000.],
            "vec__ngram_range": [(1,1), (1,2)]}

    clf = GridSearchCV(pipe, params, cv=5, scoring='f1_micro')

    clf.fit(X_txt_train, y_train)
    preds = clf.predict(X_txt_test)
    # print(preds)
    print(accuracy_score(y_test, preds))

    print('Best Score:', clf.best_score_)
    print('Best Params:', clf.best_params_)

def dropTechAnnotatorDisagreements():
    df = pd.read_csv('corrected_tech_annotator_disagreements.csv').drop(['group1_tech', 'group2_tech'], axis=1)
    df = df.drop_duplicates().rename(columns={
        'final_tech': 'group2_tech'
    })
    agree_df = pd.read_csv('tech_annotator_agreements.csv').drop_duplicates().drop('group1_tech', axis=1)
    # print(df)
    # print(agree_df)
    concat_df = pd.concat([df, agree_df])
    # print(concat_df)
    add_df = pd.read_csv('data/processed/remove_duplicates.csv').rename(columns={
        'Tech Related': 'group2_tech'
    })
    # print(add_df)
    final_concat_df = pd.concat([concat_df, add_df]).drop('final_politics_annotations', axis=1)
    final_concat_df.to_csv('corrected_tech.csv', index=False)
    print(final_concat_df)

# dropTechAnnotatorDisagreements()

def createGoldStandardUGHTHISSUCKS():
    tech = pd.read_csv('corrected_tech.csv').drop('Body', axis=1)
    politics = pd.read_csv('corrected_politics.csv').drop('Tech Related', axis=1)
    # print(politics)
    gold_standard = pd.merge(tech, politics, on=['parent_id']).drop_duplicates().rename(columns={
        'group2_tech': 'tech',
        'final_politics_annotations': 'politics'
    })
    gold_standard = gold_standard[['parent_id', 'Body', 'tech', 'politics']]
    print(gold_standard)
    gold_standard.to_csv('data/processed/gold_standard_annotations.csv', index=False)

# createGoldStandardUGHTHISSUCKS()

