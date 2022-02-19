import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/API-provider.dart';
import '../../views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: const HomeView(),
        ),
        providers: [ChangeNotifierProvider(create: (_) => TodoProvider())]);
  }
}
// end