import 'package:flutter/material.dart';
import 'package:proje_bitirme/screens/anasayfa_ekran.dart';

class SplashEkran extends StatefulWidget {
  const SplashEkran({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<SplashEkran> createState() => _SplashEkranState();
}

class _SplashEkranState extends State<SplashEkran> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AnasayfaEkran()));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/122.png'), fit: BoxFit.cover),
        ),
        /*  child: Container(
          child: Image(
            image: AssetImage('assets/images/splash-screen.png'),
          ),
        ),  */
      ),
    );
  }
}
