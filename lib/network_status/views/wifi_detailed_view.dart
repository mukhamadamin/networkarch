// Flutter imports:
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_scanner/network_status/network_status.dart';
import 'package:network_scanner/shared/shared.dart';

class WifiDetailedView extends StatefulWidget {
  const WifiDetailedView({super.key});

  @override
  State<WifiDetailedView> createState() => _WifiDetailedViewState();
}

class _WifiDetailedViewState extends State<WifiDetailedView> {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Подробная информация о Wi-Fi'),
      child: _buildDataList(context),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Подробная информация о Wi-Fi',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: _buildDataList(context),
    );
  }

  Widget _buildDataList(BuildContext context) {
    return ContentListView(
      children: [
        BlocConsumer<NetworkStatusBloc, NetworkStatusState>(
          listener: (contexts, state) {
            if (state.wifiStatus == NetworkStatus.success) {
              _buildDataList(context);
            }
          },
          builder: (context, state) {
            switch (state.wifiStatus) {
              case NetworkStatus.inital:
              case NetworkStatus.loading:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case NetworkStatus.permissionIssue:
                return const ErrorCard(
                  message:
                      'В разрешении на доступ к информации о Wi-Fi отказано.',
                );
              case NetworkStatus.success:
              case NetworkStatus.failure:
                return Column(
                  children: [
                    RoundedList(
                      children: [
                        ListTextLine(
                          widgetL: const Text('SSID'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiSSID ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('BSSID'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiBSSID ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Локальный IPv4'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiIPv4 ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Локальный IPv6'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiIPv6 ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Широковещательный адрес'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiBroadcast ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Доступ'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiGateway ?? 'N/A',
                          ),
                        ),
                        ListTextLine(
                          widgetL: const Text('Подмаска'),
                          widgetR: SelectableText(
                            state.wifiInfo?.wifiSubmask ?? 'N/A',
                          ),
                        ),
                      ],
                    ),
                    RoundedList(
                      children: [
                        ListTextLine(
                          widgetL: const Text('Внешний IPv4'),
                          subtitle: const Text('Нажмите, чтобы обновить'),
                          widgetR: state.extIpStatus == NetworkStatus.inital ||
                                  state.extIpStatus == NetworkStatus.loading
                              ? const ListCircularProgressIndicator()
                              : state.extIpStatus == NetworkStatus.failure
                                  ? const ErrorCard(
                                      message:
                                          'Не удалось получить внешний IP-адрес',
                                    )
                                  : SelectableText(
                                      state.extIP ?? 'N/A',
                                    ),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        ),
                        if (state.isWifiConnected)
                          NetworkSecurityChecker(
                              level: calculateNetworkSecurity(
                            bssid: state.wifiInfo!.wifiBSSID!,
                            gateway: state.wifiInfo!.wifiGateway!,
                            broadcast: state.wifiInfo!.wifiBroadcast!,
                            ipv4: state.wifiInfo!.wifiIPv4!,
                            ipv6: state.wifiInfo!.wifiIPv6,
                            subnetMask: state.wifiInfo!.wifiSubmask!,
                            externalIPv4: state.extIP,
                          ))
                        else
                          SizedBox()
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
            }
          },
        ),
      ],
    );
  }

  void _handleExtIPRefresh(BuildContext context) {
    context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());
  }
}

class NetworkSecurityChecker extends StatefulWidget {
  const NetworkSecurityChecker({super.key, required this.level});
  final int level;
  @override
  _NetworkSecurityCheckerState createState() => _NetworkSecurityCheckerState();
}

class _NetworkSecurityCheckerState extends State<NetworkSecurityChecker> {
  double _progress = 0.0;
  bool _isTesting = true;
  int _securityLevel = 0;
  late Timer _timer;
  List<String> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _startTesting();
  }

  @override
  void didUpdateWidget(covariant NetworkSecurityChecker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Перезапуск тестирования при изменении виджета
    _restartTesting();
  }

  void _restartTesting() {
    setState(() {
      _progress = 0.0;
      _isTesting = true;
      _securityLevel = widget.level;
      _recommendations = _generateRecommendations(_securityLevel);
      _timer.cancel();
      _startTesting();
    });
  }

  void _startTesting() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _isTesting = false;
          _recommendations = _generateRecommendations(_securityLevel);
          _timer.cancel();
          // _securityLevel = Random().nextInt(31) + 60;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<String> _generateRecommendations(int securityLevel) {
    List<String> recs = [];

    if (securityLevel < 100) {
      if (securityLevel < 90)
        recs.add("Используйте сложный пароль для Wi-Fi (WPA3 или WPA2).");
      if (securityLevel < 80)
        recs.add("Отключите широковещательные пакеты, если это возможно.");
      if (securityLevel < 70)
        recs.add("Настройте скрытый SSID для уменьшения обнаружения сети.");
      if (securityLevel < 60)
        recs.add("Включите фильтрацию MAC-адресов для дополнительной защиты.");
      if (securityLevel < 50)
        recs.add("Ограничьте количество подключаемых устройств.");
      if (securityLevel < 40)
        recs.add("Используйте VPN для защиты внешнего трафика.");
      if (securityLevel < 30)
        recs.add("Проверьте, не открыт ли доступ к роутеру извне.");
    }

    return recs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 8,
                  color: _isTesting ? Colors.blue : Colors.green,
                ),
              ),
              Text(
                _isTesting ? "Тестируем..." : "$_securityLevel% защищено",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isTesting ? "Проверка сети, подождите..." : "Проверка завершена!",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        if (!_isTesting && _recommendations.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            "Рекомендации по безопасности:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          for (var rec in _recommendations)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.security, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(rec, style: TextStyle(fontSize: 14))),
                ],
              ),
            ),
        ]
      ],
    );
  }
}

