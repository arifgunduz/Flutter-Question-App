import 'package:flutter/material.dart';
import 'package:proje_bitirme/common/theme_destek.dart';
import 'package:proje_bitirme/models/cozulen_test_model.dart';
import 'package:proje_bitirme/models/dto/test_sonuc.dart';
import 'package:proje_bitirme/screens/soru_ekran.dart';
import 'package:proje_bitirme/stores/store.dart';
import 'package:proje_bitirme/widgets/baslik_ekran.dart';
import 'package:proje_bitirme/widgets/disco_button.dart';

class CozulenTestler extends StatefulWidget {
  static const routeName = '/cozulenTestler';

  CozulenTestler({Key? key}) : super(key: key);

  @override
  _CozulenTestlerState createState() => _CozulenTestlerState();
}

class _CozulenTestlerState extends State<CozulenTestler> {
  List<CozulenTestModel> cozulenTestModelList = [];
  late DersStore dersStore;

  @override
  void initState() {
    dersStore = DersStore();
    dersStore.loadCozulenTest().then((value) {
      setState(() {
        cozulenTestModelList = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: ThemeHelper.fullEkranBgBoxDecoration(),
        child: Column(
          children: [
            BaslikEkran("Çözülen Testler"),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: List<CozulenTestModel>.from(cozulenTestModelList)
                    .map(
                      (e) => cozulenTestViewItem(e),
                    )
                    .toList(),
              ),
            ))
          ],
        ),
      ),
    ));
  }

  Widget cozulenTestViewItem(CozulenTestModel cozulenTest) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      decoration: ThemeHelper.roundBoxDeco(),
      child: Row(
        children: [
          Container(
            child: SizedBox(
              height: 115,
              width: 10,
              child: Container(
                decoration: ThemeHelper.roundBoxDeco(
                    color: ThemeHelper.shadowColor, radius: 10),
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cozulenTest.quizTitle.isEmpty
                  ? "Sorular"
                  : cozulenTest.quizTitle),
              Text(
                "Score: ${cozulenTest.score}",
                style: TextStyle(color: ThemeHelper.accentColor, fontSize: 18),
              ),
              Text("Zaman: ${cozulenTest.timeTaken}"),
              Text(
                  "Tarih: ${cozulenTest.quizDate.year}-${cozulenTest.quizDate.month}-${cozulenTest.quizDate.day} ${cozulenTest.quizDate.hour}:${cozulenTest.quizDate.minute}"),
            ],
          )),
          Column(
            children: [
              SizedBox(
                height: 50,
              ),
              DiscoButton(
                  width: 100,
                  heigth: 50,
                  onPressed: () {
                    dersStore
                        .getTestById(cozulenTest.quizId, cozulenTest.categoryId)
                        .then((value) {
                      if (value != null) {
                        Navigator.pushReplacementNamed(
                            context, SoruEkran.routeName,
                            arguments: value);
                      }
                    });
                  },
                  child: Text('Tekrar Çöz')),
            ],
          )
        ],
      ),
    );
  }
}
