import 'dart:async'; // Import for Timer
import 'dart:convert';
import 'dart:ui'; // For ImageFilter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'gif_details_page.dart'; // Import the GIF Details Page

class GifyMainPage extends StatefulWidget {
  const GifyMainPage({super.key});

  @override
  State<GifyMainPage> createState() => _GifyMainPageState();
}

class _GifyMainPageState extends State<GifyMainPage> {
  final TextEditingController controller = TextEditingController();
  final String apiKey = 'BLgpDm6FVCDZ8D7Ygyalcuo0GbDsV0nh';
  final String baseUrl = "https://api.giphy.com/v1/gifs/search";
  List<dynamic> data = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  String errorMessage = '';
  int currentPage = 0;
  int limit = 25;
  bool hasMoreData = true;
  ScrollController scrollController = ScrollController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    scrollController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      if (controller.text.isNotEmpty) {
        getData(controller.text);
      }
    });
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoadingMore && hasMoreData) {
        getData(controller.text, isPagination: true);
      }
    }
  }

  Future<void> getData(String searchText, {bool isPagination = false}) async {
    if (isLoading || isLoadingMore) return;

    setState(() {
      if (isPagination) {
        isLoadingMore = true;
      } else {
        isLoading = true;
        currentPage = 0;
        hasMoreData = true;
        data.clear();
      }
      errorMessage = '';
    });

    try {
      final int offset = currentPage * limit;
      Uri url = Uri.parse(baseUrl).replace(queryParameters: {
        'api_key': apiKey,
        'q': searchText,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'rating': 'G',
        'lang': 'en',
      });

      var res = await http.get(url);
      if (res.statusCode == 200) {
        List<dynamic> newData = jsonDecode(res.body)["data"];

        setState(() {
          data.addAll(newData);
          isLoading = false;
          isLoadingMore = false;
          currentPage++;
          if (newData.length < limit) {
            hasMoreData = false;
          }
        });
      } else {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
          errorMessage = 'Error: ${res.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
        errorMessage = 'Failed to load data. Please try again.';
      });
    }
  }

  BoxFit _determineBoxFit(
      double gifWidth, double gifHeight, double cardWidth, double cardHeight) {
    double gifAspectRatio = gifWidth / gifHeight;
    double cardAspectRatio = cardWidth / cardHeight;
    return gifAspectRatio > cardAspectRatio ? BoxFit.cover : BoxFit.contain;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final int crossAxisCount = orientation == Orientation.portrait ? 2 : 3;

    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Vx.gray800,
      body: Theme(
        data: ThemeData.dark(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSearchField(),
                ),
                20.widthBox,
                _buildButton(),
              ],
            ).p12(),
            if (isLoading)
              const CircularProgressIndicator().centered().p16()
            else if (errorMessage.isNotEmpty)
              errorMessage.text.red500.xl2.makeCentered().p16()
            else
              Expanded(
                child: VxConditional(
                  condition: data.isNotEmpty,
                  builder: (context) => GridView.builder(
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      final gif = data[index]["images"]["fixed_height"];
                      final imgUrl = gif["url"].toString();
                      final gifWidth = double.parse(gif["width"]);
                      final gifHeight = double.parse(gif["height"]);

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final cardWidth = constraints.maxWidth;
                          final cardHeight = constraints.maxHeight;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GifDetailsPage(
                                    gifUrl: imgUrl,
                                    title: data[index]["title"] ?? "No Title",
                                    username: data[index]["username"] ??
                                        "No Username",
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              imgUrl,
                              fit: _determineBoxFit(
                                  gifWidth, gifHeight, cardWidth, cardHeight),
                              width: cardWidth,
                              height: cardHeight,
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : CircularProgressIndicator();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, color: Colors.red);
                              },
                            ).card.roundedSM.make().p4(),
                          );
                        },
                      );
                    },
                    itemCount: data.length,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  fallback: (context) =>
                      "Nothing found".text.gray500.xl3.makeCentered(),
                ),
              ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoNavigationBar(
        middle: const Text('GIPHY App'),
        backgroundColor: Colors.grey[900],
      );
    } else {
      return AppBar(
        title: const Text(
          'GIPHY App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 34,
          ),
        ),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      );
    }
  }

  Widget _buildSearchField() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoTextField(
        controller: controller,
        placeholder: 'Search',
      );
    } else {
      return TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Search",
        ),
      );
    }
  }

  Widget _buildButton() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoButton(
        child: const Text('Search'),
        color: CupertinoColors.activeBlue,
        onPressed: () {
          getData(controller.text);
        },
      );
    } else {
      return ElevatedButton(
        child: const Text('Search'),
        onPressed: () {
          getData(controller.text);
        },
      );
    }
  }
}
