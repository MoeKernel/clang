import json
import os
import requests
from update import (
    get_body,
    get_tag_release
)

owner = 'moekernel'
repo = 'clang'
tag_name = get_tag_release()
target_commitish = 'main'
name = get_tag_release()
body = get_body()
draft = False
prerelease = False

token = os.getenv('TOKEN_GITHUB', '')

def draft_release():
    url = f'https://api.github.com/repos/{owner}/{repo}/releases'

    headers = {
        'Authorization': f'token {token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    data = {
        'tag_name': tag_name,
        'target_commitish': target_commitish,
        'name': name,
        'body': body,
        'draft': draft,
        'prerelease': prerelease
    }

    response = requests.post(
        url,
        headers=headers,
        data=json.dumps(data)
    )

    if response.status_code == 201:
        print('New release created successfully!')
    else:
        print(
            'Error creating release:',
            response.status_code, 
            response.text
        )

draft_release()
