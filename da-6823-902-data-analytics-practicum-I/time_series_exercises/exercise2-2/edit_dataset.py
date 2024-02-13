import pandas as pd
pd.set_option('display.max_columns', None)

df = pd.read_csv('electricity_retail_sales.csv')
# print(df)

texas_df = df.loc[(df['stateid'] == 'TX') & (df['sectorName'] == 'residential')].sort_values('period', ascending=True)
texas_df.to_csv('texas_residential_electricity_prices.csv', index=False)
# print(texas_df)

expenditures_df = pd.read_csv('WorldExpenditures.csv').drop('Unnamed: 0', axis=1)
us_df = expenditures_df.loc[(expenditures_df['Country'] == 'United States of America') & (expenditures_df['Sector'] == 'Total function')]
us_df.to_csv('us_govt_expenditures.csv', index=False)
print(us_df)