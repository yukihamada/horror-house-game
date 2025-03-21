#!/usr/bin/env python3
import requests
import json

# APIキー
ROBLOX_API_KEY = "AnO4LVMMNkm3IrGR20lxgiyS8+yrAgmCZN3uM6MNZQpZpB/iZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lRVzVQTkV4V1RVMU9hMjB6U1hKSFVqSXdiSGhuYVhsVE9DdDVja0ZuYlVOYVRqTjFUVFpOVGxwUmNGcHdRaTlwSWl3aWIzZHVaWEpKWkNJNklqZ3hPREkxTVRrMk5qQWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTBOakExTENKcFlYUWlPakUzTkRJMU5URXdNRFVzSW01aVppSTZNVGMwTWpVMU1UQXdOWDAuYTdSVC1tYzM4QU9EWFZTamNEa1hvZDNCTTBsZ25OS1VIeUdmUmgzUzllT2J4a05DWm9DSDhMR243ZU5MdHNLa1JPVlo5RFlzX3c3SkZERDM4cGdfQndYa2tsV05nSEVtWTEtWnRucEYwWlUzWVlvQkhKX2RHVUw2ZXo3QXJXeng0WkpGbkJ1c2VWS3pzM2tMdUNGUWVzejZjNjFCb2laS2lPcDhXY1Vrb3Btd3BJQmZtQ3NxYXJ6OGRXajViZDhnQzBLc21LSjgwSjRzR1JxVXRuZDlUbTcxdW9GUTVHcUY1aHRHUlNtdnNvZ2VjOS0tSWZLWE5GdjRPUHZNYV92WVNQeTVMMFgzcDRleVlDT2VIQkFWMDh4RWktQWhXNVdQVUVJejhoUVlGWGs4OTgyaldLTk4za1Jjbndid1JiX0ZpMlBETU1KOVljazJTTW9LT1pJSXJR"

def test_api_key():
    """APIキーが有効かテスト"""
    print("APIキーのテスト中...")
    
    # APIキーの情報を取得
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

def get_universes():
    """ユーザーのユニバース一覧を取得"""
    print("ユニバース一覧を取得中...")
    
    url = "https://apis.roblox.com/cloud/v2/universes"
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    try:
        response = requests.get(url, headers=headers)
        
        print(f"ステータスコード: {response.status_code}")
        
        if response.status_code == 200:
            universes = response.json()
            print(json.dumps(universes, indent=2))
            return universes
        else:
            print(f"エラーメッセージ: {response.text}")
            return None
    
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return None

def get_places(universe_id):
    """ユニバース内のプレイス一覧を取得"""
    print(f"ユニバース {universe_id} のプレイス一覧を取得中...")
    
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
            return places
        else:
            print(f"エラーメッセージ: {response.text}")
            return None
    
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return None

if __name__ == "__main__":
    # APIキーのテスト
    if test_api_key():
        # ユニバース一覧の取得
        universes = get_universes()
        
        if universes and len(universes) > 0:
            # 最初のユニバースのIDを取得
            universe_id = universes[0]["id"]
            print(f"\n最初のユニバースID: {universe_id}")
            
            # プレイス一覧の取得
            places = get_places(universe_id)
            
            if places and len(places) > 0:
                # 最初のプレイスのIDを取得
                place_id = places[0]["id"]
                print(f"\n最初のプレイスID: {place_id}")
                
                print("\n以下の情報をroblox_sync.pyに設定してください:")
                print(f"UNIVERSE_ID = \"{universe_id}\"")
                print(f"PLACE_ID = \"{place_id}\"")
            else:
                print("プレイスが見つかりませんでした")
        else:
            print("ユニバースが見つかりませんでした")