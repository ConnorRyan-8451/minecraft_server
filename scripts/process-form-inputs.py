"""
Simple form input processing template
Customize this to handle your form data
"""

def process_form_inputs(form_data):
    """
    Process form inputs from the developer portal
    
    Args:
        form_data: Dictionary containing form field values
        
    Returns:
        Processed form data ready for use
    """
    
    # Basic processing - customize this for your needs
    processed_data = {
        'user_email': form_data.get('user_email', ''),
        'request_title': form_data.get('request_title', ''),
        'request_type': form_data.get('request_type', ''),
        'description': form_data.get('description', ''),
        'terms_accepted': form_data.get('terms_0', False),  # First checkbox
        
        # Add timestamp
        'timestamp': str(__import__('datetime').datetime.now()),
        
        # Keep original data for reference
        'original_form_data': form_data
    }
    
    return processed_data


# Test the function
if __name__ == "__main__":
    # Example form data
    test_data = {
        'user_email': 'test@example.com',
        'request_title': 'Test Request',
        'request_type': 'Option 1',
        'description': 'This is a test request',
        'terms_0': True
    }
    
    result = process_form_inputs(test_data)
    print("Processed form data:", result)