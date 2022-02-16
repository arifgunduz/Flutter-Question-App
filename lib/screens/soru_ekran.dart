import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proje_bitirme/common/extensions.dart';
import 'package:proje_bitirme/common/theme_destek.dart';
import 'package:proje_bitirme/models/cozulen_test_model.dart';
import 'package:proje_bitirme/models/ders_test.dart';
import 'package:proje_bitirme/models/dto/option_selection.dart';
import 'package:proje_bitirme/models/dto/test_sonuc.dart';
import 'package:proje_bitirme/models/option_model.dart';
import 'package:proje_bitirme/models/soru_model.dart';
import 'package:proje_bitirme/screens/test_sonuc_ekran.dart';
import 'package:proje_bitirme/services/soru_services.dart';
import 'package:proje_bitirme/stores/store.dart';
import 'package:proje_bitirme/widgets/disco_button.dart';
import 'package:proje_bitirme/widgets/soru_option.dart';
import 'package:proje_bitirme/widgets/time_indicator.dart';

class SoruEkran extends StatefulWidget {
  static const routeName = '/soruEkran';
  late DersTest dersTest;
  SoruEkran(this.dersTest, {Key? key}) : super(key: key);

  @override
  _SoruEkranState createState() => _SoruEkranState(dersTest);
}

class _SoruEkranState extends State<SoruEkran> with WidgetsBindingObserver {
  late SoruServices services;
  late DersStore store;
  late DersTest test;

  SoruModel? soruModel;
  Timer? progressTimer;
  AppLifecycleState? state;

  int _remainingTime = 0;
  Map<int, OptionSelection> _optionSerial = {};

  _SoruEkranState(this.test) {
    store = DersStore();
    services = SoruServices(test, onNextSoru, onTestCompleted, onStop);
  }

  @override
  void initState() {
    services.start();

    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    this.state = state;
  }

  @override
  void dispose() {
    if (progressTimer != null && progressTimer!.isActive) {
      progressTimer!.cancel();
    }
    services.stop();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: ThemeHelper.fullEkranBgBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ekranBaslik(),
              testSoru(),
              soruOptions(),
              testProgress(),
              footerButton(),
            ],
          ),
        ),
      ),
    ));
  }

  void onNextSoru(SoruModel model) {
    setState(() {
      if (progressTimer != null && progressTimer!.isActive) {
        _remainingTime = 0;
        progressTimer!.cancel();
      }
      this.soruModel = model;
      _remainingTime = model.duration;
      _optionSerial = {};
      for (var i = 0; i < model.options.length; i++) {
        _optionSerial[i] = OptionSelection(String.fromCharCode(65 + i), false);
      }
    });
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (_remainingTime >= 0) {
        try {
          if (mounted) {
            setState(() {
              progressTimer = timer;
              _remainingTime--;
            });
          }
        } catch (ex) {
          timer.cancel();
          print(ex.toString());
        }
      }
    });
  }

  void onTestCompleted(
      DersTest dersTest, double totalCorrect, Duration takenTime) {
    if (mounted) {
      setState(() {
        _remainingTime = 0;
      });
    }
    progressTimer!.cancel();
    store.getDersKategori(dersTest.categoryId).then((category) {
      store
          .saveCozulenTestler(CozulenTestModel(
              dersTest.id,
              dersTest.title,
              category.id,
              "$totalCorrect/${dersTest.questions.length}",
              takenTime.format(),
              DateTime.now(),
              "Complete"))
          .then((value) {
        Navigator.pushReplacementNamed(context, TestSonucEkran.routeName,
            arguments: TestSonuc(dersTest, totalCorrect));
      });
    });
  }

  void onStop(DersTest dersTest) {
    _remainingTime = 0;
    progressTimer!.cancel();
  }

  Widget ekranBaslik() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        test.title,
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget testSoru() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 10),
      decoration: ThemeHelper.roundBoxDeco(),
      child: Text(
        soruModel?.text ?? "",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget soruOptions() {
    return Container(
      alignment: Alignment.center,
      decoration: ThemeHelper.roundBoxDeco(),
      child: Column(
        children: List<Option>.from(soruModel?.options ?? []).map((e) {
          int optionIndex = soruModel!.options.indexOf(e);

          var optWidget = GestureDetector(
            onTap: () {
              setState(() {
                services.updateAnswer(
                    test.questions.indexOf(soruModel!), optionIndex);
                for (int i = 0; i < _optionSerial.length; i++) {
                  _optionSerial[i]!.isSelected = false;
                }
                _optionSerial.update(optionIndex, (value) {
                  value.isSelected = true;
                  return value;
                });
              });
            },
            child: QuestionOption(
              optionIndex,
              _optionSerial[optionIndex]!.optionText,
              e.text,
              isSelected: _optionSerial[optionIndex]!.isSelected,
            ),
          );
          return optWidget;
        }).toList(),
      ),
    );
  }

  Widget testProgress() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TimeIndicator(
              soruModel?.duration ?? 1,
              _remainingTime,
              () {},
            ),
          ),
          Text(
            '$_remainingTime Seconds',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget footerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DiscoButton(
          onPressed: () {
            setState(() {
              services.stop();
              if (progressTimer != null && progressTimer!.isActive) {
                progressTimer!.cancel();
              }
            });
            Navigator.pop(context);
          },
          child: Text(
            'Çıkış',
            style: TextStyle(fontSize: 20),
          ),
          width: 130,
          heigth: 50,
        ),
        DiscoButton(
          onPressed: () {
            services.next();
          },
          child: Text(
            'Devam',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          isActive: true,
          width: 130,
          heigth: 50,
        )
      ],
    );
  }
}