int calculateNetworkSecurity({
  required String bssid,
  required String ipv4,
  required String? ipv6,
  required String broadcast,
  required String gateway,
  required String subnetMask,
  required String? externalIPv4,
}) {
  int securityScore = 0;

  // 1. Проверка BSSID (0-20%)
  if (bssid.startsWith('00:') || bssid.startsWith('FF:')) {
    // Стандартные MAC-адреса (низкая безопасность)
    securityScore += 5;
  } else {
    // Рандомизация MAC-адресов (высокая безопасность)
    securityScore += 20;
  }

  // 2. Проверка IPv4 (0-10%)
  if (ipv4.startsWith('192.168.') ||
      ipv4.startsWith('10.') ||
      ipv4.startsWith('172.')) {
    securityScore += 10;
  } else {
    securityScore += 5;
  }

  // 3. Проверка IPv6 (0-10%)
  if (ipv6 != null && ipv6.isNotEmpty) {
    securityScore += 10;
  } else {
    securityScore += 5;
  }

  // 4. Широковещательный адрес (0-20%)
  if (broadcast.startsWith('192.168.') ||
      broadcast.startsWith('10.') ||
      broadcast.startsWith('172.')) {
    securityScore += 10;
  } else {
    securityScore += 20;
  }

  // 5. Доступ (Gateway) (0-20%)
  if (gateway.startsWith('192.168.') ||
      gateway.startsWith('10.') ||
      gateway.startsWith('172.')) {
    securityScore += 15;
  } else {
    securityScore += 20;
  }

  // 6. Подмаска (0-20%)
  if (subnetMask == '255.255.255.0') {
    securityScore += 10;
  } else if (subnetMask == '255.255.0.0') {
    securityScore += 5;
  } else {
    securityScore += 20;
  }

  // 7. Внешний IPv4 (0-20%)
  if (externalIPv4 != null) {
    if (externalIPv4.startsWith('192.168.') ||
        externalIPv4.startsWith('10.') ||
        externalIPv4.startsWith('172.') ||
        externalIPv4.startsWith('127.') ||
        externalIPv4.startsWith('0.')) {
      // Внешний IP принадлежит частному диапазону (используется NAT)
      securityScore += 20;
    } else {
      // Внешний IP виден в Интернете (низкая безопасность)
      securityScore += 10;
    }
  } else {
    // Если внешний IP не определён, считаем это нейтральным фактором
    securityScore += 10;
  }

  // 8. Проверка доступности через ICMP (Ping) (Минус 20% если доступен)
  bool isPingable = false; // Эта переменная должна быть результатом проверки
  if (isPingable) {
    securityScore -= 20;
  }

  // Ограничиваем значения в пределах 0-100%
  if (securityScore < 0) securityScore = 0;
  if (securityScore > 100) securityScore = 100;

  return securityScore;
}
