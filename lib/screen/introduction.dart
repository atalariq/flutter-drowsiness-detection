import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
// import 'home.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => IntroductionPageState();
}

class IntroductionPageState extends State<IntroductionPage> {

  void _onIntroEnd(context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildImage(String assetName, [double width = 300]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w500,
        fontFamily: "Roboto",
      ),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.zero,
      pageColor: Colors.white,
      pageMargin: EdgeInsets.zero,
      imageFlex: 2,
      imagePadding: EdgeInsets.zero,
      bodyAlignment: Alignment.topCenter,
      imageAlignment: Alignment.bottomCenter,
      safeArea: 30,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 10000,
      infiniteAutoScroll: true,

      pages: [
        PageViewModel(
          title: "Selamat Datang!",
          body:
              "Si Perisai siap membantu Anda.",
          image: _buildImage('app-logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "...",
          body: "...",
          image: _buildImage('app-logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "...",
          body: "...",
          image: _buildImage('app-logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "...",
          body: "...",
          image: _buildImage('app-logo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "...",
          body: "...",
          image: _buildImage('app-logo.png'),
          decoration: pageDecoration,
        ),
      ],

      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      showBackButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left

      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w500)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w500)),

      curve: Curves.fastLinearToSlowEaseIn,

      controlsMargin: const EdgeInsets.all(10),
      controlsPadding: const EdgeInsets.all(5),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(24.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
