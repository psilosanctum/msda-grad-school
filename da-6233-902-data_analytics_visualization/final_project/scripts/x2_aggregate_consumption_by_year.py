import pandas as pd
import string
pd.set_option('display.max_columns', None)
# pd.set_option('display.max_rows', None)


# path = 'v2_global_electricity_statistics.csv'
path = 'processed/v3_global_electricity_statistics.csv'

# Create DF 
df = pd.read_csv(path)
# print(df['Features'].value_counts())

def yearly_consumption():
    
    # Create separate DF to include only energy consumption
    yearly_consumption_df = df.loc[df['Features'] == 'net consumption']
    # print(yearly_consumption_df)

    # Create DF to include energy consumption by region, country, and year
    yearly_consumption_by_country_df = yearly_consumption_df.groupby(['Country', 'Region', 'Year']).sum()['Amount'].reset_index()
    yearly_consumption_by_country_df = yearly_consumption_by_country_df.sort_values(['Year', 'Amount'], ascending=[False, False])
    # print(yearly_consumption_by_country_df.head(15))
    # print(yearly_consumption_by_country_df.loc[yearly_consumption_by_country_df['Country'] == 'China'])
    # print(yearly_consumption_by_country_df.loc[yearly_consumption_by_country_df['Country'] == 'United States'])
    # print(yearly_consumption_by_country_df.loc[yearly_consumption_by_country_df['Country'] == 'India'])

    # Create DF to include energy consumption by region and year
    yearly_consumption_by_region_df = yearly_consumption_df.groupby(['Region', 'Year']).sum()['Amount'].reset_index()
    # print(yearly_consumption_by_region_df['Region'].value_counts())
    # print(yearly_consumption_by_region_df.loc[yearly_consumption_by_region_df['Region'] == 'Asia & Oceania'])
    # print(yearly_consumption_by_region_df.loc[yearly_consumption_by_region_df['Region'] == 'North America'])

    # Calculate total energy consumption of all countries by year
    world_total_yearly_consumption = yearly_consumption_df.groupby(['Year']).sum()['Amount'].reset_index()
    world_total_yearly_consumption.to_csv('graph_datasets/world_total_yearly_consumption.csv', index=False)
    print(world_total_yearly_consumption)

def yearly_generation():

    # Generation = Consumption - Distribution Losses + Net Imports

    # Create separate DF to include only energy generation
    yearly_generation_df = df.loc[df['Features'] == 'net generation']
    # print(yearly_generation_df)

    # Create DF to include energy generation by region, country, and year
    yearly_generation_by_country_df = yearly_generation_df.groupby(['Country', 'Region', 'Year']).sum()['Amount'].reset_index()
    yearly_generation_by_country_df = yearly_generation_by_country_df.sort_values(['Year', 'Amount'], ascending=[False, False])
    # print(yearly_generation_by_country_df)

def yearly_imports():
    
    # Create separate DF to include only energy imports
    yearly_imports_df = df.loc[df['Features'] == 'imports ']
    # print(yearly_imports_df)

    # Create DF to include energy imports by region, country, and year
    yearly_imports_by_country_df = yearly_imports_df.groupby(['Country', 'Region', 'Year']).sum()['Amount'].reset_index()
    yearly_imports_by_country_df = yearly_imports_by_country_df.sort_values(['Year', 'Amount'], ascending=[False, False])
    print(yearly_imports_by_country_df)
    # print(yearly_imports_by_country_df.loc[yearly_imports_by_country_df['Country'] == 'United States'])

def yearly_exports():
    
    # Create separate DF to include only energy exports
    yearly_exports_df = df.loc[df['Features'] == 'exports ']
    # print(yearly_exports_df)

    # Create DF to include energy exports by region, country, and year
    yearly_exports_by_country_df = yearly_exports_df.groupby(['Country', 'Region', 'Year']).sum()['Amount'].reset_index()
    yearly_exports_by_country_df = yearly_exports_by_country_df.sort_values(['Year', 'Amount'], ascending=[False, False])
    print(yearly_exports_by_country_df)
    # print(yearly_exports_by_country_df.loc[yearly_exports_by_country_df['Country'] == 'United States'])
    # print(yearly_exports_by_country_df.loc[yearly_exports_by_country_df['Country'] == 'Saudi Arabia'])

