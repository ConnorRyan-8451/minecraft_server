# Form YAML Documentation

This guide explains how to create dynamic, user-facing forms using YAML configuration files. Similar to GitHub issue templates but with advanced features like conditional visibility, dynamic field population, custom validation, and cascading dependencies.

## Table of Contents

- [Basic Structure](#basic-structure)
- [Field Types](#field-types)
- [Common Properties](#common-properties)
- [Validation](#validation)
- [Dynamic Behavior](#dynamic-behavior)
- [Visibility Control](#visibility-control)
- [Hooks](#hooks)
- [Advanced Examples](#advanced-examples)

---

## Basic Structure

Every form YAML file has three top-level properties:

```yaml
name: Form Title
description: Brief description of the form's purpose
body:
  - type: input
    id: field_id
    # ... field configuration
```

### Properties

- **name** (required): The title displayed at the top of the form
- **description** (required): A brief description explaining the form's purpose
- **body** (required): An array of field definitions

---

## Field Types

### Input Field

Text-based input with support for various HTML5 input types.

```yaml
- type: input
  id: unique_field_id
  attributes:
    label: Field Label
    description: Help text shown below the field
    placeholder: Placeholder text
    input_type: text  # text, email, number, password, date, etc.
    default: ""  # Default value if user doesn't enter anything
  validations:
    required: false
    min_length: null
    max_length: null
    pattern: null
```

**Supported input_type values:**
- `text` - Standard text input
- `email` - Email input with built-in validation
- `number` - Numeric input
- `password` - Masked password input
- `date` - Date picker

**Number-specific validations:**
```yaml
validations:
  min: 0
  max: 100
  step: 1
```

**Date-specific validations:**
```yaml
validations:
  min_date: "2024-01-01"  # or "today"
  max_date: "2024-12-31"  # or "today+30"
```

### Textarea

Multi-line text input.

```yaml
- type: textarea
  id: message_field
  attributes:
    label: Message
    description: Enter your message
    placeholder: Type here...
    rows: 4
    cols: 50
    render: text  # text or markdown
    default: ""  # Default value if user doesn't enter anything
  validations:
    required: false
    min_length: null
    max_length: null
```

### Dropdown

Single or multiple selection dropdown menu.

**Single Selection:**
```yaml
- type: dropdown
  id: single_choice
  attributes:
    label: Choose an option
    description: Select one option
    options:
      - value: option1
      - value: option2
      - value: option3
    default: option1  # Default value if user doesn't select anything (set to null for no default)
    multiple: false
  validations:
    required: false
```

**Multiple Selection:**
```yaml
- type: dropdown
  id: multi_choice
  attributes:
    label: Choose multiple options
    description: Hold Ctrl/Cmd to select multiple
    options:
      - value: option1
      - value: option2
      - value: option3
    default: []  # Default values if user doesn't select anything (e.g., [option1, option2])
    multiple: true
    size: 4  # Visible rows
  validations:
    required: false
    min_selections: null
    max_selections: null
```

### Checkboxes

Group of checkboxes allowing multiple selections.

```yaml
- type: checkboxes
  id: preferences
  attributes:
    label: Select your preferences
    description: Choose one or more
    default: []  # Default checked values (e.g., [option1])
    options:
      - value: option1
        label: Option 1
        required: false
      - value: option2
        label: Option 2
        required: false
  validations:
    required: false
    min_selections: null
    max_selections: null
```

### Radio Buttons

Group of radio buttons for single selection.

```yaml
- type: radio
  id: single_choice
  attributes:
    label: Select one option
    description: Choose exactly one
    options:
      - value: choice1
        label: Choice 1
      - value: choice2
        label: Choice 2
    default: choice1  # Default selected value (set to null for no default)
  validations:
    required: false
```

---

## Common Properties

All field types support these common properties:

### ID
**Required.** Unique identifier for the field. Used for referencing in conditions and dependencies.

```yaml
id: unique_field_name
```

### Attributes
Configuration for the field's appearance and behavior.

```yaml
attributes:
  label: Display Label
  description: Help text (shown below the field)
  placeholder: Placeholder text (for input fields)
```

### Validations
Rules for validating user input.

```yaml
validations:
  required: true  # or false
```

### Visibility
Conditional display based on other field values.

```yaml
visibility:
  condition: "other_field == 'value'"
  depends_on: ["other_field"]
```

### Dynamic
Dynamic behavior like auto-population or computed values.

```yaml
dynamic:
  auto_populate: "default value"
  computed: false
```

---

## Validation

### Built-in Validations

**Text Input:**
```yaml
validations:
  required: true
  min_length: 5
  max_length: 100
  pattern: "^[a-zA-Z0-9]+$"  # Regex pattern (string format)
```

**Note:** The `pattern` field must be a string containing a valid regular expression. The pattern will be evaluated against the input value for validation.

**Number Input:**
```yaml
validations:
  required: true
  min: 0
  max: 100
  step: 5
```

**Email Input:**
```yaml
validations:
  required: true
  pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"  # Regex string
```

**Checkboxes/Dropdowns (multiple):**
```yaml
validations:
  required: false
  min_selections: 1
  max_selections: 3
```

### Custom Validators

Run custom validation logic when field values change. Supported languages: **python**, **javascript**.

**Using an external file:**
```yaml
validations:
  validator:
    type: file
    source: "scripts/validators/custom_validator.py"
    language: python  # python or javascript
    params:
      min_value: 10
      max_value: 100
    error_message: "Value must be between 10 and 100"
```

**Using inline code:**
```yaml
validations:
  validator:
    type: inline
    source: "return len(value) > 5 and value.isalnum()"
    language: python  # python or javascript
    params: {}
    error_message: "Value must be alphanumeric and longer than 5 characters"
```

**Validator function signature (Python):**
```python
def validate(value, params):
    # value: current field value
    # params: dictionary from params property
    # Return True if valid, False if invalid
    return True
```

**Validator function signature (JavaScript):**
```javascript
function validate(value, params) {
    // value: current field value
    // params: object from params property
    // Return true if valid, false if invalid
    return true;
}
```

---

## Dynamic Behavior

### Auto-Population

Automatically fill field values based on other fields or default values.

**Static default:**
```yaml
dynamic:
  auto_populate: "default-value"
  computed: false  # User can edit
```

**Template string (uses other field values):**
```yaml
dynamic:
  auto_populate: "{cloud_provider}-{region}-resource"
  computed: false
```

**Date-based:**
```yaml
dynamic:
  auto_populate: "today"  # or "today+7" for 7 days from now
  computed: false
```

**Computed (read-only):**
```yaml
dynamic:
  auto_populate: "calculateCost({instance_type}, {region})"
  computed: true  # User cannot edit
  depends_on: ["instance_type", "region"]
```

### Dynamic Options

Load dropdown/checkbox/radio options dynamically.

**Using inline options map:**
```yaml
dynamic:
  options_map:
    aws:
      - value: ec2
        label: EC2 Instance
      - value: s3
        label: S3 Bucket
    azure:
      - value: vm
        label: Virtual Machine
      - value: storage
        label: Storage Account
  depends_on_field: "cloud_provider"
```

**Multi-level dependencies:**
```yaml
dynamic:
  options_map:
    aws:
      ec2:
        - value: t2.micro
          label: t2.micro (1 vCPU, 1GB RAM)
        - value: t2.small
          label: t2.small (1 vCPU, 2GB RAM)
      rds:
        - value: db.t2.micro
          label: db.t2.micro (1 vCPU, 1GB RAM)
  depends_on_fields: ["cloud_provider", "resource_type"]
  lookup_path: "{cloud_provider}.{resource_type}"
```

**Using external script:**
```yaml
attributes:
  options_loader:
    type: file
    source: "scripts/generators/get_options.py"
    language: python
    params:
      filter: "active"
    depends_on: ["parent_field"]
```

**Using inline script:**
```yaml
attributes:
  options_loader:
    type: inline
    source: "return ['option1', 'option2', 'option3']"
    language: python
    params: {}
```

**Using API endpoint:**
```yaml
attributes:
  options_loader:
    type: api
    source: "/api/resources?provider={cloud_provider}"
    depends_on: ["cloud_provider"]
```

**Options loader function signature (Python):**
```python
def get_options(params, form_values):
    # params: dictionary from params property
    # form_values: current values of all form fields
    # Return list of dicts with 'value' and optionally 'label'
    return [
        {"value": "opt1", "label": "Option 1"},
        {"value": "opt2", "label": "Option 2"}
    ]
```

---

## Visibility Control

Control when fields are shown or hidden based on other field values.

### Simple Condition

```yaml
visibility:
  condition: "cloud_provider != null"
  depends_on: ["cloud_provider"]
```

### Equality Check

```yaml
visibility:
  condition: "environment == 'production'"
  depends_on: ["environment"]
```

### Multiple Conditions (OR)

```yaml
visibility:
  condition: "cloud_provider == 'aws' || cloud_provider == 'azure'"
  depends_on: ["cloud_provider"]
```

### Multiple Conditions (AND)

```yaml
visibility:
  condition: "cloud_provider == 'aws' && environment == 'production'"
  depends_on: ["cloud_provider", "environment"]
```

### Array Inclusion (for checkboxes)

```yaml
visibility:
  condition: "advanced_options.includes('backup')"
  depends_on: ["advanced_options"]
```

### Complex Conditions

```yaml
visibility:
  condition: "advanced_options.includes('encryption') && cloud_provider == 'aws'"
  depends_on: ["advanced_options", "cloud_provider"]
```

**Condition Expression Syntax:**
- Comparison: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical: `&&` (AND), `||` (OR), `!` (NOT)
- Array methods: `.includes('value')`
- Null checks: `field != null`, `field == null`

---

## Hooks

Execute custom code at different lifecycle events.

### Available Hooks

- **on_load**: Runs when the field is first rendered
- **on_change**: Runs when the field value changes
- **on_submit**: Runs when the form is submitted

```yaml
hooks:
  on_load:
    type: file
    source: "scripts/hooks/initialize_field.py"
    language: python
    params:
      setting: "value"

  on_change:
    type: inline
    source: "console.log('Field changed:', value)"
    language: javascript
    params: {}

  on_submit:
    type: file
    source: "scripts/hooks/validate_submission.py"
    language: python
    params: {}
```

**Hook function signature (Python):**
```python
def on_load(field_id, params, form_values):
    # field_id: current field's ID
    # params: dictionary from params property
    # form_values: current values of all form fields
    # Return value depends on hook type
    pass

def on_change(field_id, old_value, new_value, params, form_values):
    # old_value: previous field value
    # new_value: current field value
    # Can modify form state or trigger actions
    pass

def on_submit(form_values, params):
    # form_values: all form field values
    # Return True to allow submission, False to block
    return True
```

---

## Advanced Examples

### Example 1: Cascading Dropdowns

Cloud provider selection that dynamically updates region and instance type options.

```yaml
body:
  - type: dropdown
    id: cloud_provider
    attributes:
      label: Cloud Provider
      options:
        - value: aws
          label: Amazon Web Services
        - value: azure
          label: Microsoft Azure
        - value: gcp
          label: Google Cloud Platform
      default: null
    validations:
      required: true

  - type: dropdown
    id: region
    attributes:
      label: Region
      options: []
    validations:
      required: true
    visibility:
      condition: "cloud_provider != null"
      depends_on: ["cloud_provider"]
    dynamic:
      options_map:
        aws:
          - value: us-east-1
            label: US East (N. Virginia)
          - value: us-west-2
            label: US West (Oregon)
        azure:
          - value: eastus
            label: East US
          - value: westus2
            label: West US 2
        gcp:
          - value: us-central1
            label: Iowa (us-central1)
      depends_on_field: "cloud_provider"

  - type: dropdown
    id: instance_type
    attributes:
      label: Instance Type
      options: []
    validations:
      required: true
    visibility:
      condition: "cloud_provider != null"
      depends_on: ["cloud_provider"]
    dynamic:
      options_map:
        aws:
          - value: t2.micro
            label: t2.micro (1 vCPU, 1GB RAM)
          - value: t2.small
            label: t2.small (1 vCPU, 2GB RAM)
        azure:
          - value: Standard_B1s
            label: Standard_B1s (1 vCPU, 1GB RAM)
        gcp:
          - value: e2-micro
            label: e2-micro (0.25-2 vCPU, 1GB RAM)
      depends_on_field: "cloud_provider"
```

### Example 2: Conditional Fields with Auto-Population

```yaml
body:
  - type: input
    id: project_name
    attributes:
      label: Project Name
      input_type: text
    validations:
      required: true
      pattern: "^[a-z0-9-]+$"

  - type: dropdown
    id: environment
    attributes:
      label: Environment
      options:
        - value: dev
          label: Development
        - value: staging
          label: Staging
        - value: prod
          label: Production
    validations:
      required: true

  - type: input
    id: resource_name
    attributes:
      label: Resource Name
      input_type: text
      placeholder: auto-generated
    dynamic:
      auto_populate: "{project_name}-{environment}-resource"
      computed: false  # User can still edit

  - type: checkboxes
    id: features
    attributes:
      label: Optional Features
      options:
        - value: monitoring
          label: Enable Monitoring
        - value: backup
          label: Enable Automated Backups
        - value: encryption
          label: Enable Encryption
    visibility:
      condition: "environment == 'prod'"
      depends_on: ["environment"]

  - type: input
    id: backup_retention
    attributes:
      label: Backup Retention (days)
      input_type: number
    validations:
      min: 1
      max: 365
    visibility:
      condition: "features.includes('backup')"
      depends_on: ["features"]
```

### Example 3: Complex Multi-Level Dependencies

```yaml
body:
  - type: dropdown
    id: cloud_provider
    attributes:
      label: Cloud Provider
      options:
        - value: aws
        - value: azure
        - value: gcp
    validations:
      required: true

  - type: dropdown
    id: service_type
    attributes:
      label: Service Type
      options: []
    visibility:
      condition: "cloud_provider != null"
      depends_on: ["cloud_provider"]
    dynamic:
      options_map:
        aws:
          - value: compute
            label: Compute (EC2)
          - value: database
            label: Database (RDS)
        azure:
          - value: compute
            label: Compute (VM)
          - value: database
            label: Database (SQL)
        gcp:
          - value: compute
            label: Compute Engine
          - value: database
            label: Cloud SQL
      depends_on_field: "cloud_provider"

  - type: dropdown
    id: instance_size
    attributes:
      label: Size/Tier
      options: []
    visibility:
      condition: "service_type != null"
      depends_on: ["cloud_provider", "service_type"]
    dynamic:
      options_map:
        aws:
          compute:
            - value: t2.micro
              label: t2.micro
            - value: t2.small
              label: t2.small
          database:
            - value: db.t2.micro
              label: db.t2.micro
            - value: db.t2.small
              label: db.t2.small
        azure:
          compute:
            - value: Standard_B1s
              label: Standard_B1s
          database:
            - value: Basic
              label: Basic
        gcp:
          compute:
            - value: e2-micro
              label: e2-micro
          database:
            - value: db-f1-micro
              label: db-f1-micro
      depends_on_fields: ["cloud_provider", "service_type"]
      lookup_path: "{cloud_provider}.{service_type}"

  - type: input
    id: estimated_cost
    attributes:
      label: Estimated Monthly Cost (USD)
      input_type: text
      readonly: true
    dynamic:
      auto_populate: "calculateCost({cloud_provider}, {service_type}, {instance_size})"
      computed: true
      depends_on: ["cloud_provider", "service_type", "instance_size"]
```

### Example 4: Using External Scripts for Options

```yaml
body:
  - type: dropdown
    id: github_repo
    attributes:
      label: GitHub Repository
      options: []
      options_loader:
        type: api
        source: "/api/github/repos"
    validations:
      required: true

  - type: dropdown
    id: branch
    attributes:
      label: Branch
      options: []
      options_loader:
        type: file
        source: "scripts/get_branches.py"
        language: python
        params:
          include_protected: true
        depends_on: ["github_repo"]
    visibility:
      condition: "github_repo != null"
      depends_on: ["github_repo"]
```

---

## Best Practices

1. **Use meaningful IDs**: Choose descriptive field IDs that clearly indicate their purpose
2. **Always set depends_on**: When using visibility or dynamic features, always specify `depends_on` to ensure proper field updates
3. **Provide descriptions**: Help users understand each field with clear descriptions
4. **Set appropriate defaults**: Use sensible default values where applicable
5. **Validate early**: Use built-in validations before resorting to custom validators
6. **Keep conditions simple**: Complex visibility conditions can be hard to debug; break them into multiple fields if needed
7. **Test cascading dependencies**: Ensure multi-level dependent fields work correctly in all scenarios
8. **Use computed fields sparingly**: Only mark fields as computed when users should never edit them manually
9. **Optimize API calls**: For options_loader with API type, consider caching strategies to avoid excessive API requests
10. **Document custom scripts**: When using external validators or option loaders, document their expected behavior

---

## Troubleshooting

### Field Not Showing
- Check the `visibility.condition` is correctly formatted
- Ensure all fields in `depends_on` exist and have values
- Verify the condition evaluates to true

### Options Not Loading
- Confirm `options_loader.source` path is correct
- Check `depends_on` fields have values before options load
- Verify API endpoints return the expected format: `[{value, label}]`

### Validation Not Working
- Ensure `pattern` uses properly escaped regex
- For custom validators, check the function signature matches expectations
- Verify `validator.source` path is correct for file-based validators

### Auto-Population Not Working
- Check template strings use correct field IDs: `{field_id}`
- Ensure `depends_on` includes all referenced fields
- Verify referenced fields have values before auto-population

---

## Additional Resources

- Review the included `form.yml` example for a comprehensive reference
- Check commented examples at the end of `form.yml` for advanced use cases
- Test your forms incrementally, adding complexity gradually
