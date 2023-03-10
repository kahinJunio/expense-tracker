import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/providers/transaction_provider.dart';
import '../models/transaction.dart';

class NewTraction extends StatefulWidget {
  const NewTraction({super.key});

  @override
  State<NewTraction> createState() => _NewTractionState();
}

class _NewTractionState extends State<NewTraction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  void _submitData(TransactionProvider txprovider) {
    if (_amountController.text.isEmpty) {
      return;
    }
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);
    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }
    // widget.addTx(title, amount, _selectedDate);
    txprovider.add(Transaction(
      id: '',
      title: title,
      amount: amount,
      date: _selectedDate!,
    ));
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final txprovider = Provider.of<TransactionProvider>(context, listen: false);
    return Card(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (_) => _submitData,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              onSubmitted: (_) => _submitData,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No date choosen'
                        : DateFormat.yMd().format(_selectedDate!),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: const Text('Choose date'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                style: TextButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () => _submitData(txprovider),
                child: const Text('Add Transaction'))
          ])),
    );
  }
}