def yearly_net_imports():
    
    # Create DF for average prices per kWh 
    avg_prices_df = pd.read_csv("raw/avg_prices_for_electricity_per_kwh.csv")
    # print(avg_prices_df)

    # Create separate DF to include only energy net imports
    yearly_net_imports_df = df.loc[df['Features'] == 'net imports ']
    # print(yearly_net_imports_df)

    # Create DF to include energy net imports by region, country, and year
    yearly_net_imports_by_country_df = yearly_net_imports_df.groupby(['Country', 'Region', 'Year']).sum()['Amount'].reset_index()
    yearly_net_imports_by_country_df = yearly_net_imports_by_country_df.sort_values(['Year', 'Amount'], ascending=[False, True])
    # print(yearly_net_imports_by_country_df)
    # print(yearly_net_imports_by_country_df.loc[yearly_net_imports_by_country_df['Country'] == 'China'])
    # print(yearly_net_imports_by_country_df.loc[yearly_net_imports_by_country_df['Year'] == 2020])

    # Merge average prices DF with net imports by country by year DF
    merged_df = pd.merge(yearly_net_imports_by_country_df, avg_prices_df, on='Year')
    # print(merged_df)

    # Column formatting
    merged_df = merged_df.rename(columns={
        'Amount': 'Net Imports (billion kWh)'
    })

    # Calculate net import cost by country by year
    merged_df['Net Import Cost (billion $)'] = (merged_df['Net Imports (billion kWh)'] * merged_df['Average Price (per kWh)']).round(2)
    # print(merged_df.head(15))
    # print(merged_df.loc[merged_df['Year'] == 2020].head(15))
    # print(merged_df.loc[merged_df['Country'] == 'China'])

    # Create DF for top 15 importers
    top_10_importers = merged_df.loc[(
        (merged_df['Country'] == 'Italy') | 
        (merged_df['Country'] == 'United States') | 
        (merged_df['Country'] == 'Thailand') | 
        (merged_df['Country'] == 'United Kingdom') | 
        (merged_df['Country'] == 'Brazil') | 
        (merged_df['Country'] == 'Iraq') | 
        (merged_df['Country'] == 'Finland') | 
        (merged_df['Country'] == 'Hungary') | 
        (merged_df['Country'] == 'Hong Kong') | 
        (merged_df['Country'] == 'Lithuania')
    )]

    sum_top_10_importers = top_10_importers.groupby(['Country', 'Region']).sum()[['Net Import Cost (billion $)', 'Net Imports (billion kWh)']].reset_index()
    # print(sum_top_10_importers)
    # sum_top_10_importers.to_csv('processed/top_10_importers.csv', index=False)
    # print(top_10_importers)

    # Create DF for top 10 exporters
    top_10_exporters = merged_df.loc[(
        (merged_df['Country'] == 'France') | 
        (merged_df['Country'] == 'Canada') | 
        (merged_df['Country'] == 'Laos') | 
        (merged_df['Country'] == 'Paraguay') | 
        (merged_df['Country'] == 'Sweden') | 
        (merged_df['Country'] == 'Germany') | 
        (merged_df['Country'] == 'China') | 
        (merged_df['Country'] == 'Russia') | 
        (merged_df['Country'] == 'Norway') | 
        (merged_df['Country'] == 'Czechia')
    )]


    # Remove negative signs
    top_10_exporters['Net Imports (billion kWh)'] = abs(top_10_exporters['Net Imports (billion kWh)'])
    top_10_exporters['Net Import Cost (billion $)'] = abs(top_10_exporters['Net Import Cost (billion $)'])

    # Column formatting
    top_10_exporters = top_10_exporters.rename(columns={
        'Net Imports (billion kWh)': 'Net Exports (billion kWh)',
        'Net Import Cost (billion $)': 'Net Export Cost (billion $)'
    })
    sum_top_10_exporters = top_10_exporters.groupby(['Country', 'Region']).sum()[['Net Export Cost (billion $)', 'Net Exports (billion kWh)']].reset_index()
    sum_top_10_exporters.to_csv('processed/top_10_exporters.csv', index=False)
    # print(top_10_exporters)


