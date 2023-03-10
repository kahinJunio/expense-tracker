import 'package:flutter/material.dart';
import '../models/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import './chart_bart.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.transactions,
  });
  final List<Map<String, Object>> transactions;
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context);
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactions.groupedTransactionValues
              .map((tx) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      tx['day'] as String,
                      tx['amount'] as double,
                      (transactions.totalSpending == 0.0
                              ? 0.0
                              : tx['amount'] as double) /
                          transactions.totalSpending,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
