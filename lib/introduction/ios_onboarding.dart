// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:network_scanner/constants.dart';
import 'package:network_scanner/permissions/permissions.dart';

class IosOnboarding extends StatelessWidget {
  const IosOnboarding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoOnboarding(
      onPressedOnLastPage: () {
        Navigator.of(context).pop();

        Hive.box<bool>('settings').put('hasIntroductionBeenShown', true);
      },
      widgetAboveBottomButton: const CupertinoButton(
        onPressed: openAppSettings,
        child: Text('Откройте настройки приложения'),
      ),
      pages: [
        WhatsNewPage(
          title: const Text('Добро пожаловать в NetworkArch'),
          features: [
            const WhatsNewFeature(
              title: Text(Constants.wifiFeatureTitle),
              description: Text(Constants.wifiFeatureDesc),
              icon: Icon(
                CupertinoIcons.wifi,
              ),
            ),
            // WhatsNewFeature(
            //   title: const Text(Constants.carrierFeatureTitle),
            //   description: const Text(Constants.carrierFeatureDesc),
            //   icon: Icon(
            //     CupertinoIcons.antenna_radiowaves_left_right,
            //     color: CupertinoColors.activeGreen.resolveFrom(context),
            //   ),
            // ),
            WhatsNewFeature(
              title: const Text(Constants.utilitiesFeatureTitle),
              description: const Text(Constants.utilitiesFeatureDesc),
              icon: Icon(
                CupertinoIcons.check_mark_circled,
                color: CupertinoColors.systemPink.resolveFrom(context),
              ),
            ),
          ],
        ),
        const CupertinoOnboardingPage(
          title: Text('Разрешения'),
          bodyPadding: EdgeInsets.zero,
          titleToBodySpacing: 10,
          body: PermissionsView(),
        ),
      ],
    );
  }
}
