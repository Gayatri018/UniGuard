import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                title: "Welcome to Uniguard!",
                subtitle: "An anonymous platform for reporting, support, and resources.",
                image: "assets/images/welcome.png",
              ),
              buildPage(
                title: "Report Anonymously",
                subtitle: "Submit reports with location and media evidence. Stay anonymous, stay safe.",
                image: "assets/images/report.png",
              ),
              buildPage(
                title: "Support & Resources",
                subtitle: "Join anonymous counseling sessions via Google Meet and access mental health & substance abuse resources.",
                image: "assets/images/support.png",
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Color(0xFF8D0E02),
                  ),
                ),
                SizedBox(height: 20),
                isLastPage
                    ? ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('onboardingComplete', true);
                    Navigator.pushReplacementNamed(context, '/landing_page');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8D0E02),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                      "Get Started",
                      style: TextStyle(color: Color(0xFFFBF4F4)),

                  ),
                )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({required String title, required String subtitle, required String image}) {
    return Container(
      color: Color(0xFFFBF4F4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8D0E02))),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}