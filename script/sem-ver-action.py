#  imports
import os
import git
from git import Repo
import logging

#  variables
script_path = os.getcwd()
remote_url = "git@github.com:shiri2001/training.git"
branch = "main"  # noqa:E501 change later to main so it only runs on main


#  clone repository from github if needed
def clone():
    logging.info("trying to clone repository...")
    try:
        Repo.clone_from(remote_url, script_path)
        logging.info("repository cloned!")
    except git.exc.GitCommandError:
        logging.error("repository already cloned")


def login():
    # logging bot into github using desired branch
    logging.info("connecting to repository...")
    repo = Repo(script_path)
    repo.git.checkout(branch)
    git = repo.git
    git.config("user.email", "<>")
    git.config("user.name", "action_bot")


def divide_tag():
    # divide latest tag to major minor and patch
    logging.info("fetching tags...")
    repo = Repo(script_path)
    tags = repo.tags
    latest_tag = str(tags[-1])
    bare_version = str(
        latest_tag.translate({ord(i): None for i in 'v-areposity'}))
    version_split = bare_version.split(".")
    major = int(version_split[0])
    minor = int(version_split[1])
    patch = int(version_split[2])
    return major, minor, patch


def compare_commits():
    # compare the current and previous commits
    # find out whether a change was made
    logging.info("comparing commits...")
    repo = Repo(script_path)
    git = repo.git
    last_commit = git.log("-n", "1", "--skip", "1", "--pretty=format:'%H'")
    last_commit_hash = str(
        last_commit.translate({ord(i): None for i in "'"}))
    current_commit = git.log("-n", "1", "--pretty=format:'%H'")
    current_commit_hash = str(
        current_commit.translate({ord(i): None for i in "'"}))
    change = git.diff(last_commit_hash, current_commit_hash, "--", "app/")
    return change


def update_ver():
    # check commit message for relevant keywords
    # and add 1 to major/minor/patch if needed
    logging.info("creating a new version...")
    repo = Repo(script_path)
    git = repo.git
    commit_message = git.log("--format=%B", "-n", "1")
    change = compare_commits()
    major, minor, patch = divide_tag()
    if change == "":
        pass
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
    return major, minor, patch


def create_tag():
    # create new tag
    repo = Repo(script_path)
    git = repo.git
    logging.info("creating a tag for the new version...")
    major, minor, patch = update_ver()
    new_tag = (f"v{major}.{minor}.{patch}-app")
    git.tag("-a", new_tag, "-m", f"new app version {new_tag}")
    print(new_tag)


def main():
    # logger config
    logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s')
    # start action
    logging.info("executing semantic versioning action!")
    clone()
    login()
    divide_tag()
    compare_commits()
    update_ver()
    try:
        create_tag()
    except git.exc.GitCommandError:
        logging.error("No changes found from last ver")
    logging.info("action complete!")


if __name__ == "__main__":
    main()
