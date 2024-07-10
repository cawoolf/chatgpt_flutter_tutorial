import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';
import '../constants/constants.dart';
import '../models/models_model.dart';

class ApiService {


  // Send Message fct
  static Future<void> sendMessage(
      {required String content, required String modelId}) async {

     var messagesBody = [
       {"role": "system",
      "content" : "You are a helpful assistant"
    },
    {"role" : "user",
    "content" : content}];

     print("content: $content \n modelId: $modelId");

    try {
      var response = await http.post(
        Uri.parse("$BASE_CHAT_URL/completions"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $API_KEY'
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": messagesBody,
            "max_tokens": 100,
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        print("error");
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }

      if (jsonResponse["choices"].length > 0) {
        print("response: $jsonResponse");
        log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
      }
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }



  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_MODELS_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
