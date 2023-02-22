import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> get transactions {
    return [..._transactions];
  }

//recent transactions
  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0;
      for (int i = 0; i < _transactions.length; i++) {
        if (_recentTransactions[i].date.day == weekDay.day &&
            _recentTransactions[i].date.month == weekDay.month &&
            _recentTransactions[i].date.year == weekDay.year) {
          totalSum += _recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
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

// get all transactions
  Future<void> getAllTx() async {
    try {
      final url = Uri.https('expensetracker-2b853-default-rtdb.firebaseio.com',
          '/transactions.json');
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Transaction> loadedData = [];
      extractedData.forEach((txId, tx) {
        loadedData.insert(
          0,
          Transaction(
            id: txId,
            title: tx['title'],
            amount: tx['amount'],
            date: DateTime.parse(tx['date']),
          ),
        );
      });
      _transactions = loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> add(Transaction transaction) async {
    try {
      final url = Uri.https('expensetracker-2b853-default-rtdb.firebaseio.com',
          '/transactions.json');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': transaction.title,
            'date': transaction.date.toIso8601String(),
            'amount': transaction.amount
          },
        ),
      );
      _transactions.insert(
        0,
        Transaction(
          id: json.decode(response.body)['name'],
          title: transaction.title,
          amount: transaction.amount,
          date: transaction.date,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
