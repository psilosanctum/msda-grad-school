import pandas as pd
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
pd.set_option('display.max_columns', None)

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

def bankLogisticRegression():
    # Initialize and fit logistic regression model
    log_reg = LogisticRegression(max_iter=1000)
    log_reg.fit(X_train, y_train)

    # Predict on test set
    y_pred = log_reg.predict(X_test)

    # Evaluate the model
    accuracy = accuracy_score(y_test, y_pred)
    classification_rep = classification_report(y_test, y_pred)

    # Output results
    print(accuracy) 
    print(classification_rep)

def bankRandomForest():

    # Initialize Random Forest classifier
    random_forest = RandomForestClassifier(random_state=42)

    # Train the Random Forest model
    random_forest.fit(X_train, y_train)

    # Predict on the test set
    y_pred_rf = random_forest.predict(X_test)

    # Evaluate the Random Forest model
    accuracy_rf = accuracy_score(y_test, y_pred_rf)
    classification_report_rf = classification_report(y_test, y_pred_rf)

    # Perform cross-validation for Random Forest
    cv_scores_rf = cross_val_score(random_forest, X, y, cv=5)

    # Display accuracy and classification report
    print(f"Test Set Accuracy: {accuracy_rf:.2f}")
    print("\nClassification Report:\n", classification_report_rf)
    print(f"\n5-Fold Cross-Validation Accuracy: {cv_scores_rf.mean():.2f}")

bankRandomForest()
    