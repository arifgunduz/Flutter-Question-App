import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:proje_bitirme/common/json_util.dart';
import 'package:proje_bitirme/models/cozulen_test_model.dart';
import 'package:proje_bitirme/models/ders_test.dart';
import 'package:proje_bitirme/models/ders_kategori.dart';
import 'package:proje_bitirme/models/soru_model.dart';
import 'package:proje_bitirme/screens/cozulen_testler_ekran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DersStore {
  static SharedPreferences? prefs;
  static const String cozulenTestModelListKey = "cozulenTestModelListKey";
  final String kategoriJsonFileName = 'assets/data/dersler.json';
  final String testJsonFileName = 'assets/data/soru.json';

  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<List<DersKategori>> loadDersler() async {
    List<DersKategori> derslerList = [];

    derslerList = await JsonUtil.loadFromJson(
        kategoriJsonFileName, DersKategori.jsonToObject);
    return derslerList;
  }

  Future<List<DersTest>> loadTestListByDersler(int derslerId) async {
    List<DersTest> testList = [];

    testList = await JsonUtil.loadFromJson<DersTest>(
        testJsonFileName, DersTest.jsonToObject);

    var derslerTestList =
        testList.where((element) => element.categoryId == derslerId).toList();
    return derslerTestList;
  }

  Future<DersKategori> getDersKategori(int kategoriId) async {
    List<DersKategori> kategoriList = [];
    kategoriList = await JsonUtil.loadFromJson<DersKategori>(
        kategoriJsonFileName, DersKategori.jsonToObject);

    return kategoriList.where((element) => element.id == kategoriId).first;
  }

  Future<List<CozulenTestModel>> loadCozulenTest() async {
    List<CozulenTestModel> cozulenTestModelList = [];
    var isExist = DersStore.prefs!.containsKey(cozulenTestModelListKey);
    if (isExist) {
      var cozulenTestJson = DersStore.prefs!.getString(cozulenTestModelListKey);
      if (cozulenTestJson != null) {
        cozulenTestModelList =
            await JsonUtil.loadFromJsonString<CozulenTestModel>(
                cozulenTestJson, CozulenTestModel.jsonToObject);
        cozulenTestModelList = cozulenTestModelList.reversed.toList();
      }
    }
    return cozulenTestModelList;
  }

  Future<DersTest> getRandomTest() async {
    List<DersTest> testList = [];
    testList = await JsonUtil.loadFromJson<DersTest>(
        testJsonFileName, DersTest.jsonToObject);
    var max = testList.length;
    var index = Random().nextInt(max);
    var test = testList[index];
    return test;
  }

  Future<void> saveCozulenTestler(CozulenTestModel cozulenTestler) async {
    var cozulenTestList = await loadCozulenTest();
    cozulenTestList.add(cozulenTestler);
    var cozulenTestlerJson = jsonEncode(cozulenTestList);
    prefs!.setString(cozulenTestModelListKey, cozulenTestlerJson);
  }

  Future<DersTest> getTestById(int quizId, int categoryId) async {
    var quizList = await loadTestListByDersler(categoryId);
    var quiz = quizList.where((element) => element.id == quizId).first;
    return quiz;
  }
}
