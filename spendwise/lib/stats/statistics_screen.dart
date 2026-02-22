import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flchart/fl_chart.dart';
import '../../providers/transaction_provider.dart';
import '../../models/category_model.dart';
import '../../widgets/category_icon.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionProvider);
    final categoryExpenses = transactionState.getCategoryExpenses();
    final monthlySummary = transactionState.getMonthlySummary();

    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.light
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF6F5FC),
                  Color(0xFFEDEAF6),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1E2C),
                  Color(0xFF2D2A3A),
                ],
              ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your spending analysis',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Budget Alert
                    if (transactionState.isOverBudget)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warning_rounded,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Budget Alert!',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You\'ve exceeded your monthly budget of '
                                    '\$${NumberFormat('#,##0.00').format(transactionState.monthlyBudget)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Monthly Comparison Chart
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Comparison',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: _getMaxY(monthlySummary.values.toList()),
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor:
                                          Theme.of(context).colorScheme.surface,
                                      getTooltipItem: (
                                        BarChartGroupData group,
                                        int groupIndex,
                                        BarChartRodData rod,
                                        int rodIndex,
                                      ) {
                                        return BarTooltipItem(
                                          '\$${NumberFormat('#,##0.00').format(rod.toY)}',
                                          GoogleFonts.poppins(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index >= 0 &&
                                              index < monthlySummary.length) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                monthlySummary.keys.elementAt(index),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '\$${value.toInt()}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    show: true,
                                    drawHorizontalLine: true,
                                    horizontalInterval: 100,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.1),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  barGroups: monthlySummary.entries
                                      .map((entry) => BarChartGroupData(
                                            x: monthlySummary.keys
                                                .toList()
                                                .indexOf(entry.key),
                                            barRods: [
                                              BarChartRodData(
                                                toY: entry.value,
                                                color:
                                                    Theme.of(context).colorScheme.primary,
                                                width: 20,
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(4),
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Category Breakdown
                    if (categoryExpenses.isNotEmpty)
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Spending by Category',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onBackground,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    startDegreeOffset: -90,
                                    sections: _buildPieSections(
                                      context,
                                      categoryExpenses,
                                    ),
                                    pieTouchData: PieTouchData(
                                      touchCallback:
                                          (FlTouchEvent event, pieTouchResponse) {},
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ..._buildCategoryLegends(
                                context,
                                categoryExpenses,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(List<double> values) {
    if (values.isEmpty) return 100;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.1).ceilToDouble();
  }

  List<PieChartSectionData> _buildPieSections(
    BuildContext context,
    Map<String, double> categoryExpenses,
  ) {
    final total = categoryExpenses.values.fold(0.0, (a, b) => a + b);
    
    return categoryExpenses.entries.map((entry) {
      final category = Category.getCategoryById(entry.key);
      final percentage = (entry.value / total * 100);
      
      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        titleStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: category.color,
        radius: 70,
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  List<Widget> _buildCategoryLegends(
    BuildContext context,
    Map<String, double> categoryExpenses,
  ) {
    final total = categoryExpenses.values.fold(0.0, (a, b) => a + b);
    final sortedEntries = categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((entry) {
      final category = Category.getCategoryById(entry.key);
      final percentage = (entry.value / total * 100);
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            CategoryIcon(
              icon: category.icon,
              color: category.color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: entry.value / total,
                    backgroundColor: category.color.withOpacity(0.1),
                    color: category.color,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${NumberFormat('#,##0.00').format(entry.value)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}