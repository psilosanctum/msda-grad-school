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
pd.set_option("display.max_columns", None)

data = pd.read_csv('data/processed/genres_by_month_features.csv')
# encoder = LabelEncoder()
# encoded = encoder.fit_transform(data['genre'])
# print(encoded)

# Separate features and target variable
X = data.drop(columns=["mode", 'popularity'])
y = data['popularity']
print(X)

# Identify categorical and numerical features
categorical_features = ["genre", "month"]
numerical_features = X.select_dtypes(include=["float64", "int64"]).columns.tolist()
numerical_features = [feature for feature in numerical_features if feature not in categorical_features]

# Preprocessing pipeline
preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numerical_features),
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features),
    ]
)

# Define the model pipeline
model_pipeline = Pipeline(
    steps=[
        ("preprocessor", preprocessor),
        ("regressor", RandomForestRegressor(random_state=42)),
    ]
)

# Split the dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# # Train the model
# model_pipeline.fit(X_train, y_train)

# # Predict on the test set
# y_pred = model_pipeline.predict(X_test)

# # Evaluate the model
# mse = mean_squared_error(y_test, y_pred)
# rmse = mse ** 0.5

# rmse

# Define a list of models to evaluate

models = {
    "Linear Regression": LinearRegression(),
    "Ridge Regression": Ridge(random_state=42),
    "Random Forest": RandomForestRegressor(random_state=42),
    "Gradient Boosting": GradientBoostingRegressor(random_state=42),
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
best_pipe = best_pipeline.fit(X_train, y_train)
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
# Visualize residuals and prediction performance
# Residuals vs. Predicted
# plt.figure(figsize=(10, 6))
plt.scatter(y_pred, residuals, alpha=0.7, edgecolor='k')
plt.axhline(0, color='red', linestyle='--', linewidth=2)
plt.title('Residuals vs. Predicted')
plt.xlabel('Predicted Values')
plt.ylabel('Residuals')
plt.grid()

plt.subplot(1, 2, 2)
plt.hist(residuals, bins=20, alpha=0.7)
plt.xlabel("Residuals")
plt.title(f"{best_model_name} Residual Distribution")

plt.tight_layout()
plt.savefig('predictions_vs_actual_residuals.png')
plt.show()

# Summarize the analysis
{
    "Best Model": best_model_name,
    "R2 Score": r2_best,
    "Mean Absolute Error": mae_best,
}

plt.figure(figsize=(12, 6))
plt.barh(results_df['Model'], results_df['R2 Score'], align='center', color='skyblue')
plt.xlabel('R-squared')
plt.ylabel('Model')
plt.title('Model Performance')
plt.gca().invert_yaxis()
plt.grid(axis='x', linestyle='--', alpha=0.7)
plt.savefig('model_performance.png')
plt.show()

