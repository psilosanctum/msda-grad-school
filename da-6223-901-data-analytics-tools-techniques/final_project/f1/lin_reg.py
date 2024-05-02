from pandas import read_excel, set_option, read_csv, merge
import statsmodels.api as sm
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import r2_score
from sklearn.linear_model import LinearRegression
set_option('display.max_columns', None)

# model = LinearRegression()
# model = model.fit(X,y)
# coeff = model.coef_.__getitem__(0)
# intercept = model.intercept_
# r_sq = model.score(X, y)
# print(r_sq)

def regression_wins_budget_spend():
    df = read_excel('data/processed/wins_budget_spend_regression_for_regression.xlsx')
    # print(df)
    y = df['annual_wins']
    X = np.array(df['f1_budget_spend']).reshape(-1,1)
    # print(X.shape, y.shape)
    x = sm.add_constant(X)
    model = sm.OLS(y.astype(float), x.astype(float)).fit()
    summary = model.summary()
    print(summary)
    labels_list = df['constructorId'].unique().tolist()
    # print(labels_list)

    x_plot = []
    y_plot = []
    list_label = []
    for id in labels_list:
        new_df = df.loc[df['constructorId'] == id]
        x_plot.append(new_df['f1_budget_spend'].to_numpy())
        y_plot.append(new_df['annual_wins'].to_numpy())
        list_label.append(new_df['name'].to_numpy())

    plt.figure(figsize=(10,10))
    x = x_plot[0]
    y = y_plot[0]
    label = list_label[0]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[1]
    y = y_plot[1]
    label = list_label[1]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[2]
    y = y_plot[2]
    label = list_label[2]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[3]
    y = y_plot[3]
    label = list_label[3]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[4]
    y = y_plot[4]
    label = list_label[4]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[5]
    y = y_plot[5]
    label = list_label[5]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[6]
    y = y_plot[6]
    label = list_label[6]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[7]
    y = y_plot[7]
    label = list_label[7]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[8]
    y = y_plot[8]
    label = list_label[8]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[9]
    y = y_plot[9]
    label = list_label[9]
    plt.scatter(x=x, y=y, label=label[0])
    x_args = (x_plot[0], x_plot[1], x_plot[2], x_plot[3], x_plot[4], x_plot[5], x_plot[6], x_plot[7], x_plot[8], x_plot[9])
    x_all = np.concatenate(x_args)
    # print(x_all)
    y_args = (y_plot[0], y_plot[1], y_plot[2], y_plot[3], y_plot[4], y_plot[5], y_plot[6], y_plot[7], y_plot[8], y_plot[9])
    y_all = np.concatenate(y_args)
    # print(y_all)
    plt.legend(loc="center left")
    z = np.polyfit(x_all,y_all,1)
    p = np.poly1d(z)
    y_hat = np.poly1d(z)(x_all)
    plt.plot(x_all, y_hat)
    text = f"$y={z[0]:0.3f}\;x{z[1]:+0.3f}$\n$R^2 = {r2_score(y_all,y_hat):0.3f}$"
    plt.gca().text(0.05, 0.95, text, transform=plt.gca().transAxes, fontsize=14, verticalalignment='top')
    plt.xlabel('Team\'s Annual Spend (millions)')
    plt.ylabel('Wins')
    plt.title('Wins vs. Annual Spend')
    # plt.savefig('team_wins_budget_spend_regression.png')
    # plt.show()
    # plt.close()

