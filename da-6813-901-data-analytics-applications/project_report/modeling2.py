# Re-import necessary libraries
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import matplotlib.pyplot as plt


# Reload the dataset
file_path = 'data/processed/genres_by_month_features.csv'
data = pd.read_csv(file_path)

# Separate features and target variable
X = data.drop(columns=["allocated_minutes"])
y = data["allocated_minutes"]

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

# Linear Regression pipeline
linear_reg_pipeline = Pipeline(
    steps=[
        ("preprocessor", preprocessor),
        ("regressor", LinearRegression()),
    ]
)

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the model
linear_reg_pipeline.fit(X_train, y_train)

# Predict on the test set
y_pred = linear_reg_pipeline.predict(X_test)

# Evaluate the model
rmse = mean_squared_error(y_test, y_pred) ** 0.5
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

{
    "RMSE": rmse,
    "MAE": mae,
    "R2 Score": r2,
}
print(r2)
# Improved visualization of predictions vs actual values
plt.figure(figsize=(12, 8))

# Scatter plot of actual vs predicted values
plt.scatter(y_test, y_pred, alpha=0.6, edgecolor='k', label="Predictions")
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--', linewidth=2, label="Perfect Prediction Line")
plt.show()

# Highlight areas of overestimation and underestimation
plt.fill_betweenx([y_test.min(), y_test.max()], y_test.min(), y_test.max(), color="gray", alpha=0.1, label="Error Zone")

# Add labels, title, and legend
plt.xlabel("Actual Allocated Minutes")
plt.ylabel("Predicted Allocated Minutes")
plt.title("Linear Regression: Predictions vs Actual Values (Optimized)")
plt.legend()
plt.grid(alpha=0.3)

plt.show()

# Calculate residuals
residuals = y_test - y_pred

# Plot the residuals distribution
plt.figure(figsize=(10, 6))
plt.hist(residuals, bins=20, edgecolor='k', alpha=0.7)
plt.axvline(0, color='r', linestyle='dashed', linewidth=2, label="Zero Residual Line")
plt.title("Distribution of Residuals (Actual - Predicted)")
plt.xlabel("Residuals")
plt.ylabel("Frequency")
plt.legend()
plt.grid(alpha=0.3)
plt.show()


