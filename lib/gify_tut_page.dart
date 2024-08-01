import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class GifyMainPage extends StatefulWidget {
  const GifyMainPage({super.key});

  @override
  State<GifyMainPage> createState() => _GifyMainPageState();
}

class _GifyMainPageState extends State<GifyMainPage> {
  final TextEditingController controller = TextEditingController();

  // My API Giphy key: BLgpDm6FVCDZ8D7Ygyalcuo0GbDsV0nh
  final String url =
      "https://api.giphy.com/v1/gifs/search?api_key=BLgpDm6FVCDZ8D7Ygyalcuo0GbDsV0nh&limit=25&offset=0&rating=G&lang=en&q=";
  bool showLoading = false;
  var data;

  @override
  void initState() {
    super.initState();
  }

  getData(String searchText) async {
    showLoading = true;
    setState(() {});
    var res = await http.get((url + searchText) as Uri);
    data = jsonDecode(res.body)["data"];
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Vx.gray800,
        body: Theme(
          data: ThemeData.dark(),
          child: VStack([
            "Gify App".text.white.xl4.make().objectCenter(),
            [
              Expanded(
                  child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Search",
                ),
              )),
              30.widthBox,
              FilledButton(
                onPressed: () {
                  getData(controller.text);
                },
                child: const Text("Go"),
              ).h8(context)
            ]
                .hStack(
                    axisSize: MainAxisSize.max,
                    crossAlignment: CrossAxisAlignment.center)
                .p24(),
            if (showLoading)
              CircularProgressIndicator().centered()
            else
              VxConditional(
                condition: data != null,
                builder: (context) => GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.isMobile ? 2 : 3,
                  ),
                  itemBuilder: (context, index) {
                    final imgUrl =
                        data[index]["images"]["fixed_height"]["url"].toString();
                    return ZStack(
                      [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.8),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Image.network(
                          imgUrl,
                          fit: BoxFit.contain,
                        )
                      ],
                    ).card.roundedSM.make().p4();
                  },
                  itemCount: data.lenght,
                ),
                fallback: (context) =>
                    "Nothing found".text.gray500.xl3.makeCentered(),
              ).h(context.percentHeight * 40)
          ])
              .p16()
              .scrollVertical(physics: const NeverScrollableScrollPhysics()),

          // VxConditional(
          //   condition: data != null,
          //   builder: (context) => GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: context.isMobile ? 2 : 3,
          //     ),
          //     itemBuilder: (context, index) {
          //       final url =
          //           data[index]["images"]["fixed_height"]["url"].toString();
          //       return Image.network(url, fit: BoxFit.cover)
          //           .card
          //           .roundedSM
          //           .make();
          //     },
          //     itemCount: data.lenght,
          //   ),
          //   fallback: (context) => "Nothing found".text.gray500.xl3.make(),
          // ).h(context.percentHeight * 40)
        ));
  }
}
