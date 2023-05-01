"""
Tests if the app is running correctly
"""

import subprocess
import sys
import os
PATH = str(subprocess.check_output(
        "cd", shell=True, universal_newlines=True)).rstrip()

sys.path.append(os.path.abspath(PATH))

from App import app  # noqa: E402


class TestApp:
    def test_print_output(self):
        assert app() == "this is a placeholder", "output incorrect"
