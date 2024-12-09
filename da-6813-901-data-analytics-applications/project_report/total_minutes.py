from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder, LabelEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error, precision_score, recall_score, f1_score
from sklearn.linear_model import LinearRegression, Ridge
from sklearn.tree import DecisionTreeRegressor
from sklearn.svm import SVR
import pandas as pd
import matplotlib.pyplot as plt
pd.set_option('display.max_columns', None)


# Load the uploaded CSV file
uploaded_file_path = 'data/processed/total_song_minutes_played_features.csv'
uploaded_data = pd.read_csv(uploaded_file_path).drop(['song_id', 'song_name', 'album_id', 'album_name', 'album_release_date', 'artist_id'], axis=1)

# Identify numerical features for clustering
# numerical_features = uploaded_data.select_dtypes(include=['float64', 'int64']).columns
numerical_features = ['danceability', 'energy', 'loudness', 'mode', 'speechiness',
       'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'artist_followers', 
       'artist_popularity', 'minutes_played']

# Expand artist genres into individual rows to analyze impact
uploaded_data['artist_genres_expanded'] = uploaded_data['artist_genres'].str.strip("[]").str.replace("'", "").str.split(", ")

# Explode genres into separate rows
genres_uploaded_data = uploaded_data.explode('artist_genres_expanded').rename(columns={'artist_genres_expanded': 'genre'}).drop('artist_genres', axis=1)
# print(genres_uploaded_data)
# categorical_features = ['artist_name', 'genre']
# numerical_features = [feature for feature in numerical_features if feature not in categorical_features]
# top25_genres = genres_uploaded_data['genre'].value_counts().head(25).index.to_list()
# genres_uploaded_data = genres_uploaded_data.loc[genres_uploaded_data['genre'].isin(top25_genres)]

genres_uploaded_data = genres_uploaded_data.groupby(['danceability', 'energy', 'loudness', 'mode', 'speechiness',
       'acousticness', 'instrumentalness', 'liveness', 'valence', 'tempo', 'artist_followers', 
       'artist_popularity', 'popularity']).sum()['minutes_played'].reset_index()
genres_uploaded_data = genres_uploaded_data.loc[genres_uploaded_data['minutes_played'] > 10]
print(genres_uploaded_data)

# Separate features and target variable
X = genres_uploaded_data.drop("popularity", axis=1)
# y = data['month']
y = genres_uploaded_data['popularity']
# print(X)

# Preprocessing pipeline
preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numerical_features),
        # ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features),
    ]
)

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

models = {
    "Linear Regression": LinearRegression(),
    "Ridge Regression": Ridge(random_state=42),
    "Decision Tree": DecisionTreeRegressor(random_state=42),
    "Random Forest": RandomForestRegressor(random_state=42),
    "Gradient Boosting": GradientBoostingRegressor(random_state=42),
    "SVR": SVR()
}



# Evaluate each model using the pipeline

results = []

for name, model in models.items():

    pipeline = Pipeline(

        steps=[

            ("preprocessor", preprocessor),

            ("regressor", model),

        ]

    )

    pipeline.fit(X_train, y_train)
    y_pred = pipeline.predict(X_test)
    

    # Collect metrics

    mse = mean_squared_error(y_test, y_pred)
    rmse = mse ** 0.5
    mae = mean_absolute_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    results.append({"Model": name, "RMSE": rmse, "MSE": mse, "MAE": mae, "R2 Score": r2})



# Convert results to a DataFrame for better readability

results_df = pd.DataFrame(results)
print(results_df)


# Select the best-performing model based on RMSE (lowest value)
best_model_name = results_df.sort_values(by="RMSE").iloc[0]["Model"]
best_model = models[best_model_name]

# Fit the best model on the full training data
best_pipeline = Pipeline(
    steps=[
        ("preprocessor", preprocessor),
        ("regressor", best_model),
    ]
)
best_pipeline.fit(X_train, y_train)

# Predict and analyze further
y_pred_best = best_pipeline.predict(X_test)

# Calculate residuals
residuals = y_test - y_pred_best

# Analyze performance metrics
r2_best = r2_score(y_test, y_pred_best)
mae_best = mean_absolute_error(y_test, y_pred_best)

# Visualize residuals and prediction performance
plt.figure(figsize=(12, 6))
plt.subplot(1, 2, 1)
plt.scatter(y_test, y_pred_best, alpha=0.7)
plt.xlabel("True Values")
plt.ylabel("Predictions")
plt.title(f"{best_model_name} Predictions vs True Values")

plt.subplot(1, 2, 2)
plt.hist(residuals, bins=20, alpha=0.7)
plt.xlabel("Residuals")
plt.title(f"{best_model_name} Residual Distribution")

plt.tight_layout()
plt.show()
