import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score, precision_score, recall_score
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import LinearRegression, Ridge
from sklearn.tree import DecisionTreeRegressor
from sklearn.svm import SVR
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.metrics import mean_absolute_error, r2_score

pd.set_option("display.max_columns", None)


# Load the dataset
file_path = 'data/processed/month_total_song_minutes_played_features.csv'
data = pd.read_csv(file_path)

# Expand artist genres into individual rows to analyze impact
data['artist_genres_expanded'] = data['artist_genres'].str.strip("[]").str.replace("'", "").str.split(", ")

# Explode genres into separate rows
genres_data = data.explode('artist_genres_expanded').rename(columns={'artist_genres_expanded': 'genre'})
genres_columns = genres_data.columns.to_list()
genres_columns.remove("genre")
print(genres_columns)
unique_data = genres_data.groupby(genres_columns).agg({
    'genre': 'nunique'
}).reset_index().rename(columns={
    "genre": "number_genres"
})
unique_data = pd.merge(unique_data, genres_data, on=genres_columns)

unique_data['allocated_minutes'] = unique_data['minutes_played'] / unique_data['number_genres']
genres_by_month_day = unique_data.groupby(['genre', 'month']).agg({
    'danceability': 'mean', 
    'energy': 'mean', 
    'loudness': 'mean', 
    'mode': 'mean', 
    'speechiness': 'mean', 
    'acousticness': 'mean', 
    'instrumentalness': 'mean', 
    'liveness': 'mean', 
    'valence': 'mean', 
    'tempo': 'mean',
    'allocated_minutes': 'sum',
    'popularity': 'mean'
}).reset_index()
genres_by_month_day = genres_by_month_day.loc[genres_by_month_day['allocated_minutes'] > 50]
print(genres_by_month_day.sort_values("allocated_minutes", ascending=False))
genres_by_month_day.to_csv('data/processed/genres_by_month_features.csv', index=False)
genres_total =  unique_data.groupby(['genre']).agg({
    'danceability': 'mean', 
    'energy': 'mean', 
    'loudness': 'mean', 
    'mode': 'mean', 
    'speechiness': 'mean', 
    'acousticness': 'mean', 
    'instrumentalness': 'mean', 
    'liveness': 'mean', 
    'valence': 'mean', 
    'tempo': 'mean',
    'allocated_minutes': 'sum',
    'popularity': 'mean'
}).reset_index()
# genres_total.to_csv('data/processed/genres_total.csv', index=False)
# print(genres_total.sort_values("allocated_minutes", ascending=False))

# Identify non-numeric columns
non_numeric_columns = genres_by_month_day.select_dtypes(include=['object']).columns

# Encode non-numeric columns
label_encoders = {}
for col in non_numeric_columns:
    label_encoders[col] = LabelEncoder()
    genres_by_month_day[col] = label_encoders[col].fit_transform(genres_by_month_day[col])

# Prepare features and target
features = unique_data.drop(columns=['minutes_played', 'song_id', 'artist_id', 'artist_genres', 'song_name', 'allocated_minutes', 'album_id', 'album_release_date', 'album_name'], axis=1)
features = genres_by_month_day.drop(columns=['allocated_minutes', 'mode'], axis=1)
print(features)
# target = unique_data['allocated_minutes']
target = unique_data['allocated_minutes']
target = genres_by_month_day['allocated_minutes']
print(target)

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(features, target, test_size=0.2, random_state=42)

# # Initialize models
# models = {
#     "Linear Regression": LinearRegression(),
#     "Random Forest": RandomForestRegressor(random_state=42),
#     "Gradient Boosting": GradientBoostingRegressor(random_state=42),
# }

# # Train and evaluate models
# results = []
# for name, model in models.items():
#     model.fit(X_train, y_train)
#     predictions = model.predict(X_test)

#     # Calculate performance metrics
#     mse = mean_squared_error(y_test, predictions)
#     r2 = r2_score(y_test, predictions)
#     results.append((name, mse, r2))

# # Convert results to a DataFrame for better visualization
# results_df = pd.DataFrame(results, columns=["Model", "MSE", "R2 Score"])
# print(results_df)

# Define parameter grids
param_grid_rf = {
    'n_estimators': [200],
    'max_depth': [10],
    'min_samples_split': [5]
}

param_grid_gb = {
    'n_estimators': [200],
    'learning_rate': [0.1],
    'max_depth': [5]
}

# Initialize GridSearchCV for Random Forest
grid_search_rf = GridSearchCV(RandomForestRegressor(random_state=42), param_grid_rf, cv=3, scoring='r2', n_jobs=-1)
grid_search_rf.fit(X_train, y_train)

# Initialize GridSearchCV for Gradient Boosting
grid_search_gb = GridSearchCV(GradientBoostingRegressor(random_state=42), param_grid_gb, cv=3, scoring='r2', n_jobs=-1)
grid_search_gb.fit(X_train, y_train)

# Best parameters and scores
best_rf_params = grid_search_rf.best_params_
best_gb_params = grid_search_gb.best_params_

# Evaluate fine-tuned models on the test set
best_rf = grid_search_rf.best_estimator_
best_gb = grid_search_gb.best_estimator_

# Predictions
pred_rf = best_rf.predict(X_test)
pred_gb = best_gb.predict(X_test)

# Metrics
rf_mse = mean_squared_error(y_test, pred_rf)
rf_r2 = r2_score(y_test, pred_rf)

gb_mse = mean_squared_error(y_test, pred_gb)
gb_r2 = r2_score(y_test, pred_gb)

# Display results
fine_tune_results = pd.DataFrame([
    ("Fine-Tuned Random Forest", rf_mse, rf_r2, best_rf_params),
    ("Fine-Tuned Gradient Boosting", gb_mse, gb_r2, best_gb_params)
], columns=["Model", "MSE", "R2 Score", "Best Parameters"])
print(fine_tune_results)

# Visualize feature importance
rf_feature_importances_total = best_rf.feature_importances_
feature_names_total = X_train.columns
sorted_idx_total = rf_feature_importances_total.argsort()[::-1]
sorted_importances_total = rf_feature_importances_total[sorted_idx_total]
sorted_features_total = feature_names_total[sorted_idx_total]

import matplotlib.pyplot as plt

plt.figure(figsize=(12, 6))
plt.barh(sorted_features_total[:10], sorted_importances_total[:10], align='center', color='skyblue')
plt.xlabel('Feature Importance')
plt.ylabel('Features')
plt.title('Top 10 Feature Importances for Predicting Total Minutes')
plt.gca().invert_yaxis()
plt.grid(axis='x', linestyle='--', alpha=0.7)
# plt.show()

plt.figure(figsize=(12, 8))
# Scatter plot of actual vs predicted values
plt.scatter(y_test, pred_rf, alpha=0.6, edgecolor='k', label="Predictions")
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--', linewidth=2, label="Perfect Prediction Line")
plt.show()