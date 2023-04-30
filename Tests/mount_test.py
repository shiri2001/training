import os
import boto3

ec2 = boto3.resource('ec2')
os.system(
    'cmd /c "cd .. & cd Infrastructure & \
        terraform output -raw app_volume_id > app_volume_id.txt"')
infile = open('app_volume_id.txt', 'r')
app_volume_id = infile.read()
infile.close()
if app_volume_id == "":
    print("No volume created")
else:
    volume = ec2.Volume(app_volume_id)
    volume_state = volume.state
    print("The state of volume {} is {}".format(app_volume_id, volume_state))
