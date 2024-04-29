''' main.py
    Do NOT modify this file!
'''
from hwcode import *
import numpy as np

def main():
    # Exercise 1
    macro_f1_feats = hospital_p1('./data/colon_data.csv')
    try:
        assert(type(macro_f1_feats) is list)
    except:
        print("ERROR: hospital_p1 should return a list")

    print("Exercise 1")
    print("Best Params: {}".format(macro_f1_feats[0]))
    print("Colon F1: {:.4f}".format(macro_f1_feats[1]))
    print()

    # Exercise 2
    best_feats = hospital_p2('./data/colon_data.csv')
    try:
        assert(type(best_feats) is list)
    except:
        print("ERROR: hosptial_p2 should return a list")
    try:
        assert(len(best_feats) == 5)
    except:
        print("ERROR: hospital_p2 should return a list of length 5")

    print("Exercise 2")
    print("Best Colong Feats (Chi2): {}".format(best_feats))
    print()

    # Exercise 3
    best_feats = hospital_p3('./data/colon_data.csv')
    try:
        assert(type(best_feats) is list)
    except:
        print("ERROR: hosptial_p3 should return a list")
    try:
        assert(len(best_feats) == 5)
    except:
        print("ERROR: hospital_p3 should return a list of length 5")

    print("Exercise 3")
    print("Best Colong Feats (LinearSVC): {}".format(best_feats))
    print()

    macro_f1_feats = hospital_p4('./data/colon_data.csv')
    try:
        assert(type(macro_f1_feats) is float)
    except:
        print("ERROR: hospital_p1 should return a list")

    print("Extra Credit Colon F1: {:.4f}".format(macro_f1_feats))



if __name__ == '__main__':
    main()
