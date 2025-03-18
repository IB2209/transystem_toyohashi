

import openai
import os

# OpenAI APIキーを設定（環境変数から取得する場合）
# OpenAI APIキーを入力
API_KEY = ""# ← ここに正しいAPIキーを入力
# API_KEY = "your-api-key"  # 直接記述する場合はこちら

# OpenAIクライアントの設定（最新の書き方）
client = openai.OpenAI(api_key=API_KEY)

def get_chatgpt_response(prompt):
    """ChatGPTにプロンプトを送信し、アドバイスを取得"""
    response = client.chat.completions.create(
        model="gpt-4o",  # 利用可能な最新のモデルを指定
        messages=[{"role": "user", "content": prompt}],
        max_tokens=2000,
        temperature=0.7
    )
    return response.choices[0].message.content

def read_rails_project(directory):
    """Railsプロジェクトの主要コードを読み取る"""
    code_snippets = []
    target_dirs = ["app", "config", "db", "lib"]  # Railsの主要ディレクトリを対象
    target_extensions = (".rb", ".erb", ".rake", ".yml", ".js", ".ts", ".css", ".scss")

    for root, _, files in os.walk(directory):
        if any(dir in root for dir in target_dirs):  # 指定したディレクトリのみ対象
            for file in files:
                if file.endswith(target_extensions):  # 指定した拡張子のみ対象
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, "r", encoding="utf-8") as f:
                            code_snippets.append(f"\n### {file_path}\n" + f.read())
                    except Exception as e:
                        print(f"⚠️ {file_path} の読み取りに失敗: {e}")
    
    return "\n".join(code_snippets)

if __name__ == "__main__":
    project_directory = "."  # Railsプロジェクトのルートディレクトリ
    project_code = read_rails_project(project_directory)

    prompt = f"""これは私のRailsプロジェクトのコードです。  
    - 問題点の指摘
    - 改善点の提案
    - **具体的な修正コードの例**
    - セキュリティ対策
    - パフォーマンス向上のアイデア

    {project_code}

    Railsのベストプラクティスに基づいて、**修正コードを含めたアドバイス** を提供してください。
    """
    
    response = get_chatgpt_response(prompt)
    print("\n💡 ChatGPTのアドバイス:\n")
    print(response)
