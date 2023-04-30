"""
Tests if the app is running correctly
"""

import subprocess
import sys
PATH = str(subprocess.check_output(
        "cd", shell=True, universal_newlines=True)).rstrip() + "\\App"

sys.path.append(PATH)

from app import app  # noqa: E402


class TestApp:
    def print_output(self):
        assert app() == "this is a placeholder", "output incorrect"
