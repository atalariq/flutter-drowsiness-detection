import 'package:flutter/material.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({super.key});

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        height: 200,
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color.fromRGBO(255, 184, 28, 0.4000000059604645),
                  ))),
          Positioned(
              top: 12.5,
              left: 15,
              child: Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Stat',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Roboto',
                                fontSize: 30,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                          SizedBox(width: 15),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: Color.fromRGBO(
                                  255, 184, 28, 0.4000000059604645),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Reset',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                  bottomLeft:
                                                      Radius.circular(16),
                                                  bottomRight:
                                                      Radius.circular(16),
                                                ),
                                                color: Color.fromRGBO(255, 184,
                                                    28, 0.4000000059604645),
                                              ))),
                                      Positioned(
                                          top: 16,
                                          left: 15,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Waktu Pemakaian',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 10,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  '02:34',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ])),
                                SizedBox(width: 15),
                                SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                  bottomLeft:
                                                      Radius.circular(16),
                                                  bottomRight:
                                                      Radius.circular(16),
                                                ),
                                                color: Color.fromRGBO(255, 184,
                                                    28, 0.4000000059604645),
                                              ))),
                                      Positioned(
                                          top: 16,
                                          left: 16,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Tingkat Kesadaran',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 10,
                                                      letterSpacing:
                                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  '91%',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ])),
                                SizedBox(width: 15),
                                SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                  bottomLeft:
                                                      Radius.circular(16),
                                                  bottomRight:
                                                      Radius.circular(16),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 184, 28, 0.4),
                                              ))),
                                      Positioned(
                                          top: 16,
                                          left: 23,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Tingkat Kantuk',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  '9%',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontFamily: 'Roboto',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 1),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ])),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Kondisi Anda masih Baik!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                height: 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ]));
  }
}
