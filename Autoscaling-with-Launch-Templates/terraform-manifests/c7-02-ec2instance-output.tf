## ec2_bastion_public_instance_ids
output "ec2_bastion_public_instance_ids" {
  description = "EC2 instance ID"
  value       = module.ec2_public.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "Public IP address EC2 instance"
  value       = module.ec2_public.public_ip 
}

# Private EC2 Instances
## ec2_private_instance_ids
# output "ec2_private_instance_ids" {
#   description = "List of IDs of instances"
#   value = [for ec2private in module.ec2_private: ec2private.id ]   
# }

# ## ec2_private_ip
# output "ec2_private_ip" {
#   description = "List of private IP addresses assigned to the instances"
#   value = [for ec2private in module.ec2_private: ec2private.private_ip ]  
# }

## ec2_private_instance_ids
output "ec2_private_app1_instance_ids" {
  description = "List of IDs of instances"
  value = [for ec2private in module.ec2_private_app1: ec2private.id ]   
}

## ec2_private_ip
output "ec2_private_app1_ip" {
  description = "List of private IP addresses assigned to the instances"
  value = [for ec2private in module.ec2_private_app1: ec2private.private_ip ]  
}

output "ec2_private_app2_instance_ids" {
  description = "List of IDs of instances"
  value = [for ec2private in module.ec2_private_app2: ec2private.id ]   
}

## ec2_private_ip
output "ec2_private_app2_ip" {
  description = "List of private IP addresses assigned to the instances"
  value = [for ec2private in module.ec2_private_app2: ec2private.private_ip ]  
}