import 'package:bitbox_moviedb/models/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {

  final List<Result> movies;

  CardSwiper({ @required this.movies});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemHeight: _screenSize.height * 0.5,
        itemWidth: _screenSize.width * 0.7,
        itemBuilder: (BuildContext context,int index){
          return Hero(
            tag: movies[index],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: movies[index]),
                child: FadeInImage(
                  image: NetworkImage( movies[index].posterPath ),
                  placeholder: AssetImage( 'assets/img/loading.gif' ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
} // CardSwiper
