import pandas as pd
pd.set_option('display.max_columns', None)
# pd.set_option('display.max_rows', None)


path = 'raw/global_electricity_statistics.csv'
df = pd.read_csv(path)
# print(df)

# transpose year columns to rows
df = df.melt(id_vars=['Country', 'Features', 'Region'],
             var_name='Year',
             value_name='Amount')

# fix non-numeric data in the Amount column
df = df.fillna(0).replace(to_replace=['--', 'ie'], 
                value=0)
df['Amount'] = df['Amount'].astype(float)

# separate installed capacity to assign separate unit of measurement
install_capacity_df = df.loc[df['Features'] == 'installed capacity ']
install_capacity_df['Unit'] = 'million kW'
# print(install_capacity_df)

# separate the rest of the features to assign unit of measurement
other_features_df = df.loc[df['Features'] != 'installed capacity ']
other_features_df['Unit'] = 'billion kWh'
# print(other_features_df)

# merge cleaned data
all_features_df = pd.concat([other_features_df, install_capacity_df])
print(all_features_df)

all_features_df.to_csv('v2_global_electricity_statistics.csv', index=False)