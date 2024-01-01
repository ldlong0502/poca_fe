
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:poca/models/user_model.dart';
import 'package:poca/screens/admin/admin_statistics.dart';

import '../../../configs/constants.dart';
import '../../../utils/resizable.dart';

class UserChart extends StatefulWidget {
  const UserChart({super.key, required this.cubit});
  final AdminStatisticsCubit cubit;
  @override
  State<UserChart> createState() => _UserChartState();
}

class _UserChartState extends State<UserChart> {
  List<Color> gradientColors = [
    contentColorCyan,
    contentColorBlue,
  ];
  int maxUser = 0;
  int year = 2023;
  @override
  void initState() {
    maxUser = widget.cubit.listUsers.where((element) => !element.isAdmin && element.createdAt.year == year).length;
    super.initState();
  }
  bool showAvg = false;
  Map<int, int> countUsersByMonth(List<UserModel> users , int year) {
    Map<int, int> userCountByMonth = {};

    for (var user in users) {
      if(user.createdAt.year == year) {
        int month = user.createdAt.month;
        userCountByMonth[month] = (userCountByMonth[month] ?? 0) + 1;
      }
    }
    for (int month = 1; month <= 12; month++) {
      userCountByMonth[month] ??= 0;
    }
    return userCountByMonth;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Year',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Resizable.font(context, 20),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<int>(
                  value: year,
                  hint: const Text(
                    'Choose year',
                  ),
                  iconSize: 0,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Resizable.font(
                          context, 20)),
                  decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.only(left: 20),
                      fillColor:
                      secondaryColor.withOpacity(0.25),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(1000),
                      )),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      year = value!;
                      maxUser = widget.cubit.listUsers.where((element) => !element.isAdmin && element.createdAt.year == year).length;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Channel can't empty";
                    } else {
                      return null;
                    }
                  },
                  dropdownColor: secondaryColor,
                  items: [2023,2024].map((val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val.toString(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: LineChart(
                  showAvg ? avgData() : mainData(),
                ),
              ),
            ),
            SizedBox(
              width: 60,
              height: 34,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showAvg = !showAvg;
                  });
                },
                child: Text(
                  'avg',
                  style: TextStyle(
                    fontSize: 12,
                    color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white
    );

    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.white
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = (maxUser ~/ 5).toString();
        break;
      case 3:
        text = (maxUser * 3 ~/ 5).toString();
        break;
      case 5:
        text = maxUser.toString();
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    Map<int, int> userCountByMonth = countUsersByMonth(widget.cubit.listUsers.where((element) => !element.isAdmin).toList() , year);
    print(userCountByMonth);
    var list = convertMapToList(userCountByMonth);
    list.sort((a,b) => a.month.compareTo(b.month));
    print(list[0].month);
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return  FlLine(
            color: mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return  FlLine(
            color: mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:  AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles:  AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            ...list.map((e) =>   FlSpot((e.month-1).toDouble(), e.userCount.toDouble())).toList()
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData:  FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    Map<int, int> userCountByMonth = countUsersByMonth(widget.cubit.listUsers.where((element) => !element.isAdmin).toList() , year);
    print(userCountByMonth);
    var list = convertMapToList(userCountByMonth);
    list.sort((a,b) => a.month.compareTo(b.month));
    double avg = maxUser / 12;
    return LineChartData(
      lineTouchData:  LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return  FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return  FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles:  AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles:  AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            ...list.map((e) =>   FlSpot((e.month-1).toDouble(), avg)).toList()
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData:  FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MonthStats {
  final int month;
  final int userCount;

  MonthStats({required this.month, required this.userCount});
}

List<MonthStats> convertMapToList(Map<int, int> userCountByMonth) {
  return userCountByMonth.entries.map((entry) {
    return MonthStats(month: entry.key, userCount: entry.value);
  }).toList();
}