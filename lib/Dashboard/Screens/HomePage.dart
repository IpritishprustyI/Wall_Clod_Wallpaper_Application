import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wall_clod/Dashboard/Components/FullScreen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {'Authorization': '563492ad6f91700001000001580cd7ac43574f7dace2433efd60628c'}).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {'Authorization': '563492ad6f91700001000001580cd7ac43574f7dace2433efd60628c'}).then(
            (value) {
          Map result = jsonDecode(value.body);
          setState(() {
            images.addAll(result['photos']);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WallClod', style: TextStyle(letterSpacing: 5),),
          actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0,bottom: 0.0,left: 20.0,right: 20.0),
              child: Container(
                child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 20,
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                    imageurl: images[index]['src']['large2x'],
                                  )));
                        },
                        child: Container(
                          color: Colors.black,
                          child: Image.network(
                            images[index]['src']['tiny'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton(
          onPressed:()  {loadmore();},
          child: Icon(Icons.arrow_downward),
          backgroundColor: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
