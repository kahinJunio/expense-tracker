import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/providers/transaction_provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context);
    return Container(
      child: transactions.transactions.isEmpty
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
                            '\$${transactions.transactions[index].amount}',
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions.transactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd()
                          .format(transactions.transactions[index].date),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await transactions.removeItem(
                          transactions.transactions[index].id,
                        );
                      },
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      tooltip: 'Delete transaction',
                    ),
                  ),
                );
              },
              itemCount: transactions.transactions.length,
            ),
    );
  }
}
