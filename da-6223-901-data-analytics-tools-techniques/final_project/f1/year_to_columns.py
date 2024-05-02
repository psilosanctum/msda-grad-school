import pandas as pd
pd.set_option('display.max_columns', None)

df = pd.read_csv('data/raw/budget_spend.csv')
# new_df = pd.melt(df, id_vars=['Year'], value_vars=['name', 'f1_budget_spend', 'constructorId'])
# new_df = df.set_index(['name', 'constructorId', 'f1_budget_spend'])
new_df = df.pivot(index='name', columns=['Year'], values='f1_budget_spend')
new_df = new_df.reset_index()
new_df.to_csv('data/processed/pivoted_budget_spend.csv',index=False)
print(new_df)