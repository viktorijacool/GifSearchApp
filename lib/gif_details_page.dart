import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class GifDetailsPage extends StatelessWidget {
  final String gifUrl;
  final String title;
  final String username;

  const GifDetailsPage({
    Key? key,
    required this.gifUrl,
    required this.title,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // White back button
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text(
          'GIF Details',
          style: TextStyle(color: Colors.white), // White title
        ),
        backgroundColor: Vx.gray900,
      ),
      backgroundColor: Vx.gray800,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display GIF in its full size
              Image.network(
                gifUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.error, color: Colors.red),
                  );
                },
              ).centered(),
              const SizedBox(height: 16.0),
              // Conditionally display the title card if title exists
              if (title.isNotEmpty) _buildInfoCard('Title:', title),
              const SizedBox(height: 8.0),
              // Conditionally display the username card if username exists
              if (username.isNotEmpty) _buildInfoCard('Username:', username),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4.0,
      color: Vx.gray700, // Card background color
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(
          label,
          style: const TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Vx.gray500),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14.0, color: Vx.gray300),
        ),
      ),
    );
  }
}
