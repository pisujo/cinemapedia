import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifiers, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifiers(fetchMoreMovies: fetchMoreMovies);
});

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifiers, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifiers(fetchMoreMovies: fetchMoreMovies);
});

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifiers, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifiers(fetchMoreMovies: fetchMoreMovies);
});

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifiers, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifiers(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifiers extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifiers({
    required this.fetchMoreMovies,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }
}
