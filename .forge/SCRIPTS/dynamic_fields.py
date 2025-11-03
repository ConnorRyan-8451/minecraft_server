"""
Dynamic field handlers for form options
These functions provide dynamic options based on form selections
"""

def get_cloud_providers():
    """Return available cloud providers"""
    return [
        {"value": "aws", "label": "Amazon Web Services (AWS)"},
        {"value": "azure", "label": "Microsoft Azure"},
        {"value": "gcp", "label": "Google Cloud Platform (GCP)"},
        {"value": "on-premise", "label": "On-Premise"}
    ]

def get_services_for_provider(cloud_provider=None):
    """Return available services based on cloud provider"""
    
    # Define services by provider
    services = {
        "aws": [
            {"value": "database", "label": "Database (RDS/DynamoDB)"},
            {"value": "compute", "label": "Compute (EC2)"},
            {"value": "storage", "label": "Storage (S3)"},
            {"value": "serverless", "label": "Serverless (Lambda)"}
        ],
        "azure": [
            {"value": "database", "label": "Database (SQL/Cosmos)"},
            {"value": "compute", "label": "Compute (Virtual Machines)"},
            {"value": "storage", "label": "Storage (Blob)"},
            {"value": "serverless", "label": "Serverless (Functions)"}
        ],
        "gcp": [
            {"value": "database", "label": "Database (Cloud SQL/Firestore)"},
            {"value": "compute", "label": "Compute (Compute Engine)"},
            {"value": "storage", "label": "Storage (Cloud Storage)"},
            {"value": "serverless", "label": "Serverless (Cloud Functions)"}
        ],
        "on-premise": [
            {"value": "database", "label": "Database Server"},
            {"value": "compute", "label": "Virtual Machine"},
            {"value": "storage", "label": "Storage Array"}
        ]
    }
    
    return services.get(cloud_provider, [])

def get_environments(service_type=None):
    """Return available environments based on service type"""
    
    # Different environments available for different services
    if service_type == "database":
        return [
            {"value": "development", "label": "Development"},
            {"value": "staging", "label": "Staging"},
            {"value": "production", "label": "Production"},
            {"value": "sandbox", "label": "Sandbox"}
        ]
    elif service_type in ["compute", "storage"]:
        return [
            {"value": "development", "label": "Development"},
            {"value": "staging", "label": "Staging"},
            {"value": "production", "label": "Production"}
        ]
    elif service_type == "serverless":
        return [
            {"value": "development", "label": "Development"},
            {"value": "production", "label": "Production"}
        ]
    
    # Default environments
    return [
        {"value": "development", "label": "Development"},
        {"value": "production", "label": "Production"}
    ]

def get_resource_sizes(service_type=None, environment=None):
    """Return resource sizes based on service type and environment"""
    
    if service_type == "database":
        if environment == "production":
            return [
                {"value": "db.t3.medium", "label": "Medium (2 vCPU, 4GB RAM)"},
                {"value": "db.t3.large", "label": "Large (2 vCPU, 8GB RAM)"},
                {"value": "db.r5.xlarge", "label": "Extra Large (4 vCPU, 32GB RAM)"},
                {"value": "db.r5.2xlarge", "label": "2X Large (8 vCPU, 64GB RAM)"}
            ]
        else:
            return [
                {"value": "db.t3.micro", "label": "Micro (1 vCPU, 1GB RAM)"},
                {"value": "db.t3.small", "label": "Small (1 vCPU, 2GB RAM)"},
                {"value": "db.t3.medium", "label": "Medium (2 vCPU, 4GB RAM)"}
            ]
    
    elif service_type == "compute":
        if environment == "production":
            return [
                {"value": "m5.large", "label": "Large (2 vCPU, 8GB RAM)"},
                {"value": "m5.xlarge", "label": "Extra Large (4 vCPU, 16GB RAM)"},
                {"value": "m5.2xlarge", "label": "2X Large (8 vCPU, 32GB RAM)"},
                {"value": "c5.2xlarge", "label": "Compute Optimized (8 vCPU, 16GB RAM)"}
            ]
        else:
            return [
                {"value": "t3.micro", "label": "Micro (1 vCPU, 1GB RAM)"},
                {"value": "t3.small", "label": "Small (1 vCPU, 2GB RAM)"},
                {"value": "t3.medium", "label": "Medium (2 vCPU, 4GB RAM)"}
            ]
    
    elif service_type == "storage":
        return [
            {"value": "standard", "label": "Standard (Good for backups)"},
            {"value": "standard-ia", "label": "Standard-IA (Infrequent access)"},
            {"value": "glacier", "label": "Glacier (Archive storage)"},
            {"value": "express", "label": "Express (High performance)"}
        ]
    
    # Default sizes
    return [
        {"value": "small", "label": "Small"},
        {"value": "medium", "label": "Medium"},
        {"value": "large", "label": "Large"}
    ]

