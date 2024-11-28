import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secrets.dart'; // secrets.dartで管理するAPIキー

class ApiService {
  static Future<String> generateText(String prompt) async {
    // Cohereの生成APIエンドポイント
    final url = Uri.parse('https://api.cohere.ai/v1/generate');

    // リクエストヘッダー
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $ApiKey', // secrets.dartで管理するAPIキー
    };

    // リクエストボディ
    final body = jsonEncode({
      'model': 'command', // Cohereのモデル（commandモデルを指定）
      'prompt': '$promptをまとめて、日本語で小説風の文章にしてください',
      'max_tokens': 50, // 最大トークン数
      'temperature': 0.7, // 創造性の度合い
    });

    try {
      // HTTP POSTリクエストを送信
      final response = await http.post(url, headers: headers, body: body);

      // ステータスコードが200（成功）かどうかを確認
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8でデコード
        print('レスポンス全体: $decodedResponse'); // デバッグ用に出力

        // `generations`フィールドの内容を取得
        if (decodedResponse.containsKey('generations')) {
          final generations = decodedResponse['generations'];
          if (generations.isNotEmpty) {
            return generations[0]['text'].toString().trim(); // 最初の生成されたテキストを返す
          } else {
            return '生成されたテキストが空です';
          }
        } else {
          return 'レスポンスにgenerationsフィールドがありません';
        }
      } else {
        // ステータスコードが200でない場合はエラー
        throw Exception('Failed to generate text: ${response.body}');
      }
    } catch (e) {
      // エラーが発生した場合に例外をスロー
      return 'エラーが発生しました: $e';
    }
  }
}
