import 'package:flutter/material.dart';
import 'package:proje_bitirme/common/route_generator.dart';
import 'package:proje_bitirme/common/theme_destek.dart';
import 'package:proje_bitirme/stores/store.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await DersStore.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atanamayanlar',
      theme: ThemeHelper.getThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
