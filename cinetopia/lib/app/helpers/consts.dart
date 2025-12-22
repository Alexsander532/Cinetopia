import 'package:cinetopia/app/api_key.dart';

const String popularMoviesUrlTemplate =
    'https://api.themoviedb.org/3/movie/popular?api_key=%s&language=pt-BR&page=1';

const String moviePrefixURL =
    'https://api.themoviedb.org/3/search/movie?query=';

const String movieFilterSufixTemplate =
    "&include_adult=false&language=pt-BR&page=1&api_key=%s";

final String movieFilterSufix = movieFilterSufixTemplate.replaceFirst(
  '%s',
  apiKey,
);

final String url = popularMoviesUrlTemplate.replaceFirst('%s', apiKey);
const requestHeader = {'Content-Type': 'application/json'};

const String upcomingUrlTemplate = 
    "https://api.themoviedb.org/3/movie/upcoming?language=pt-BR&page=1&api_key=%s";

final String upcomingUrl = upcomingUrlTemplate.replaceFirst(
  '%s',
  apiKey,
);

const String imageUrlPrefix = 'https://image.tmdb.org/t/p/w500';
