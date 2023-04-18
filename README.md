# Create Infrastructure

This project creates a basic infrastructure using AWS, consisting an app server with a volume attached to it, accessible only through a bastion server. 

## Usage

Run tf-apply.yml file in the .github/workflows directory to apply the infrastructure. 

## Testing

Run mount_test.py in the Tests directory to test whether the volume attached to the app server has properly mounted.