from pandas import read_excel, set_option, read_csv
import matplotlib.pyplot as plt
import numpy as np
from numpy import unique, array
set_option('display.max_columns', None)

def team_annual_wins_time_series():
    team_wins_time_series_df = read_excel('data/processed/team_time_series_wins.xlsx')
    team_wins_time_series_df = team_wins_time_series_df.loc[team_wins_time_series_df['year'] >= 2005]
    team_list = team_wins_time_series_df['constructorId'].unique().tolist()

    for id in team_list:
        x_plot = []
        y_plot = []
        list_label = []
        for id in team_list:
            new_df = team_wins_time_series_df.loc[team_wins_time_series_df['constructorId'] == id]
            x_plot.append(new_df['year'].to_numpy())
            y_plot.append(new_df['annual_wins'].to_numpy())
            list_label.append(new_df['name'].to_numpy())

    plt.figure(figsize=(15,10))
    x = x_plot[0]
    y = y_plot[0]
    label = list_label[0]
    plt.plot(x, y, label=label[0])
    x = x_plot[1]
    y = y_plot[1]
    label = list_label[1]
    plt.plot(x, y, label=label[0])
    x = x_plot[2]
    y = y_plot[2]
    label = list_label[2]
    plt.plot(x, y, label=label[0])
    x = x_plot[3]
    y = y_plot[3]
    label = list_label[3]
    plt.plot(x, y, label=label[0])
    plt.legend(loc='upper left')
    plt.xlabel('Year')
    plt.ylabel('Wins')
    plt.title('Team Wins Over Time')
    plt.show()

def top_10_drivers_time_series():
    df = read_excel('data/processed/top_10_drivers_time_series.xlsx')
    df = df.loc[df['year'] >= 2010]
    team_list = df['driverId'].unique().tolist()

    for id in team_list:
        x_plot = []
        y_plot = []
        list_label = []
        for id in team_list:
            new_df = df.loc[df['driverId'] == id]
            x_plot.append(new_df['year'].to_numpy())
            y_plot.append(new_df['driver_wins'].to_numpy())
            list_label.append(new_df['driverRef'].to_numpy())

    print(x_plot[0])
    plt.figure(figsize=(15,10))
    x = x_plot[0]
    y = y_plot[0]
    label = list_label[0]
    plt.plot(x, y, label=label[0])
    x = x_plot[1]
    y = y_plot[1]
    label = list_label[1]
    plt.plot(x, y, label=label[0])
    x = x_plot[2]
    y = y_plot[2]
    label = list_label[2]
    plt.plot(x, y, label=label[0])
    x = x_plot[3]
    y = y_plot[3]
    label = list_label[3]
    plt.plot(x, y, label=label[0])
    x = x_plot[4]
    y = y_plot[4]
    label = list_label[4]
    plt.plot(x, y, label=label[0])
    x = x_plot[5]
    y = y_plot[5]
    label = list_label[5]
    plt.plot(x, y, label=label[0])
    x = x_plot[6]
    y = y_plot[6]
    label = list_label[6]
    plt.plot(x, y, label=label[0])
    x = x_plot[7]
    y = y_plot[7]
    label = list_label[7]
    plt.plot(x, y, label=label[0])
    x = x_plot[8]
    y = y_plot[8]
    label = list_label[8]
    plt.plot(x, y, label=label[0])
    x = x_plot[9]
    y = y_plot[9]
    label = list_label[9]
    plt.plot(x, y, label=label[0])
    plt.legend(loc='upper left')
    plt.xlabel('Year')
    plt.ylabel('Wins')
    plt.title('Team Wins Over Time')
    plt.show()

