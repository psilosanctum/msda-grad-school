import pandas as pd
pd.set_option('display.max_columns', None)

month_dict = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
}

weekday_dict = {
    0: "Monday",
    1: "Tuesday",
    2: "Wednesday",
    3: "Thursday",
    4: "Friday",
    5: "Saturday",
    6: "Sunday"
}

hour_dict = {
    0: "12:00 AM",
    1: "1:00 AM",
    2: "2:00 AM",
    3: "3:00 AM",
    4: "4:00 AM",
    5: "5:00 AM",
    6: "6:00 AM",
    7: "7:00 AM",
    8: "8:00 AM",
    9: "9:00 AM",
    10: "10:00 AM",
    11: "11:00 AM",
    12: "12:00 PM",
    13: "1:00 PM",
    14: "2:00 PM",
    15: "3:00 PM",
    16: "4:00 PM",
    17: "5:00 PM",
    18: "6:00 PM",
    19: "7:00 PM",
    20: "8:00 PM",
    21: "9:00 PM",
    22: "10:00 PM",
    23: "11:00 PM",
}

df = pd.read_csv("data/raw/artist_metadata.csv")
a = []
df = df.loc[df['artist_genres'] != '[]']
# df = df.assign(var1=df['artist_genres'].str.split(',')).explode('var1').drop("artist_genres", axis=1)
# df['var1'] = df['var1'].str.replace("[", "")
# df['var1'] = df['var1'].str.replace("]", "")
# df['var1'] = df['var1'].str.replace("'", "")
# df = df.rename(columns={
#     'var1': 'artist_genres'
# })
df.to_csv('data/processed/all_artist_metadata.csv', index=False)
print(df)