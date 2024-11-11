import pandas as pd
import numpy as np
pd.set_option('display.max_columns', None)

data_path = 'bank-additional.csv'
data = pd.read_csv(data_path, delimiter=';')
data = data.drop('duration', axis=1)
data['pdays'] = data['pdays'].astype(int)
# print(data['pdays'].value_counts())
data['pdays'] = data['pdays'].apply(lambda x: 'Never Contacted' if x == 999 else x).apply(lambda x: '1 Week' if x <= 6 else x)
print(data['pdays'].value_counts())
