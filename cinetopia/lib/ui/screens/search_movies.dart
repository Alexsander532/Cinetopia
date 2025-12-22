import 'package:cinetopia/app/viewmodels/search_movies_viewmodel.dart';
import 'package:cinetopia/ui/components/movie_card.dart';
import 'package:cinetopia/ui/screens/movie_details.dart';
import 'package:flutter/material.dart';

class SearchMovies extends StatefulWidget {


  SearchMovies({super.key});

  @override
  State<SearchMovies> createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<SearchMovies> {
  final SearchMoviesViewModel viewModel = SearchMoviesViewModel(); 
 // Instanciando o ViewModel
  final TextEditingController textController= TextEditingController(); 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.getMovie(textController.text), // Chamando o método de busca de filmes
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // dados carregados
          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Image.asset("assets/movie.png", height: 80, width: 80),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    "Filmes populares",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: TextField(
                    onEditingComplete: () async {
                      FocusScope.of(context).unfocus(); // Fechando o teclado
                      setState(() {});
                    },  // Chamando o método de busca ao completar a edição
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "Pesquisar",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList.builder(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetails(
                            movie: viewModel.moviesList[index],
                          ),
                        ),
                      );
                    },
                    child: MovieCard(movie: viewModel.moviesList[index]),
                  ),
                ),
                itemCount: viewModel.moviesList.length,
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
