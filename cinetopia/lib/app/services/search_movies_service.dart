import 'dart:convert';
import 'package:cinetopia/app/helpers/consts.dart';
import 'package:cinetopia/app/models/movie.dart';
import 'package:http/http.dart' as http;

/// **SearchMoviesService - Interface Abstrata de Serviços de Busca**
/// 
/// Define o contrato que todos os serviços de busca de filmes devem seguir.
/// Esta é a camada de Service na arquitetura MVVM.
/// 
/// **Padrão de Design: Strategy Pattern**
/// Permite que diferentes estratégias de busca (popular, por título, upcoming)
/// sejam intercambiáveis sem alterar o código cliente (ViewModel).
/// 
/// **Benefícios:**
/// - Abstração: ViewModels não precisam saber qual implementação específica está sendo usada
/// - Extensibilidade: Fácil adicionar novos tipos de busca sem modificar código existente
/// - Testabilidade: Facilita a criação de mocks para testes
abstract class SearchMoviesService {
  /// Método abstrato que todas as implementações devem fornecer
  /// Retorna uma lista de filmes de forma assíncrona
  Future<List<Movie>> getMovies();
}

/// **SearchPopularMoviesService - Busca de Filmes Populares**
/// 
/// Implementação concreta que busca os filmes mais populares do momento.
/// Consome o endpoint `/movie/popular` da API do TMDB.
/// 
/// **Quando é usado:**
/// - Tela inicial de busca (quando não há termo digitado)
/// - Exibição padrão de filmes trending
/// 
/// **Endpoint:** `https://api.themoviedb.org/3/movie/popular`
class SearchPopularMoviesService implements SearchMoviesService {
  /// Lista que armazenará os filmes retornados da API
  List<Movie> movies = <Movie>[];

  /// **Método getMovies() - Busca Filmes Populares**
  /// 
  /// **Fluxo de execução:**
  /// 1. Faz requisição HTTP GET para API do TMDB
  /// 2. Verifica se a resposta foi bem-sucedida (status 200)
  /// 3. Decodifica JSON da resposta
  /// 4. Itera sobre o array 'results' convertendo cada item em Movie
  /// 5. Retorna lista de filmes ou lança exceção em caso de erro
  /// 
  /// **Tratamento de erros:**
  /// - Status != 200: Lança exceção com código de status
  /// - Erro de rede/parsing: Captura e relança com mensagem descritiva
  @override
  Future<List<Movie>> getMovies() async {
    try {
      // Faz requisição GET usando URL e headers definidos em consts.dart
      final response = await http.get(Uri.parse(url), headers: requestHeader);

      if (response.statusCode == 200) {
        // Status 200 = Sucesso
        // Decodifica o JSON e acessa o array 'results'
        for (dynamic movie in json.decode(response.body)['results']) {
          // Converte cada Map para objeto Movie usando factory constructor
          movies.add(Movie.fromMap(movie));
        }
      } else {
        // Se status não for 200, algo deu errado (401, 404, 500, etc)
        throw Exception(
          'Falha ao carregar filmes populares: ${response.statusCode}',
        );
      }
      return movies; // Retorna lista populada
    } catch (e) {
      // Captura qualquer erro (rede, parsing, timeout, etc)
      throw Exception('Erro ao buscar filmes: $e');
    }
  }
}

/// **SearchForMovie - Busca de Filmes por Título**
/// 
/// Implementação que permite buscar filmes por um termo de pesquisa.
/// Consome o endpoint `/search/movie` da API do TMDB.
/// 
/// **Quando é usado:**
/// - Quando o usuário digita algo no campo de busca
/// - Busca dinâmica baseada em input do usuário
/// 
/// **Endpoint:** `https://api.themoviedb.org/3/search/movie?query={termo}`
class SearchForMovie implements SearchMoviesService {
  /// Lista que armazenará os resultados da busca
  List<Movie> movies = <Movie>[];

  /// Termo de busca fornecido pelo usuário
  final String query;

  /// **Construtor**
  /// Recebe o termo de busca como parâmetro obrigatório
  /// 
  /// **Exemplo de uso:**
  /// ```dart
  /// final service = SearchForMovie(query: 'Matrix');
  /// List<Movie> results = await service.getMovies();
  /// ```
  SearchForMovie({required this.query});

  /// **Método getMovies() - Busca por Título**
  /// 
  /// **Construção da URL:**
  /// - moviePrefixURL: "https://api.themoviedb.org/3/search/movie?query="
  /// - query: termo digitado pelo usuário (ex: "Matrix")
  /// - movieFilterSufix: "&include_adult=false&language=pt-BR&page=1&api_key={key}"
  /// 
  /// **URL final exemplo:**
  /// `https://api.themoviedb.org/3/search/movie?query=Matrix&include_adult=false&language=pt-BR&page=1&api_key=xyz`
  @override
  Future<List<Movie>> getMovies() async {
    try {
      // Concatena as partes da URL para formar o endpoint completo
      final response = await http.get(
        Uri.parse(moviePrefixURL + query + movieFilterSufix), 
        headers: requestHeader,
      );

      if (response.statusCode == 200) {
        // Parse do JSON e conversão para objetos Movie
        for (dynamic movie in json.decode(response.body)['results']) {
          movies.add(Movie.fromMap(movie));
        }
      } else {
        throw Exception(
          'Falha ao buscar filmes: ${response.statusCode}',
        );
      }
      return movies;
    } catch (e) {
      throw Exception('Erro ao buscar filmes: $e');
    }
  }
}

/// **SearchForUpcomingMovies - Busca de Próximos Lançamentos**
/// 
/// Implementação que busca filmes que serão lançados em breve.
/// Consome o endpoint `/movie/upcoming` da API do TMDB.
/// 
/// **Quando é usado:**
/// - Tela de "Lançamentos" (segunda aba do Dashboard)
/// - Exibição de filmes que ainda vão estrear
/// 
/// **Endpoint:** `https://api.themoviedb.org/3/movie/upcoming`
class SearchForUpcomingMovies implements SearchMoviesService {
  /// Lista que armazenará os próximos lançamentos
  final List<Movie> movieList = <Movie>[];

  /// **Método getMovies() - Busca Próximos Lançamentos**
  /// 
  /// **Diferenças desta implementação:**
  /// - Usa `upcomingUrl` ao invés de construir URL dinamicamente
  /// - Retorna lista vazia em caso de erro (ao invés de lançar exceção)
  /// - Usa `print(e)` para debug no console
  /// 
  /// **Nota:** Idealmente deveria ter tratamento de erro consistente com outras classes
  @override
  Future<List<Movie>> getMovies() async {
    try {
      // Usa URL pré-configurada para upcoming movies
      final response = await http.get(
        Uri.parse(upcomingUrl), // URL definida em consts.dart
        headers: requestHeader,
      );
      
      if (response.statusCode == 200) {
        // jsonDecode é equivalente a json.decode
        for (dynamic movie in jsonDecode(response.body)["results"]) {
          movieList.add(Movie.fromMap(movie));
        }
        return movieList;
      } else {
        // Lança exceção com corpo da resposta para debug
        throw Exception(response.body);
      }
    } catch (e) {
      // Imprime erro no console (útil para debug)
      print(e);
      // Retorna lista vazia ao invés de lançar exceção
      // Isso previne crashes mas pode ocultar erros da API
      return movieList;
    }
  }
}