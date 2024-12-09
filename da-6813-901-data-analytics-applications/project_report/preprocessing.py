import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import plotnine as p9
from helpers import weekday_dict, month_dict, hour_dict
pd.set_option('display.max_columns', None)

def song_minutes_played():
    df = pd.read_csv('data/processed/final_listening_history_audio_features.csv')
    df = df.groupby(
        ['month', 'song_id','danceability','energy','loudness','mode','speechiness','acousticness','instrumentalness','liveness', 'valence','tempo','song_name','popularity','album_id','album_name','album_release_date','artist_genres','artist_followers','artist_id','artist_name','artist_popularity']
        ).agg({'minutes_played': 'sum'}).reset_index().sort_values("minutes_played", ascending=False)
    df = df.loc[df['minutes_played'] > 1]
    # df.to_csv('data/processed/month_total_song_minutes_played_features.csv', index=False)
    return df

# df = song_minutes_played()

df = pd.read_csv('data/raw/spotify_audio.csv')
df['hour_of_day'] = pd.to_datetime(df['ts']).dt.hour
df['time_of_day'] = df['hour_of_day'].map(hour_dict)
df['day_of_week'] = pd.to_datetime(df['ts']).dt.weekday
df['weekday'] = df['day_of_week'].map(weekday_dict)
df['month_number'] = pd.to_datetime(df['ts']).dt.month
df['month'] = df['month_number'].map(month_dict)
df['seconds_played'] = df['ms_played'].__truediv__(1000)
df['minutes_played'] = df['seconds_played'].__truediv__(60)
df['track_id'] = df['spotify_track_uri'].str.replace('spotify:track:','')
df.to_csv('data/processed/pre_processed_listening_history.csv', index=False)

day_of_week_df = df.groupby(['weekday']).sum(numeric_only=True)[['seconds_played', 'minutes_played']].reset_index()
day_of_week_df['hours_played'] = day_of_week_df['minutes_played'].__truediv__(60)
day_of_week_df['days_played'] = day_of_week_df['hours_played'].__truediv__(24)

day_of_week_year_df = df.groupby(['day_of_week', 'year']).sum(numeric_only=True)[['seconds_played', 'minutes_played']].reset_index()
day_of_week_year_df['hours_played'] = day_of_week_year_df['minutes_played'].__truediv__(60)
day_of_week_year_df['days_played'] = day_of_week_year_df['hours_played'].__truediv__(24)
day_of_week_year_df = day_of_week_year_df.sort_values(['year', 'day_of_week'], ascending=[True,True])
# day_of_week_year_df['weekday'] = df['day_of_week'].map(weekday_dict)
plot_day_of_week_year_df = day_of_week_year_df[['day_of_week', 'year', 'hours_played']]
# print(day_of_week_year_df)
# plot = (
#     p9.ggplot(day_of_week_year_df, p9.aes(x='day_of_week', y='hours_played', color='factor(year)'))
#     + p9.geom_line() 
# )
plot = (
    p9.ggplot(plot_day_of_week_year_df, p9.aes(x='day_of_week', y='hours_played', fill='year'))
    + p9.geom_bar(stat='identity', position='stack')
    # + p9.geom_text(p9.aes(label="hours_played"), size=9)
    + p9.scale_x_continuous(breaks=tuple(weekday_dict.keys()),labels=tuple(weekday_dict.values()))
    + p9.scale_colour_continuous(cmap_name='Blues')
    + p9.xlab("Weekday")
    + p9.ylab("Total Hours")
    + p9.labs(
        title="YOY Listening Activity",
        subtitle="Weekly Breakdown")
    + p9.theme_minimal()
    + p9.theme(
        plot_title=p9.element_text(size=20, color='white', ha='center'),
        plot_subtitle=p9.element_text(size=14, color='gray', ha='center'),
        axis_title_x=p9.element_text(color="gray"),
        axis_title_y=p9.element_text(color="gray"),
        axis_text_x=p9.element_text(color="white"),
        axis_text_y=p9.element_text(color="white"),
        legend_text=p9.element_text(color="white"),
        legend_title=p9.element_text(color="white")
    )
)
# plot.draw(True)
plot.save("yoy_listening_breakdown.png")