def regression_avg_lap_time_budget_spend():
    df = read_excel('data/processed/avg_lap_time_budget_spend_regression.xlsx')
    # print(df)
    y = df['seconds']
    X = np.array(df['f1_budget_spend']).reshape(-1,1)
    # print(X.shape, y.shape)
    x = sm.add_constant(X)
    model = sm.OLS(y.astype(float), x.astype(float)).fit()
    summary = model.summary()
    print(summary)
    labels_list = df['constructorId'].unique().tolist()

    x_plot = []
    y_plot = []
    list_label = []
    for id in labels_list:
        new_df = df.loc[df['constructorId'] == id]
        x_plot.append(new_df['f1_budget_spend'].to_numpy())
        y_plot.append(new_df['seconds'].to_numpy())
        list_label.append(new_df['name'].to_numpy())

    plt.figure(figsize=(10,10))
    x = x_plot[0]
    y = y_plot[0]
    label = list_label[0]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[1]
    y = y_plot[1]
    label = list_label[1]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[2]
    y = y_plot[2]
    label = list_label[2]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[3]
    y = y_plot[3]
    label = list_label[3]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[4]
    y = y_plot[4]
    label = list_label[4]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[5]
    y = y_plot[5]
    label = list_label[5]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[6]
    y = y_plot[6]
    label = list_label[6]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[7]
    y = y_plot[7]
    label = list_label[7]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[8]
    y = y_plot[8]
    label = list_label[8]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[9]
    y = y_plot[9]
    label = list_label[9]
    plt.scatter(x=x, y=y, label=label[0])
    x_args = (x_plot[0], x_plot[1], x_plot[2], x_plot[3], x_plot[4], x_plot[5], x_plot[6], x_plot[7], x_plot[8], x_plot[9])
    x_all = np.concatenate(x_args)
    # print(x_all)
    y_args = (y_plot[0], y_plot[1], y_plot[2], y_plot[3], y_plot[4], y_plot[5], y_plot[6], y_plot[7], y_plot[8], y_plot[9])
    y_all = np.concatenate(y_args)
    # print(y_all)
    plt.legend(loc="upper right")
    z = np.polyfit(x_all,y_all,1)
    p = np.poly1d(z)
    y_hat = np.poly1d(z)(x_all)
    plt.plot(x_all, y_hat)
    text = f"$y={z[0]:0.3f}\;x{z[1]:+0.3f}$\n$R^2 = {r2_score(y_all,y_hat):0.3f}$"
    plt.gca().text(0.05, 0.95, text, transform=plt.gca().transAxes, fontsize=14, verticalalignment='top')
    plt.xlabel('Annual Spend (millions)')
    plt.ylabel('Avg. Lap Time (seconds)')
    plt.title('Avg. Lap Time vs. Annual Spend')
    # plt.savefig('team_avg_lap_time_budget_spend_regression.png')
    # plt.show()
    # plt.close()

def drivers_wins_budget_spend():
    df = read_excel('data/processed/drivers_wins_budget_spend_regression.xlsx')
    const_df = read_csv('data/raw/constructors.csv')
    merged_df = merge(df, const_df, on=['constructorId'])
    # print(merged_df)
    y = merged_df['annual_wins'].astype(float)
    X = np.array(merged_df['f1_budget_spend']).reshape(-1,1).astype(float)
    labels = list(merged_df['constructorId'])
    # print(np.count_nonzero(a=labels))
    labels_list = merged_df['constructorId'].unique().tolist()
    # print(legend)
    # print(X.shape, y.shape)
    x = sm.add_constant(X)
    model = sm.OLS(y.astype(float), x.astype(float)).fit()
    summary = model.summary()
    print(summary)

    x_plot = []
    y_plot = []
    list_label = []
    for id in labels_list:
        new_df = merged_df.loc[merged_df['constructorId'] == id]
        x_plot.append(np.array(new_df['f1_budget_spend']))
        y_plot.append(np.array(new_df['annual_wins']))
        list_label.append(np.array(new_df['constructorRef']))

    plt.figure(figsize=(10,10))
    x = x_plot[0]
    y = y_plot[0]
    label = list_label[0]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[1]
    y = y_plot[1]
    label = list_label[1]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[2]
    y = y_plot[2]
    label = list_label[2]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[3]
    y = y_plot[3]
    label = list_label[3]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[4]
    y = y_plot[4]
    label = list_label[4]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[5]
    y = y_plot[5]
    label = list_label[5]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[6]
    y = y_plot[6]
    label = list_label[6]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[7]
    y = y_plot[7]
    label = list_label[7]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[8]
    y = y_plot[8]
    label = list_label[8]
    plt.scatter(x=x, y=y, label=label[0])
    x = x_plot[9]
    y = y_plot[9]
    label = list_label[9]
    plt.scatter(x=x, y=y, label=label[0])
    x_args = (x_plot[0], x_plot[1], x_plot[2], x_plot[3], x_plot[4], x_plot[5], x_plot[6], x_plot[7], x_plot[8], x_plot[9])
    x_all = np.concatenate(x_args)
    # print(x_all)
    y_args = (y_plot[0], y_plot[1], y_plot[2], y_plot[3], y_plot[4], y_plot[5], y_plot[6], y_plot[7], y_plot[8], y_plot[9])
    y_all = np.concatenate(y_args)
    # print(y_all)
    plt.legend(loc="center left")
    z = np.polyfit(x_all,y_all,1)
    p = np.poly1d(z)
    y_hat = np.poly1d(z)(x_all)
    plt.plot(x_all, y_hat)
    text = f"$y={z[0]:0.3f}\;x{z[1]:+0.3f}$\n$R^2 = {r2_score(y_all,y_hat):0.3f}$"
    plt.gca().text(0.05, 0.95, text, transform=plt.gca().transAxes, fontsize=14, verticalalignment='top')
    plt.xlabel('Team\'s Annual Spend (millions)')
    plt.ylabel('Wins')
    plt.title('Driver Wins vs. Annual Spend')
    plt.savefig('driver_wins_budget_spend_regression.png')
    plt.show()
    # plt.close()

# regression_wins_budget_spend()
# regression_avg_lap_time_budget_spend()
drivers_wins_budget_spend()

