# Rego V1: The modern standard
import rego.v1

legacy_instance_prefixes := ["t2.", "m3.", "m4.", "c3.", "c4."]

deny contains msg if {
    # 1. Look for compute resources
    resource := input.resource_changes[_]
    
    # 2. Extract the instance type
    instance_type := get_instance_type(resource)
    
    # 3. Check if it matches our 'Legacy' list
    some prefix in legacy_instance_prefixes
    startswith(instance_type, prefix)
    
    # 4. Success! (Wait, 'deny' success means a policy violation)
    msg := sprintf("Governance Violation: Resource '%v' is using an old-generation instance type (%v). Modernize to Nitro-based instances (e.g., t3, m5) for better performance and cost.", [resource.address, instance_type])
}

# Handles EKS Node Groups (Uses 'instance_types' list)
get_instance_type(res) := val if {
    val := res.change.after.instance_types[_]
}

# Handles standard EC2 Instances (Uses 'instance_type' string)
get_instance_type(res) := val if {
    val := res.change.after.instance_type
}
