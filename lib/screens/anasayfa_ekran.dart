import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proje_bitirme/common/alert_util.dart';

import 'package:proje_bitirme/common/theme_destek.dart';
import 'package:proje_bitirme/screens/cozulen_testler_ekran.dart';
import 'package:proje_bitirme/screens/dersler_ekran.dart';
import 'package:proje_bitirme/screens/soru_ekran.dart';
import 'package:proje_bitirme/screens/test_sonuc_ekran.dart';
import 'package:proje_bitirme/stores/store.dart';
import 'package:proje_bitirme/widgets/disco_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AnasayfaEkran extends StatefulWidget {
  AnasayfaEkran({Key? key}) : super(key: key);
  static const routeName = '/anasayfa';

  @override
  _AnasayfaEkranState createState() => _AnasayfaEkranState();
}

class _AnasayfaEkranState extends State<AnasayfaEkran> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final DersStore _dersStore = DersStore();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _key,
      drawer: navigationDrawer(),
      body: Container(
        alignment: Alignment.center,
        decoration: ThemeHelper.fullEkranBgBoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            drawerToggleButton(),
            Column(
              children: [
                baslikText('KPSS Soru Çözümü'),
                const SizedBox(
                  height: 30,
                ),
                ...anasayfaEkranButton(context)
              ],
            )
          ],
        ),
      ),
    ));
  }

  navigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black54),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'KPSS Soru Çözümü',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Ansayfa'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AnasayfaEkran.routeName);
            },
          ),
          Divider(
            thickness: 2,
            indent: 17,
            endIndent: 18,
          ),
          ListTile(
            title: Text('Teste Başla'),
            onTap: () async {
              var test = await _dersStore.getRandomTest();
              Navigator.pushNamed(context, "/soruEkran", arguments: test);
            },
          ),
          Divider(
            thickness: 2,
            indent: 17,
            endIndent: 18,
          ),
          ListTile(
            title: Text('Kategoriler'),
            onTap: () {
              Navigator.pushNamed(context, DerslerEkran.routeName);
            },
          ),
          Divider(
            thickness: 2,
            indent: 17,
            endIndent: 18,
          ),
          ListTile(
            title: Text('Çözülen Testler'),
            onTap: () {
              Navigator.pushNamed(context, CozulenTestler.routeName);
            },
          ),
          Divider(
            thickness: 5,
          ),
          ListTile(
            title: Text('Hakkımızda'),
            onTap: () {
              AlertUtil.showAlert(context, "İnstagram",
                  "Detaylı bilgi için https://www.instagram.com/atanamayanlarr/");
            },
          ),
          Divider(
            thickness: 2,
            indent: 17,
            endIndent: 18,
          ),
          ListTile(
            title: Text('Çıkıs'),
            onTap: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else {
                if (Platform.isIOS) {
                  exit(0);
                }
              }
            },
          ),
          Divider(
            thickness: 2,
            indent: 17,
            endIndent: 18,
          ),
        ],
      ),
    );
  }

  drawerToggleButton() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20),
      alignment: Alignment.topLeft,
      child: GestureDetector(
          child: Image(
            image: AssetImage('assets/icons/menu_iconn.png'),
            width: 36,
          ),
          onTap: () {
            _key.currentState!.openDrawer();
          }),
    );
  }

  Text baslikText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 65,
          color: ThemeHelper.accentColor,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
                color: ThemeHelper.shadowColor,
                offset: Offset(-15, 20),
                blurRadius: 30)
          ]),
      textAlign: TextAlign.center,
    );
  }

  List<Widget> anasayfaEkranButton(BuildContext context) {
    return [
      DiscoButton(
        onPressed: () async {
          var quiz = await _dersStore.getRandomTest();
          Navigator.pushNamed(context, SoruEkran.routeName, arguments: quiz);
        },
        child: Text(
          'Teste Başla',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        isActive: true,
      ),
      DiscoButton(
        onPressed: () {
          Navigator.pushNamed(context, DerslerEkran.routeName);
        },
        child: Text(
          'Dersler',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        isActive: true,
      ),
      DiscoButton(
        onPressed: () {
          Navigator.pushNamed(context, CozulenTestler.routeName);
        },
        child: Text(
          'Çözülen Testler',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        isActive: true,
      ),
      Container(
          margin: EdgeInsets.all(40),
          height: 60,
          child: GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/icons/category/instagram.png'),
                ),
                Text(
                  '@atanamayanlar',
                  style: TextStyle(fontSize: 28),
                )
              ],
            ),
          )),
    ];
  }

  _launchURL() async {
    const url = 'https://www.instagram.com/atanamayanlarr';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Bu url hatalı $url';
    }
  }
}
