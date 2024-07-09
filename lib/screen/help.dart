import 'package:flutter/material.dart';
import '../component/faq.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Widget _createQA(String question, String answer) {
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
      ansPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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

              _createQA(
                """Apa itu Si Perisai?""",
                """Aplikasi Si Perisai merupakan kepanjangan dari sistem peringatan dini microsleep berbasis Artificial Intelligence (AI). Ketika tanda-tanda microsleep terdeteksi, aplikasi ini memberikan peringatan suara untuk membangunkan pengemudi dan mencegah kecelakaan.""",
              ),

              _createQA(
                """Apa itu microsleep?""",
                """Microsleep adalah sebuah kondisi di mana seseorang dalam beraktivitas tiba-tiba tertidur singkat persekian detik, penyebabnya karena kondisi yang sudah sangat lelah.""",
              ),

              _createQA(
                """Saya terdeteksi microsleep, apa yang sebaiknya saya lakukan?""",
                """Sangat disarankan untuk istirahat/tidur sejenak minimal 30 menit. Jika tidak memungkinkan, Anda dapat meminum kopi atau mendengarkan musik yang energik untuk membantu Anda tetap terjaga selama mengemudi.""",
              ),
            ],
          ),
        ));
  }
}

