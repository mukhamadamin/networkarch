// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_scanner/shared/shared.dart';
import 'package:network_scanner/wake_on_lan/wake_on_lan.dart';

class WolPacketDetailsView extends StatelessWidget {
  const WolPacketDetailsView(this.response, {super.key});

  final WolResponseModel response;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сведения о пакете'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Сведения о пакете'),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (_) => ContentListView(
        children: [
          RoundedList(
            children: [
              ListTextLine(
                widgetL: const Text('MAC-адрес'),
                widgetR: Text(response.mac.address),
              ),
              ListTextLine(
                widgetL: const Text('ip-адрес'),
                widgetR: Text(response.ipv4.address),
              ),
              HexBytesViewer(
                title: 'Байты волшебного пакета',
                bytes: response.packetBytes,
              ),
            ],
          ),
        ],
      ),
      iosBuilder: (_) => ContentListView(
        children: [
          RoundedList(
            children: [
              ListTextLine(
                widgetL: const Text('MAC-адрес'),
                widgetR: Text(response.mac.address),
              ),
              ListTextLine(
                widgetL: const Text('ip-адрес'),
                widgetR: Text(response.ipv4.address),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            header: const Text('Байты волшебного пакета'),
            children: [
              HexBytesViewer(
                bytes: response.packetBytes,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
