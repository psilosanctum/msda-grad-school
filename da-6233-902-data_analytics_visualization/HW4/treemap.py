import pandas as pd
pd.set_option('display.max_columns', None)

path = 'homework_4/election_16_20.csv'
df = pd.read_csv(path)
# print(df)

df_2020_total_state_votes = df.groupby(['state_name']).sum()[['votes_gop_20', 'votes_dem_20', 'total_votes_20']].reset_index()
df_2020_total_state_votes['Trump Vote Percentage'] = ((df_2020_total_state_votes['votes_gop_20'] / df_2020_total_state_votes['total_votes_20'])).round(4)
df_2020_total_state_votes['Biden Vote Percentage'] = ((df_2020_total_state_votes['votes_dem_20'] / df_2020_total_state_votes['total_votes_20'])).round(4)
df_2020_total_state_votes = df_2020_total_state_votes.rename(columns={
    'total_votes_20': 'Total Votes',
    'state_name': 'State Name'
}).drop(['votes_gop_20', 'votes_dem_20'], axis=1)
df_2020_total_state_votes.to_csv('homework_4/v2_treemap.csv', index=False)

print(df_2020_total_state_votes)