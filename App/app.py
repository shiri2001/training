from flask import Flask, request
import random

image_path = ".\\Images"
app = Flask(__name__)
option_list = ["ROCK", "PAPER", "SCISSORS"]
player_win = 0
computer_win = 0


@app.route("/")
def index():
    answer = request.args.get("answer", "")
    return (
        """<h1>Rock Paper scissors! please make your choice</h1>
                <form action="" method="get">
                    <input type="text" name="answer">
                    <input type="submit" value="submit">
                </form>"""
        + game(answer)
    )


@app.route("/<int:answer>")
def game(answer):
    computer_choice = random.choice(option_list)
    if answer.upper() == computer_choice:
        return f"Computer chose {computer_choice}! It's a draw!"
    elif answer.upper() == "rock".upper():
        if computer_choice == "PAPER":
            return f"Computer chose {computer_choice}! too bad! you lost!"
        else:
            return f"Computer chose {computer_choice}! You won!"
    elif answer.upper() == "paper".upper():
        if computer_choice == "SCISSORS":
            return f"Computer chose {computer_choice}! too bad! you lost!"
        else:
            return f"Computer chose {computer_choice}! You won!"
    elif answer.upper() == "scissors".upper():
        if computer_choice == "SCISSORS":
            return f"Computer chose {computer_choice}! too bad! you lost!"
        else:
            return f"Computer chose {computer_choice}! You won!"
    else:
        return "type a valid input"


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080, debug=True)
