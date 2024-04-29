from pandas import read_csv, set_option, merge, DataFrame, concat, melt
import matplotlib.pyplot as plt
set_option('display.max_columns', None)

lap_times_df = read_csv('lap_times.csv')
races_df = read_csv('races.csv')
drivers_df = read_csv('drivers.csv')
drivers_df['driver'] = drivers_df['forename'] + ', ' + drivers_df['surname']
# print(drivers_df)
results_df = read_csv('results.csv')
driver_standings_df = read_csv('driver_standings.csv')
constructors_df = read_csv('constructors.csv')
constructors_standings_df = read_csv('constructor_standings.csv')
qualifying_df = read_csv('qualifying.csv')
sprint_results_df = read_csv('sprint_results.csv')

def driver_wins():
    # print(driver_standings_df)
    # driver_wins = driver_standings_df.loc[driver_standings_df['driverId'] == 1]
    driver_wins = driver_standings_df.loc[driver_standings_df['wins'] != 0]
    driver_wins = merge(driver_wins, races_df, on='raceId')
    driver_wins_year = driver_wins.groupby(['driverId', 'year']).max()['wins'].reset_index().sort_values('wins', ascending=False)
    driver_wins_total = driver_wins_year.groupby('driverId').sum(numeric_only=True)['wins'].reset_index().sort_values('wins', ascending=False)
    # print(driver_wins_total)
    # print(driver_wins_year)
    return driver_wins_year

def drivers_constructors():
    df = merge(drivers_df, driver_standings_df, on='driverId')
    df = merge(df, constructors_standings_df, on='raceId')
    df = merge(df, constructors_df, on='constructorId')
    df = df[['driverId', 'driver', 'constructorId', 'constructorRef']]
    # print(df.drop_duplicates())

drivers_constructors()
def avg_lap_time_metrics():
    merge_lap_times_races_df = merge(lap_times_df, races_df, on='raceId')
    avg_driver_annual_lap_time = merge_lap_times_races_df.groupby(['driverId', 'year']).mean()['milliseconds'].reset_index()
    avg_driver_annual_lap_time = merge(avg_driver_annual_lap_time, drivers_df, on='driverId')
    avg_driver_annual_lap_time = avg_driver_annual_lap_time[['driverId', 'driver', 'year', 'milliseconds']]
    avg_driver_career_lap_time = merge_lap_times_races_df.groupby(['driverId']).mean()['milliseconds'].reset_index()
    # print(avg_driver_annual_lap_time)

    avg_lap_time_all_drivers = merge_lap_times_races_df.groupby(['year']).mean()['milliseconds'].reset_index()
    # print(avg_lap_time_all_drivers)

    # x = avg_lap_time_all_drivers['year']
    # y = avg_lap_time_all_drivers['milliseconds']
    # plt.plot(x, y)
    # plt.show()
    # plt.close()
    return avg_driver_annual_lap_time

wins = driver_wins()
lap = avg_lap_time_metrics()
# print(lap)
merged = merge(wins, lap, on=['driverId', 'year'], how='inner')
merged['seconds'] = merged['milliseconds'].__truediv__(1000)
driver_list = merged['driver'].unique().tolist()
# print(driver_list)
# print(merged.sort_values(['year'],ascending=[True]))
driver_dict = {}
year_list = []
seconds_list = []
# print(driver_dict)
# years = []
# seconds = []
# print(driver_dict.values())
# for key, value in driver_dict.items():
#      print(key, value)


constructor_names_list = [
    "mercedes",
    'ferrari',
    "red_bull",
    'mcclaren',
    "alpine",
    'aston_martin',
    "alpha_tauri",
    'alfa_romeo',
    "williams",
    'haas'
]
constructor_id_list = [131, 6, 9, 1, 4, 211, 5, 15, 3, 210]
list_2015 = [527.6, 474.7, 532.5, 528.3, 149.8, 147.3, 156.1, 117.2, 217.7, float('nan')]
list_2016 = [352, 483.3, 286.2, 246.4, 199.8, 119.2, 132.8, 126, 139.6, float('nan')]
list_2017 = [352.1, 295.3, 284, 240.8, 195.4, 117, 130.6, 123.8, 136.3, 130.6]
list_2018 = [400, 410, 310, 220, 190, 120, 150, 135, 150, 130]
list_2019 = [484, 463, 445, 269, 272, 188, 138, 132, 141, 173]
# print(list_2015)
year_2015 = [2015, 2015, 2015, 2015, 2015, 2015, 2015, 2015, 2015, 2015]
year_2016 = [2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016, 2016]
year_2017 = [2017, 2017, 2017, 2017, 2017, 2017, 2017, 2017, 2017, 2017]
year_2018 = [2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018, 2018]
year_2019 = [2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019, 2019]

mercedes = [constructor_id_list[0], list_2015[0], list_2016[0], list_2017[0], list_2018[0], list_2019[0]]
ferrari = [constructor_id_list[1], list_2015[1], list_2016[1], list_2017[1], list_2018[1], list_2019[1]]
red_bull = [constructor_id_list[2], list_2015[2], list_2016[2], list_2017[2], list_2018[2], list_2019[2]]
mcclaren = [constructor_id_list[3], list_2015[3], list_2016[3], list_2017[3], list_2018[3], list_2019[3]]
alpine = [constructor_id_list[4], list_2015[4], list_2016[4], list_2017[4], list_2018[4], list_2019[4]]
aston_martin = [constructor_id_list[5], list_2015[5], list_2016[5], list_2017[5], list_2018[5], list_2019[5]]
alpha_tauri = [constructor_id_list[6], list_2015[6], list_2016[6], list_2017[6], list_2018[6], list_2019[6]]
alfa_romeo = [constructor_id_list[7], list_2015[7], list_2016[7], list_2017[7], list_2018[7], list_2019[7]]
williams = [constructor_id_list[8], list_2015[8], list_2016[8], list_2017[8], list_2018[8], list_2019[8]]
haas = [constructor_id_list[9], list_2015[9], list_2016[9], list_2017[9], list_2018[9], list_2019[9]]
identifiers = ['cons']

# dict_temp = {
#     "mercedes": mercedes,
#     'ferrari': ferrari,
#     "red_bull": red_bull,
#     'mcclaren': mcclaren,
#     "alpine": alpine,
#     'aston_martin': aston_martin,
#     "alpha_tauri": alpha_tauri,
#     'alfa_romeo': alfa_romeo,
#     "williams": williams,
#     'haas': haas,
# }
dict_temp = {
    "name": constructor_names_list,
    "constructorId": constructor_id_list,
    "2015": list_2015,
    "2016": list_2016,
    "2017": list_2017,
    "2018": list_2018,
    "2019": list_2019,
}
# print(dict_temp)
df = DataFrame.from_dict(dict_temp)
# print(df)
melted_df = df.melt(id_vars=['name', 'constructorId'], var_name='Year', value_name='f1_budget_spend')
melted_df.to_csv('budget_spend.csv', index=False)
print(melted_df)