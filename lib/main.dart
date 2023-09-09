import 'package:flutter/material.dart';
import 'package:github_repository/screens/home_screen.dart';

void main() {
  runApp(const GitHubRepo());
}

class GitHubRepo extends StatelessWidget {
  const GitHubRepo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
