import 'package:cinemapedia/infrastructure/datasource/moviedb_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repositoriy_impl.dart';

// este repositorio es inmutable, es decir, no se puede reemplazar por otros
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDataSource());
});
