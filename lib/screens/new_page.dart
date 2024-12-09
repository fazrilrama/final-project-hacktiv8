

import 'package:final_project/providers/news_provider.dart';
import 'package:final_project/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool isSwitched = false;
  bool _init = true;
  bool _isLoading = false;

  String payload = '';

  String _selectedOption = 'USA';
  final List<String> _dropdownOptions = ['USA', 'MEXICO', 'UNITED ARAB EMIRATES', 'NEW ZEALAND', 'ISRAEL', 'INDONESIA'];
  
  String _selectedOptionCategory = 'science';
  final List<String> _dropdownOptionsCategory = ['science', 'business', 'technology', 'sports', 'health', 'general', 'entertaiment', 'all'];
  String _selectedOptionChannel = 'BBC News';
  final List<String> _dropdownOptionsChannel = ['BBC News', 'Times of India', 'Politico', 'The Washington Post', 'Reuters', 'CNN', 'NBC NEWS', 'The Hills', 'FOX News'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_init) {  
      setState(() {
        _isLoading = true;
      });

      Provider.of<NewsProvider>(context, listen: false)
        .fetchNews()
        .then((value) {
          setState(() {
            _isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
          });
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('An error occurred!'),
              content: const Text('Something went wrong.'),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          );
        })
        .whenComplete(() {
          setState(() {
            _init = false;
          });
        });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            },
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (BuildContext context, NewsProvider value, Widget? child) { 
          return _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
              itemCount: value.news.length,
              itemBuilder: (context, index) {
                final news = value.news[index];
                String image;
                if (news.urlToImage != null && news.urlToImage!.isNotEmpty) {
                  image = news.urlToImage!;
                } else {
                  image = 'https://www.oregonlive.com/resizer/v2/AWHHECYC7BHLDBGPJWLSESUUXY.jpg?auth=fbf9e974918989ce821ebe86953bc423a72fca30d1214d0abe376ae50f26dfb1&width=1280&quality=90';
                }
                return Column(
                  children: [
                    buildNewsCard(
                      context,
                      // ignore: unnecessary_null_comparison
                      imageUrl: image,
                      title: news.title,
                      source: news.sourceName,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                );
              },
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(
                "Fazril Ramadhan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text("fazrilramadhan2000@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://via.placeholder.com/150"), // Ganti dengan URL gambar profil
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Country:",
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: _selectedOption,
                    items: _dropdownOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                      });

                      Provider.of<NewsProvider>(context, listen: false)
                        .fetchChange(_selectedOption, 'country')
                        .then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                        })
                        .catchError((error) {
                          setState(() {
                            _isLoading = false; 
                          });

                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('An error occurred!'),
                              content: const Text('Something went wrong.'),
                              actions: [
                                TextButton(
                                  child: const Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        })
                        .whenComplete(() {
                          setState(() {
                            _init = false;
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        });
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Category:",
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: _selectedOptionCategory,
                    items: _dropdownOptionsCategory.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOptionCategory = newValue!;
                      });

                      Provider.of<NewsProvider>(context, listen: false)
                        .fetchChange(_selectedOptionCategory, 'category')
                        .then((value) {})
                        .catchError((error) {

                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('An error occurred!'),
                              content: const Text('Something went wrong.'),
                              actions: [
                                TextButton(
                                  child: const Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Channel:",
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: _selectedOptionChannel,
                    items: _dropdownOptionsChannel.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOptionChannel = newValue!;
                      });

                      Provider.of<NewsProvider>(context, listen: false)
                        .fetchChange(_selectedOptionChannel, 'channel')
                        .then((value) {
                          // Jika berhasil, lakukan sesuatu jika diperlukan
                          setState(() {
                            _isLoading = false; // Menghentikan loading setelah API call selesai
                          });
                        })
                        .catchError((error) {
                          // Menangani error jika API gagal
                          setState(() {
                            _isLoading = false;  // Menghentikan loading jika error terjadi
                          });

                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('An error occurred!'),
                              content: const Text('Something went wrong.'),
                              actions: [
                                TextButton(
                                  child: const Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        })
                        .whenComplete(() {
                          // Bisa tambahkan logika lainnya jika diperlukan
                          setState(() {
                            _init = false;
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNewsCard(BuildContext context,
    {required String imageUrl, required String title, required String source}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              source,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}