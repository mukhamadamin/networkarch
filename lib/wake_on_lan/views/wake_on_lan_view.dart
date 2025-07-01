import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:dart_ping/dart_ping.dart';
import 'dart:io';

class PentestScreen extends StatefulWidget {
  @override
  _PentestScreenState createState() => _PentestScreenState();
}

class _PentestScreenState extends State<PentestScreen> {
  String? _wifiName;
  String? _wifiBSSID;
  String? _wifiIP;
  String? _wifiGateway;
  List<String> _connectedDevices = [];
  List<String> _openPorts = [];

  @override
  void initState() {
    super.initState();
    _getNetworkInfo();
  }

  Future<void> _getNetworkInfo() async {
    final info = NetworkInfo();
    _wifiName = await info.getWifiName();
    _wifiBSSID = await info.getWifiBSSID();
    _wifiIP = await info.getWifiIP();
    _wifiGateway = await info.getWifiGatewayIP();
    setState(() {});
  }

  void _scanNetwork() {
    if (_wifiGateway != null) {
      for (int i = 1; i < 255; i++) {
        String targetIP =
            _wifiGateway!.substring(0, _wifiGateway!.lastIndexOf('.') + 1) +
                '$i';
        final ping = Ping(targetIP, count: 3);

        ping.stream.listen((event) {
          if (event.response != null) {
            setState(() {
              if (!_connectedDevices.contains(targetIP)) {
                _connectedDevices.add(targetIP);
              }
            });
            _scanPorts(targetIP);
          }
        });
      }
    }
  }

  void _scanPorts(String ip) async {
    List<int> portsToCheck = [
      21,
      22,
      23,
      25,
      53,
      80,
      110,
      143,
      443,
      3306,
      3389
    ];
    for (var port in portsToCheck) {
      try {
        Socket socket =
            await Socket.connect(ip, port, timeout: Duration(seconds: 1));
        setState(() {
          _openPorts.add('$ip:$port - открыт');
        });
        socket.destroy();
      } catch (_) {}
    }
  }

  void _showReport() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Отчёт по безопасности сети'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wi-Fi сеть: $_wifiName'),
                Text('BSSID: $_wifiBSSID'),
                Text('IP-адрес: $_wifiIP'),
                Text('Шлюз: $_wifiGateway'),
                Divider(),
                Text('Возможные подключения:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ..._connectedDevices.map((e) => Text(e)),
                Divider(),
                Text('Открытые порты:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ..._openPorts.map((e) => Text(e)),
                Divider(),
                Text('Рекомендации:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('- Используйте сложные пароли для Wi-Fi'),
                Text('- Отключите ненужные открытые порты'),
                Text('- Включите шифрование WPA2/WPA3'),
                Text('- Ограничьте доступ к сети'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Закрыть'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Wi-Fi Пентест', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wi-Fi сеть: $_wifiName',
                style: TextStyle(color: Colors.white70)),
            Text('BSSID: $_wifiBSSID', style: TextStyle(color: Colors.white70)),
            Text('IP-адрес: $_wifiIP', style: TextStyle(color: Colors.white70)),
            Text('Шлюз: $_wifiGateway',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _scanNetwork,
                child: Text('Сканировать сеть'),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _showReport,
                child: Text('Показать отчёт'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _connectedDevices.length + _openPorts.length,
                itemBuilder: (context, index) {
                  if (index < _connectedDevices.length) {
                    return ListTile(
                      title: Text(_connectedDevices[index],
                          style: TextStyle(color: Colors.white)),
                    );
                  } else {
                    return ListTile(
                      title: Text(_openPorts[index - _connectedDevices.length],
                          style: TextStyle(color: Colors.white)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
