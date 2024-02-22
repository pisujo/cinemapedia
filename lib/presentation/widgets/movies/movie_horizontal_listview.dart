import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

import '../../../config/helpers/human_formats.dart';

class MovieHorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListView({
    super.key,
    required this.movies,
    this.title,
    this.subtitle,
    this.loadNextPage,
  });

  @override
  State<MovieHorizontalListView> createState() =>
      _MovieHorizontalListViewState();
}

class _MovieHorizontalListViewState extends State<MovieHorizontalListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 350,
        //width: double.infinity,
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title != null || widget.subtitle != null)
                _Title(title: widget.title, subtitle: widget.subtitle),
              Expanded(
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: widget.movies.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FadeInRight(
                          child: _Slide(
                            movie: widget.movies[index],
                          ),
                        );
                      }))
            ]));
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStile = Theme.of(context).textTheme;

    return Container(
      //width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* image
          SizedBox(
              width: 150,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    width: 150,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      }
                      return FadeIn(child: child);
                    },
                    fit: BoxFit.cover,
                  ))),
          const SizedBox(
            height: 5,
          ),
          //* title
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
//                overflow: TextOverflow.ellipsis,
              style: textStile.titleMedium,
            ),
          ),
          //* Rating
          SizedBox(
            width: 150,
            child: Row(children: [
              Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
              const SizedBox(width: 5),
              Text('${movie.voteAverage}',
                  style: textStile.bodyMedium
                      ?.copyWith(color: Colors.yellow.shade800)),
              //const SizedBox(width: 5),
              const Spacer(),
              //            Text('(${movie.popularity})', style: textStile.bodySmall),
              Text(HumanFormats.number(movie.popularity),
                  style: textStile.bodySmall),
            ]),
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title({
    super.key,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    return Container(
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: [
          if (title != null) Text(title!, style: titleStyle),
          const Spacer(),
          if (subtitle != null)
            FilledButton.tonal(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {},
              child: Text(subtitle!),
            )
        ]));
  }
}
