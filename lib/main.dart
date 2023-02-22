import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './widgets/app_drawer.dart';
import './models/providers/transaction_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Expenses',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = _buildAppBar(context);

    final txList = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: const TransactionList());
    final appBody = SafeArea(
        child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!isLandScape) ..._buildPortraitContent(mediaQuery, appBar, txList),
      ],
    )));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      drawer: const AppDrawer(),
      body: appBody,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

void _startAddNewTransaction(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: ((context) => GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: const NewTraction(),
        )),
  );
}

List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
  return [
    SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.3,
      child: const Chart(),
    ),
    txList
  ];
}

Widget _buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text('Personal Expenses'),
    actions: [
      IconButton(
        onPressed: () => _startAddNewTransaction(context),
        icon: const Icon(Icons.add),
      )
    ],
  );
}
