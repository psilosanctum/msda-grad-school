# Import necessary libraries
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import cross_val_score, train_test_split
from statsmodels.stats.outliers_influence import variance_inflation_factor
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

path = 'bank-additional.csv'
data = pd.read_csv(path, delimiter=';')
# print(data)

# Replace 'unknown' with NaN for proper handling of missing data
data_cleaned = data.replace('unknown', pd.NA)

# Drop rows with missing values
data_cleaned = data_cleaned.dropna()

# Convert categorical variables into dummy/indicator variables
data_encoded = pd.get_dummies(data_cleaned, drop_first=True)

# Separate the target variable 'y' and features
X = data_encoded.drop('y_yes', axis=1)  # 'y_yes' is the column where 'yes' has been encoded as 1
y = data_encoded['y_yes']

# Split data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
# Checking for Variance Inflation Factor (VIF)
# Select numerical features from the dataset
numerical_features = X.select_dtypes(include=[np.number])

# Create a DataFrame to store VIF values
vif_data = pd.DataFrame()
vif_data["Feature"] = numerical_features.columns
vif_data["VIF"] = [variance_inflation_factor(numerical_features.values, i) for i in range(numerical_features.shape[1])]

# Sort by VIF
vif_data = vif_data.sort_values(by="VIF", ascending=False)

# Plot the VIF values
plt.figure(figsize=(10, 6))
sns.barplot(x='VIF', y='Feature', data=vif_data, palette='viridis')
plt.title('Variance Inflation Factor (VIF) for Features')
plt.show()

# Identify and drop highly collinear features (VIF > 10)
high_vif_features = vif_data[vif_data['VIF'] > 10]['Feature']

# Drop the high VIF features from the dataset
X_reduced = X.drop(columns=high_vif_features)

# Train-test split with the reduced feature set
X_train_reduced, X_test_reduced, y_train_reduced, y_test_reduced = train_test_split(
    X_reduced, y, test_size=0.3, random_state=42, stratify=y
)

# Train Random Forest again on the reduced feature set
random_forest_reduced = RandomForestClassifier(random_state=42)
random_forest_reduced.fit(X_train_reduced, y_train_reduced)

# Predict on the test set
y_pred_rf_reduced = random_forest_reduced.predict(X_test_reduced)

# Evaluate the Random Forest model with reduced features
accuracy_rf_reduced = accuracy_score(y_test_reduced, y_pred_rf_reduced)
classification_report_rf_reduced = classification_report(y_test_reduced, y_pred_rf_reduced)

# Perform cross-validation for the reduced model
cv_scores_rf_reduced = cross_val_score(random_forest_reduced, X_reduced, y, cv=5)

# Output results
print(f"Test Set Accuracy: {accuracy_rf_reduced:.4f}")
print("\nClassification Report:\n", classification_report_rf_reduced)
print(f"\n5-Fold Cross-Validation Accuracy: {cv_scores_rf_reduced.mean():.4f}")


