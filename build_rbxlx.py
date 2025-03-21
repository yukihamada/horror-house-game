#!/usr/bin/env python3
"""
Robloxプロジェクトビルドスクリプト
Rojoがない環境でも、JSONモデルファイルからRobloxプレイスファイル(.rbxlx)を生成します
"""

import os
import json
import xml.etree.ElementTree as ET
import xml.dom.minidom as minidom
from datetime import datetime

def create_basic_rbxlx():
    """基本的なRoblox XMLプレイスファイルを作成"""
    print("基本的なRobloxプレイスファイルを作成中...")
    
    # ルート要素
    root = ET.Element("roblox", {
        "xmlns:xmime": "http://www.w3.org/2005/05/xmlmime",
        "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:noNamespaceSchemaLocation": "http://www.roblox.com/roblox.xsd",
        "version": "4"
    })
    
    # 基本的なサービスを追加
    services = [
        {"class": "Workspace", "properties": {"FilteringEnabled": "true"}},
        {"class": "ReplicatedStorage"},
        {"class": "ServerScriptService"},
        {"class": "StarterGui"},
        {"class": "Lighting", "properties": {
            "Ambient": "0.078 0.078 0.118",
            "Brightness": "0.2",
            "GlobalShadows": "true",
            "TimeOfDay": "22:00:00"
        }}
    ]
    
    item_id = 0
    for service in services:
        item = ET.SubElement(root, "Item", {"class": service["class"]})
        item_id += 1
        
        # プロパティを追加
        if "properties" in service:
            properties = ET.SubElement(item, "Properties")
            for prop_name, prop_value in service["properties"].items():
                prop = ET.SubElement(properties, prop_name)
                prop.text = prop_value
    
    # XMLを整形して保存
    xml_str = ET.tostring(root, encoding="unicode")
    pretty_xml = minidom.parseString(xml_str).toprettyxml(indent="  ")
    
    with open("game.rbxlx", "w", encoding="utf-8") as f:
        f.write(pretty_xml)
    
    print("基本的なRobloxプレイスファイルを作成しました: game.rbxlx")
    return "game.rbxlx"

def add_lua_scripts():
    """Luaスクリプトをプレイスファイルに追加"""
    print("Luaスクリプトをプレイスファイルに追加中...")
    
    # XMLファイルを読み込む
    tree = ET.parse("game.rbxlx")
    root = tree.getroot()
    
    # スクリプトディレクトリ
    script_dirs = {
        "ServerScriptService": "src/ServerScriptService",
        "ReplicatedStorage": "src/ReplicatedStorage",
        "StarterGui": "src/StarterGui"
    }
    
    # 各サービスにスクリプトを追加
    for service_name, script_dir in script_dirs.items():
        # サービスを見つける
        service = None
        for item in root.findall("Item"):
            if item.get("class") == service_name:
                service = item
                break
        
        if service is None:
            print(f"警告: {service_name} が見つかりません")
            continue
        
        # ディレクトリ内のLuaスクリプトを検索
        if os.path.exists(script_dir):
            for filename in os.listdir(script_dir):
                if filename.endswith(".lua"):
                    script_path = os.path.join(script_dir, filename)
                    script_name = os.path.splitext(filename)[0]
                    
                    # スクリプト内容を読み込む
                    with open(script_path, "r", encoding="utf-8") as f:
                        script_content = f.read()
                    
                    # スクリプト要素を作成
                    script_item = ET.SubElement(service, "Item", {"class": "Script"})
                    properties = ET.SubElement(script_item, "Properties")
                    
                    # 名前プロパティ
                    name_prop = ET.SubElement(properties, "string", {"name": "Name"})
                    name_prop.text = script_name
                    
                    # ソースプロパティ
                    source_prop = ET.SubElement(properties, "ProtectedString", {"name": "Source"})
                    source_prop.text = script_content
                    
                    print(f"スクリプトを追加しました: {script_name}")
    
    # XMLを整形して保存
    xml_str = ET.tostring(root, encoding="unicode")
    pretty_xml = minidom.parseString(xml_str).toprettyxml(indent="  ")
    
    with open("game.rbxlx", "w", encoding="utf-8") as f:
        f.write(pretty_xml)
    
    print("すべてのLuaスクリプトを追加しました")

