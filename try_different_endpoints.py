#!/usr/bin/env python3
"""
異なるエンドポイントを試すスクリプト
"""

import requests
import json

# APIキー
ROBLOX_API_KEY = "8cFFQLCJNUaK6KppccZgeDfSKtfVCFuV7NxdAYs6YobzNIfKZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lPR05HUmxGTVEwcE9WV0ZMTmt0d2NHTmpXbWRsUkdaVFMzUm1Wa05HZFZZM1RuaGtRVmx6TmxsdllucE9TV1pMSWl3aWIzZHVaWEpKWkNJNklqTTVOREl5Tmprek5UTWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTFOemMwTENKcFlYUWlPakUzTkRJMU5USXhOelFzSW01aVppSTZNVGMwTWpVMU1qRTNOSDAuZmtvZ0hTN1VuLTk3eGpudWpwa0tnQ0ZxV0pIVlV2MUhRWUF6QU1ib1RrZVhBaTR3LTljcU5HZS01UkJhdVJ4NUhKQWc2d2R2eE9QUm9NQ3poaWxlZm1NZk9HZUx1MFVzM1BqSC1wYS1aYl9xdS1kXzJHYjBLejkwRFJObkZlZ2Q1aU92cE1xc0cxcnVIQTR1YXQ0dU01dWlKMHRVN05sMVNzUUE3QTYxX0pfb19SNnFHd1BHUGxzMktHaElKRzdlQ2tGS1NVaG5NRDM5WkJFZkdDa0tPSDF1cGE4ckhFWlotRzRKc0t6M2VDdEhPbk03V0p5Q2Rwbk41OFJpcmx6eURPLUx6c0VXTXVCU0xPRWhlcnJUWkhqWkFsOFVvQnJxTU1KV0Y1V0VXY25uQ0RCa0ZmRk5LaWdkSXZqcjhxV2t0MGJxREUyNDZUdUYtaENPUzBlZ3JB"

# 試すユニバースIDとプレイスID
UNIVERSE_ID = "3942269353"  # APIキーから抽出したオーナーID
PLACE_ID = "3942269353"     # 同じIDを試す

def try_all_endpoints():
    """様々なエンドポイントを試す"""
    endpoints = [
        # APIキー情報
        {"url": "https://apis.roblox.com/cloud/v1/api-keys/metadata", "method": "GET"},
        
        # ユーザー情報
        {"url": "https://apis.roblox.com/cloud/v1/users/me", "method": "GET"},
        {"url": "https://apis.roblox.com/cloud/v2/users/me", "method": "GET"},
        
        # ゲーム一覧
        {"url": "https://apis.roblox.com/cloud/v1/games", "method": "GET"},
        {"url": "https://apis.roblox.com/cloud/v2/games", "method": "GET"},
        
        # ユニバース情報
        {"url": f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}", "method": "GET"},
        {"url": f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places", "method": "GET"},
        
        # プレイス情報
        {"url": f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places/{PLACE_ID}", "method": "GET"},
        
        # 他のエンドポイント
        {"url": "https://apis.roblox.com/assets/v1", "method": "GET"},
        {"url": "https://apis.roblox.com/cloud/v1/places", "method": "GET"},
        {"url": "https://apis.roblox.com/", "method": "GET"}
    ]
    
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    for endpoint in endpoints:
        url = endpoint["url"]
        method = endpoint["method"]
        
        print(f"\n{method} {url} を試しています...")
        
        try:
            if method == "GET":
                response = requests.get(url, headers=headers)
            elif method == "POST":
                response = requests.post(url, headers=headers)
            
            print(f"ステータスコード: {response.status_code}")
            print(f"レスポンス: {response.text[:200]}..." if len(response.text) > 200 else f"レスポンス: {response.text}")
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")

def try_with_owner_id():
    """オーナーIDを使用して試す"""
    print("\nオーナーIDを使用して試しています...")
    
    # APIキーから抽出したオーナーID
    owner_id = "3942269353"
    
    urls = [
        f"https://apis.roblox.com/cloud/v1/users/{owner_id}/games",
        f"https://apis.roblox.com/cloud/v2/users/{owner_id}/games",
        f"https://apis.roblox.com/users/v1/{owner_id}",
        f"https://apis.roblox.com/users/v1/{owner_id}/games"
    ]
    
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    for url in urls:
        print(f"\nGET {url} を試しています...")
        
        try:
            response = requests.get(url, headers=headers)
            print(f"ステータスコード: {response.status_code}")
            print(f"レスポンス: {response.text[:200]}..." if len(response.text) > 200 else f"レスポンス: {response.text}")
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")

if __name__ == "__main__":
    print("様々なRoblox APIエンドポイントを試しています...")
    
    # 様々なエンドポイントを試す
    try_all_endpoints()
    
    # オーナーIDを使用して試す
    try_with_owner_id()
    
    print("\n完了")