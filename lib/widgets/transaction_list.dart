import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/providers/transaction_provider.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({
    super.key,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TransactionProvider>(context, listen: false)
          .getAllTx()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;
    print(transactions.length);
    return Container(
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 100,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                            '\$${transactions[index].amount}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd().format(transactions[index].date),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      tooltip: 'Delete transaction',
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
