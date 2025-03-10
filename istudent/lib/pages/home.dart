import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> images = [
    {
      "url": "images/barcamp.png",
      "link": "https://www.instagram.com/barcamp_cyberjaya/"
    },
    {
      "url": "images/umhack.jpeg",
      "link": "https://www.instagram.com/umhackathon/"
    },
    {
      "url": "images/usmhack.jpeg",
      "link": "https://www.instagram.com/vhack.usm/"
    }
  ];

  // Function to open the link
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Row
            Row(
              children: [
                Image.asset(
                  "images/wave.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Hello, Shahrizal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      "images/try.png",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Welcome Text
            const Text(
              "Welcome to,",
              style: TextStyle(
                color: Color.fromARGB(186, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // "I Student" Text
            Row(
              children: [
                const Text(
                  "I",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Student",
                  style: TextStyle(
                    color: Color.fromARGB(255, 213, 128, 0),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Carousel Slider with Clickable Images
            Center(
              child: CarouselSlider(
                items: images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () => _launchURL(image["link"]!), // Open the link when clicked
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              image["url"]!,
                              fit: BoxFit.contain,
                              height: 220,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 140,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
