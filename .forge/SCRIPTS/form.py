"""
Form helper utilities
Add any form-related helper functions here
"""

def validate_email(email):
    """Simple email validation"""
    return '@' in email and '.' in email

def validate_form_data(form_data):
    """Validate form data before processing"""
    errors = []
    
    # Check required fields
    if not form_data.get('user_email'):
        errors.append("Email is required")
    elif not validate_email(form_data['user_email']):
        errors.append("Invalid email format")
    
    if not form_data.get('request_title'):
        errors.append("Request title is required")
    
    if not form_data.get('description'):
        errors.append("Description is required")
    
    return errors

if __name__ == "__main__":
    # Test validation
    test_data = {
        'user_email': 'test@example.com',
        'request_title': 'Test',
        'description': 'Test description'
    }
    
    errors = validate_form_data(test_data)
    if errors:
        print("Validation errors:", errors)
    else:
        print("✅ Form data is valid")
