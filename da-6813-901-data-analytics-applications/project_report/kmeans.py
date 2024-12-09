# Re-import necessary libraries after session reset
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import Ridge
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

# Load the uploaded dataset
file_path = 'data/processed/total_song_minutes_played_features.csv'
data = pd.read_csv(file_path)

# Drop specified columns
columns_to_drop = ['mode', 'loudness', 'artist_genres', 'artist_name', 'song_id', 'song_name', 'album_id', 'album_name', 'album_release_date', 'artist_id']
data = data.drop(columns=columns_to_drop, errors='ignore')

# Separate features and target variable
# Assuming 'allocated_minutes' as the target variable
target = data['popularity']
features = data.drop(columns=['popularity'])

# Encode categorical variables and standardize numerical features
features_encoded = pd.get_dummies(features, drop_first=True)
scaler = StandardScaler()
features_scaled = scaler.fit_transform(features_encoded)

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(features_scaled, target, test_size=0.3, random_state=42)

# Train a Ridge Regression model
ridge = Ridge(alpha=1.0, random_state=42)
ridge.fit(X_train, y_train)

# Extract feature coefficients
coefficients = ridge.coef_
feature_names = features_encoded.columns

# Sort features by importance (absolute value of coefficients)
sorted_indices = abs(coefficients).argsort()[::-1]
sorted_features = feature_names[sorted_indices]
sorted_coefficients = coefficients[sorted_indices]

# Visualize the feature coefficients
plt.figure(figsize=(10, 8))
plt.barh(sorted_features, sorted_coefficients, color='skyblue')
plt.xlabel('Coefficient Value')
plt.ylabel('Feature')
plt.title('Feature Coefficients in Ridge Regression')
plt.gca().invert_yaxis()  # Most important features at the top
plt.tight_layout()
plt.savefig('ridge_coefficients.png')
plt.show()