month_df = df.groupby(['month_number']).sum(numeric_only=True)[['seconds_played', 'minutes_played']].reset_index()
month_df['hours_played'] = month_df['minutes_played'].__truediv__(60)
month_df['days_played'] = month_df['hours_played'].__truediv__(24)

hour_of_day_df = df.groupby(['time_of_day']).sum(numeric_only=True)[['seconds_played', 'minutes_played']].reset_index()
hour_of_day_df['hours_played'] = hour_of_day_df['minutes_played'].__truediv__(60)
hour_of_day_df['days_played'] = hour_of_day_df['hours_played'].__truediv__(24)

day_of_week_hour_of_day_df = df.groupby(['hour_of_day', 'weekday', 'time_of_day', 'day_of_week']).sum(numeric_only=True)[['seconds_played', 'minutes_played']].reset_index()
day_of_week_hour_of_day_df['hours_played'] = day_of_week_hour_of_day_df['minutes_played'].__truediv__(60)
day_of_week_hour_of_day_df['days_played'] = day_of_week_hour_of_day_df['hours_played'].__truediv__(24)
plot_heatmap = day_of_week_hour_of_day_df[['weekday', 'hours_played', 'hour_of_day', 'time_of_day', 'day_of_week']].rename(columns={'hours_played': 'Total Hours'})
# print(plot_heatmap)
plot_heatmap['Total Hours'] = plot_heatmap['Total Hours'].astype('float')
g = (
    p9.ggplot(plot_heatmap, p9.aes("factor(day_of_week)", "factor(hour_of_day)", fill="Total Hours"))
    + p9.geom_tile(p9.aes(width=0.95, height=0.95))
    + p9.scale_y_discrete(breaks=tuple(hour_dict.keys()),labels=tuple(hour_dict.values()))
    + p9.scale_x_discrete(breaks=tuple(weekday_dict.keys()),labels=tuple(weekday_dict.values()))
    + p9.scale_fill_continuous(cmap_name='Blues')
    + p9.xlab("Weekday")
    + p9.ylab("Time of Day")
    + p9.labs(
        title="Listening Activity Breakdown",
        subtitle="by Weekday~Hour")
    + p9.theme_minimal()
    + p9.theme(
        plot_title=p9.element_text(size=20, color='gray', ha='center'),
        plot_subtitle=p9.element_text(size=14, color='gray', ha='center'),
        axis_title_x=p9.element_text(color="gray"),
        axis_title_y=p9.element_text(color="gray"),
        axis_text_x=p9.element_text(color="gray"),
        axis_text_y=p9.element_text(color="gray"),
        legend_text=p9.element_text(color="gray"),
        legend_title=p9.element_text(color="gray")
    )
)
g.save(filename="listening_activity_breakdown.png")
# print(g)

def concat_audio_features():
    df = pd.read_csv('audio_features.csv')
    df1 = pd.read_csv('audio_features2.csv')
    total_df = pd.concat([df,df1])
    # total_df.to_csv('data/processed/all_audio_features.csv', index=False)
    return total_df

def concat_track_metadata():
    df = pd.read_csv('data/raw/track_metadata.csv')
    df1 = pd.read_csv('data/raw/track_metadata2.csv')
    total_df = pd.concat([df,df1])
    # total_df.to_csv('data/processed/all_track_metadata.csv', index=False)
    return total_df
    
def concat_album_metadata():
    df = pd.read_csv('data/raw/album_metadata.csv')
    df1 = pd.read_csv('data/raw/album_metadata2.csv')
    total_df = pd.concat([df,df1])
    total_df.to_csv('data/processed/all_album_metadata.csv', index=False)
    return total_df

# concat_album_metadata()

