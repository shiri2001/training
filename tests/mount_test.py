import os
import boto3
import subprocess

ec2 = boto3.resource('ec2')
os.system(
    'cmd /c "cd .. & cd Infrastructure & \
        terraform output -raw app_volume_id > app_volume_id.txt"')
PATH = str(subprocess.check_output(
        "cd", shell=True, universal_newlines=True)).rstrip()

vol_path = "{}//app_volume_id.txt".format(PATH)
vol_path = vol_path.replace("\\", "//")


def test_mount():
    if os.path.isfile(vol_path) is True:
        infile = open('app_volume_id.txt', 'r')
        app_volume_id = infile.read()
        infile.close()
        volume = ec2.Volume(app_volume_id)
        volume_state = volume.state
        print("The state of volume {} is {}".format(
            app_volume_id, volume_state))
    else:
        print("volume creation failed")


test_mount()
