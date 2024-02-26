import pandas as pd
from datetime import datetime
pd.set_option("display.max_columns", None)

df = pd.read_csv("continuous dataset.csv")
# df['datetime'] = pd.to_datetime(df['datetime'])
converted_dates = []
converted_holiday_ids = []
for idx, row in df.iterrows():
    converted_dates.append(datetime.strptime(row['datetime'], '%Y-%m-%d %H:%M:%S').strftime('%Y-%m-%d'))
    if row['Holiday_ID'] == 0:
        converted_holiday_ids.append('No holiday')
    elif row['Holiday_ID'] == 1:
        converted_holiday_ids.append('New Year')
    elif row['Holiday_ID'] == 2:
        converted_holiday_ids.append('Martyrs Day')
    elif row['Holiday_ID'] == 3:
        converted_holiday_ids.append('Carnival Saturday')
    elif row['Holiday_ID'] == 4:
        converted_holiday_ids.append('Carnival Sunday')
    elif row['Holiday_ID'] == 5:
        converted_holiday_ids.append('Carnival Monday')
    elif row['Holiday_ID'] == 6:
        converted_holiday_ids.append('Carnival Tuesday')
    elif row['Holiday_ID'] == 7:
        converted_holiday_ids.append('Ash Wednesday')
    elif row['Holiday_ID'] == 8:
        converted_holiday_ids.append('Holy Thursday')
    elif row['Holiday_ID'] == 9:
        converted_holiday_ids.append('Good Friday')
    elif row['Holiday_ID'] == 10:
        converted_holiday_ids.append('Holy Saturday')
    elif row['Holiday_ID'] == 11:
        converted_holiday_ids.append('Resurrection Sunday')
    elif row['Holiday_ID'] == 12:
        converted_holiday_ids.append('Labor Day')
    elif row['Holiday_ID'] == 13:
        converted_holiday_ids.append('Foundation of Old Panama')
    elif row['Holiday_ID'] == 14:
        converted_holiday_ids.append('Separation of Panama from Colombia')
    elif row['Holiday_ID'] == 15:
        converted_holiday_ids.append('Flag Day')
    elif row['Holiday_ID'] == 16:
        converted_holiday_ids.append('Patriotic Commemoration in Colon city')
    elif row['Holiday_ID'] == 17:
        converted_holiday_ids.append('First Cry of Independence')
    elif row['Holiday_ID'] == 18:
        converted_holiday_ids.append('Independence of Panama from Spain')
    elif row['Holiday_ID'] == 19:
        converted_holiday_ids.append('Mothers Day')
    elif row['Holiday_ID'] == 20:
        converted_holiday_ids.append('Christmas Eve')
    elif row['Holiday_ID'] == 21:
        converted_holiday_ids.append('Christmas')
    elif row['Holiday_ID'] == 22:
        converted_holiday_ids.append('New Years Eve')
    else:
        converted_holiday_ids.append(row['Holiday_ID'])
# print(converted_dates)
# print(converted_holiday_ids)
df['datetime'] = converted_dates
df['Holiday_ID'] = converted_holiday_ids
dummies = pd.get_dummies(df['Holiday_ID'])
# print(dummies)
df = pd.concat([df, dummies], axis=1)
# print(df)
df = df.drop(['Holiday_ID', 'holiday'], axis=1)
df = df.groupby(['datetime']).agg(
    {'nat_demand': 'sum',
    'T2M_toc': 'mean',
    'QV2M_toc': 'mean',
    'TQL_toc': 'mean',
    'W2M_toc': 'mean',
    'T2M_san': 'mean',
    'QV2M_san': 'mean',
    'TQL_san': 'mean',
    'W2M_san': 'mean',
    'T2M_dav': 'mean',
    'QV2M_dav': 'mean',
    'TQL_dav': 'mean',
    'W2M_dav': 'mean',
    'school': 'mean',
    'No holiday': 'mean',
    'Martyrs Day': 'mean',
    'Carnival Saturday': 'mean',
    'Carnival Sunday': 'mean',
    'Carnival Monday': 'mean',
    'Carnival Tuesday': 'mean',
    'Ash Wednesday': 'mean',
    'Holy Thursday': 'mean',
    'Good Friday': 'mean',
    'Holy Saturday': 'mean',
    'Resurrection Sunday': 'mean',
    'Labor Day': 'mean',
    'Foundation of Old Panama': 'mean',
    'Separation of Panama from Colombia': 'mean',
    'Flag Day': 'mean',
    'Patriotic Commemoration in Colon city': 'mean',
    'First Cry of Independence': 'mean',
    'Independence of Panama from Spain': 'mean',
    'Mothers Day': 'mean',
    'Christmas Eve': 'mean',
    'Christmas': 'mean',
    'New Years Eve': 'mean'})
# print(df['Holiday_ID'].value_counts())
df = df.loc[df.index != '2020-06-27']
# df = df.loc[(df['No holiday'] == 0.0) & (df['school'] == 1.0)]
df = df[['nat_demand']]
print(df)
df.to_csv('v4_electricity_load.csv')