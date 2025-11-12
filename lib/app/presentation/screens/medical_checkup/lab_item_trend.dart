import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:mobile_app_2/app/presentation/screens/medical_checkup/all_lab_histories.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class LabItemTrend extends StatefulWidget {
  final String labTestName;
  final int id;
  const LabItemTrend({super.key, required this.labTestName, required this.id});

  @override
  State<LabItemTrend> createState() => _LabItemTrendState();
}

class _LabItemTrendState extends State<LabItemTrend> {
  int _selectedRangeIndex = 3;
  String range = '1Y';
  List<dynamic> trends = [];
  List<ItemHistory> itemHistories = [];
  bool isLoading = false;

  final List<String> _ranges = ['1W', '1M', '6M', '1Y'];

  Future<void> fetchLabItemTrendAndHistory() async {
    itemHistories.clear();
    trends.clear();
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });

      final hnNumber = await AuthLocalDataSourceImpl().getHnNumber();
      final response = await ApiService()
          .get('patients/$hnNumber/lab-items/${widget.id}/trends?range=$range');
      final response2 = await ApiService().get(
          'patients/$hnNumber/lab-items/${widget.id}/history?page=1&limit=3');

      if (response.statusCode == 200 && response2.statusCode == 200) {
        final trendBody = jsonDecode(response.body);
        final historyBody = jsonDecode(response2.body);

        if (trendBody['trend'] is List && historyBody['history'] is List) {
          trends.addAll(trendBody['trend']);
          for (var v in historyBody['history']) {
            itemHistories.add(
              ItemHistory.fromJson(v),
            );
          }
        }
      } else {
        throw Exception('Error Fetching Data ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Fetching Data $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onRangeSelected(int index) {
    if (_selectedRangeIndex != index) {
      setState(() {
        _selectedRangeIndex = index;
        range = _ranges[index];
      });
      fetchLabItemTrendAndHistory();
    }
  }

  @override
  void initState() {
    super.initState();
    // Setting initial range to 1Y (index 3) to match common default
    _selectedRangeIndex = _ranges.indexOf('1Y');
    range = '1Y';
    fetchLabItemTrendAndHistory();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '${widget.labTestName} Trend',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildRangeSelectionButtons(),
            const SizedBox(height: 16),
            // Use loading state and dynamic chart builder
            isLoading
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ))
                : _buildLineChart(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllLabHistories(
                          id: widget.id,
                          title: widget.labTestName,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              // Wrap ListView in Expanded
              child: _buildHistoryList(),
            ),
          ],
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
        child: const Text('No trend data available for this range.'),
      );
    }

    final List<FlSpot> spots = trends.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final value = (entry.value['value'] as num).toDouble();
      return FlSpot(index, value);
    }).toList();

    // 3. Determine min/max Y values for better chart scaling
    // Add a buffer around min/max values if data exists
    double? minY = spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5
        : null;
    double? maxY = spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5
        : null;

    if (minY == null || maxY == null || (maxY - minY).abs() < 10) {
      // Handle case where only one point exists or range is too small
      final center = spots.isNotEmpty ? spots.first.y : 100.0;
      minY = center - 5;
      maxY = center + 5;
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(
          8, 16, 16, 16), // Adjusted padding for titles
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
          maxX: spots.isNotEmpty ? spots.length.toDouble() - 1 : 1,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Only show titles for the first and last point
                  if (value == 0 || value == spots.length.toDouble() - 1) {
                    final index = value.toInt();
                    if (index >= 0 && index < trends.length) {
                      final dateStr = trends[index]['date'] as String;
                      final date = DateTime.tryParse(dateStr);
                      String title = '';
                      // Format date based on selected range
                      if (date != null) {
                        if (range == '1W') {
                          // E.g., 11/02 (Day/Month)
                          title =
                              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
                        } else {
                          // E.g., 02/25 (Month/Year)
                          title =
                              '${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
                        }
                      }
                      return SideTitleWidget(
                        meta: meta,
                        space: 8.0,
                        child:
                            Text(title, style: const TextStyle(fontSize: 10)),
                      );
                    }
                  }
                  return Container();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.left,
                  );
                },
                interval: (maxY - minY) / 4, // Simple interval calculation
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
              left: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
              right: BorderSide.none,
              top: BorderSide.none,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.lightBlueAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 4,
                        color: Colors.lightBlueAccent,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      )),
              belowBarData: BarAreaData(show: false),
            ),
            // Removed the second hardcoded line chart bar
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final monthFormatter = DateFormat('MMM');
    final dateFormatter = DateFormat('dd');
    final hourFormatter = DateFormat('hh:mm');
    return itemHistories.isEmpty && isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : itemHistories.isEmpty
            ? Container(
                height: 200,
                alignment: Alignment.center,
                child: const Text('No History data available for this range.'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemHistories.length,
                itemBuilder: (context, index) {
                  final dateString = itemHistories[index].date;
                  DateTime date = DateTime.parse(dateString!);
                  final month = monthFormatter.format(date);
                  final day = dateFormatter.format(date);
                  final hour = hourFormatter.format(date);
                  final value = itemHistories[index].value;
                  final unit = itemHistories[index].unit;
                  final status = itemHistories[index].status;
                  Color statusColor = Colors.grey;
                  if (status != null) {
                    final statusLower = status.toLowerCase().trim();

                    if (statusLower == 'normal') {
                      statusColor = Colors.green.shade700;
                    } else if (statusLower == 'low') {
                      statusColor = Colors.orange.shade600;
                    } else if (statusLower == 'high') {
                      statusColor = Colors.orange.shade800;
                    } else if (statusLower == 'very high') {
                      statusColor = Colors.red.shade700;
                    } else if (statusLower == 'dangerously high') {
                      statusColor = Colors.red.shade900;
                    } else if (statusLower == 'stage 1') {
                      statusColor = Colors.green.shade600;
                    } else if (statusLower == 'stage 2') {
                      statusColor = Colors.yellow.shade800;
                    } else if (statusLower == 'stage 3') {
                      statusColor = Colors.orange.shade700;
                    } else if (statusLower == 'stage 4') {
                      statusColor = Colors.red.shade700;
                    } else if (statusLower == 'stage 5') {
                      statusColor = Colors.red.shade900;
                    }
                  }
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                month,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                day,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hour,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$value  $unit',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              status ?? 'Status',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
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

class ItemHistory {
  String? date;
  double? value;
  String? unit;
  String? status;
  ItemHistory({this.date, this.value, this.unit, this.status});

  ItemHistory.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    value = double.parse('${json['value']}');
    unit = json['unit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['date'] = date;
    data['value'] = value;
    data['unit'] = unit;
    data['status'] = status;
    return data;
  }
}
