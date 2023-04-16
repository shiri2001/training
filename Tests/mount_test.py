import os
import boto3

ec2 = boto3.resource('ec2')
os.system('cmd /c "terraform output -raw volume_id > volume_id.txt"')
infile = open('volume_id.txt','r')
volume_id = infile.read()
infile.close()
if volume_id == "":
    print("No volume created")
else:
    volume = ec2.Volume(volume_id)
    volume_state = volume.state
    print("The state of volume {} is {}".format(volume_id,volume_state))