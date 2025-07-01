// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_scanner/dns_lookup/dns_lookup.dart';
import 'package:network_scanner/introduction/introduction.dart';
import 'package:network_scanner/ip_geo/ip_geo.dart';
import 'package:network_scanner/lan_scanner/lan_scanner.dart';
import 'package:network_scanner/network_status/network_status.dart';
import 'package:network_scanner/overview/overview.dart';
import 'package:network_scanner/ping/ping.dart';
import 'package:network_scanner/settings/settings.dart';
import 'package:network_scanner/wake_on_lan/wake_on_lan.dart';
import 'package:network_scanner/whois/whois.dart';

abstract class Constants {
  static const String appName = 'NetworkArch';
  static const String appDesc = '''
      NetworkArch is an open-source network diagnostics tool 
      equipped with various useful utilities.
      ''';
  static const String sourceCodeURL =
      'https://github.com/ivirtex/networkarch-flutter';

  static const String privacyPolicyURL =
      'https://ivirtex.dev/projects/networkarch/privacyPolicy';

  static const String termsOfUseURL =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  static const String wifiFeatureTitle = 'Wi-Fi';
  static const String wifiFeatureDesc =
      'Изучите подробную информацию о вашей сети Wi-Fi.';

  // static const String carrierFeatureTitle = 'проводник';
  static const String carrierFeatureDesc =
      'Изучите подробную информацию о вашей сотовой сети.';

  static const String utilitiesFeatureTitle = 'Услуги';
  static const String utilitiesFeatureDesc =
      'Протестируйте свою сеть с помощью различных диагностических инструментов, таких как ping, Wake on LAN, LAN Scanner и других.';

  static const String usageDesc =
      'Мы никогда ни с кем не делимся этими данными.';

  static const String overviewAndroidAdUnitId =
      'ca-app-pub-3222092607864795/3727150533';
  static const String overviewIOSAdUnitId =
      'ca-app-pub-3222092607864795/6714553758';

  static const String premiumAccessAndroidAdUnitId =
      'ca-app-pub-3222092607864795/9965201926';
  static const String premiumAccessIOSAdUnitId =
      'ca-app-pub-3222092607864795/3915633040';

  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  static final Map<String, Widget Function(BuildContext)> routes = {
    '/overview': (context) => const OverviewView(),
    '/settings': (context) => const SettingsView(),
    '/introduction': (context) => IntroductionScreen(
          pages: pagesList,
          curve: Curves.easeInOut,
          animationDuration: 500,
          controlsPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.bottom,
            horizontal: 16,
          ),
          done: const Text('Done'),
          next: const Icon(Icons.navigate_next),
          onDone: () {
            Navigator.of(context).pop();

            Hive.box<bool>('settings').put('hasIntroductionBeenShown', true);
          },
          dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
    '/wifi': (context) => const WifiDetailedView(),
    // '/carrier': (context) => const CarrierDetailView(),
    '/tools/ping': (context) => const PingView(),
    '/tools/lan': (context) => NetworkPentestScreen(),
    '/tools/wol': (context) => PentestScreen(),
    '/tools/ip_geo': (context) => const IpGeoView(),
    '/tools/whois': (context) => const WhoisView(),
    '/tools/dns_lookup': (context) => const DnsLookupView(),
  };

  // Styles
  static const EdgeInsets listPadding = EdgeInsets.all(10);

  static const EdgeInsets bodyPadding = EdgeInsets.all(10);
  static const EdgeInsets iOSbodyPadding =
      EdgeInsets.only(left: 18.5, right: 18.5, bottom: 6);

