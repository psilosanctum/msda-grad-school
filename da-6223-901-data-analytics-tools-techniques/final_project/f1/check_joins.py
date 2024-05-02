import pandas as pd
pd.set_option('display.max_columns', None)

# results_df = pd.read_csv('data/raw/results.csv')
joined_df = pd.read_csv('data/raw/final.csv')
# joined_df.to_csv('new.csv', index=False)
joined_df['wins'] = joined_df['wins'].fillna(0)

# merged_df = pd.merge(joined_df, results_df, on=['driverId', 'raceId'], how='inner')
print(joined_df.dtypes)
# print(results_df)
# print(merged_df)
# print(results_df)
# merged_df.to_csv('test.csv', index=False)

row_list = []
for idx, row in joined_df.iterrows():
    if row['wins'] == 0:
        new_row = 0
        row_list.append(new_row)
    elif row['wins'] == 1:
        new_row = 1
        row_list.append(new_row)
    elif row['wins'] > 1:
        new_row = 1
        row_list.append(new_row)

print(row_list)