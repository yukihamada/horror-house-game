#!/usr/bin/env python3
"""
新しいAPIキーを使用してRobloxプレイスファイルをアップロードするスクリプト
"""

import requests
import json
import os

# 新しいAPIキー
ROBLOX_API_KEY = "8cFFQLCJNUaK6KppccZgeDfSKtfVCFuV7NxdAYs6YobzNIfKZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lPR05HUmxGTVEwcE9WV0ZMTmt0d2NHTmpXbWRsUkdaVFMzUm1Wa05HZFZZM1RuaGtRVmx6TmxsdllucE9TV1pMSWl3aWIzZHVaWEpKWkNJNklqTTVOREl5Tmprek5UTWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTFOemMwTENKcFlYUWlPakUzTkRJMU5USXhOelFzSW01aVppSTZNVGMwTWpVMU1qRTNOSDAuZmtvZ0hTN1VuLTk3eGpudWpwa0tnQ0ZxV0pIVlV2MUhRWUF6QU1ib1RrZVhBaTR3LTljcU5HZS01UkJhdVJ4NUhKQWc2d2R2eE9QUm9NQ3poaWxlZm1NZk9HZUx1MFVzM1BqSC1wYS1aYl9xdS1kXzJHYjBLejkwRFJObkZlZ2Q1aU92cE1xc0cxcnVIQTR1YXQ0dU01dWlKMHRVN05sMVNzUUE3QTYxX0pfb19SNnFHd1BHUGxzMktHaElKRzdlQ2tGS1NVaG5NRDM5WkJFZkdDa0tPSDF1cGE4ckhFWlotRzRKc0t6M2VDdEhPbk03V0p5Q2Rwbk41OFJpcmx6eURPLUx6c0VXTXVCU0xPRWhlcnJUWkhqWkFsOFVvQnJxTU1KV0Y1V0VXY25uQ0RCa0ZmRk5LaWdkSXZqcjhxV2t0MGJxREUyNDZUdUYtaENPUzBlZ3JB"

def check_api_key():
    """APIキーの情報を取得"""
    print("APIキーの情報を確認中...")
    
    # APIキーのメタデータを取得
    url = "https://apis.roblox.com/cloud/v1/api-keys/metadata"
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    try:
        response = requests.get(url, headers=headers)
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
        
        if response.status_code == 200:
            print("APIキーは有効です")
            return True
        else:
            print("APIキーが無効か、権限が不足しています")
            return False
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return False

def get_user_games():
    """ユーザーのゲーム一覧を取得"""
    print("\nユーザーのゲーム一覧を取得中...")
    
    url = "https://apis.roblox.com/cloud/v2/games"
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    try:
        response = requests.get(url, headers=headers)
        print(f"ステータスコード: {response.status_code}")
        
        if response.status_code == 200:
            games = response.json()
            print(json.dumps(games, indent=2))
            
            # 最初のゲームのIDを取得
            if games and len(games) > 0:
                universe_id = games[0].get("id")
                print(f"\n最初のゲーム（ユニバース）ID: {universe_id}")
                return universe_id
        else:
            print(f"エラーメッセージ: {response.text}")
        
        return None
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return None

def get_universe_places(universe_id):
    """ユニバース内のプレイス一覧を取得"""
    if not universe_id:
        print("ユニバースIDが指定されていません")
        return None
    
    print(f"\nユニバース {universe_id} のプレイス一覧を取得中...")
    
    url = f"https://apis.roblox.com/universes/v1/{universe_id}/places"
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    try:
        response = requests.get(url, headers=headers)
        print(f"ステータスコード: {response.status_code}")
        
        if response.status_code == 200:
            places = response.json()
            print(json.dumps(places, indent=2))
            
            # 最初のプレイスのIDを取得
            if places and len(places) > 0:
                place_id = places[0].get("id")
                print(f"\n最初のプレイスID: {place_id}")
                return place_id
        else:
            print(f"エラーメッセージ: {response.text}")
        
        return None
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return None

def upload_place(universe_id, place_id):
    """プレイスをアップロード"""
    if not universe_id or not place_id:
        print("ユニバースIDまたはプレイスIDが指定されていません")
        return False
    
    print(f"\nユニバースID: {universe_id}, プレイスID: {place_id} でアップロードを試しています...")
    
    url = f"https://apis.roblox.com/universes/v1/{universe_id}/places/{place_id}/versions"
    
    headers = {
        "x-api-key": ROBLOX_API_KEY,
        "Content-Type": "application/octet-stream"
    }
    
    params = {
        "versionType": "Published"
    }
    
    try:
        with open("game.rbxlx", "rb") as file:
            file_data = file.read()
        
        response = requests.post(url, headers=headers, params=params, data=file_data)
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
        
        if response.status_code == 200:
            print("アップロードに成功しました！")
            return True
        else:
            print("アップロードに失敗しました")
            return False
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return False

if __name__ == "__main__":
    print("Robloxプレイスファイルのアップロードを開始します...")
    
    # ファイルの存在確認
    if not os.path.exists("game.rbxlx"):
        print("エラー: game.rbxlxファイルが見つかりません")
        exit(1)
    
    # APIキーの確認
    if not check_api_key():
        print("APIキーの確認に失敗しました")
        exit(1)
    
    # ユーザーのゲーム一覧を取得
    universe_id = get_user_games()
    
    if universe_id:
        # ユニバース内のプレイス一覧を取得
        place_id = get_universe_places(universe_id)
        
        if place_id:
            # プレイスをアップロード
            if upload_place(universe_id, place_id):
                print("\nアップロードが完了しました！")
                exit(0)
    
    print("\nアップロードに失敗しました。")