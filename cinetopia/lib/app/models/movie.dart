import 'dart:convert';

import 'package:cinetopia/app/helpers/consts.dart';

class Movie {
  final int id;
  final String title;
  final String imageURL;
  final String release_date;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.imageURL,
    required this.release_date,
    required this.overview,
  });

  String getPosterImageUrl() => imageUrlPrefix + imageURL;  // Método para obter a URL completa da imagem

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      imageURL: map['poster_path'] ?? '',
      release_date: map['release_date'] ?? '',
      overview: map['overview'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageURL': imageURL,
      'release_date': release_date,
      'overview': overview,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'];
    final imageUrl = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : '';
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageURL: imageUrl,
      release_date: json['release_date'] ?? '',
      overview: json['overview'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
}
