import pandas as pd
pd.set_option("display.max_columns", None)

df = pd.read_csv("train.csv")
print(df)
# df = df[['Order Date', 'Sales']]
df['Order Date'] = pd.to_datetime(df['Order Date'], format='mixed')
# df = df.groupby(['Order Date']).sum()[['Sales']].reset_index().round(2)
df = df.loc[(df['Order Date'] != '2015-03-18') & (df['Order Date'] != '2017-02-10') & (df['Order Date'] != '2018-10-22') & (df['Order Date'] != '2018-03-23') 
            & (df['Order Date'] != '2015-08-09') & (df['Order Date'] != '2018-11-17') & (df['Order Date'] != '2016-08-11') & (df['Order Date'] != '2017-12-17')
            & (df['Order Date'] != '2015-11-17') & (df['Order Date'] != '2016-09-17') & (df['Order Date'] != '2018-04-11') & (df['Order Date'] != '2015-09-23')
            & (df['Order Date'] != '2017-05-23') & (df['Order Date'] != '2017-12-25')]
# print(df.sort_values('Sales', ascending=False).head(25))
df.to_csv("superstore_sales_data.csv", index=False)

final_dates = []
final_sales = []
for index, row in df.iterrows():
    if row['Sales'] <= 10000:
        final_sales.append(row['Sales'])
        final_dates.append(row['Order Date'])
    else:
        pass
# df.to_csv('superstore_sales.csv', index=False)
# print(df.head(25))
# print(final_dates)
# print(final_sales)
final_df = pd.DataFrame()
final_df['Order Date'] = final_dates
final_df['Sales'] = final_sales
# print(final_df.sort_values('Order Date', ascending=False))
# final_df.to_csv('superstore_sales.csv', index=False)