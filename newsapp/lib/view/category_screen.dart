import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/model/categorynewsmodel.dart';
import 'package:newsapp/view/home_screen.dart';
import 'package:newsapp/view/news_details_screen.dart';
import 'package:newsapp/view_model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String category = 'general';
  List<String> categoryList = [
    'General',
    'entertainment',
    'health',
    'sports',
    'business',
    'technology'
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          category = categoryList[index];
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: category == categoryList[index]
                                      ? Colors.blue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Center(
                                    child: Text(
                                  categoryList[index].toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: Colors.white),
                                )),
                              )),
                        ),
                      );
                    })),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<CategoryNewsModel>(
                  future: newsViewModel.fetchCategoryNewsApi(category),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return (const Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.blue,
                        ),
                      ));
                    } else {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
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
                                            snapshot.data!.articles![index]
                                                .urlToImage
                                                .toString(),
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            snapshot.data!.articles![index]
                                                .publishedAt
                                                .toString(),
                                            snapshot
                                                .data!.articles![index].author
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
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        height: height * .18,
                                        width: width * .3,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: const Center(
                                            child: SpinKitCircle(
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      height: height * 0.18,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 3,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 3,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
