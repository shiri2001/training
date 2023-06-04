from flask import Flask, render_template
import random

app = Flask(__name__)
option_list = ["rock", "paper", "scissors"]
print("test")


@app.route("/")
@app.route("/home", methods=["POST"])
def index():
    return render_template('home.html', result="none")


@app.route("/rock")
def rock():
    computer_choice = random.choice(option_list)
    if computer_choice == "rock":
        return render_template("rock.html", cpu_choice=computer_choice,
                               result="It's a draw!")
    elif computer_choice == "paper":
        return render_template("rock.html", cpu_choice=computer_choice,
                               result="You lost!")
    else:
        return render_template("rock.html", cpu_choice=computer_choice,
                               result="You won!")


@app.route("/paper")
def paper():
    computer_choice = random.choice(option_list)
    if computer_choice == "paper":
        return render_template("paper.html", cpu_choice=computer_choice,
                               result="It's a draw!")
    elif computer_choice == "scissors":
        return render_template("paper.html", cpu_choice=computer_choice,
                               result="You lost!")
    else:
        return render_template("paper.html", cpu_choice=computer_choice,
                               result="You won!")


@app.route("/scissors")
def scissors():
    computer_choice = random.choice(option_list)
    if computer_choice == "scissors":
        return render_template("scissors.html", cpu_choice=computer_choice,
                               result="It's a draw!")
    elif computer_choice == "rock":
        return render_template("scissors.html", cpu_choice=computer_choice,
                               result="You lost!")
    else:
        return render_template("scissors.html", cpu_choice=computer_choice,
                               result="You won!")


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080, debug=True)
