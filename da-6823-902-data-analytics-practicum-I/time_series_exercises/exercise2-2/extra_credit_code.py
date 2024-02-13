import pandas as pd
from datetime import datetime
import matplotlib.pyplot as plt
from statsmodels.graphics.tsaplots import plot_acf
import statsmodels.api as sm
pd.set_option('display.max_columns', None)

# Create DataFrame (DF).
path = 'datasets/bitcoin_on_chain_data.csv'
df = pd.read_csv(path)

# Function for pre-processing.
def clean_bitcoin_data(df=df):
    
    # Convert UNIX milliseconds to seconds.
    df['timestamp_seconds'] = df['timestamp'] / 1000

    # Create empty list to append converted UNIX values.
    converted_date_list = []

    # Loop through UNIX timestamp (in seconds), convert each timestamp to the year-month value and append converted values to our converted list.
    for i in df['timestamp_seconds']:
        converted_date_list.append(datetime.utcfromtimestamp(i).strftime('%Y-%m'))

    # Create DF column with converted year-month date values.
    df['converted_timestamps_month'] = converted_date_list

    # Create new DF to include only time series data for transactions.
    time_series_df = df[['converted_timestamps_month', 'tx_count']]

    # Sum transactions per month.
    time_series_df = time_series_df.groupby(['converted_timestamps_month']).sum()[['tx_count']].reset_index().sort_values('converted_timestamps_month', ascending=True)

    # Remove most recent month that does not have a full month's worth of transaction data.
    time_series_df = time_series_df.loc[time_series_df['converted_timestamps_month'] != '2023-10']

    # Set index to year-monthly values for plotting.
    time_series_df = time_series_df.set_index('converted_timestamps_month')

    return time_series_df

time_series_df = clean_bitcoin_data(df)

# Graph bitcoin transactions per month time series.
def plot_time_series(df):
    fig = plt.figure(figsize=(16, 10))
    plt.plot(df.index, df['tx_count'])
    plt.gca().yaxis.set_major_formatter(plt.matplotlib.ticker.StrMethodFormatter('{x:,.0f}'))
    plt.title('Bitcoin Transactions by Month', fontsize=20)
    plt.xlabel('Month', fontsize=15)
    plt.ylabel('Transactions', fontsize=15)
    plt.xlim(df.index.min(), df.index.max())

    # Defining and displaying all time axis ticks
    ticks = ["2009-01", '2010-01', '2011-01', '2012-01', '2013-01', '2014-01', '2015-01', '2016-01', '2017-01', '2018-01', '2019-01', '2020-01', '2021-01', '2022-01', '2023-01']
    plt.xticks(ticks, rotation=45)
    plt.savefig('screenshots/bitcoin_time_series.png')
    plt.show()
plot_time_series(df=time_series_df)

# Create ACF plot.
def ACF_plot(df): 
    plot_acf(df, lags=50)
    plt.savefig('screenshots/bitcoin_acf_plot.png')
    plt.show()
ACF_plot(df=time_series_df)

# KPSS Test
def perform_kpss_test(df):
    kpss_test = sm.tsa.stattools.kpss(df, regression='ct')
    print("The KPSS test statistic: ", kpss_test[0])
    print("The p-value: ", kpss_test[1])
    print("The truncation lag parameter: ", kpss_test[2])
    print("The critical value of 10%: ", kpss_test[3]["10%"])
    print("The critical value of 5%: ", kpss_test[3]["5%"])
    print("The critical value of 2.5%: ", kpss_test[3]["2.5%"])
    print("The critical value of 1%: ", kpss_test[3]["1%"])
perform_kpss_test(df=time_series_df)
    
# ADF Test 
def perform_augmented_dickey_fuller_test(df):
    dickey_fuller_test = sm.tsa.stattools.adfuller(df, regression='c', autolag='AIC')
    print('ADF Test Results')
    print("The ADF test statistic: ", dickey_fuller_test[0])
    print("The p-value: ", dickey_fuller_test[1])
    print("Number of lags: ", dickey_fuller_test[2])
    print("Number of observations: ", dickey_fuller_test[3])
    print("The critical value of 10%: ", dickey_fuller_test[4]["10%"])
    print("The critical value of 5%: ", dickey_fuller_test[4]["5%"])
    print("The critical value of 1%: ", dickey_fuller_test[4]["1%"])
perform_augmented_dickey_fuller_test(df=time_series_df)