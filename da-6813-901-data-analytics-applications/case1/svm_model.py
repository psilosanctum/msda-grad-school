import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Machine Learning Libraries
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report

# Load the dataset
file_path = 'bank-additional.csv'
data = pd.read_csv(file_path, delimiter=';')

# =========================
# 1. Descriptive Statistics
# =========================
descriptive_stats = data.describe(include='all')
missing_values = data.isnull().sum()
unknown_values = (data == 'unknown').sum()

print("Descriptive Statistics:\n", descriptive_stats)
print("\nMissing Values:\n", missing_values)
print("\n'Unknown' Values:\n", unknown_values)

# =========================
# 2. Data Cleaning
# =========================
# Replace 'unknown' with NaN
data_cleaned = data.replace('unknown', pd.NA)

# Drop rows with any missing values
data_cleaned = data_cleaned.dropna()

# =========================
# 3. Feature Encoding
# =========================
# Convert categorical variables into dummy/indicator variables
data_encoded = pd.get_dummies(data_cleaned, drop_first=True)

# Separate features and target variable
X = data_encoded.drop('y_yes', axis=1)  # 'y_yes' is the encoded target
y = data_encoded['y_yes']

# =========================
# 4. Feature Scaling
# =========================
# It's important to scale features for SVM
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# =========================
# 5. Train-Test Split
# =========================
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.2, random_state=42, stratify=y
)

# =========================
# 6. Training the SVM Model
# =========================
# Initialize the Support Vector Classifier (SVC)
svm_model = SVC(kernel='linear', random_state=42, probability=True)

# Train the SVM model
svm_model.fit(X_train, y_train)

# =========================
# 7. Making Predictions
# =========================
# Predict on the test set
y_pred_svm = svm_model.predict(X_test)

# =========================
# 8. Evaluating the Model
# =========================
# Calculate Accuracy
accuracy_svm = accuracy_score(y_test, y_pred_svm)
print(f"Accuracy on Test Set: {accuracy_svm:.4f}")

# Generate Classification Report
classification_report_svm = classification_report(y_test, y_pred_svm)
print("\nClassification Report:\n", classification_report_svm)

# =========================
# 9. Cross-Validation
# =========================
# Perform 5-fold Cross-Validation
cv_scores_svm = cross_val_score(svm_model, X_scaled, y, cv=5)
print(f"5-Fold Cross-Validation Accuracy: {cv_scores_svm.mean():.4f}")

# =========================
# 10. Visualizing the Results (Optional)
# =========================
# Plotting the confusion matrix
from sklearn.metrics import confusion_matrix
import seaborn as sns

conf_matrix = confusion_matrix(y_test, y_pred_svm)
plt.figure(figsize=(6,4))
sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', 
            xticklabels=['No', 'Yes'], yticklabels=['No', 'Yes'])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix - SVM')
# plt.show()
