import 'dart:math';
import 'dart:async';
import 'package:proje_bitirme/models/ders_test.dart';
import 'package:proje_bitirme/models/soru_model.dart';


typedef OnTestNext = void Function(SoruModel model);
typedef OnTestCompleted = void Function(
    DersTest dersTest, double totalCorrect,Duration takenTime);
typedef OnTestStop = void Function(DersTest dersTest);

class SoruServices {
  int soruIndex = 0;
  int soruDuration = 0;
  bool isRunning = false;
  bool takeYeniSoru = true;
  DateTime sinavBaslamaSuresi = DateTime.now();
  DateTime soruBaslamaSuresi = DateTime.now();

  DersTest dersTest;
  List<int> takenSorular = [];
  Map<int, bool> soruCevaplari = {};

  OnTestNext onNext;
  OnTestCompleted onCompleted;
  OnTestStop onStop;

  SoruServices(
    this.dersTest,
    this.onNext,
    this.onCompleted,
    this.onStop,
  );

  void start() {
    soruIndex = 0;
    soruDuration = 0;
    takenSorular = [];
    soruCevaplari = {};
    isRunning = true;
    takeYeniSoru = true;

    Future.doWhile(() async {
      SoruModel? soruModel;
      soruBaslamaSuresi = DateTime.now();
      sinavBaslamaSuresi = DateTime.now();
      do {
        if (takeYeniSoru) {
          soruModel = _NextQuestion(dersTest, soruIndex);
          if (soruModel != null) {
            takeYeniSoru = false;
            soruIndex++;
            soruBaslamaSuresi = DateTime.now();
            onNext(soruModel);
          }
        }
        if (soruModel != null) {
          var soruTimeEnd =
              soruBaslamaSuresi.add(Duration(seconds: soruModel.duration));
          var timeDiff = soruTimeEnd.difference(DateTime.now()).inSeconds;

          if (timeDiff <= 0) {
            takeYeniSoru = true;
          }
        }

        if (soruModel == null ||
            dersTest.questions.length == soruCevaplari.length) {
          double totalCorrect = 0.0;
          soruCevaplari.forEach((key, value) {
            if (value == true) {
              totalCorrect++;
            }
          });
          var takenTime = sinavBaslamaSuresi.difference(DateTime.now());
          onCompleted(dersTest, totalCorrect, takenTime);
        }

        await Future.delayed(Duration(milliseconds: 500));
      } while (soruModel != null && isRunning);
      return false;
    });
  }

  void stop() {
    takeYeniSoru = false;
    isRunning = false;
    onStop(dersTest);
  }

  void next() {
    takeYeniSoru = true;
  }

  void updateAnswer(int soruIndex, int answer) {
    var soruModel = dersTest.questions[soruIndex];
    soruCevaplari[soruIndex] = soruModel.options[answer].isCorrect;
  }

  SoruModel? _NextQuestion(DersTest dersTest, int soruIndex) {
    while (true) {
      if (takenSorular.length >= dersTest.questions.length) {
        return null;
      }
      if (dersTest.shuffleQuestions) {
        soruIndex = Random().nextInt(dersTest.questions.length);
        if (takenSorular.contains(soruIndex) == false) {
          takenSorular.add(soruIndex);
          return dersTest.questions[soruIndex];
        }
      } else {
        return dersTest.questions[soruIndex];
      }
    }
  }
}
