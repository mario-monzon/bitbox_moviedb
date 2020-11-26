import 'package:bitbox_moviedb/models/popular.dart';
import 'package:bitbox_moviedb/net/api.dart';
import 'package:bitbox_moviedb/widget/card_swiper_widget.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text('Cine', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 25.0),),
       backgroundColor: Colors.deepPurple,
       actions: [
         IconButton(
             icon: Icon(Icons.search),
             onPressed: (){
               showSearch(
                   context: context,
                   delegate: null,
                   query: '' );
             }),
       ],
     ),
      body: Container(
        child: Center(
         child:  _swiperCards(context),
        ),
      ),
    );
  }

  Widget _swiperCards(BuildContext context) {
    return FutureBuilder<Response<Popular>>(
      // 2
      future: Provider.of<ApiService>(context).getPopularMovies(),
      builder: (context, snapshot) {
        // 3
        if (snapshot.connectionState == ConnectionState.done) {
          // 4
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }

          final popular = snapshot.data.body;
          return Text( '$popular' );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  } // _swiperTarjetas
}


// return snapshot.hasData ? CardSwiper( movies: snapshot.data ) : Center();