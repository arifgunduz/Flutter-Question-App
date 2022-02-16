import 'package:flutter/material.dart';
import 'package:proje_bitirme/common/theme_destek.dart';
import 'package:proje_bitirme/models/dto/test_sonuc.dart';
import 'package:proje_bitirme/screens/cozulen_testler_ekran.dart';
import 'package:proje_bitirme/widgets/disco_button.dart';

class TestSonucEkran extends StatefulWidget {
  TestSonucEkran(this.sonuc, {Key? key}) : super(key: key);

  static const routeName = '/testSonuc';
  TestSonuc sonuc;

  @override
  _TestSonucEkranState createState() => _TestSonucEkranState(this.sonuc);
}

class _TestSonucEkranState extends State<TestSonucEkran> {
  TestSonuc sonuc;
  int toplamSoru = 0;
  double toplamDogru = 0;

  _TestSonucEkranState(this.sonuc);

  @override
  void initState() {
    setState(() {
      toplamDogru = sonuc.totalCorrect;
      toplamSoru = sonuc.quiz.questions.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: ThemeHelper.fullEkranBgBoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            testSonucInfo(sonuc),
            bottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget testSonucInfo(TestSonuc sonuc) {
    return Column(
      children: [
        Image(image: AssetImage("assets/images/sonuc.png")),
        Text(
          'Tebrikler',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          'Testi Bitirdiniz',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          'Score',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          '$toplamDogru/$toplamSoru',
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }

  Widget bottomButtons() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DiscoButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Kapat',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            width: 160,
            heigth: 80,
          ),
          DiscoButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, CozulenTestler.routeName);
            },
            child: Text(
              'Çözülen Testler',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            width: 160,
            heigth: 80,
            isActive: true,
          ),
        ],
      ),
    );
  }
}
