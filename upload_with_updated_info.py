#!/usr/bin/env python3
"""
更新された情報でRobloxプレイスファイルをアップロードするスクリプト
"""

import requests
import json
import os

# APIキー
ROBLOX_API_KEY = "8cFFQLCJNUaK6KppccZgeDfSKtfVCFuV7NxdAYs6YobzNIfKZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lPR05HUmxGTVEwcE9WV0ZMTmt0d2NHTmpXbWRsUkdaVFMzUm1Wa05HZFZZM1RuaGtRVmx6TmxsdllucE9TV1pMSWl3aWIzZHVaWEpKWkNJNklqTTVOREl5Tmprek5UTWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTFOemMwTENKcFlYUWlPakUzTkRJMU5USXhOelFzSW01aVppSTZNVGMwTWpVMU1qRTNOSDAuZmtvZ0hTN1VuLTk3eGpudWpwa0tnQ0ZxV0pIVlV2MUhRWUF6QU1ib1RrZVhBaTR3LTljcU5HZS01UkJhdVJ4NUhKQWc2d2R2eE9QUm9NQ3poaWxlZm1NZk9HZUx1MFVzM1BqSC1wYS1aYl9xdS1kXzJHYjBLejkwRFJObkZlZ2Q1aU92cE1xc0cxcnVIQTR1YXQ0dU01dWlKMHRVN05sMVNzUUE3QTYxX0pfb19SNnFHd1BHUGxzMktHaElKRzdlQ2tGS1NVaG5NRDM5WkJFZkdDa0tPSDF1cGE4ckhFWlotRzRKc0t6M2VDdEhPbk03V0p5Q2Rwbk41OFJpcmx6eURPLUx6c0VXTXVCU0xPRWhlcnJUWkhqWkFsOFVvQnJxTU1KV0Y1V0VXY25uQ0RCa0ZmRk5LaWdkSXZqcjhxV2t0MGJxREUyNDZUdUYtaENPUzBlZ3JB"

# 新しいユニバースIDとプレイスID
UNIVERSE_ID = "7410425472"  # 画面に表示されていたユニバースID
PLACE_ID = "7410425472"     # 同じIDを試す（通常、最初のプレイスIDはユニバースIDと同じ）

def upload_place():
    """プレイスをアップロード"""
    print(f"ユニバースID: {UNIVERSE_ID}, プレイスID: {PLACE_ID} でアップロードを試しています...")
    
    url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places/{PLACE_ID}/versions"
    
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

def try_get_universe_info():
    """ユニバース情報を取得"""
    print(f"\nユニバース {UNIVERSE_ID} の情報を取得中...")
    
    url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}"
    
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    try:
        response = requests.get(url, headers=headers)
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
        
        if response.status_code == 200:
            print("ユニバース情報の取得に成功しました！")
            return True
        else:
            print("ユニバース情報の取得に失敗しました")
            return False
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return False

def try_get_places():
    """ユニバース内のプレイス一覧を取得"""
    print(f"\nユニバース {UNIVERSE_ID} のプレイス一覧を取得中...")
    
    url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places"
    
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    try:
        response = requests.get(url, headers=headers)
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
        
        if response.status_code == 200:
            places = response.json()
            if places and len(places) > 0:
                # 最初のプレイスIDを取得
                first_place_id = places[0].get("id")
                print(f"最初のプレイスID: {first_place_id}")
                return first_place_id
            else:
                print("プレイスが見つかりませんでした")
                return None
        else:
            print("プレイス一覧の取得に失敗しました")
            return None
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return None

if __name__ == "__main__":
    print("Robloxプレイスファイルのアップロードを開始します...")
    
    # ファイルの存在確認
    if not os.path.exists("game.rbxlx"):
        print("エラー: game.rbxlxファイルが見つかりません")
        exit(1)
    
    # ユニバース情報を取得
    try_get_universe_info()
    
    # プレイス一覧を取得
    place_id = try_get_places()
    if place_id:
        # 取得したプレイスIDを使用
        PLACE_ID = place_id
    
    # プレイスをアップロード
    if upload_place():
        print("\nアップロードが完了しました！")
        print(f"ユニバースID: {UNIVERSE_ID}")
        print(f"プレイスID: {PLACE_ID}")
        exit(0)
    else:
        print("\nアップロードに失敗しました。")
        exit(1)