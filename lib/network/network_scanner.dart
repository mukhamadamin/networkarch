import 'package:dart_ping/dart_ping.dart' as DartPing;
import 'package:network_info_plus/network_info_plus.dart';

class NetworkScanner {
  final NetworkInfo _networkInfo = NetworkInfo();

  /// Получение информации о текущем Wi-Fi
  Future<Map<String, String?>> getWifiInfo() async {
    return {
      "SSID": await _networkInfo.getWifiName(),
      "BSSID": await _networkInfo.getWifiBSSID(),
      "IPv4": await _networkInfo.getWifiIP(),
      "Gateway": await _networkInfo.getWifiGatewayIP(),
    };
  }

  /// Выполняет ping указанного IP-адреса
  Future<bool> isHostReachable(String ip) async {
    final ping = DartPing.Ping(ip, count: 3);
    final response = await ping.stream.first;
    return response.response != null;
  }
}
