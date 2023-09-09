import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; //for date formatting

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> repo = [];
  int selectedDays = 60;
  bool isLoading = true; // Indicates whether data is being fetched

  @override
  void initState() {
    super.initState();
    fetchData(selectedDays);
  }

  Future<void> fetchData(int days) async {
    final now = DateTime.now();
    final selectedDaysAgo = now.subtract(Duration(days: days));
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDaysAgo);
    final response = await http.get(
      Uri.parse(
          "https://api.github.com/search/repositories?q=created:%3E$formattedDate&sort=stars&order=desc"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        repo = data['items'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text('Most Starred GitHub Repositories'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: double.infinity,
              height: 30,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select days ',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedDays,
                        items: const [
                          DropdownMenuItem(
                            value: 30,
                            child: Text('Last 30 days'),
                          ),
                          DropdownMenuItem(
                            value: 60,
                            child: Text('Last 60 days'),
                          ),
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            selectedDays = newValue!;
                            isLoading =
                                true; //Set isLoading to true when changing days
                          });
                          fetchData(
                              selectedDays); // Fetch data based on the selected days
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.grey,
                      backgroundColor: Colors.transparent,
                    )) // Show progress indicator while loading
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: repo.length,
                      itemBuilder: (context, index) {
                        final repository = repo[index];
                        return Card(
                          elevation: 6.0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.redAccent,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  repository['owner']['avatar_url'],
                                ),
                              ),
                            ),
                            title: Text(
                              repository['name'].toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Description : ',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                          text: '${repository['description']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Stars : ',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${repository['stargazers_count']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ]),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: 'Owner : ',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${repository['owner']['login']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