  static const EdgeInsets cupertinoListTileWithIconPadding =
      EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );

  static const double listSpacing = 10;

  static const double linearProgressWidth = 50;

  static const double listDividerIndent = 14;

  // Description styles
  static final TextStyle descStyleLight = TextStyle(
    color: Colors.grey[600],
  );

  static final TextStyle descStyleDark = TextStyle(
    color: Colors.grey[400],
  );

  // Tools descriptions
  static const String pingDesc =
      'Отправляйте ICMP-сообщения на определенный IP-адрес или домен.';

  static const String lanScannerDesc =
      'Найдите сетевые устройства в локальной сети.';

  static const String wolDesc =
      'Отправляйте волшебные пакеты в вашей локальной сети.';

  static const String ipGeoDesc = 'Получите геолокацию любого IP-адреса.';

  static const String whoisDesc = 'Поиск информации о любом домене.';

  static const String dnsDesc = 'Просматривайте DNS-записи любого домена.';

  // Error descriptions
  static const String defaultError = 'Ошибка при загрузке данных';

  static const String simError = 'Нет SIM-карты';

  static const String noReplyError = 'Ответа от ведущего не получено';

  static const String unknownError = 'Неизвестная ошибка';

  static const String unknownHostError = 'Неизвестный хост';

  static const String requestTimedOutError = 'Время ожидания запроса истекло';

  // Permissions descriptions
  static const String locationPermissionDesc =
      'Нам необходимо разрешение на определение вашего местоположения, чтобы получить доступ к информации о Wi-Fi.';

  static const String phoneStatePermissionDesc =
      'Нам необходимо разрешение вашего телефона, чтобы получить доступ к информации о операторе связи.';

  // Permissions messages
  static const String _permissionGranted = 'Разрешение успешно получено.';

  static const String _permissionDenied =
      '''В разрешении отказано, приложение может работать неправильно, проверьте настройки приложения.''';

  static const String _permissionDefault =
      'Что-то пошло не так, проверьте права доступа к приложению.';

  static const SnackBar permissionGrantedSnackbar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.check_circle_rounded, color: Colors.green),
        SizedBox(width: 10),
        Expanded(child: Text(_permissionGranted)),
      ],
    ),
  );

  static const SnackBar permissionDeniedSnackbar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.error_rounded, color: Colors.red),
        SizedBox(width: 10),
        Expanded(child: Text(_permissionDenied)),
      ],
    ),
    action: SnackBarAction(
      label: 'Откройте настройки',
      onPressed: openAppSettings,
    ),
  );

  static const SnackBar permissionDefaultSnackbar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.warning_rounded, color: Colors.orange),
        SizedBox(width: 10),
        Expanded(child: Text(_permissionDefault)),
      ],
    ),
    action: SnackBarAction(
      label: 'Откройте настройки',
      onPressed: openAppSettings,
    ),
  );

  static CupertinoAlertDialog permissionGrantedCupertinoDialog(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('Разрешение получено'),
        content: const Text(_permissionGranted),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static CupertinoAlertDialog permissionDeniedCupertinoDialog(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('В разрешении отказано'),
        content: const Text(_permissionDenied),
        actions: [
          const CupertinoDialogAction(
            onPressed: openAppSettings,
            child: Text('Откройте настройки'),
          ),
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static CupertinoAlertDialog permissionDefaultCupertinoDialog(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('Что-то пошло не так'),
        content: const Text(_permissionDefault),
        actions: [
          const CupertinoDialogAction(
            onPressed: openAppSettings,
            child: Text('Откройте настройки'),
          ),
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  // WOL iOS dialogs
  static const String _wolIpValidationError =
      'Если IPv4-адрес неверен, проверьте свои данные и повторите попытку.';

  static CupertinoAlertDialog wolIpValidationError(BuildContext context) =>
      CupertinoAlertDialog(
        title: const Text('Ошибка'),
        content: const Text(_wolIpValidationError),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static const String _wolMacValidationError =
      'Если MAC-адрес указан неверно, проверьте свои данные и повторите попытку.';

  static CupertinoAlertDialog wolMacValidationError(BuildContext context) =>
      CupertinoAlertDialog(
        title: const Text('Ошибка'),
        content: const Text(_wolMacValidationError),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  static const String _wolIpAndMacValidationError =
      'Если IPv4 и MAC-адрес неверны, проверьте свои данные и повторите попытку.';

  static CupertinoAlertDialog wolIpAndMacValidationError(
    BuildContext context,
  ) =>
      CupertinoAlertDialog(
        title: const Text('Ошибка'),
        content: const Text(_wolIpAndMacValidationError),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
}
