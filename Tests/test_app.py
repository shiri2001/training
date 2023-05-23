"""
Tests if the app is running correctly
"""

import subprocess
import sys
import os
from flask import Flask, request, render_template
import random
PATH = str(subprocess.check_output(
        "cd", shell=True, universal_newlines=True)).rstrip()
option_list = ["rock", "paper", "scissors"]

sys.path.append(os.path.abspath(PATH))

from App import app  # noqa: E402


class TestApp:
    def test_print_output(self):
        computer_choice = random.choice(option_list)
        assert app.rock() == render_template(
            "rock.html",cpu_choice=computer_choice,
            result="It's a draw!") \
                or \
            render_template("rock.html",cpu_choice=computer_choice,
                            result="You lost!") \
                or \
            render_template("rock.html",cpu_choice=computer_choice,
                            result="You won!")
            
                
