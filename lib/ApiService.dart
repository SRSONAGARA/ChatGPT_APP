import 'dart:convert';
import 'dart:io';

import 'package:chatgpt/.env.dart';
import 'package:http/http.dart' as http;

class ApiServices{

static Future<String> generateResponces(String prompt) async {
  const apiKey = ChatGPTAPIKey;    // Add your OpenAI api key
  String? res;
  var url = Uri.parse("https://api.openai.com/v1/chat/completions");
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      "Content-Type": "application/json"
    },
    body: jsonEncode(
      {
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content": prompt,
          }
        ]
      },
    ),
  );
  Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    Map<String, dynamic> newresponses = jsonDecode(response.body.toString());
    res = newresponses['choices'][0]['message']['content'];
    print(res.toString());
  } else if (jsonResponse['error'] != null) {
    res = HttpException(jsonResponse['error']["message"]).toString();
    throw HttpException(jsonResponse['error']["message"]);
  } else {
    print("Failed to fetched");
  }
  return res!;
}
}