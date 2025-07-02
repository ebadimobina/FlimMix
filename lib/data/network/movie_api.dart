import 'package:flimmix/data/dto/top_rate_movie.dart';
import 'package:flimmix/data/network/api_manager.dart';
import 'package:flimmix/data/network/endpoints.dart';

class MovieApi {
  final ApiManager _apiManager = ApiManager();

  Future<TopRateMovie> fetchTopRatedMovies() async {
    final response = await _apiManager.dio.get(
      Endpoints.topRated,
      queryParameters: {
        'api_key': 'acbd212c210d23400bcd9e41e543a07b',
      },
    );
    return TopRateMovie.fromJson(response.data);
  }

}
