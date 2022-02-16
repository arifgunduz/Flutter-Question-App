import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proje_bitirme/models/cozulen_test_model.dart';
import 'package:proje_bitirme/models/ders_kategori.dart';
import 'package:proje_bitirme/models/ders_test.dart';
import 'package:proje_bitirme/models/dto/test_sonuc.dart';
import 'package:proje_bitirme/screens/anasayfa_ekran.dart';
import 'package:proje_bitirme/screens/cozulen_testler_ekran.dart';
import 'package:proje_bitirme/screens/dersler_detay_ekran.dart';
import 'package:proje_bitirme/screens/dersler_ekran.dart';
import 'package:proje_bitirme/screens/soru_ekran.dart';
import 'package:proje_bitirme/screens/splash_ekran.dart';
import 'package:proje_bitirme/screens/test_sonuc_ekran.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case SplashEkran.routeName:
        return MaterialPageRoute(builder: (_) => SplashEkran());
      case AnasayfaEkran.routeName:
        return MaterialPageRoute(builder: (_) => AnasayfaEkran());
      case SoruEkran.routeName:
        if (args is DersTest) {
          return MaterialPageRoute(
            builder: (_) => SoruEkran(args),
          );
        }
        return _errorRoute();
      case TestSonucEkran.routeName:
        if (args is TestSonuc) {
          return MaterialPageRoute(
            builder: (_) => TestSonucEkran(args),
          );
        }
        return _errorRoute();
      case DerslerEkran.routeName:
        return MaterialPageRoute(builder: (_) => DerslerEkran());

      case CozulenTestler.routeName:
        return MaterialPageRoute(builder: (_) => CozulenTestler());

      case DerslerDetay.routeName:
        if (args is DersKategori) {
          return MaterialPageRoute(
            builder: (_) => DerslerDetay(args),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(
            'ERROR: Please try again.',
            style: TextStyle(fontSize: 32),
          ),
        ),
      );
    });
  }
}
