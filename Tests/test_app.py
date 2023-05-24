"""
Tests if the app is running correctly
"""

import subprocess
import sys
import os
import pytest
PATH = str(subprocess.check_output(
        "cd", shell=True, universal_newlines=True)).rstrip()
option_list = ["rock", "paper", "scissors"]

sys.path.append(os.path.abspath(PATH))


@pytest.fixture
def test_title(client):
    response = client.get("/")
    assert b"<title>Rock Paper scissors!</title>" in response.data