def drivers_teams_annual_wins_comparison_time_series():
    df = read_excel('data/processed/driver_and_team_annual_wins_time_series.xlsx')
    team_df = read_excel('data/processed/team_time_series_wins.xlsx')
    team_df = team_df.loc[team_df['year'] >= 2007]
    # df = df.loc[df['year'] >= 2010]
    id_list = df['driverId'].unique().tolist()

    individual_store_list = []
    complete_store_list = []
    for id in id_list:
        new_df = df.loc[df['driverId'] == id]
        check_multi_teams = new_df['constructorId'].unique().tolist()
        count = 0
        for i in check_multi_teams:
            count +=1
        if count > 1:
            for j in check_multi_teams:
                split_df = new_df.loc[new_df['constructorId'] == j]
                final_dict ={
                    "driver_id": id,
                    "year":  split_df['year'].to_numpy(),
                    "driver_wins": split_df['driver_annual_wins'].to_numpy(),
                    "team_wins": split_df['team_annual_wins'].to_numpy(),
                    "driver_list": split_df['driverRef'].to_numpy(),
                    "constructorId": split_df['constructorId'].to_numpy()
                }
                individual_store_list.append(final_dict)
        else:
            new_df = new_df.loc[new_df['constructorId'] == check_multi_teams[0]]
            final_dict ={
                    "driver_id": id,
                    "year":  new_df['year'].to_numpy(),
                    "driver_wins": new_df['driver_annual_wins'].to_numpy(),
                    "team_wins": new_df['team_annual_wins'].to_numpy(),
                    "driver_list": new_df['driverRef'].to_numpy(),
                    "constructorId": new_df['constructorId'].to_numpy()
            }
            individual_store_list.append(final_dict)

    for id in id_list:
        res = [sub for sub in individual_store_list if sub['driver_id'] == id]
        complete_store_list.append(res)

    all_list = []
    for driver in complete_store_list:
        for driver_team in driver:
            constructor_id = unique(driver_team['constructorId'])[0]
            filtered_team_df = team_df.loc[team_df['constructorId'] == constructor_id]

            if unique(filtered_team_df['name']).size != 0:
                final_dict = {
                    driver_team['driver_list'][0]: {
                        unique(filtered_team_df['name'])[0]: filtered_team_df['annual_wins'],
                        "team_year" : filtered_team_df['year'],
                        "x": driver_team['year'],
                        'y': driver_team['driver_wins']
                    }
                }
                all_list.append(final_dict)
            else:
                pass
    final_list = []
    driver_name_list = df['driverRef'].unique().tolist()
    for name in driver_name_list:
        key = name
        res = [sub for sub in all_list if key in list(sub.keys())]
        final_list.append(res)
    # print(final_list[0][0]['hamilton']['x'])
    # print(final_list[0][0]['hamilton']['y'])

    plt.figure(figsize=(15,10))
    x = final_list[0][0]['hamilton']['team_year']
    y = final_list[0][0]['hamilton']['McLaren']
    plt.plot(x,y, color="red", label="McLaren")
    x = final_list[0][1]['hamilton']['team_year']
    y = final_list[0][1]['hamilton']['Mercedes']
    plt.plot(x,y, color="green", label="Mercedes")
    x = final_list[0][0]['hamilton']['x']
    y = final_list[0][0]['hamilton']['y']
    plt.plot(x,y, color="black", label="Lewis Hamilton")
    x = final_list[0][1]['hamilton']['x']
    y = final_list[0][1]['hamilton']['y']
    plt.plot(x,y,color="black")
    x = array([2012, 2013])
    y = array([4, 1])
    plt.plot(x,y,color="black")
    x = array([2013])
    y = array([1])
    plt.scatter(x,y,color="black", s=100)
    plt.legend()
    plt.xlabel('Year')
    plt.ylabel('Wins')
    plt.title('Driver\'s Win Contribution')
    plt.show()

def stacked_bar_chart_budget_spend():
    df = read_csv('data/raw/budget_spend.csv')
    y_list = []
    x_list = []
    team_list = []
    x = array(df['Year'].unique())
    for year in x:
        new_df = df.loc[df['Year'] == year]
        y_vals = new_df['f1_budget_spend'].to_numpy()
        y_vals[np.isnan(y_vals)] = 0
        x_vals = new_df['Year'].to_numpy()
        team_vals = new_df['name'].to_numpy()
        team_list.append(team_vals)
        y_list.append(y_vals)
        x_list.append(x_vals)
    print(y_list[0][0])
    # print(y_list[3])
    # print(x_list[0])
    # print(x_list[3])
    
    y_list = array(y_list)
    # fig, ax = plt.subplots(figsize=(15,10))
    # for idx, name in enumerate(y_list):
    #     ax.bar(x_list, y_list[name], bottom=np.sum(y_list[:name], axis=0))
    # plt.plot(kind='bar', stacked=True, ax=ax)
    # for i in y_list:
    #     for j in i:
    #         print(j)
    plt.bar(x_list[0], y_list[0], color='r')
    # plt.bar(x_list[1], y_list[1], bottom=y_list[0], color='b')
    # plt.bar(x_list[2], y_list[2], bottom=y_list[0] + y_list[1], color='y')
    # plt.bar(x_list[3], y_list[3], bottom=y_list[0]+ y_list[1]+ y_list[2], color='g')
    # plt.bar(x_list[4], y_list[4], bottom=y_list[0]+ y_list[1]+y_list[2]+ y_list[3], color='c')
    plt.xlabel("Teams")
    plt.ylabel("Score")
    plt.legend(labels=team_list[0])
    # plt.title("Scores by Teams in 4 Rounds")
    plt.show()
# team_annual_wins_time_series()
# top_10_drivers_time_series()
# drivers_teams_annual_wins_comparison_time_series()
# stacked_bar_chart_budget_spend()

   

