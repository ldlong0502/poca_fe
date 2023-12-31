import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/screens/admin/admin_statistics.dart';
import 'package:poca/utils/resizable.dart';

class ChannelReport extends StatelessWidget {
  const ChannelReport({super.key, required this.cubit});

  final AdminStatisticsCubit cubit;

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Special": cubit.listChannels
          .where((element) => !element.isUser)
          .length
          .toDouble(),
      "User": cubit.listChannels
          .where((element) => element.isUser)
          .length
          .toDouble(),
    };
    final gradientList = <List<Color>>[
      [
        const Color.fromRGBO(223, 250, 92, 1),
        const Color.fromRGBO(129, 250, 112, 1),
      ],
      [
        const Color.fromRGBO(129, 182, 205, 1),
        const Color.fromRGBO(91, 253, 199, 1),
      ],
      [
        const Color.fromRGBO(175, 63, 62, 1.0),
        const Color.fromRGBO(254, 154, 92, 1),
      ]
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Channels',
            style: TextStyle(
                color: textColor,
                fontSize: Resizable.font(context, 20),
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0 ,vertical: 20),
          child: PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            gradientList: gradientList,
            emptyColorGradient: const[
               Color(0xff6c5ce7),
              Colors.blue,
            ],
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 25,
            centerText: "CHANNELS",
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
        )
      ],
    );
  }
}
