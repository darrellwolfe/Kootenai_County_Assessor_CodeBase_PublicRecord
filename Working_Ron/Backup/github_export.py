import requests
import time
import os
import argparse
from datetime import datetime

def get_github_token():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        raise ValueError("GITHUB_TOKEN environment variable is not set. Please set it with your GitHub Personal Access Token.")
    return token

def start_export(api_base, headers, owner, repo):
    export_url = f'{api_base}/repos/{owner}/{repo}/migrations'
    data = {'lock_repositories': False}
    response = requests.post(export_url, json=data, headers=headers)
    if response.status_code == 202:
        return response.json()['id']
    else:
        raise Exception(f"Failed to start export: {response.text}")

def check_export_status(api_base, headers, owner, repo, export_id):
    status_url = f'{api_base}/repos/{owner}/{repo}/migrations/{export_id}'
    while True:
        response = requests.get(status_url, headers=headers)
        if response.status_code == 200:
            status = response.json()['state']
            if status == 'exported':
                return response.json()['archive_url']
            elif status in ['failed', 'deleted']:
                raise Exception(f"Export failed or was deleted. Status: {status}")
        time.sleep(60)  # Wait for 60 seconds before checking again

def download_export(archive_url, headers, repo):
    response = requests.get(archive_url, headers=headers, stream=True)
    if response.status_code == 200:
        filename = f"{repo}_export_{datetime.now().strftime('%Y%m%d_%H%M%S')}.tar.gz"
        with open(filename, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        return filename
    else:
        raise Exception(f"Failed to download export: {response.text}")

def main():
    parser = argparse.ArgumentParser(description='Export a GitHub repository.')
    parser.add_argument('owner', help='The GitHub username or organization name')
    parser.add_argument('repo', help='The name of the repository to export')
    args = parser.parse_args()

    try:
        github_token = get_github_token()
        api_base = 'https://api.github.com'
        headers = {
            'Authorization': f'token {github_token}',
            'Accept': 'application/vnd.github.v3+json'
        }

        print(f"Starting export for {args.owner}/{args.repo}...")
        export_id = start_export(api_base, headers, args.owner, args.repo)
        print(f"Export started. ID: {export_id}")
        
        print("Waiting for export to complete...")
        archive_url = check_export_status(api_base, headers, args.owner, args.repo, export_id)
        print("Export completed. Downloading...")
        
        filename = download_export(archive_url, headers, args.repo)
        print(f"Export downloaded: {filename}")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == "__main__":
    main()

