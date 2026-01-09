import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop_nauval/gridelectronic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchProduct = TextEditingController();
  PageController bannerController = PageController();
  List<dynamic> listProductItem = [];
  Timer? bannerTimer;
  int indexBanner = 0;
  @override
  void initState() {
    super.initState();
    bannerController.addListener(() {
      setState(() {
        indexBanner = bannerController.page?.round() ?? 0;
      });
    });
    bannerOnBoarding();
    getProductItem();
  }

  void bannerOnBoarding() {
    bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (indexBanner < 2) {
        indexBanner++;
      } else {
        indexBanner = 0;
      }
      bannerController.animateToPage(
        indexBanner,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> getProductItem() async {
    String urlProductItem =
        "http://10.0.3.2/servershop_nauval/allproductitem.php";
    try {
      var response = await http.get(Uri.parse(urlProductItem));
      setState(() {
        listProductItem = json.decode(response.body);
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> bannerImage = [
      "lib/images/banner1.png",
      "lib/images/banner2.png",
      "lib/images/banner3.png"
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nauval Online Shop",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GridElectronic(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: searchProduct,
              decoration: const InputDecoration(
                hintText: 'Search Product',
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 13),
                suffixIcon:
                    Icon(Icons.filter_list, color: Colors.black, size: 17),
                prefixIcon:
                    Icon(Icons.arrow_back, color: Colors.black, size: 17),
                filled: true,
                fillColor: Color.fromARGB(255, 233, 240, 234),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: bannerController,
                itemCount: bannerImage.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    bannerImage[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 90,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GridElectronic(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/images/icon_elektronik.png',
                                height: 45,
                                width: 45,
                              ),
                              const Text(
                                'Electronic',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GridElectronic(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/images/icon_bajuPria.png',
                                height: 45,
                                width: 45,
                              ),
                              const Text(
                                'Baju pria',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GridElectronic(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/images/icon_bajuWanita.png',
                                height: 45,
                                width: 45,
                              ),
                              const Text(
                                'Dress',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GridElectronic(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/images/icon_sepatuPria.png',
                                height: 45,
                                width: 45,
                              ),
                              const Text(
                                'Sepatu Pria',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GridElectronic(),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/images/icon_sepatuWanita.png',
                                height: 45,
                                width: 45,
                              ),
                              const Text(
                                'Heels',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Popular Product',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (listProductItem.isEmpty) ...[
                    const Center(
                      child: Text(
                        'Product Not Found',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    )
                  ] else ...[
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: listProductItem.length,
                        itemBuilder: (context, index) {
                          final productItem = listProductItem[index];
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 5,
                              child: Column(
                                children: [
                                  Image.network(
                                    productItem['images'],
                                    height: 120,
                                    width: 150,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 5, 10, 0),
                                    child: Text(
                                      productItem['name'] ?? 'Product',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 5, 10, 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 1),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Rp ${productItem['price'] ?? '0'}',
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
