class Endpoints {
  static const String baseUrl = 'https://api.tvmaze.com';
  static const String shows = 'https://api.tvmaze.com/shows';
  static const String searchShows = 'https://api.tvmaze.com/search/shows';
  static String showCast(int showId) => 'https://api.tvmaze.com/shows/$showId/cast';
}