def yearly_distribution_losses():
    
    # Create separate DF to include only energy distribution losses
    yearly_distribution_losses_df = df.loc[df['Features'] == 'distribution losses ']
    # print(yearly_distribution_losses_df)

    # Create DF to include energy distribution losses by region, country, and year
    yearly_distribution_losses_by_country_df = yearly_distribution_losses_df.groupby(['Country', 'Region', 'Year']).sum()['Amount'].reset_index()
    yearly_distribution_losses_by_country_df = yearly_distribution_losses_by_country_df.sort_values(['Year', 'Amount'], ascending=[False, False])
    print(yearly_distribution_losses_by_country_df)
    # print(yearly_distribution_losses_by_country_df.loc[yearly_distribution_losses_by_country_df['Country'] == 'China'])
    # print(yearly_distribution_losses_by_country_df.loc[yearly_distribution_losses_by_country_df['Country'] == 'United States'])

def electricity_consumption_2021():
    
    # Create separate DF to include only energy consumption for 2021 by country
    electricity_consumption_2021_df = df.loc[(df['Features'] == 'net consumption') & (df['Year'] == 2021)]
    # electricity_consumption_2021_df.to_csv('graph_datasets/map_data_2021.csv', index=False)
    # print(electricity_consumption_2021_df)

    # Create variable to calculate total energy consumed by the world in 2021 - for the pie chart/heatmap
    total_electricity_consumed_2021 = electricity_consumption_2021_df['Amount'].sum()
    # print(total_electricity_consumed_2021)

    # Calculate percentage of total energy consumed by country in 2021
    electricity_consumption_2021_df['Percent of Total'] = (electricity_consumption_2021_df['Amount'] / total_electricity_consumed_2021)
    
    # Remove unnecessary columns
    electricity_consumption_2021_df = electricity_consumption_2021_df[['Country', 'Region', 'Percent of Total']]
    electricity_consumption_2021_df = electricity_consumption_2021_df.sort_values('Percent of Total', ascending=False)
    # print(electricity_consumption_2021_df)
    
    # Create variable to calculate percentage of total energy consumed by region in 2021
    pie_chart_by_region_df = electricity_consumption_2021_df.groupby(['Region']).sum()['Percent of Total'].reset_index()
    pie_chart_by_region_df = pie_chart_by_region_df.sort_values('Percent of Total', ascending=False)
    pie_chart_by_region_df.to_csv('graph_datasets/pie_chart_by_region_2021.csv', index=False)
    print(pie_chart_by_region_df) 


def top_15_countries_yearly_consumption():
    
    # Create separate DF to include only energy consumption
    yearly_consumption_df = df.loc[(df['Features'] == 'net consumption') & 
                                   ((df['Country'] == 'China') | 
                                    (df['Country'] == 'United States') | 
                                    (df['Country'] == 'India') | 
                                    (df['Country'] == 'Russia') | 
                                    (df['Country'] == 'Japan') | 
                                    (df['Country'] == 'Brazil') | 
                                    (df['Country'] == 'South Korea') | 
                                    (df['Country'] == 'Canada') | 
                                    (df['Country'] == 'Germany') | 
                                    (df['Country'] == 'France') | 
                                    (df['Country'] == 'Saudi Arabia') | 
                                    (df['Country'] == 'Iran') | 
                                    (df['Country'] == 'Mexico') | 
                                    (df['Country'] == 'Italy') | 
                                    (df['Country'] == 'United Kingdom'))]
    yearly_consumption_df = yearly_consumption_df.sort_values(['Year', 'Amount'], ascending=[False, False])
    # yearly_consumption_df.to_csv('graph_datasets/top_15_countries_yearly_consumption.csv', index=False)
    # print(yearly_consumption_df)
    print(yearly_consumption_df.loc[yearly_consumption_df['Country'] == 'China'])
    print(yearly_consumption_df.loc[yearly_consumption_df['Country'] == 'United States'])


 

# yearly_generation()
# yearly_consumption()
# yearly_imports()
# yearly_exports()
yearly_net_imports()
# yearly_distribution_losses()
# electricity_consumption_2021()
# top_15_countries_yearly_consumption()