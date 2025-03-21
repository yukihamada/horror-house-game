#!/usr/bin/env python3
"""
Roblox APIキーとプロジェクト情報をチェックするスクリプト
"""

import requests
import json

# APIキー
ROBLOX_API_KEY = "AnO4LVMMNkm3IrGR20lxgiyS8+yrAgmCZN3uM6MNZQpZpB/iZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lRVzVQTkV4V1RVMU9hMjB6U1hKSFVqSXdiSGhuYVhsVE9DdDVja0ZuYlVOYVRqTjFUVFpOVGxwUmNGcHdRaTlwSWl3aWIzZHVaWEpKWkNJNklqZ3hPREkxTVRrMk5qQWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTBOakExTENKcFlYUWlPakUzTkRJMU5URXdNRFVzSW01aVppSTZNVGMwTWpVMU1UQXdOWDAuYTdSVC1tYzM4QU9EWFZTamNEa1hvZDNCTTBsZ25OS1VIeUdmUmgzUzllT2J4a05DWm9DSDhMR243ZU5MdHNLa1JPVlo5RFlzX3c3SkZERDM4cGdfQndYa2tsV05nSEVtWTEtWnRucEYwWlUzWVlvQkhKX2RHVUw2ZXo3QXJXeng0WkpGbkJ1c2VWS3pzM2tMdUNGUWVzejZjNjFCb2laS2lPcDhXY1Vrb3Btd3BJQmZtQ3NxYXJ6OGRXajViZDhnQzBLc21LSjgwSjRzR1JxVXRuZDlUbTcxdW9GUTVHcUY1aHRHUlNtdnNvZ2VjOS0tSWZLWE5GdjRPUHZNYV92WVNQeTVMMFgzcDRleVlDT2VIQkFWMDh4RWktQWhXNVdQVUVJejhoUVlGWGs4OTgyaldLTk4za1Jjbndid1JiX0ZpMlBETU1KOVljazJTTW9LT1pJSXJR"

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

def list_available_apis():
    """利用可能なAPIエンドポイントを確認"""
    print("\n利用可能なAPIエンドポイントを確認中...")
    
    # 利用可能なAPIを確認
    url = "https://apis.roblox.com/"
    
    try:
        response = requests.get(url)
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")

def try_different_endpoints():
    """異なるエンドポイントを試す"""
    print("\n異なるエンドポイントを試しています...")
    
    # 異なるエンドポイントのリスト
    endpoints = [
        "https://apis.roblox.com/universes/v1/places",
        "https://apis.roblox.com/cloud/v1/games",
        "https://apis.roblox.com/cloud/v2/games",
        "https://apis.roblox.com/assets/v1",
        "https://apis.roblox.com/cloud/v1/places"
    ]
    
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    for endpoint in endpoints:
        print(f"\n{endpoint} を試しています...")
        try:
            response = requests.get(endpoint, headers=headers)
            print(f"ステータスコード: {response.status_code}")
            print(f"レスポンス: {response.text[:200]}..." if len(response.text) > 200 else f"レスポンス: {response.text}")
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")

def try_upload_place():
    """プレイスのアップロードを試す"""
    print("\nプレイスのアップロードを試しています...")
    
    # 複数のユニバースIDとプレイスIDの組み合わせを試す
    combinations = [
        {"universe_id": "8182519660", "place_id": "8182519660"},
        {"universe_id": "8182519660", "place_id": "8182519661"},
        {"universe_id": "4815162342", "place_id": "4815162342"}
    ]
    
    headers = {
        "x-api-key": ROBLOX_API_KEY,
        "Content-Type": "application/octet-stream"
    }
    
    for combo in combinations:
        universe_id = combo["universe_id"]
        place_id = combo["place_id"]
        
        url = f"https://apis.roblox.com/universes/v1/{universe_id}/places/{place_id}/versions"
        
        print(f"\nユニバースID: {universe_id}, プレイスID: {place_id} でアップロードを試しています...")
        
        try:
            with open("game.rbxlx", "rb") as file:
                file_data = file.read()
            
            response = requests.post(url, headers=headers, data=file_data)
            print(f"ステータスコード: {response.status_code}")
            print(f"レスポンス: {response.text}")
        except Exception as e:
            print(f"エラーが発生しました: {str(e)}")

if __name__ == "__main__":
    print("Roblox APIキーとプロジェクト情報のチェックを開始します...")
    
    # APIキーの確認
    check_api_key()
    
    # 利用可能なAPIエンドポイントの確認
    list_available_apis()
    
    # 異なるエンドポイントを試す
    try_different_endpoints()
    
    # プレイスのアップロードを試す
    try_upload_place()
    
    print("\nチェック完了")