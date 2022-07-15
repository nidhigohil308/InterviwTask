import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo/event_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EventDataModel? eventData;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var url = Uri.parse('http://44.234.205.222/eventapp/api/home/data');
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      // var dataj=jsonDecode(response.body);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['success']) {
        var data = EventDataModel.fromJson(responseData['data']);
        eventData = data;
      }
      setState(() {});
      log(eventData!.advertisments.toString());
    }
  }

  packageDialog({List<Products>? productData, String? img, String? name}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                    shrinkWrap: true,
                    itemCount: productData!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(img!);
                    }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: eventData == null
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const TextField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    hintText: 'What are you looking for?',
                                    hintStyle: TextStyle(color: Colors.white),
                                    fillColor: Colors.grey),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.menu_rounded,
                                color: Colors.yellow[300]),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                padding: const EdgeInsets.all(10),
                                margin:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Icon(Icons.person,
                                    color: Colors.yellow[300]),
                              ),
                              const Text(
                                'Hello Rebutia',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(right: 10),
                                child: Icon(Icons.transform_rounded,
                                    color: Colors.yellow[300]),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Cart',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(Icons.shopping_cart_rounded,
                                        color: Colors.yellow[300]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: CarouselSlider(
                      options: CarouselOptions(height: 200.0, autoPlay: true),
                      items: eventData!.advertisments!.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: NetworkImage(i.imageUrl!),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                  right: 20,
                                  top: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.star_rate_rounded,
                                          color: Colors.black,
                                        ),
                                        Text('1.5K'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: eventData!.packages!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (() {
                            packageDialog(
                                productData:
                                    eventData!.packages![index].products!,
                                img:
                                    eventData!.packages![index].headerImageUrl!,
                                name: eventData!.packages![index].name!);
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            margin: const EdgeInsets.all(10),
                            height: 150,
                            width: 150,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 5,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Image.network(
                                    eventData!.packages![index].headerImageUrl!,
                                    height: 130,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                Text(eventData!.packages![index].name!)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    // padding: const EdgeInsets.only(top: 5),
                    height: 290,
                    color: Colors.white,
                    child: GridView.builder(
                      itemCount: eventData!.sections!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            children: [
                              Image.network(
                                eventData!.sections![index].imageUrl!,
                                // fit: BoxFit.cover,
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                eventData!.sections![index].title!,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
