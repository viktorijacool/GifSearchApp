import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gif_search_app/gify_main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Returns a MaterialApp or CupertinoApp based on the platform
    return Builder(
      builder: (context) {
        final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
        return MaterialApp(
          title: 'Flutter GIFy',
          debugShowCheckedModeBanner: false,
          theme: isIOS
              ? null
              : ThemeData(
                  primarySwatch: Colors.green,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
          home: GifyMainPage(),
        );
      },
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:gif_search_app/gify_main_page.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter GIFy',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: GifyMainPage(),
//     );
//   }
// }
