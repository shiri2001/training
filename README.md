# Create Infrastructure

This project creates a basic infrastructure using AWS, consisting an app server with a volume attached to it, accessible only through a bastion server. 
The project contains a simple rock/paper/scissors app.

## Usage

Run tf-apply.yml file in the .github/workflows directory to apply the infrastructure.
run CI.yml file in the .github/workflows directory to build and test the app.

## Testing

mount_test.py: dedicated to test whether the volume attached to the app server has properly mounted.
test_app.py: dedicated to test proper functionality of the app.