def add_model_json():
    """JSONモデルファイルをプレイスファイルに追加"""
    print("JSONモデルファイルをプレイスファイルに追加中...")
    
    # XMLファイルを読み込む
    tree = ET.parse("game.rbxlx")
    root = tree.getroot()
    
    # モデルディレクトリ
    model_dirs = {
        "Workspace": "src/Workspace",
        "ReplicatedStorage": "src/ReplicatedStorage",
        "StarterGui": "src/StarterGui"
    }
    
    # 各サービスにモデルを追加
    for service_name, model_dir in model_dirs.items():
        # サービスを見つける
        service = None
        for item in root.findall("Item"):
            if item.get("class") == service_name:
                service = item
                break
        
        if service is None:
            print(f"警告: {service_name} が見つかりません")
            continue
        
        # ディレクトリ内のJSONモデルファイルを検索
        if os.path.exists(model_dir):
            for filename in os.listdir(model_dir):
                if filename.endswith(".model.json"):
                    model_path = os.path.join(model_dir, filename)
                    
                    try:
                        # JSONファイルを読み込む
                        with open(model_path, "r", encoding="utf-8") as f:
                            model_data = json.load(f)
                        
                        # モデルをXMLに変換して追加
                        add_model_to_service(service, model_data)
                        
                        print(f"モデルを追加しました: {filename}")
                    except Exception as e:
                        print(f"モデル {filename} の追加中にエラーが発生しました: {str(e)}")
    
    # XMLを整形して保存
    xml_str = ET.tostring(root, encoding="unicode")
    pretty_xml = minidom.parseString(xml_str).toprettyxml(indent="  ")
    
    with open("game.rbxlx", "w", encoding="utf-8") as f:
        f.write(pretty_xml)
    
    print("すべてのJSONモデルを追加しました")

def add_model_to_service(service, model_data):
    """モデルデータをXMLサービスに追加"""
    # モデル要素を作成
    model_item = ET.SubElement(service, "Item", {"class": model_data.get("ClassName", "Model")})
    properties = ET.SubElement(model_item, "Properties")
    
    # 名前プロパティ
    name_prop = ET.SubElement(properties, "string", {"name": "Name"})
    name_prop.text = model_data.get("Name", "Model")
    
    # その他のプロパティを追加
    if "Properties" in model_data:
        for prop_name, prop_value in model_data["Properties"].items():
            # プロパティの型を判断
            if isinstance(prop_value, bool):
                prop = ET.SubElement(properties, "bool", {"name": prop_name})
                prop.text = str(prop_value).lower()
            elif isinstance(prop_value, (int, float)):
                prop = ET.SubElement(properties, "float", {"name": prop_name})
                prop.text = str(prop_value)
            elif isinstance(prop_value, list) and len(prop_value) == 3:
                # Vector3または色
                prop = ET.SubElement(properties, "Vector3", {"name": prop_name})
                prop.text = f"{prop_value[0]} {prop_value[1]} {prop_value[2]}"
            else:
                prop = ET.SubElement(properties, "string", {"name": prop_name})
                prop.text = str(prop_value)
    
    # 子要素を追加
    if "Children" in model_data:
        for child in model_data["Children"]:
            add_model_to_service(model_item, child)

def main():
    """メイン処理"""
    print("Robloxプレイスファイルのビルドを開始します...")
    
    # 基本的なプレイスファイルを作成
    create_basic_rbxlx()
    
    # Luaスクリプトを追加
    add_lua_scripts()
    
    # JSONモデルを追加
    add_model_json()
    
    print("ビルドが完了しました: game.rbxlx")
    return "game.rbxlx"

if __name__ == "__main__":
    main()