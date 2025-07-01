// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import 'package:network_scanner/constants.dart';
import 'package:network_scanner/introduction/introduction.dart';
import 'package:network_scanner/overview/overview.dart';
import 'package:network_scanner/permissions/permissions.dart';
import 'package:network_scanner/shared/shared.dart';
import 'package:network_scanner/utils/helpers.dart';

class DebugSection extends StatelessWidget {
  const DebugSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return Column(
          children: [
            const SmallDescription(
              text: 'Отлаживать',
              leftPadding: 8,
            ),
            ToolCard(
              toolName: 'Грант IAP',
              onPressed: () async {
                await Hive.box<bool>('iap').put('isPremiumGranted', true);
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Очистить данные IAP',
              onPressed: () async {
                await Hive.box<bool>('iap').put('isPremiumGranted', false);
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Показать разрешения',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  Constants.permissionGrantedSnackbar,
                );
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Показать разрешения отклонённые',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  Constants.permissionDeniedSnackbar,
                );
              },
            ),
            const SizedBox(height: Constants.listSpacing),
            ToolCard(
              toolName: 'Показать разрешения по умолчанию',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  Constants.permissionDefaultSnackbar,
                );
              },
            ),
            const SizedBox(height: Constants.listSpacing),
          ],
        );
      },
      iosBuilder: (context) {
        return CupertinoListSection.insetGrouped(
          hasLeading: false,
          header: const Text('Отлаживать'),
          children: [
            ToolCard(
              toolName: 'Грант IAP',
              onPressed: () async {
                await Hive.box<bool>('iap').put('isPremiumGranted', true);
              },
            ),
            ToolCard(
              toolName: 'Очистить данные IAP',
              onPressed: () async {
                await Hive.box<bool>('iap').put('isPremiumGranted', false);
              },
            ),
            ToolCard(
              toolName: 'Показать разрешения',
              onPressed: () {
                showPlatformMessage(
                  context,
                  type: MessageType.granted,
                );
              },
            ),
            ToolCard(
              toolName: 'Показать разрешения отклонённые',
              onPressed: () {
                showPlatformMessage(
                  context,
                  type: MessageType.denied,
                );
              },
            ),
            ToolCard(
              toolName: 'Показать разрешения по умолчанию',
              onPressed: () {
                showPlatformMessage(
                  context,
                  type: MessageType.default_,
                );
              },
            ),
            ToolCard(
              toolName: 'Показать процесс адаптации iOS',
              onPressed: () {
                showCupertinoModalBottomSheet<void>(
                  context: context,
                  useRootNavigator: true,
                  builder: (context) => const IosOnboarding(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
