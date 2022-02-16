import 'package:flutter/material.dart';
import 'package:proje_bitirme/common/theme_destek.dart';
import 'package:proje_bitirme/models/ders_kategori.dart';
import 'package:proje_bitirme/screens/dersler_detay_ekran.dart';
import 'package:proje_bitirme/stores/store.dart';
import 'package:proje_bitirme/widgets/baslik_ekran.dart';

class DerslerEkran extends StatefulWidget {
  DerslerEkran({Key? key}) : super(key: key);
  static const routeName = '/derslerEkran';

  @override
  _DerslerEkranState createState() => _DerslerEkranState();
}

class _DerslerEkranState extends State<DerslerEkran> {
  late List<DersKategori> derslerList = [];

  @override
  void initState() {
    var dersStore = DersStore();

    dersStore.loadDersler().then((value) {
      setState(() {
        derslerList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: ThemeHelper.fullEkranBgBoxDecoration(),
        child: Column(
          children: [
            baslikEKran(),
            Expanded(child: dersListView(derslerList)),
          ],
        ),
      ),
    );
  }

  Widget baslikEKran() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            child: Image(
              image: AssetImage('assets/icons/gerires.png'),
              width: 40,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Dersler',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  Widget dersListView(List<DersKategori> derslerList) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 20,
        runSpacing: 30,
        direction: Axis.horizontal,
        children: derslerList
            .map((x) => GestureDetector(
                  child: derslerListViewItem(x),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(DerslerDetay.routeName, arguments: x);
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget derslerListViewItem(DersKategori dersler) {
    return Container(
      width: 160,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(dersler.imagePath),
            width: 250,
            height: 140,
          ),
          Text(dersler.name),
        ],
      ),
    );
  }
}
