import os
import git
from git import Repo

current_path = os.getcwd()
script_path = os.path.join(current_path)
remote_url = "git@github.com:shiri2001/training.git"
branch = "feature/issue004/add-sem-ver-python-script"  # noqa:E501 change later to main so it only runs on main
print(script_path)
repo = Repo(script_path)


def create_path():
    if os.path.exists(script_path):
        pass
    else:
        os.mkdir(script_path)


def clone():
    try:
        Repo.clone_from(remote_url, script_path)
    except git.exc.GitCommandError:
        pass


def main():
    repo.git.checkout(branch)
    git = repo.git
    tags = repo.tags
    latest_tag = str(tags[-1])
    bare_version = str(
        latest_tag.translate({ord(i): None for i in 'v-areposity'}))
    version_split = bare_version.split(".")
    major = int(version_split[0])
    minor = int(version_split[1])
    patch = int(version_split[2])
    last_commit = git.log("-n", "1", "--skip", "1", "--pretty=format:'%H'")
    last_commit_hash = str(
        last_commit.translate({ord(i): None for i in "'"}))
    current_commit = git.log("-n", "1", "--pretty=format:'%H'")
    current_commit_hash = str(
        current_commit.translate({ord(i): None for i in "'"}))
    print(f"{last_commit}, {current_commit}")
    change = git.diff(last_commit_hash, current_commit_hash, "--", "app/")
    commit_message = git.log("--format=%B", "-n", "1")
    print(commit_message)
    if change == "":
        print("app version unchanged")
    else:
        if "patch:" in commit_message:
            patch += 1
        elif "feat:" in commit_message:
            patch = 0
            minor += 1
        elif "BREAKING CHANGES:" in commit_message:
            patch = 0
            minor = 0
            major += 1
        else:
            pass
        new_tag = (f"v{major}.{minor}.{patch}-app")
        git.tag("-a", new_tag, "-m", f"new app version {new_tag}")


if __name__ == "__main__":
    create_path()
    clone()
    main()
