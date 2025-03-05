import 'package:flutter/material.dart';
import 'package:sprintmap/mainwrapper.dart'; // Ensure this points to your main sidebar screen
import 'package:intro_slider/intro_slider.dart';

class IntroSliderPage extends StatefulWidget {
  const IntroSliderPage({super.key});

  @override
  IntroSliderPageState createState() => IntroSliderPageState();
}

class IntroSliderPageState extends State<IntroSliderPage> {
  final List<ContentConfig> slides = [];

  @override
  void initState() {
    super.initState();
    slides.addAll([
      ContentConfig(
        title: "Hello Food!",
        description: "The easiest way to order food from your favorite restaurant!",
        pathImage: "assets/images/hamburger.png",
        backgroundColor: Colors.green.shade700,
      ),
      ContentConfig(
        title: "Movie Tickets",
        description: "Book movie tickets for your family and friends!",
        pathImage: "assets/images/movie.png",
        backgroundColor: Colors.blue.shade700,
      ),
      ContentConfig(
        title: "Great Discounts",
        description: "Best discounts on every single service we offer!",
        pathImage: "assets/images/discount.png",
        backgroundColor: Colors.red.shade700,
      ),
      ContentConfig(
        title: "World Travel",
        description: "Book tickets of any transportation and travel the world!",
        pathImage: "assets/images/travel.png",
        backgroundColor: Colors.purple.shade700,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      listContentConfig: slides,
      renderSkipBtn: const Text("Skip"),
      renderNextBtn: const Text("Next"),
      renderDoneBtn: const Text("Done"),
      onDonePress: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainWrapper()), // Navigate to the main screen
        );
      },
      indicatorConfig: IndicatorConfig(
        colorActiveIndicator: Colors.white,
        colorIndicator: Colors.white60,
        sizeIndicator: 8.0,
        typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
      ),
      scrollPhysics: const BouncingScrollPhysics(),
    );
  }
}
