import 'package:newsapp/model/categorynewsmodel.dart';
import 'package:newsapp/model/news_channel_headlines_model.dart';
import 'package:newsapp/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoryNewsModel> fetchCategoryNewsApi(String category) async {
    final response = await _rep.fetchCategoryNewsApi(category);
    return response;
  }
}
