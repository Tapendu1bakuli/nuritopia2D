/*
 * File name: translation_service.dart
 * Last modified: 2022.03.12 at 00:53:39
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../repositories/setting_repository.dart';
import 'settings_service.dart';

class TranslationService extends GetxService {
  final translations = Map<String, Map<String, String>>().obs;

  static List<String> languages = [];

  late SettingRepository _settingsRepo;
  late GetStorage _box;

  TranslationService() {
    _settingsRepo = new SettingRepository();
    _box = new GetStorage();
  }

  // initialize the translation service by loading the assets/locales folder
  // the assets/locales folder must contains file for each language that named
  // with the code of language concatenate with the country code
  // for example (en_US.json)
  Future<TranslationService> init() async {
    GetStorage box = GetStorage();
    languages = await _settingsRepo.getSupportedLocales();
    final String defaultLocale = Platform.localeName;
    print("Phone Lang: ${defaultLocale.toString().split("_").first}");
    if (box.read("language_selection") == 1) {
      print("Set Lang: ${box.read("language")}");
      await loadTranslation(locale: box.read("language"));
    } else {
      if (languages.contains(defaultLocale.toString().split("_").first)) {
        box.write('language_selection', 1);
        box.write('language', defaultLocale.toString().split("_").first);
        Get.find<SettingsService>().setting.value.mobileLanguage =
            defaultLocale.toString().split("_").first;
        await loadTranslation(
            locale: defaultLocale.toString().split("_").first);
      } else {
        box.write('language_selection', 1);
        box.write('language',
            Get.find<SettingsService>().setting.value.mobileLanguage);
        await loadTranslation(
            locale: Get.find<SettingsService>().setting.value.mobileLanguage);
      }
    }

    return this;
  }

  Future<void> loadTranslation({locale}) async {
    locale = locale ?? getLocale().languageCode;
    Map<String, String> _translations =
        await _settingsRepo.getTranslations(locale);
    Get.addTranslations({locale: _translations});
  }

  Locale getLocale() {
    String _locale = _box.read<String>('language')!;
    if (_locale.isEmpty) {
      _locale = Get.find<SettingsService>().setting.value.mobileLanguage!;
    }
    return fromStringToLocale(_locale);
  }

  // get list of supported local in the application
  List<Locale> supportedLocales() {
    return TranslationService.languages.map((_locale) {
      return fromStringToLocale(_locale);
    }).toList();
  }

  // Convert string code to local object
  Locale fromStringToLocale(String _locale) {
    if (_locale.contains('_')) {
      // en_US
      return Locale(
          _locale.split('_').elementAt(0), _locale.split('_').elementAt(1));
    } else {
      // en
      return Locale(_locale);
    }
  }
}
