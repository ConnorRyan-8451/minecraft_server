"""
Simple completion script template
This runs when resources have been provisioned
"""

def send_completion_email(user_email, request_data):
    """Send completion notification"""
    print(f"📧 Sending completion email to: {user_email}")
    print(f"📧 Request completed: {request_data['request_title']}")
    
    # TODO: Load email template and send email
    # Example: Load completed.html template and populate with request_data

def cleanup_temporary_resources():
    """Clean up any temporary resources if needed"""
    print("🧹 Cleaning up temporary resources...")
    # TODO: Add cleanup logic if needed

if __name__ == "__main__":
    # Example - this would be called after provisioning is complete
    request_data = {
        'user_email': 'user@example.com',
        'request_title': 'My Request',
        'request_type': 'Option 1',
        'description': 'Completed request'
    }
    
    send_completion_email(request_data['user_email'], request_data)
    cleanup_temporary_resources()
    
    print("✅ Request completion processing done!")
