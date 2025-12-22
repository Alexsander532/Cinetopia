import 'dart:convert';
import 'package:cinetopia/app/helpers/consts.dart';
import 'package:cinetopia/app/models/movie.dart';
import 'package:http/http.dart' as http;

abstract class SearchMoviesService {
  Future<List<Movie>> getMovies();
}

class SearchPopularMoviesService implements SearchMoviesService {
  List<Movie> movies = <Movie>[];

  @override //Serve para sobrescrever um método da classe pai
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse(url), headers: requestHeader);

      if (response.statusCode == 200) {
        for (dynamic movie in json.decode(response.body)['results']) {
          movies.add(Movie.fromMap(movie));
        }
      } else {
        throw Exception(
          'Falha ao carregar filmes populares: ${response.statusCode}',
        );
      }
      return movies;
    } catch (e) {
      throw Exception('Erro ao buscar filmes: $e');
    }
  }
}

class SearchForMovie implements SearchMoviesService {
  // Interface para busca de filmes por título
  List<Movie> movies = <Movie>[];

  final String query;
  SearchForMovie({required this.query});  // Construtor para receber o termo de busca

  @override //Serve para sobrescrever um método da classe pai
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(
        Uri.parse(moviePrefixURL + query + movieFilterSufix), 
        headers: requestHeader);

      if (response.statusCode == 200) {
        for (dynamic movie in json.decode(response.body)['results']) {
          movies.add(Movie.fromMap(movie));
        }
      } else {
        throw Exception(
          'Falha ao carregar filmes populares: ${response.statusCode}',
        );
      }
      return movies;
    } catch (e) {
      throw Exception('Erro ao buscar filmes: $e');
    }
  }
}

class SearchForUpcomingMovies implements SearchMoviesService {
  final List<Movie> movieList = <Movie>[];

  @override
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(
        Uri.parse(upcomingUrl),
        headers: requestHeader,
      );
      if (response.statusCode == 200) {
        for (dynamic movie in jsonDecode(response.body)["results"]) {
          movieList.add(Movie.fromMap(movie));
        }
        return movieList;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e);
      return movieList;
    }
  }
}