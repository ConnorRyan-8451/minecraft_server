# Developer Portal Form Template

This is a simple template for creating forms in your developer portal that trigger backend workflows.

## Files Structure

```
├── form/
│   └── form.yml          # Form configuration (like GitHub issue templates)
├── scripts/
│   ├── process-form-inputs.py    # Process form data
│   ├── process-request.py        # Main request handler
│   ├── complete-request.py       # Completion handler
│   └── form.py                   # Form utilities
├── email_templates/
│   ├── request.html              # Request received email
│   └── completed.html            # Request completed email
├── main.py                       # Entry point
└── requirements.txt              # Python dependencies
```

## Quick Start

1. **Customize the form** in `form/form.yml`
   - Change form name, description, and fields
   - Add/remove fields as needed

2. **Update form processing** in `scripts/process-form-inputs.py`
   - Modify to handle your specific form fields
   - Add any validation logic

3. **Add your business logic** in `scripts/process-request.py`
   - Configure email sending (SendGrid, SMTP, etc.)
   - Add resource provisioning logic

4. **Customize email templates** in `email_templates/`
   - Update HTML templates with your branding
   - Modify content for your use case

## Usage

Run the main script:
```bash
python main.py
```

Or test individual components:
```bash
python scripts/process-request.py
```

## Environment Variables

Set these for email functionality:
```bash
export SENDGRID_API_KEY="your-sendgrid-key"
# OR for SMTP:
export SMTP_SERVER="smtp.gmail.com"
export SMTP_USERNAME="your-username"
export SMTP_PASSWORD="your-password"
```

## Customization

This template is designed to be simple and easy to customize:

- **Form Fields**: Edit `form/form.yml` to match your needs
- **Processing Logic**: Modify scripts in `scripts/` folder  
- **Email Templates**: Update HTML files in `email_templates/`
- **Dependencies**: Add any packages to `requirements.txt`

## Form Field Types

Supported field types in `form.yml`:
- `input` - Single line text
- `textarea` - Multi-line text  
- `dropdown` - Select options
- `checkboxes` - Multiple checkboxes
- `markdown` - Static content

## Integration

Your developer portal should:
1. Read `form.yml` to generate the form UI
2. Submit form data to `main.py` when user submits
3. Handle the response from the processing system

That's it! Keep it simple and customize as needed.
