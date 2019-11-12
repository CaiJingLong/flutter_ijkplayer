import 'dart:ui';
part 'cn.dart';
part 'en.dart';

abstract class I18n {

  I18n._();

  factory I18n(Locale locale) {
    if (locale?.languageCode == "zh") {
      return _I18nZh();
    } else {
      return _I18nEn();
    }
  }

  String get indexTitle;
  String get networkButton;
  String get photoButton;
  String get assetButton;
  String get listViewButton;
  String get fullScreenAutoButton;
  String get fullScreenManualButton;
  String get withDialogButton;
  String get pageViewButton;

  String get showDialog;

  String get autoFullScreenTitle;

  String get changeFullScreenWithButton;

  String get play;

  String get fullScreen;

  String get pick;

  String get noPickTip;

  String get useStreamUsage;

  String get playFinishToast;

  String get screenshotTitle;

  String get overlayPageTitle;

  String get ijkStatusTitle;

  String get customOption;

  String get errorUrl;

  String get customFullScreenWidget;

  String get setSpeed;

  String get autoFullScreenOnPlay;
}

I18n get currentI18n => I18n(window.locale);
