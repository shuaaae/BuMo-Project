import 'package:angkas_clone_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      // Page 1
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/on_boarding_img1.png',
              width: 300,
              height: 200,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Beat the traffic",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "You can reach your \ndestination quickly and safely",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/on_boarding_img2.png',
                width: 300, height: 200),
            SizedBox(
              height: 10,
            ),
            Text(
              "Value for your money",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "We offer fair prices and a service\nthat cares for the passenger.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/on_boarding_img3.png',
                width: 300, height: 200),
            SizedBox(
              height: 10,
            ),
            Text(
              "99.997% safety record",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "All our bikers have undergone\nbackground checks, safety training,\nand skills assessment.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          ],
        ),
      )
    ];

    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPageNotifier.value = page;
              });
            },
            children: _pages,
          ),
        ),
        CirclePageIndicator(
          size: 8.0,
          selectedSize: 8.0,
          itemCount: _pages.length,
          currentPageNotifier: _currentPageNotifier,
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (_currentPageNotifier.value != 2) {
                _currentPageNotifier.value += 1;
                _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 143, 249),
                  borderRadius: BorderRadius.circular(50)),
              child: const Center(
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
