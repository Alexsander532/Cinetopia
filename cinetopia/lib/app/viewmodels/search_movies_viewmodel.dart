import 'package:cinetopia/app/models/movie.dart';
import 'package:cinetopia/app/services/search_movies_service.dart';

class SearchMoviesViewModel {
  List<Movie> _moviesList = <Movie>[];

  // ViewModel implementation for searching movies
  Future<List<Movie>> getPopularMovies() async {
    final SearchMoviesService service =
        SearchPopularMoviesService(); // Instanciamento do serviço (Inversão de dependência simples)
    _moviesList = await service.getMovies();
    return _moviesList;
  }

  Future<List<Movie>> getMovie(String query) async {
    // Método para buscar filmes por título
    if (query.isEmpty) {
      _moviesList =
          await getPopularMovies(); // Se o termo de busca estiver vazio, busca os filmes populares
    } else {
      final SearchMoviesService service = SearchForMovie( 
        query: query,
      ); // Instanciamento do serviço de busca por título
      _moviesList = await service
          .getMovies(); // Busca os filmes usando o serviço
    }
    return _moviesList; // Retorna a lista privada de filmes encontrados
  }

  List<Movie> get moviesList =>
      _moviesList; //Getter para acessar a lista de filmes
}
