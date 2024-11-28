// ignore_for_file: non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  //TOTAL & %
  double vip_percent = 0;
  double medium_percent = 0.0;
  double standard_percent = 0.0;

  @override
  void initState() {

    super.initState();

    Fun_getCalculate();
  }

  //Calculate %
  Future Fun_getCalculate() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/counteywan"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      //Total Eywan
      var resbody = jsonDecode(res.body);
      var total_eyewan = resbody;
      // print("resbody $resbody");

      //Total VIP
      final res_vip = await http.get(
        Uri.parse("https://tinheywan.com/api/getallvip"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (res_vip.statusCode == 200) {
        var res_vip_body = jsonDecode(res_vip.body)['data'];
        var total_vip = res_vip_body.length;
        // print("TOTAL VIP = $total_vip");

        setState(() {
          vip_percent = double.parse(
              ((total_vip / total_eyewan) * 100).toStringAsFixed(2));
        });
      }

      //Total MEDIUM
      final res_medium = await http.get(
        Uri.parse("https://tinheywan.com/api/getallmedium"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (res_medium.statusCode == 200) {
        var res_medium_body = jsonDecode(res_medium.body)['data'];
        var total_medium = res_medium_body.length;
        // print("TOTAL MEDIUM = $total_medium");

        setState(() {
          medium_percent = double.parse(
              ((total_medium / total_eyewan) * 100).toStringAsFixed(2));
        });
      }

      //Total STANDARD
      final res_standard = await http.get(
        Uri.parse("https://tinheywan.com/api/getallstandard"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (res_standard.statusCode == 200) {
        var res_standard_body = jsonDecode(res_standard.body)['data'];
        var total_standard = res_standard_body.length;
        // print("TOTAL STANDARD = $total_standard");

        setState(() {
          standard_percent = double.parse(
              ((total_standard / total_eyewan) * 100).toStringAsFixed(2));
        });
      }
    } else {
      print("FAIL API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: AppColors.contentColorYellow,
                text: 'STANDARD',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Color.fromARGB(255, 223, 223, 10),
                text: 'VIP',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: AppColors.contentColorGreen,
                text: 'MEDIUM',
                isSquare: true,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: 30,
            title: '$standard_percent%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: 15,
            title: '$vip_percent%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: 15,
            title: '$medium_percent%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class AppColors {
  static const Color contentColorBlue = Color.fromARGB(255, 223, 15, 15);
  static const Color contentColorYellow = Color.fromARGB(255, 255, 149, 0);
  static const Color contentColorPurple = Color.fromARGB(255, 233, 233, 10);
  static const Color contentColorGreen = Color.fromARGB(255, 31, 232, 58);
  static const Color mainTextColor1 = Color(0xFF212121);
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
