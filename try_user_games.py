#!/usr/bin/env python3
"""
ユーザーのゲーム一覧を取得するスクリプト
"""

import requests
import json

# APIキー
ROBLOX_API_KEY = "8cFFQLCJNUaK6KppccZgeDfSKtfVCFuV7NxdAYs6YobzNIfKZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lPR05HUmxGTVEwcE9WV0ZMTmt0d2NHTmpXbWRsUkdaVFMzUm1Wa05HZFZZM1RuaGtRVmx6TmxsdllucE9TV1pMSWl3aWIzZHVaWEpKWkNJNklqTTVOREl5Tmprek5UTWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTFOemMwTENKcFlYUWlPakUzTkRJMU5USXhOelFzSW01aVppSTZNVGMwTWpVMU1qRTNOSDAuZmtvZ0hTN1VuLTk3eGpudWpwa0tnQ0ZxV0pIVlV2MUhRWUF6QU1ib1RrZVhBaTR3LTljcU5HZS01UkJhdVJ4NUhKQWc2d2R2eE9QUm9NQ3poaWxlZm1NZk9HZUx1MFVzM1BqSC1wYS1aYl9xdS1kXzJHYjBLejkwRFJObkZlZ2Q1aU92cE1xc0cxcnVIQTR1YXQ0dU01dWlKMHRVN05sMVNzUUE3QTYxX0pfb19SNnFHd1BHUGxzMktHaElKRzdlQ2tGS1NVaG5NRDM5WkJFZkdDa0tPSDF1cGE4ckhFWlotRzRKc0t6M2VDdEhPbk03V0p5Q2Rwbk41OFJpcmx6eURPLUx6c0VXTXVCU0xPRWhlcnJUWkhqWkFsOFVvQnJxTU1KV0Y1V0VXY25uQ0RCa0ZmRk5LaWdkSXZqcjhxV2t0MGJxREUyNDZUdUYtaENPUzBlZ3JB"

# ユーザーID
USER_ID = "3942269353"  # APIキーから抽出したオーナーID

def try_roblox_api_endpoints():
    """様々なRoblox APIエンドポイントを試す"""
    endpoints = [
        # Roblox Web APIエンドポイント（APIキーなし）
        {"url": f"https://games.roblox.com/v2/users/{USER_ID}/games", "method": "GET", "auth": False},
        {"url": f"https://games.roblox.com/v1/games/list", "method": "GET", "auth": False},
        {"url": f"https://users.roblox.com/v1/users/{USER_ID}", "method": "GET", "auth": False},
        
        # Roblox Open Cloud APIエンドポイント（APIキーあり）
        {"url": f"https://apis.roblox.com/universes/v1/owners/{USER_ID}/universes", "method": "GET", "auth": True},
        {"url": f"https://apis.roblox.com/cloud/v1/games", "method": "GET", "auth": True},
        {"url": f"https://apis.roblox.com/cloud/v2/games", "method": "GET", "auth": True},
        {"url": f"https://apis.roblox.com/cloud/v1/users/{USER_ID}/games", "method": "GET", "auth": True},
        {"url": f"https://apis.roblox.com/cloud/v2/users/{USER_ID}/games", "method": "GET", "auth": True},
        
        # 追加のエンドポイント
        {"url": "https://apis.roblox.com/universes/v1", "method": "GET", "auth": True},
        {"url": "https://apis.roblox.com/cloud/v1/games/list", "method": "GET", "auth": True}
    ]
    
    for endpoint in endpoints:
        url = endpoint["url"]
        method = endpoint["method"]
        auth = endpoint["auth"]
        
        print(f"\n{method} {url} を試しています...")
        
        headers = {}
        if auth:
            headers["x-api-key"] = ROBLOX_API_KEY
        
        try:
            if method == "GET":
                response = requests.get(url, headers=headers)
            elif method == "POST":
                response = requests.post(url, headers=headers)
            
            print(f"ステータスコード: {response.status_code}")
            print(f"レスポンス: {response.text[:200]}..." if len(response.text) > 200 else f"レスポンス: {response.text}")
            
            # JSONレスポンスの場合、解析して表示
            if response.status_code == 200 and response.text.strip().startswith("{"):
                try:
                    json_data = response.json()
                    print(f"JSON解析結果: {json.dumps(json_data, indent=2, ensure_ascii=False)[:500]}...")
                except:
                    pass
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")

def try_roblox_web_api():
    """Roblox Web APIを使用してゲーム情報を取得"""
    print("\nRoblox Web APIを使用してゲーム情報を取得中...")
    
    # ユーザーのゲーム一覧を取得
    url = f"https://games.roblox.com/v2/users/{USER_ID}/games?limit=50"
    
    try:
        response = requests.get(url)
        print(f"ステータスコード: {response.status_code}")
        
        if response.status_code == 200:
            games = response.json()
            print(json.dumps(games, indent=2, ensure_ascii=False))
            
            # ゲーム情報を抽出
            if "data" in games and len(games["data"]) > 0:
                for game in games["data"]:
                    print(f"\nゲーム名: {game.get('name')}")
                    print(f"ゲームID: {game.get('id')}")
                    print(f"ユニバースID: {game.get('universeId')}")
                    print(f"プレイスID: {game.get('rootPlaceId')}")
                    print(f"作成日: {game.get('created')}")
                    print(f"更新日: {game.get('updated')}")
            else:
                print("ゲームが見つかりませんでした")
        else:
            print(f"エラーメッセージ: {response.text}")
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")

if __name__ == "__main__":
    print("Roblox APIを使用してユーザーのゲーム一覧を取得しています...")
    
    # 様々なRoblox APIエンドポイントを試す
    try_roblox_api_endpoints()
    
    # Roblox Web APIを使用してゲーム情報を取得
    try_roblox_web_api()
    
    print("\n完了")