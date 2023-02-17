import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bart.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart(this.recentTransactions, {super.key});
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weedDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0;
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weedDay.day &&
            recentTransactions[i].date.month == weedDay.month &&
            recentTransactions[i].date.year == weedDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weedDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
      0.0,
      (previousValue, element) => previousValue + (element['amount'] as double),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues
              .map((tx) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(tx['day'] as String, tx['amount'] as double,
                        (tx['amount'] as double) / totalSpending),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
