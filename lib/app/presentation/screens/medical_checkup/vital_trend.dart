import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';
import 'package:intl/intl.dart';
import '../../../../Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import '../../../utilities/api_service.dart';

class VitalTrend extends StatefulWidget {
  const VitalTrend({super.key});

  @override
  State<VitalTrend> createState() => _VitalTrendState();
}

class _VitalTrendState extends State<VitalTrend> {
  List<dynamic> trends = [];
  List<dynamic> histories = [];
  bool isLoading = false;
  bool isHistoryLoading = false;
  final List<String> _ranges = ['1W', '1M', '6M', '1Y'];
  int _selectedRangeIndex = 3;
  String range = '1Y';
  bool onClick = false;
  bool isSending = false;

  final weightController = TextEditingController();
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();

  void _onRangeSelected(int index) {
    if (_selectedRangeIndex != index) {
      setState(() {
        _selectedRangeIndex = index;
        range = _ranges[index];
      });
      fetchVitalTrend();
    }
  }

  Future<void> fetchVitalTrend() async {
    try {
      setState(() {
        isLoading = true;
      });
      trends.clear();
      final hnNumber = await AuthLocalDataSourceImpl().getHnNumber();
      final response = await ApiService()
          .get('patients/$hnNumber/vitals/trends?range=$range');
      if (response.statusCode == 200) {
        final trendBody = jsonDecode(response.body);
        if (trendBody['data_points'] is List) {
          trends.addAll(trendBody['data_points']);
        }
        print(trends);
      } else {
        throw Exception('Error Fetching Data ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Fetching Data $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchHistory() async {
    try {
      histories.clear();
      setState(() {
        isHistoryLoading = true;
      });
      final hnNumber = await AuthLocalDataSourceImpl().getHnNumber();
      final response = await ApiService()
          .get('patients/$hnNumber/vitals/history/all?page=1&limit=4');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['history'] is List) {
          histories.addAll(body['history']);
        }
      } else {
        throw Exception('Error Fetching Data ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Fetching Data $e');
    } finally {
      setState(() {
        isHistoryLoading = false;
      });
    }
  }

  Future<void> addNewVitalInfo(
      double weight, double systolic, double diastolic) async {
    try {
      setState(() {
        isSending = true;
      });
      final hnNumber = await AuthLocalDataSourceImpl().getHnNumber();
      final response = await ApiService().post(
        'patients/$hnNumber/vitals',
        {
          "weight": weight,
          "systolic": systolic,
          "diastolic": diastolic,
        },
      );
      if (response.statusCode == 201) {
        fetchHistory();
        fetchVitalTrend();
      } else {
        throw Exception('Error send the data ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error send the data $e');
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  void clearText() {
    weightController.clear();
    systolicController.clear();
    diastolicController.clear();
  }

  @override
  void initState() {
    super.initState();
    // Setting initial range to 1Y (index 3) to match common default
    _selectedRangeIndex = _ranges.indexOf('1Y');
    range = '1Y';
    fetchVitalTrend();
    fetchHistory();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    weightController.dispose();
    systolicController.dispose();
    diastolicController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Historical Trend',
          // ignore: undefined_identifier
          style: appbarTestStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isDismissible: false,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return AnimatedContainer(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: onClick ? 800 : 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                duration: Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: AlignmentGeometry.center,
                      child: Card(
                        color: Colors.grey,
                        child: const SizedBox(
                          width: 80,
                          height: 8,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add New Vital Info',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              onClick = false;
                            });
                            clearText();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            CupertinoIcons.xmark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Fill In the value below!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          onTap: () {
                            setState(() {
                              onClick = true;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              onClick = false;
                            });
                          },
                          controller: weightController,
                          decoration: InputDecoration(
                            hintText: 'e.g., 75',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Color(0xffa6c7cfff),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Systolic',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.44,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    onClick = false;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    onClick = true;
                                  });
                                },
                                controller: systolicController,
                                decoration: InputDecoration(
                                  hintText: 'e.g., 120',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffa6c7cfff),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diastolic',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.44,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    onClick = false;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    onClick = true;
                                  });
                                },
                                controller: diastolicController,
                                decoration: InputDecoration(
                                  hintText: 'e.g., 80',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xffa6c7cfff),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () async {
                          await addNewVitalInfo(
                            double.parse(
                              weightController.text.trim(),
                            ),
                            double.parse(
                              systolicController.text.trim(),
                            ),
                            double.parse(
                              diastolicController.text.trim(),
                            ),
                          );
                          setState(() {
                            onClick = false;
                          });
                          clearText();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(15),
                            )),
                        child: isSending
                            ? CircularProgressIndicator()
                            : Text(
                                'Save Reading',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            onClick = false;
                          });
                          clearText();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(15),
                            )),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              histories.isEmpty
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          color: Color(0xffedfaf1),
                          child: SizedBox(
                            height: 90,
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.teal,
                                        child: Icon(
                                          Icons.monitor_weight_outlined,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      Text(
                                        'Latest Weight',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '${histories[0]['weight']} kg',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.lightBlue.shade100,
                          child: SizedBox(
                            height: 90,
                            width: 150,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.cyan,
                                        child: Icon(
                                          Icons.bloodtype,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Latest BP',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    '${histories[0]['systolic']}/${histories[0]['diastolic']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
              const SizedBox(height: 16),
              _buildRangeSelectionButtons(),
              const SizedBox(height: 16),
              isLoading
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ))
                  : _buildLineChart(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 20,
                        child: Card(
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Weight')
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 20,
                        child: Card(
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Systolic')
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 20,
                        child: Card(
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Diastolic')
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _buildHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRangeSelectionButtons() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_ranges.length, (index) {
          return GestureDetector(
            onTap: () => _onRangeSelected(index), // Use dynamic handler
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedRangeIndex == index
                    ? Colors.white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _ranges[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _selectedRangeIndex == index
                      ? Colors.blueAccent
                      : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLineChart() {
    if (trends.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const Text('No data available.'),
      );
    }

    // Convert data points into line chart spots
    final List<FlSpot> weightSpots = [];
    final List<FlSpot> systolicSpots = [];
    final List<FlSpot> diastolicSpots = [];

    for (int i = 0; i < trends.length; i++) {
      final point = trends[i];
      weightSpots
          .add(FlSpot(i.toDouble(), (point['weight'] as num).toDouble()));
      systolicSpots
          .add(FlSpot(i.toDouble(), (point['systolic'] as num).toDouble()));
      diastolicSpots
          .add(FlSpot(i.toDouble(), (point['diastolic'] as num).toDouble()));
    }

    // Compute Y-axis min and max with a little buffer
    final allValues = [
      ...weightSpots.map((e) => e.y),
      ...systolicSpots.map((e) => e.y),
      ...diastolicSpots.map((e) => e.y),
    ];
    double minY = allValues.reduce((a, b) => a < b ? a : b) - 5;
    double maxY = allValues.reduce((a, b) => a > b ? a : b) + 5;

    final dateFormatter = DateFormat('HH:mm');

    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: trends.length.toDouble() - 1,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < trends.length) {
                    final dateStr = trends[index]['created_at'] as String;
                    final date = DateTime.tryParse(dateStr);
                    return SideTitleWidget(
                      meta: meta,
                      space: 8.0,
                      child: Text(
                        date != null ? dateFormatter.format(date) : '',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 10),
                  );
                },
                interval: (maxY - minY) / 4,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
              left: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: weightSpots,
              isCurved: true,
              color: Colors.orange,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
            LineChartBarData(
              spots: systolicSpots,
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
            LineChartBarData(
              spots: diastolicSpots,
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final monthFormatter = DateFormat('MMM');
    final dateFormatter = DateFormat('dd');

    return histories.isEmpty && isHistoryLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : histories.isEmpty
            ? Container(
                height: 200,
                alignment: Alignment.center,
                child: const Text('No History data available.'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: histories.length - 1,
                itemBuilder: (context, index) {
                  final dateString = histories[index + 1]['created_at'];
                  DateTime date = DateTime.parse(dateString!);
                  final month = monthFormatter.format(date);
                  final day = dateFormatter.format(date);
                  final weight = histories[index + 1]['weight'];
                  final systolic = histories[index + 1]['systolic'];
                  final diastolic = histories[index + 1]['diastolic'];
                  return Card(
                    color: const Color.fromARGB(255, 242, 240, 240),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  month,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  day,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$weight',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Systolic',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$systolic',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Diastolic',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$diastolic',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
