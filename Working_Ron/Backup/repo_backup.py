import os
import requests
import subprocess
import schedule
import time
from datetime import datetime

def get_github_token():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        raise ValueError("GITHUB_TOKEN environment variable is not set. Please set it with your GitHub Personal Access Token.")
    return token

def backup_repository(owner, repo, backup_dir):
    github_token = get_github_token()
    api_url = f"https://api.github.com/repos/{owner}/{repo}"
    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json"
    }

    # Get repository information
    response = requests.get(api_url, headers=headers)
    if response.status_code != 200:
        print(f"Failed to get repository information: {response.text}")
        return

    repo_data = response.json()
    clone_url = repo_data['clone_url']

    # Create backup directory if it doesn't exist
    os.makedirs(backup_dir, exist_ok=True)

    # Generate backup filename with timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_name = f"{repo}_{timestamp}"
    backup_path = os.path.join(backup_dir, backup_name)

    # Clone the repository
    clone_command = f"git clone --mirror {clone_url} {backup_path}"
    result = subprocess.run(clone_command, shell=True, capture_output=True, text=True)

    if result.returncode == 0:
        print(f"Repository {owner}/{repo} backed up successfully to {backup_path}")
    else:
        print(f"Failed to backup repository: {result.stderr}")

def schedule_backup(owner, repo, backup_dir, interval_hours):
    schedule.every(interval_hours).hours.do(backup_repository, owner, repo, backup_dir)

    while True:
        schedule.run_pending()
        time.sleep(60)  # Check every minute

if __name__ == "__main__":
    # Replace these with your GitHub username/organization and repository name
    OWNER = "your_github_username"
    REPO = "your_repository_name"
    BACKUP_DIR = "path/to/backup/directory"
    INTERVAL_HOURS = 24  # Backup every 24 hours

    schedule_backup(OWNER, REPO, BACKUP_DIR, INTERVAL_HOURS)