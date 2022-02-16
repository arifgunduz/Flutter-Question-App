import 'package:flutter/material.dart';
import 'package:proje_bitirme/common/theme_destek.dart';
import 'package:proje_bitirme/models/ders_test.dart';

import 'package:proje_bitirme/models/ders_kategori.dart';
import 'package:proje_bitirme/models/soru_model.dart';
import 'package:proje_bitirme/stores/store.dart';

class DerslerDetay extends StatefulWidget {
  DerslerDetay(this.dersler, {Key? key}) : super(key: key);

  static const routeName = '/derslerDetay';
  late DersKategori dersler;

  @override
  _DerslerDetayState createState() => _DerslerDetayState(dersler);
}

class _DerslerDetayState extends State<DerslerDetay> {
  late DersKategori dersler;
  _DerslerDetayState(this.dersler);

  late List<DersTest> testList = [];

  @override
  void initState() {
    var dersStore = DersStore();
    dersStore.loadTestListByDersler(dersler.id).then((value) {
      setState(() {
        testList = value;
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
            ekranBaslik(dersler),
            Expanded(child: derslerDetayView(testList)),
          ],
        ),
      ),
    ));
  }

  ekranBaslik(DersKategori dersler) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            child: Image(
              image: AssetImage('assets/icons/back.png'),
              width: 50,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            "${dersler.name} Dersi",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  derslerDetayView(List<DersTest> testList) {
    return SingleChildScrollView(
      child: Column(
        children: testList
            .map((test) => GestureDetector(
                  child: dersDetayViewItem(test),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed("/soruEkran", arguments: test);
                  },
                ))
            .toList(),
      ),
    );
  }

  dersDetayViewItem(DersTest test) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper.roundBoxDeco(),
      child: Stack(
        children: [
          derslerDetayItemBadge(test),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: ThemeHelper.roundBoxDeco(
                      color: Color(0xffE1E9F6), radius: 10),
                  child: Image(
                    image: AssetImage(test.imagePath.isEmpty == true
                        ? dersler.imagePath
                        : test.imagePath),
                    width: 130,
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      test.title,
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(test.description),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  derslerDetayItemBadge(DersTest test) {
    return Container(
      alignment: Alignment.topRight,
      child: Container(
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ThemeHelper.accentColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        child: Text(
          "${test.questions.length} Soru",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