def merge_all_data():
    audio_df = pd.read_csv('data/processed/all_audio_features.csv').rename(columns={
        'id': 'song_id'
    }).drop(['duration_ms', 'time_signature', 'analysis_url', 'track_href', 'uri', 'key', 'type'], axis=1)
    metadata_df = pd.read_csv('data/processed/all_track_metadata.csv')
    listening_df = pd.read_csv('data/processed/pre_processed_listening_history.csv').rename(columns={
        'track_id': 'song_id'
    })
    listening_df = listening_df[['reason_start', 'reason_end', 'shuffle', 'skipped', 'date', 'year', 'month_year', 'hour_of_day', 'time_of_day', 'day_of_week', 'weekday', 'month_number', 'month', 'minutes_played', 'song_id']]
    artist_df = pd.read_csv("data/processed/all_artist_metadata.csv")
    album_df = pd.read_csv("data/processed/all_album_metadata.csv")
    album_artist_merge = pd.merge(artist_df, album_df, on=['artist_id', 'artist_name'])
    track_album_artist_merge = pd.merge(metadata_df, album_artist_merge, on='album_id', how='left')
    audio_track_album_artist_merge = pd.merge(audio_df, track_album_artist_merge, on='song_id', how='left')
    final_df = pd.merge(listening_df, audio_track_album_artist_merge, on='song_id')
    final_df = final_df.loc[final_df['artist_id'].notnull()]
    # final_df = pd.merge(final_df, audio_df, on='song_id')
    # format_df = final_df.drop(['date', 'year', 'month_year', 'hour_of_day', 'day_of_week', 'month_number'], axis=1)
    # format_df.to_csv('data/processed/chatgpt_listening_history_audio_features.csv', index=False)
    final_df.to_csv('data/processed/final_listening_history_audio_features.csv', index=False)
    return final_df

# exas = merge_all_data()
# print(exas)

# es = merge_all_data()
# print(es)
def calculate_top_100_songs():
    df = pd.read_csv('data/processed/pre_processed_listening_history.csv')
    top_songs_df = df.groupby(['master_metadata_track_name', 'spotify_track_uri', 'month']).sum(numeric_only=True)['ms_played'].reset_index()
    top_songs_df['seconds_played'] = top_songs_df['ms_played'].__truediv__(1000)
    top_songs_df['minutes_played'] = top_songs_df['seconds_played'].__truediv__(60)
    top_songs_df = top_songs_df.sort_values("minutes_played", ascending=False).rename(columns={
        'spotify_track_uri': 'uri'
    })
    audio_features_df = pd.read_csv('data/processed/all_audio_features.csv')
    final_df = pd.merge(top_songs_df, audio_features_df, on='uri').drop(['duration_ms', 'time_signature', 'analysis_url', 'track_href', 'ms_played', 'seconds_played', 'key', 'type', 'mode'], axis=1).rename(columns={
        'id': 'song_id'
    })
    final_df = final_df.drop(['master_metadata_track_name', 'uri'], axis=1)
    metadata_df = pd.read_csv('data/processed/all_track_metadata.csv')
    final_df = pd.merge(metadata_df, final_df, on='song_id')
    # final_df.to_csv("data/processed/chatgpt_month_song_total_minutes_audio_features.csv", index=False)
    # return final_df.head(100)

# test = calculate_top_100_songs()

# test = pd.read_csv('data/processed/total_song_minutes_played_features.csv')
test = pd.read_csv("data/processed/final_listening_history_audio_features.csv")
test['duration_ms'] = test['minutes_played'] * 60 * 1000


# List of numerical columns to plot
numerical_columns = [
    'danceability', 'energy', 'loudness', 'speechiness', 'acousticness',
    'instrumentalness', 'liveness', 'valence', 'tempo', 'duration_ms', 'popularity'
]


# Plotting the distributions
for column in numerical_columns:
    plt.figure(figsize=(10, 6))
    plt.hist(test[column], bins=30, color='blue', alpha=0.7)
    plt.title(f'Distribution of {column}')
    plt.xlabel(column)
    plt.ylabel('Frequency')
    plt.grid(True)
    # plt.savefig(f"plots/hist_plots/{column}_hist_plot.png")
    plt.show()
    plt.close()
    # plt.show()

# Plotting box plots for numerical columns to visualize potential outliers
# for column in test.select_dtypes(include=[np.number]).columns:
for column in numerical_columns:
    plt.figure(figsize=(10, 6))
    sns.boxplot(x=test[column])
    plt.title(f'Box plot for {column}')
    # plt.savefig(f"plots/box_plots/{column}_hist_plot.png")
    # plt.show()
    plt.close()

correlation_matrix = test.corr(numeric_only=True)
# print(correlation_matrix)

# Plotting the correlation matrix
plt.figure(figsize=(12, 8))
sns.heatmap(correlation_matrix, annot=True, fmt=".2f", cmap="coolwarm", linewidths=0.5)
plt.title('Correlation Matrix of Audio Features')

