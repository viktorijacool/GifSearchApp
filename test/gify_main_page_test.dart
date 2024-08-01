// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:gif_search_app/gify_main_page.dart';
// import 'package:http/http.dart' as http;
// import 'package:mockito/mockito.dart';

// class MockClient extends Mock implements http.Client {}

// void main() {
//   testWidgets('Search triggers getData function', (WidgetTester tester) async {
//     final mockClient = MockClient();

//     // Mock the http.get method to return a successful response
//     when(mockClient.get(any)).thenAnswer(
//       (_) async => http.Response('{"data": []}', 200),
//     );

//     // Build GifyMainPage with the mocked client
//     await tester.pumpWidget(MaterialApp(
//       home: GifyMainPage(client: mockClient),
//     ));

//     // Find the search field and the search button
//     final searchField = find.byType(TextField);
//     final searchButton = find.byType(ElevatedButton);

//     // Enter text into the search field
//     await tester.enterText(searchField, 'funny cats');
//     await tester.pump();

//     // Tap the search button
//     await tester.tap(searchButton);
//     await tester.pump();

//     // Verify that getData was called with the correct search term
//     verify(mockClient.get(Uri.parse(
//         'https://api.giphy.com/v1/gifs/search?api_key=BLgpDm6FVCDZ8D7Ygyalcuo0GbDsV0nh&q=funny%20cats&limit=25&offset=0&rating=G&lang=en')));
//   });
// }
