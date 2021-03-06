import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_movie_videos_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/video.dart';
import 'package:movie_app/model/video_response.dart';
import 'package:movie_app/net/firebase.dart';
import 'package:movie_app/screens/video_player_screen.dart';
import 'package:movie_app/screens/wishlist_screen.dart';
import 'package:movie_app/style/theme.dart' as Style;
import 'package:movie_app/widgets/casts_widget.dart';
import 'package:movie_app/widgets/movie_info_widget.dart';
import 'package:movie_app/widgets/similar_movies_widget.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser.uid.toString();

class MoviesDetailScreen extends StatefulWidget {
  final Movie movie;

  MoviesDetailScreen({Key key, @required this.movie}) : super(key: key);

  @override
  _MoviesDetailScreenState createState() => _MoviesDetailScreenState(movie);
}

class _MoviesDetailScreenState extends State<MoviesDetailScreen> {
  final Movie movie;

  _MoviesDetailScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    movieVideosBloc..getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(
        builder: (context) {
          return SliverFab(
            floatingPosition: FloatingPosition(right: 20.0),
            floatingWidget: StreamBuilder<VideoResponse>(
                stream: movieVideosBloc.subject.stream,
                builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.error != null &&
                        snapshot.data.error.length > 0) {
                      return _buildErrorWidget(snapshot.data.error);
                    }
                    return _buildVideoWidget(snapshot.data);
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error);
                  } else {
                    return _buildLoadingWidget();
                  }
                }),
            expandedHeight: 200.0,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Style.Colors.mainColor,
                expandedHeight: 200.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    movie.title.length > 40
                        ? movie.title.substring(0, 37) + "..."
                        : movie.title,
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  background: Stack(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      movie.backPoster),
                              fit: BoxFit.cover)),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.0)),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0)
                          ])),
                    )
                  ]),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(0.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            movie.rating.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RatingBar.builder(
                            itemSize: 8.0,
                            initialRating: movie.rating / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              EvaIcons.star,
                              color: Style.Colors.secondColor,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 30.0,
                          padding: EdgeInsets.only(right: 20.0),
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.favorite),
                            color: Colors.pink,
                            iconSize: 30.0,
                            padding: EdgeInsets.only(bottom: 10.0),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          WishListScreen(uid)));
                              updateWishlist(movie.title);
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Text(
                        "OVERVIEW",
                        style: TextStyle(
                            color: Style.Colors.titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      child: Text(movie.overview,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              height: 1.5)),
                    ),
                    MoviesInfo(
                      id: movie.id,
                    ),
                    Casts(
                      id: movie.id,
                    ),
                    SimilarMovies(
                      id: movie.id,
                    )
                  ]),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container();
    //   Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       SizedBox(
    //         height: 25.0,
    //         width: 25.0,
    //         child: CircularProgressIndicator(
    //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //           strokeWidth: 4.0,
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("Error occurred: $error")],
      ),
    );
  }

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
        backgroundColor: Style.Colors.secondColor,
        child: Icon(Icons.play_arrow),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                      controller: YoutubePlayerController(
                          initialVideoId: videos[0].key,
                          flags: YoutubePlayerFlags(
                            forceHD: false,
                            autoPlay: true,
                          )))));
        });
  }
}
