import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'login_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController boardController = PageController();
  int indexPage = 0;

  List<Map<String, String>> boardingData = [
    {
      "title": "Welcome to ShopNauval",
      "subTitle": "Discover the best products at unbeatable prices.",
      "image":
          "https://down-id.img.susercontent.com/file/id-11134207-8224o-mh0vwu9vcg7ge8.webp",
    },
    {
      "title": "Man Shirt",
      "subTitle": "Explore our Man Shirt collection for every occasion.",
      "image":
          "https://smexpo.pertamina.com/data-smexpo/images/products/3398/galleries/2023082420102112345_1715080740.jpg",
    },
    {
      "title": "Women Shirt",
      "subTitle": "Explore our Women Shirt collection for every occasion.",
      "image":
          "https://evermos.com/home/wp-content/uploads/2024/11/ba4143fb-5b83-4213-996c-c573a5c58a84.jpeg",
    },
    {
      "title": "Man Shoes",
      "subTitle": "Step out in Man Shoes that combine style and comfort.",
      "image":
          "https://down-id.img.susercontent.com/file/sg-11134201-7req5-mdubpdio0gh7d0.webp",
    },
    {
      "title": "Get Started",
      "subTitle": "Begin your shopping journey with ShopNauval today!",
      "image":
          "https://down-id.img.susercontent.com/file/id-11134207-7rbk6-m8ecgncgxhsuea.webp",
    },
  ];

  @override
  void initState() {
    super.initState();
    boardController = PageController();
    boardController.addListener(() {
      setState(() {
        indexPage = boardController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    boardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: boardController,
              itemCount: boardingData.length,
              itemBuilder: (context, index) {
                return OnboardingLayout(
                  title: "${boardingData[index]['title']}",
                  subTitle: "${boardingData[index]['subTitle']}",
                  image: "${boardingData[index]['image']}",
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                indexPage == boardingData.length - 1
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text("Get Started"),
                      )
                    : const Text(""),
                Row(
                  children: List.generate(
                    boardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indexPage == index
                            ? Colors.black54
                            : Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (indexPage == boardingData.length - 1) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } else {
                      boardController.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease,
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  final String title;
  final String subTitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(
          image,
          height: 350,
          width: 300,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            subTitle,
            style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 17),
          ),
        ),
      ],
    );
  }
}
