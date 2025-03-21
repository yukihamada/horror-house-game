#!/usr/bin/env python3
"""
Robloxプレイスファイルをアップロードするスクリプト
"""

import requests
import json
import os

# APIキー
ROBLOX_API_KEY = "AnO4LVMMNkm3IrGR20lxgiyS8+yrAgmCZN3uM6MNZQpZpB/iZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lRVzVQTkV4V1RVMU9hMjB6U1hKSFVqSXdiSGhuYVhsVE9DdDVja0ZuYlVOYVRqTjFUVFpOVGxwUmNGcHdRaTlwSWl3aWIzZHVaWEpKWkNJNklqZ3hPREkxTVRrMk5qQWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTBOakExTENKcFlYUWlPakUzTkRJMU5URXdNRFVzSW01aVppSTZNVGMwTWpVMU1UQXdOWDAuYTdSVC1tYzM4QU9EWFZTamNEa1hvZDNCTTBsZ25OS1VIeUdmUmgzUzllT2J4a05DWm9DSDhMR243ZU5MdHNLa1JPVlo5RFlzX3c3SkZERDM4cGdfQndYa2tsV05nSEVtWTEtWnRucEYwWlUzWVlvQkhKX2RHVUw2ZXo3QXJXeng0WkpGbkJ1c2VWS3pzM2tMdUNGUWVzejZjNjFCb2laS2lPcDhXY1Vrb3Btd3BJQmZtQ3NxYXJ6OGRXajViZDhnQzBLc21LSjgwSjRzR1JxVXRuZDlUbTcxdW9GUTVHcUY1aHRHUlNtdnNvZ2VjOS0tSWZLWE5GdjRPUHZNYV92WVNQeTVMMFgzcDRleVlDT2VIQkFWMDh4RWktQWhXNVdQVUVJejhoUVlGWGs4OTgyaldLTk4za1Jjbndid1JiX0ZpMlBETU1KOVljazJTTW9LT1pJSXJR"

# プレイスIDとユニバースID
UNIVERSE_ID = "8182519660"
PLACE_ID = "8182519660"

def upload_place_with_version_type():
    """バージョンタイプを指定してプレイスをアップロード"""
    print(f"ユニバースID: {UNIVERSE_ID}, プレイスID: {PLACE_ID} でアップロードを試しています...")
    
    url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places/{PLACE_ID}/versions"
    
    headers = {
        "x-api-key": ROBLOX_API_KEY,
        "Content-Type": "application/octet-stream"
    }
    
    # クエリパラメータでバージョンタイプを指定
    params = {
        "versionType": "Published"  # または "Saved"
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

def try_multiple_version_types():
    """複数のバージョンタイプを試す"""
    version_types = ["Published", "Saved", "Archived"]
    
    for version_type in version_types:
        print(f"\nバージョンタイプ '{version_type}' でアップロードを試しています...")
        
        url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places/{PLACE_ID}/versions"
        
        headers = {
            "x-api-key": ROBLOX_API_KEY,
            "Content-Type": "application/octet-stream"
        }
        
        params = {
            "versionType": version_type
        }
        
        try:
            with open("game.rbxlx", "rb") as file:
                file_data = file.read()
            
            response = requests.post(url, headers=headers, params=params, data=file_data)
            print(f"ステータスコード: {response.status_code}")
            print(f"レスポンス: {response.text}")
            
            if response.status_code == 200:
                print(f"バージョンタイプ '{version_type}' でアップロードに成功しました！")
                return True
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")
    
    return False

def try_different_content_types():
    """異なるContent-Typeを試す"""
    content_types = [
        "application/octet-stream",
        "application/xml",
        "text/xml",
        "application/x-www-form-urlencoded"
    ]
    
    for content_type in content_types:
        print(f"\nContent-Type '{content_type}' でアップロードを試しています...")
        
        url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places/{PLACE_ID}/versions"
        
        headers = {
            "x-api-key": ROBLOX_API_KEY,
            "Content-Type": content_type
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
                print(f"Content-Type '{content_type}' でアップロードに成功しました！")
                return True
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")
    
    return False

if __name__ == "__main__":
    print("Robloxプレイスファイルのアップロードを開始します...")
    
    # ファイルの存在確認
    if not os.path.exists("game.rbxlx"):
        print("エラー: game.rbxlxファイルが見つかりません")
        exit(1)
    
    # バージョンタイプを指定してアップロード
    if upload_place_with_version_type():
        print("アップロードが完了しました")
        exit(0)
    
    # 複数のバージョンタイプを試す
    print("\n複数のバージョンタイプを試します...")
    if try_multiple_version_types():
        print("アップロードが完了しました")
        exit(0)
    
    # 異なるContent-Typeを試す
    print("\n異なるContent-Typeを試します...")
    if try_different_content_types():
        print("アップロードが完了しました")
        exit(0)
    
    print("\nすべての試行が失敗しました。APIキー、プレイスID、ユニバースIDを確認してください。")