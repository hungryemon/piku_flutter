import 'package:flutter/material.dart';
import 'package:piku_flutter/piku_sdk.dart';

import 'secrets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Piku"),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          PikuChatDialog.show(context,
              baseUrl: YOUR_URL,
              inboxIdentifier: YOUR_INBOX_IDENTIFIER,
              title: "Piku",
              contactIdentifier: "b6c78535-eebd-41b7-a4c8-f11d0155dc2e",
              conversationId: 186,
              enablePersistence: true,);
        }),
        body: Container());
  }
}
