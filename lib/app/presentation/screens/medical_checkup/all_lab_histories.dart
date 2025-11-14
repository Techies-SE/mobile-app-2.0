import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';
import '../../../../Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import '../../../utilities/api_service.dart';
import 'lab_item_trend.dart';

class AllLabHistories extends StatefulWidget {
  final int id;
  final String title;
  const AllLabHistories({super.key, required this.id, required this.title});

  @override
  State<AllLabHistories> createState() => _AllLabHistoriesState();
}

class _AllLabHistoriesState extends State<AllLabHistories> {
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;

  List<ItemHistory> itemHistories = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchLabItemHistory() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final hnNumber = await AuthLocalDataSourceImpl().getHnNumber();
      final response = await ApiService().get(
          'patients/$hnNumber/lab-items/${widget.id}/history?page=$currentPage');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final List newData = (body['history'] ?? []);
        if (newData.isEmpty) {
          setState(() => hasMore = false);
        } else {
          setState(() {
            itemHistories.addAll(newData.map((v) => ItemHistory.fromJson(v)));
            currentPage++;
          });
        }
      } else {
        throw Exception('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLabItemHistory();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        fetchLabItemHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthFormatter = DateFormat('MMM');
    final dateFormatter = DateFormat('dd');
    final hourFormatter = DateFormat('hh:mm');

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'All ${widget.title} History',
          style: appbarTestStyle,
        ),
      ),
      body: itemHistories.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : itemHistories.isEmpty
              ? const Center(
                  child: Text('No History data available for this range.'),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          itemCount: itemHistories.length + (isLoading ? 1 : 0),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index >= itemHistories.length) {
                              // bottom loader
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            final item = itemHistories[index];
                            final dateString = item.date ?? '';
                            final date = DateTime.tryParse(dateString);
                            final month =
                                date != null ? monthFormatter.format(date) : '';
                            final day =
                                date != null ? dateFormatter.format(date) : '';
                            final hour =
                                date != null ? hourFormatter.format(date) : '';

                            final value = item.value ?? '';
                            final unit = item.unit ?? '';
                            final status = item.status;
                            Color statusColor = Colors.grey;

                            if (status != null) {
                              final s = status.toLowerCase().trim();
                              if (s == 'normal') {
                                statusColor = Colors.green.shade700;
                              } else if (s == 'low') {
                                statusColor = Colors.orange.shade600;
                              } else if (s == 'high') {
                                statusColor = Colors.orange.shade800;
                              } else if (s == 'very high') {
                                statusColor = Colors.red.shade700;
                              } else if (s == 'dangerously high') {
                                statusColor = Colors.red.shade900;
                              } else if (s == 'stage 1') {
                                statusColor = Colors.green.shade600;
                              } else if (s == 'stage 2') {
                                statusColor = Colors.yellow.shade800;
                              } else if (s == 'stage 3') {
                                statusColor = Colors.orange.shade700;
                              } else if (s == 'stage 4') {
                                statusColor = Colors.red.shade700;
                              } else if (s == 'stage 5') {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(month,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(day,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(hour,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 8),
                                          Text('$value $unit',
                                              style: const TextStyle(
                                                  fontSize: 14)),
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
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
