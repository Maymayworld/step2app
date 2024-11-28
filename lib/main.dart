import 'package:flutter/material.dart';
import 'services/api_service.dart'; // 先ほど作成したAPIサービスをインポート

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小説化アプリ',
      home: NovelizePage(),
    );
  }
}

class NovelizePage extends StatefulWidget {
  @override
  _NovelizePageState createState() => _NovelizePageState();
}

class _NovelizePageState extends State<NovelizePage> {
  final TextEditingController _controller = TextEditingController();
  String displayedText = ""; // 上部に表示されるテキスト
  bool isLoading = false; // ローディング中かどうか

  // 決定ボタンを押したときの処理
  void addText(String text) {
    setState(() {
      displayedText += text + " "; // 入力されたテキストを連結して表示
      _controller.clear(); // 入力フィールドをクリア
    });
  }

  // 小説化ボタンを押したときの処理
  Future<void> novelizeText() async {
    setState(() {
      isLoading = true; // ローディング中に切り替え
    });

    try {
      final novelizedText = await ApiService.generateText(displayedText);
      setState(() {
        displayedText = novelizedText; // 小説化されたテキストを表示
      });
    } catch (e) {
      print("エラー: $e");
      setState(() {
        displayedText = "小説化に失敗しました。";
      });
    } finally {
      setState(() {
        isLoading = false; // ローディング終了
      });
    }
  }

  // 削除ボタンを押したときの処理
  void clearText() {
    setState(() {
      displayedText = ""; // 表示テキストを空にする
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('小説化アプリ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 上部の表示エリア
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Text(
                  displayedText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 16),
            // 入力フィールド
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "ここに入力してください",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // ボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => addText(_controller.text),
                  child: Text('決定'),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : novelizeText,
                  child: isLoading ? CircularProgressIndicator() : Text('小説化'),
                ),
                ElevatedButton(
                  onPressed: clearText, // 削除ボタンの処理を追加
                  child: Text('消去'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

