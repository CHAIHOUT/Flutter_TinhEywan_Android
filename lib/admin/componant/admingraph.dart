// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_interpolation_to_compose_strings, unused_element

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BarChart2 extends StatefulWidget {
  const BarChart2({Key? key}) : super(key: key);

  @override
  State<BarChart2> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart2> {
  List<dynamic> users = [];
  //month
  double jan = 0;
  double feb = 0;
  double mar = 0;
  double apr = 0;
  double may = 0;
  double jun = 0;
  double jul = 0;
  double aug = 0;
  double sep = 0;
  double oct = 0;
  double nov = 0;
  double dec = 0;

  @override
  void initState() {
    super.initState();
    // This code runs once when the widget is created
    Fun_getTotalUser();
  }

  Future Fun_getTotalUser() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getalluser"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      users = resbody;
      for (var user in users) {
        // print("Name: ${user['name']}");
        DateTime createdAt = DateTime.parse(user['created_at']);
        int month = createdAt.month;
        if (month == 1) {
          jan = jan + 1;
          setState(() {
            jan;
          });
        } else if (month == 2) {
          feb = feb + 1;
          setState(() {
            feb;
          });
        } else if (month == 3) {
          mar = mar + 1;
          setState(() {
            mar;
          });
        } else if (month == 4) {
          apr = apr + 1;
          setState(() {
            apr;
          });
        } else if (month == 5) {
          may = may + 1;
          setState(() {
            may;
          });
        } else if (month == 6) {
          jul = jul + 1;
          setState(() {
            jul;
          });
        } else if (month == 7) {
          jun = jun + 1;
          setState(() {
            jun;
          });
        } else if (month == 8) {
          jul = jul + 1;
          setState(() {
            jul;
          });
        } else if (month == 9) {
          aug = aug + 1;
          setState(() {
            aug;
          });
        } else if (month == 10) {
          sep = sep + 1;
          setState(() {
            sep;
          });
        } else if (month == 11) {
          nov = nov + 1;
          setState(() {
            nov;
          });
        } else if (month == 12) {
          dec = dec + 1;
          setState(() {
            dec;
          });
        }
      }
    } else {
      // print("FAIL API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: darken(Colors.black, 0.2),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'JAN';
        break;
      case 1:
        text = 'FEB';
        break;
      case 2:
        text = 'MAR';
        break;
      case 3:
        text = 'APR';
        break;
      case 4:
        text = 'MAY';
        break;
      case 5:
        text = 'JUN';
        break;
      case 6:
        text = 'JUL';
        break;
      case 7:
        text = 'AUG';
        break;
      case 8:
        text = 'SEP';
        break;
      case 9:
        text = 'OCT';
        break;
      case 10:
        text = 'NOV';
        break;
      case 11:
        text = 'DEC';
        break;
      default:
        text = 'AUG';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          darken(Colors.black, 0.2),
          Colors.black,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: jan,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: feb,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: mar,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: apr,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: may,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: jun,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: jul,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
              toY: aug,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
              toY: sep,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
              toY: oct,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
              toY: nov,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
              toY: dec,
              gradient: _barsGradient,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  // Function to darken a color
  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

// class BarChartSample3 extends StatefulWidget {
//   const BarChartSample3({Key? key}) : super(key: key);

//   @override
//   State<BarChartSample3> createState() => BarChartSample3State();
// }

// class BarChartSample3State extends State<BarChartSample3> {
//   @override
//   Widget build(BuildContext context) {
//     return const AspectRatio(
//       aspectRatio: 1.6,
//       child: BarChart2(),
//     );
//   }
// }
