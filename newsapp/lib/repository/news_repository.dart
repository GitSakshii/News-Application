import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/categorynewsmodel.dart';
import 'package:newsapp/model/news_channel_headlines_model.dart';

class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=d1e71e07772f48089f55d85e526b5007";

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception("Error");
  }

  Future<CategoryNewsModel> fetchCategoryNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=${category}&apiKey=d1e71e07772f48089f55d85e526b5007";

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoryNewsModel.fromJson(body);
    }
    throw Exception("Error");
  }
}