def get_compute_features(service_type=None):
    """Return compute-specific features"""
    if service_type == "compute":
        return [
            {"value": "auto_scaling", "label": "Auto Scaling"},
            {"value": "load_balancer", "label": "Load Balancer"},
            {"value": "monitoring", "label": "Enhanced Monitoring"},
            {"value": "backup", "label": "Automated Backups"},
            {"value": "security_groups", "label": "Custom Security Groups"}
        ]
    return []

def get_storage_types(service_type=None, cloud_provider=None):
    """Return storage types based on service and provider"""
    
    if service_type == "storage":
        if cloud_provider == "aws":
            return [
                {"value": "s3_standard", "label": "S3 Standard"},
                {"value": "s3_ia", "label": "S3 Infrequent Access"},
                {"value": "s3_glacier", "label": "S3 Glacier"},
                {"value": "ebs_gp3", "label": "EBS GP3 (Block Storage)"}
            ]
        elif cloud_provider == "azure":
            return [
                {"value": "blob_hot", "label": "Blob Storage (Hot)"},
                {"value": "blob_cool", "label": "Blob Storage (Cool)"},
                {"value": "blob_archive", "label": "Blob Storage (Archive)"},
                {"value": "managed_disk", "label": "Managed Disk"}
            ]
        elif cloud_provider == "gcp":
            return [
                {"value": "standard", "label": "Standard Storage"},
                {"value": "nearline", "label": "Nearline Storage"},
                {"value": "coldline", "label": "Coldline Storage"},
                {"value": "archive", "label": "Archive Storage"}
            ]
    
    return [
        {"value": "block", "label": "Block Storage"},
        {"value": "object", "label": "Object Storage"},
        {"value": "file", "label": "File Storage"}
    ]

# Registry of all dynamic field functions
FIELD_FUNCTIONS = {
    "get_cloud_providers": get_cloud_providers,
    "get_services_for_provider": get_services_for_provider,
    "get_environments": get_environments,
    "get_resource_sizes": get_resource_sizes,
    "get_compute_features": get_compute_features,
    "get_storage_types": get_storage_types
}

def get_dynamic_options(function_name, **kwargs):
    """
    Get dynamic options for a field
    
    Args:
        function_name: Name of the function to call
        **kwargs: Parameters to pass to the function
    
    Returns:
        List of option dictionaries with 'value' and 'label' keys
    """
    if function_name in FIELD_FUNCTIONS:
        try:
            return FIELD_FUNCTIONS[function_name](**kwargs)
        except Exception as e:
            print(f"Error getting dynamic options for {function_name}: {e}")
            return []
    else:
        print(f"Unknown function: {function_name}")
        return []

# Test function
if __name__ == "__main__":
    print("Testing dynamic field functions...")
    
    # Test cloud providers
    providers = get_dynamic_options("get_cloud_providers")
    print("Cloud Providers:", providers)
    
    # Test services for AWS
    services = get_dynamic_options("get_services_for_provider", cloud_provider="aws")
    print("AWS Services:", services)
    
    # Test environments for database
    environments = get_dynamic_options("get_environments", service_type="database")
    print("Database Environments:", environments)
    
    # Test resource sizes for production database
    sizes = get_dynamic_options("get_resource_sizes", service_type="database", environment="production")
    print("Production DB Sizes:", sizes)
