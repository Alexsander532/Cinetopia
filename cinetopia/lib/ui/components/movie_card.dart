import 'package:cinetopia/app/models/movie.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Movie movie; // Adicionando o parâmetro movie

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Container(
            width: 90,
            height: 120,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 164, 34, 34),
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                  movie.getPosterImageUrl(),
                ),
                fit: BoxFit.cover,
              ),
            ),
            margin: const EdgeInsets.only(right: 16.0),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  "${movie.title}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "Lançamento: ${movie.release_date}",
                style: TextStyle(color: Color(0xFFA5A5A5)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
