import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhom4/core/API/API_Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

final api = ApiService();

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<dynamic> currentWalletFuture;
  late String selectedMonth;
  List<String> recentMonths = [];
  double totalIncome = 0;
  double totalExpense = 0;

  Map<String, double> incomeByCategory = {};
  Map<String, double> expenseByCategory = {};
  Map<String, String> categoryNames = {};

  @override
  void initState() {
    super.initState();
    currentWalletFuture = getCurrentWallet();
    recentMonths = getRecentMonths(10);
    selectedMonth = DateFormat('MM/yyyy').format(DateTime.now());
    fetchDataForMonth(selectedMonth);
  }

  Future<dynamic> getCurrentWallet() async {
    final currentUser = await api.getUser(FirebaseAuth.instance.currentUser!.uid);
    final wallet = await api.getWalletById(currentUser['current_wallet_id']);
    return wallet;
  }

  List<String> getRecentMonths(int count) {
    final now = DateTime.now();
    return List.generate(count, (index) {
      final date = DateTime(now.year, now.month - index, 1);
      return DateFormat('MM/yyyy').format(date);
    }).reversed.toList();
  }

  Future<void> fetchDataForMonth(String month) async {
    try {
      final transactions = await api.getTransactionsByUser(FirebaseAuth.instance.currentUser!.uid);
      final filtered = (transactions ?? []).where((tx) {
        final txDate = DateTime.parse(tx['date']);
        final txMonth = DateFormat('MM/yyyy').format(txDate);
        return txMonth == month;
      }).toList();

      double income = 0;
      double expense = 0;
      incomeByCategory.clear();
      expenseByCategory.clear();
      categoryNames.clear();

      for (var tx in filtered) {
        try {
          final category = await api.getCategory(tx['category_id']);
          final amount = double.tryParse(tx['amount'].toString()) ?? 0;
          final catName = category['name'] ?? 'Không rõ';

          categoryNames[category['id']] = catName;

          if (category['type'] == 'income') {
            income += amount;
            incomeByCategory[catName] = (incomeByCategory[catName] ?? 0) + amount;
          } else {
            expense += amount;
            expenseByCategory[catName] = (expenseByCategory[catName] ?? 0) + amount;
          }
        } catch (e) {
          print('Lỗi lấy category cho giao dịch: $e');
        }
      }

      setState(() {
        totalIncome = income;
        totalExpense = expense;
      });
    } catch (e) {
      print('Lỗi khi tải dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Báo cáo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: currentWalletFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text(
                'Không thể tải dữ liệu ví.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final wallet = snapshot.data;
          final amount = wallet['amount'];
          final now = DateTime.now();
          final previousMonth = DateFormat('MM/yyyy').format(DateTime(now.year, now.month - 1));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Số dư hiện tại: ${NumberFormat("#,##0").format(double.parse(amount.toString()))} đ',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Các tháng gần đây:', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recentMonths.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final month = recentMonths[index];
                      final isSelected = selectedMonth == month;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMonth = month;
                          });
                          fetchDataForMonth(month);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green
                                : (month == previousMonth ? Colors.blue : const Color(0xFF1E1E1E)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            month,
                            style: TextStyle(
                              color: isSelected || month == previousMonth ? Colors.white : Colors.white70,
                              fontWeight: isSelected || month == previousMonth ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                const Text('Biểu đồ khoản thu:', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.black54,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              NumberFormat("#,##0").format(rod.toY),
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                NumberFormat.compact().format(value),
                                style: const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) =>
                                const Text("Thu", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: totalIncome,
                              width: 20,
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text('Biểu đồ khoản chi:', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.black54,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              NumberFormat("#,##0").format(rod.toY),
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                NumberFormat.compact().format(value),
                                style: const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) =>
                                const Text("Chi", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: totalExpense,
                              width: 20,
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                const Text('Thu theo nhóm:', style: TextStyle(color: Colors.white, fontSize: 16)),
                ...incomeByCategory.entries.map((e) => ListTile(
                      leading: const Icon(Icons.arrow_upward, color: Colors.greenAccent),
                      title: Text(e.key, style: const TextStyle(color: Colors.white)),
                      trailing: Text(
                        '${NumberFormat("#,##0").format(e.value)} đ',
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    )),

                const SizedBox(height: 16),

                const Text('Chi theo nhóm:', style: TextStyle(color: Colors.white, fontSize: 16)),
                ...expenseByCategory.entries.map((e) => ListTile(
                      leading: const Icon(Icons.arrow_downward, color: Colors.redAccent),
                      title: Text(e.key, style: const TextStyle(color: Colors.white)),
                      trailing: Text(
                        '${NumberFormat("#,##0").format(e.value)} đ',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