plt.savefig('correlation_matrix.png')
# plt.show()

top_features = correlation_matrix[correlation_matrix.abs() > 0.5].stack().reset_index()
top_features = top_features[top_features['level_0'] != top_features['level_1']]
top_features.columns = ['Feature 1', 'Feature 2', 'Correlation']
# print(top_features)

# Plot scatter plots with regression lines for the top correlated features
for _, row in top_features.iterrows():
    plt.figure(figsize=(8, 6))
    sns.regplot(data=test, x=row['Feature 1'], y=row['Feature 2'], scatter_kws={'alpha':0.6})
    plt.title(f'Scatter plot with Regression: {row["Feature 1"]} vs {row["Feature 2"]}')
    plt.xlabel(row['Feature 1'])
    plt.ylabel(row['Feature 2'])
    plt.grid()
    plt.savefig(f"plots/scatter_plots/{row['Feature 1']}_vs_{row['Feature 2']}_regression_plot.png")
    # plt.show()
    plt.close()

# Pair plots for the top correlated features
sns.pairplot(test[top_features['Feature 1'].unique()], diag_kind='kde', plot_kws={'alpha': 0.7})
plt.suptitle('Pair Plot of Top Correlated Features', y=1.02)
# plt.savefig('plots/pair_plots/top_correlated_features.png')
# plt.show()
plt.close()

def count_track_listen():
    df = pd.read_csv("data/processed/final_listening_history_audio_features.csv")
    count_artist_listens_df = df.groupby(['song_name', 'song_id']).agg({
        'popularity': 'count',
        'minutes_played': 'sum',
    }).reset_index().rename(columns={
        'minutes_played': 'total_minutes',
        'popularity': 'total_listens'
    })
    count_distinct_tracks = df.groupby(['song_name', 'song_id']).agg({
        'popularity': 'nunique'
    }).reset_index().rename(columns={
        'popularity': 'distinct_tracks'
    })
    artist_first_last_listen = df.groupby(['song_name', 'song_id'])['date'].agg(
        min_date='min', max_date='max'
    ).reset_index()
    artist_df = df[['song_name', 'song_id', 'artist_name']].drop_duplicates()
    final_artist_df = pd.merge(count_artist_listens_df, count_distinct_tracks, on=['song_id', 'song_name'])
    final_artist_df['total_hours'] = final_artist_df['total_minutes'] / 60
    final_artist_df = pd.merge(final_artist_df, artist_first_last_listen, on=['song_id', 'song_name'])
    final_artist_df = pd.merge(artist_df, final_artist_df, on=['song_id', 'song_name']).sort_values('total_hours', ascending=False)
    final_artist_df.head(10).to_csv('data/processed/final_top_songs_aggregations.csv', index=False)
    return final_artist_df.head(10)

sdgas = count_track_listen()
print(sdgas)

def count_artist_listen():
    df = pd.read_csv("data/processed/final_listening_history_audio_features.csv")
    count_artist_listens_df = df.groupby(['artist_name', 'artist_id']).agg({
        'popularity': 'count',
        'minutes_played': 'sum',
    }).reset_index().rename(columns={
        'minutes_played': 'total_minutes',
        'popularity': 'total_listens'
    })
    count_distinct_tracks = df.groupby(['artist_name', 'artist_id']).agg({
        'popularity': 'nunique'
    }).reset_index().rename(columns={
        'popularity': 'distinct_tracks'
    })
    artist_first_last_listen = df.groupby(['artist_name', 'artist_id'])['date'].agg(
        min_date='min', max_date='max'
    ).reset_index()
    final_artist_df = pd.merge(count_artist_listens_df, count_distinct_tracks, on=['artist_id', 'artist_name'])
    final_artist_df['total_hours'] = final_artist_df['total_minutes'] / 60
    final_artist_df = pd.merge(final_artist_df, artist_first_last_listen, on=['artist_id', 'artist_name']).sort_values('total_hours', ascending=False)
    final_artist_df.head(10).to_csv('data/processed/final_top_artists_aggregations.csv', index=False)
    return final_artist_df.head(10)

artists_df = count_artist_listen()
print(artists_df)