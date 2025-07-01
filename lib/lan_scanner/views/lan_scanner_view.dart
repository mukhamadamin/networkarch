import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkPentestScreen extends StatefulWidget {
  @override
  _NetworkPentestScreenState createState() => _NetworkPentestScreenState();
}

class _NetworkPentestScreenState extends State<NetworkPentestScreen> {
  final LanScanner scanner = LanScanner();
  final NetworkInfo networkInfo = NetworkInfo();
  List<Host> hosts = [];
  bool isScanning = false;
  String? wifiIP;
  String? subnet;
  String? gateway;

  Future<void> getNetworkInfo() async {
    wifiIP = await networkInfo.getWifiIP();
    gateway = await networkInfo.getWifiGatewayIP();
    subnet = wifiIP != null ? ipToCSubnet(wifiIP!) : null;
    setState(() {});
  }

  Future<void> scanNetwork() async {
    if (subnet == null) return;
    setState(() {
      isScanning = true;
      hosts.clear();
    });

    final stream = scanner.icmpScan(subnet!, progressCallback: (progress) {
      print('Сканирование: $progress%');
    });

    stream.listen((Host host) {
      setState(() {
        hosts.add(host);
      });
    }).onDone(() {
      setState(() {
        isScanning = false;
      });
    });
  }

  Future<void> scanPorts(String ip) async {
    for (int port = 20; port <= 1024; port++) {
      final ping = Ping(ip, count: 1, timeout: 1);
      ping.stream.listen((event) {
        if (event.response != null) {
          print('Port $port open on $ip');
        }
      });
    }
  }

  String ipToCSubnet(String ip) {
    var parts = ip.split('.');
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  @override
  void initState() {
    super.initState();
    getNetworkInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Анализ сети', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('IP: $wifiIP', style: TextStyle(color: Colors.white70)),
            Text('Сеть: $gateway', style: TextStyle(color: Colors.white70)),
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
                onPressed: isScanning ? null : scanNetwork,
                child:
                    Text(isScanning ? 'Сканирование...' : 'Сканировать сеть'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: hosts.isEmpty
                  ? Center(
                      child: isScanning
                          ? CircularProgressIndicator()
                          : Text('Нет найденных хостов',
                              style: TextStyle(color: Colors.white70)),
                    )
                  : ListView.builder(
                      itemCount: hosts.length,
                      itemBuilder: (context, index) {
                        final host = hosts[index];
                        return Card(
                          color: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(host.internetAddress.address,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                'Доступно: ${host.internetAddress.isLinkLocal ? "Да" : "Нет"}',
                                style: TextStyle(color: Colors.white70)),
                            trailing: IconButton(
                              icon: Icon(Icons.search, color: Colors.blue),
                              onPressed: () =>
                                  scanPorts(host.internetAddress.address),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
