#!/usr/bin/env python3
import os
import requests
import subprocess
import json
import time
from datetime import datetime

# 設定
# 注意: 実際の運用では環境変数や安全な方法でキーを管理してください
ROBLOX_API_KEY = "AnO4LVMMNkm3IrGR20lxgiyS8+yrAgmCZN3uM6MNZQpZpB/iZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNkluTnBaeTB5TURJeExUQTNMVEV6VkRFNE9qVXhPalE1V2lJc0luUjVjQ0k2SWtwWFZDSjkuZXlKaVlYTmxRWEJwUzJWNUlqb2lRVzVQTkV4V1RVMU9hMjB6U1hKSFVqSXdiSGhuYVhsVE9DdDVja0ZuYlVOYVRqTjFUVFpOVGxwUmNGcHdRaTlwSWl3aWIzZHVaWEpKWkNJNklqZ3hPREkxTVRrMk5qQWlMQ0poZFdRaU9pSlNiMkpzYjNoSmJuUmxjbTVoYkNJc0ltbHpjeUk2SWtOc2IzVmtRWFYwYUdWdWRHbGpZWFJwYjI1VFpYSjJhV05sSWl3aVpYaHdJam94TnpReU5UVTBOakExTENKcFlYUWlPakUzTkRJMU5URXdNRFVzSW01aVppSTZNVGMwTWpVMU1UQXdOWDAuYTdSVC1tYzM4QU9EWFZTamNEa1hvZDNCTTBsZ25OS1VIeUdmUmgzUzllT2J4a05DWm9DSDhMR243ZU5MdHNLa1JPVlo5RFlzX3c3SkZERDM4cGdfQndYa2tsV05nSEVtWTEtWnRucEYwWlUzWVlvQkhKX2RHVUw2ZXo3QXJXeng0WkpGbkJ1c2VWS3pzM2tMdUNGUWVzejZjNjFCb2laS2lPcDhXY1Vrb3Btd3BJQmZtQ3NxYXJ6OGRXajViZDhnQzBLc21LSjgwSjRzR1JxVXRuZDlUbTcxdW9GUTVHcUY1aHRHUlNtdnNvZ2VjOS0tSWZLWE5GdjRPUHZNYV92WVNQeTVMMFgzcDRleVlDT2VIQkFWMDh4RWktQWhXNVdQVUVJejhoUVlGWGs4OTgyaldLTk4za1Jjbndid1JiX0ZpMlBETU1KOVljazJTTW9LT1pJSXJR"

# 実際のゲーム情報
PLACE_ID = "11150575352"  # プレイスID
UNIVERSE_ID = "3987796973"  # ユニバースID（ゲームID）

# ログファイル
LOG_FILE = "roblox_sync_log.txt"

def log_message(message):
    """ログメッセージを記録"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_entry = f"[{timestamp}] {message}"
    print(log_entry)
    
    with open(LOG_FILE, "a") as f:
        f.write(log_entry + "\n")

def export_place_to_file():
    """現在のプロジェクトをRobloxプレイスファイルにエクスポート"""
    log_message("プロジェクトをRobloxプレイスファイルにエクスポート中...")
    
    # Rojoがインストールされている場合はそれを使用
    try:
        subprocess.run(["rojo", "build", "-o", "game.rbxlx"], check=True)
        log_message("Rojoを使用してプロジェクトをビルドしました")
        return "game.rbxlx"
    except (subprocess.SubprocessError, FileNotFoundError):
        log_message("Rojoが見つからないか、ビルドに失敗しました")
        
        # カスタムビルドスクリプトを使用
        try:
            log_message("カスタムビルドスクリプトを使用してビルドを試みます...")
            if os.path.exists("build_rbxlx.py"):
                subprocess.run(["python", "build_rbxlx.py"], check=True)
                if os.path.exists("game.rbxlx"):
                    log_message("カスタムビルドスクリプトでビルドに成功しました")
                    return "game.rbxlx"
            
            log_message("カスタムビルドスクリプトでのビルドに失敗しました")
        except Exception as e:
            log_message(f"カスタムビルド中にエラーが発生しました: {str(e)}")
        
        # 既存のファイルを使用
        if os.path.exists("game.rbxlx"):
            log_message("既存のgame.rbxlxファイルを使用します")
            return "game.rbxlx"
        else:
            log_message("エラー: Robloxプレイスファイルを生成できません")
            return None

def upload_to_roblox(file_path):
    """Roblox Open Cloud APIを使用してプレイスファイルをアップロード"""
    if not os.path.exists(file_path):
        log_message(f"エラー: ファイル {file_path} が見つかりません")
        return False
    
    log_message(f"Robloxプレイス (ID: {PLACE_ID}) にアップロード中...")
    
    url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places/{PLACE_ID}/versions"
    headers = {
        "x-api-key": ROBLOX_API_KEY,
        "Content-Type": "application/octet-stream"
    }
    
    try:
        with open(file_path, "rb") as file:
            file_data = file.read()
        
        response = requests.post(url, headers=headers, data=file_data)
        
        if response.status_code == 200:
            log_message("Robloxへのアップロードに成功しました！")
            log_message(f"レスポンス: {response.text}")
            return True
        else:
            log_message(f"アップロード失敗: ステータスコード {response.status_code}")
            log_message(f"エラーメッセージ: {response.text}")
            return False
    
    except Exception as e:
        log_message(f"アップロード中にエラーが発生しました: {str(e)}")
        return False

def get_place_info():
    """プレイスの情報を取得"""
    log_message(f"プレイス (ID: {PLACE_ID}) の情報を取得中...")
    
    url = f"https://apis.roblox.com/universes/v1/{UNIVERSE_ID}/places/{PLACE_ID}"
    headers = {
        "x-api-key": ROBLOX_API_KEY
    }
    
    try:
        response = requests.get(url, headers=headers)
        
        if response.status_code == 200:
            log_message("プレイス情報の取得に成功しました")
            log_message(f"情報: {response.text}")
            return response.json()
        else:
            log_message(f"プレイス情報の取得に失敗: ステータスコード {response.status_code}")
            log_message(f"エラーメッセージ: {response.text}")
            return None
    
    except Exception as e:
        log_message(f"プレイス情報の取得中にエラーが発生しました: {str(e)}")
        return None

def main():
    """メイン処理"""
    log_message("Roblox同期プロセスを開始します")
    
    # プレイス情報の取得（APIキーが有効かテスト）
    place_info = get_place_info()
    if not place_info:
        log_message("プレイス情報の取得に失敗しました。APIキーが正しいか確認してください。")
        return
    
    # プロジェクトをエクスポート
    place_file = export_place_to_file()
    if not place_file:
        log_message("プロジェクトのエクスポートに失敗しました")
        return
    
    # Robloxにアップロード
    success = upload_to_roblox(place_file)
    
    if success:
        log_message("同期プロセスが正常に完了しました")
    else:
        log_message("同期プロセスが失敗しました")

if __name__ == "__main__":
    main()