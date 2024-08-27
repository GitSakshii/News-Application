import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/model/news_channel_headlines_model.dart';
import 'package:newsapp/view/category_screen.dart';
import 'package:newsapp/view/news_details_screen.dart';
import 'package:newsapp/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoryScreen()));
              },
              icon: Image.asset(
                'images/category_icon.png',
                height: 30,
                width: 30,
              )),
          centerTitle: true,
          title: Text(
            "News",
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          actions: [
            PopupMenuButton<FilterList>(
                initialValue: selectedMenu,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (FilterList item) {
                  switch (item) {
                    case FilterList.bbcNews:
                      name = 'bbc-news';
                      break;
                    case FilterList.aryNews:
                      name = 'ary-news';
                      break;
                    case FilterList.alJazeera:
                      name = 'al-jazeera-english';
                      break;
                    case FilterList.cnn:
                      name = 'cnn';
                      break;
                    case FilterList.independent:
                      name = 'independent';
                      break;
                    case FilterList.reuters:
                      name = 'reuters';
                      break;
                  }
                  setState(() {});
                },
                itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                      const PopupMenuItem(
                          value: FilterList.bbcNews, child: Text('BBC News')),
                      const PopupMenuItem(
                          value: FilterList.aryNews, child: Text('Ary News')),
                      const PopupMenuItem(
                          value: FilterList.alJazeera,
                          child: Text('AlJazeera News')),
                      const PopupMenuItem(
                          value: FilterList.cnn, child: Text('CNN News')),
                      const PopupMenuItem(
                          value: FilterList.independent,
                          child: Text('Indpendent'))
                    ])
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: height * .55,
              width: width,
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return (const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    ));
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                          snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          snapshot.data!.articles![index]
                                              .publishedAt
                                              .toString(),
                                          snapshot.data!.articles![index].author
                                              .toString(),
                                          snapshot.data!.articles![index]
                                              .description
                                              .toString(),
                                          snapshot
                                              .data!.articles![index].content
                                              .toString(),
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString())));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.6,
                                    width: width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * 0.02),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              spinKit2,
                                          errorWidget: (context, url, error) =>
                                              const Image(
                                                  image: AssetImage(
                                                      "images/splash_pic.jpg"))),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      child: Container(
                                        height: height * .22,
                                        padding: const EdgeInsets.all(15),
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    format.format(dateTime),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ));
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
