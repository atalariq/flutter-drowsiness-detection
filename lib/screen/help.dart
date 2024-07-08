import 'package:flutter/material.dart';
import '../component/faq.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Widget _wFAQ(String question, String answer) {
    return FAQ(
      question: question,
      answer: answer,
      queStyle: TextStyle(
        fontSize: 16,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w500,
      ),
      ansStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontFamily: "Roboto",
        fontWeight: FontWeight.w400,
      ),
      // ansPadding: EdgeInsets.symmetric(horizontal: 60, vertical: 0),
      ansPadding: EdgeInsets.only(left: 55, right: 20, top: 10, bottom: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 32,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Title
              Text(
                'Pelajari',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
              ),

              // FAQ - 1
              _wFAQ(
                """Apa itu Si Perisai?""",
                data,
              ),

              // FAQ - 2
              _wFAQ(
                """Apa itu microsleep?""",
                data,
              ),

              // FAQ - 3
              _wFAQ(
                """Dimana sebaiknya saya menaruh perangkat saya?""",
                data,
              ),

              // FAQ - 4
              _wFAQ(
                """Saya terdeteksi microsleep, apa yang sebaiknya saya lakukan?""",
                data,
              ),
            ],
          ),
        ));
  }
}

String data = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc eu rutrum elit, et vehicula ante.
""";
