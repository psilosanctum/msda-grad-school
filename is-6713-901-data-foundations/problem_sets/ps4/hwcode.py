""" hwcode.py
    Write the code for the HW exercises in this file.
"""

import csv
import numpy as np
# Add any extra imports you want here


def hospital_p1(csv_filename):
    '''
    Train a classifier on colon cancer gene expression data.

    :param str csv_filename: The file path of the colon dataset
    :return: A list containing GridSearchCV's best params (.best_params_) dictionary as the first item and GridSearchCV's .best_score_ as the second (Best GridSearchCV macro F1)
    '''
    # Write code for exercise 1 here
    return [{}, 0.0]

def hospital_p2(csv_filename):
    '''
    Return the most important features using chi2 feature selection method

    :param str csv_filename: The file path of the colon dataset
    :return: A list of the top 5 chi2
             feature names (strings) ["feature_1", ..., "feature_72"]
    '''
    # Write code for exercise 2 here
    return ["feature_1", "feature_2", "feature_20", "feature_500", "feature_4"]

def hospital_p3(csv_filename):
    '''
    Return the most important features based on the coefficients in the LinearSVC method. (i.e., clf.coef_)
    You will need to train a LienarSVC on the dataset, then map the coefs to the feature names.

    :param str csv_filename: The file path of the colon dataset
    :return: A list of the top 5 features based on the linearSVC coef scores
             feature names (strings) ["feature_1", ..., "feature_72"]
    '''
    # Write code for exercise 3 here
    return ["feature_1", "feature_2", "feature_20", "feature_500", "feature_4"]

def hospital_p4(csv_filename):
    '''
    Train a classifier on colon cancer gene expression data.

    :param str csv_filename: The file path of the colon dataset
    :return: A float (Best GridSearchCV macro F1)
    '''
    # Write code for exercise 4 here
    return 0.0


