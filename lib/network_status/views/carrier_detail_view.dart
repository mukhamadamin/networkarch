// // Flutter imports:
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:flutter_bloc/flutter_bloc.dart';

// // Project imports:
// import 'package:network_scanner/network_status/network_status.dart';
// import 'package:network_scanner/shared/shared.dart';

// class CarrierDetailView extends StatelessWidget {
//   const CarrierDetailView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PlatformWidget(
//       androidBuilder: _buildAndroid,
//       iosBuilder: _buildIOS,
//     );
//   }

//   Widget _buildIOS(BuildContext context) {
//     return CupertinoContentScaffold(
//       largeTitle: const Text('Информация о проводнике'),
//       child: _buildDataList(context),
//     );
//   }

//   Widget _buildAndroid(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Информация о проводнике',
//         ),
//       ),
//       body: _buildDataList(context),
//     );
//   }

//   Widget _buildDataList(BuildContext context) {
//     return ContentListView(
//       children: [
//         BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
//           builder: (context, state) {
//             switch (state.carrierStatus) {
//               case NetworkStatus.inital:
//               case NetworkStatus.loading:
//                 return const Center(
//                   child: CircularProgressIndicator.adaptive(),
//                 );
//               case NetworkStatus.permissionIssue:
//                 return const Center(
//                   child: Text(
//                       'В разрешении на передачу данных проводника отказано'),
//                 );
//               case NetworkStatus.failure:
//               case NetworkStatus.success:
//                 return Column(
//                   children: [
//                     RoundedList(
//                       children: [
//                         ListTextLine(
//                           widgetL: const Text('Позволяет использовать VOIP'),
//                           widgetR: Text(
//                             state.carrierInfo?.allowsVOIP.toString() ?? 'N/A',
//                           ),
//                         ),
//                         ListTextLine(
//                           widgetL: const Text('Имя проводника'),
//                           widgetR: Text(
//                             state.carrierInfo?.carrierName ?? 'N/A',
//                           ),
//                         ),
//                         ListTextLine(
//                           widgetL: const Text('Код страны ISO'),
//                           widgetR: Text(
//                             state.carrierInfo?.isoCountryCode ?? 'N/A',
//                           ),
//                         ),
//                         ListTextLine(
//                           widgetL: const Text('Мобильный код страны'),
//                           widgetR: Text(
//                             state.carrierInfo?.mobileCountryCode ?? 'N/A',
//                           ),
//                         ),
//                         ListTextLine(
//                           widgetL: const Text('Код мобильной сети'),
//                           widgetR: Text(
//                             state.carrierInfo?.mobileNetworkCode ?? 'N/A',
//                           ),
//                         ),
//                         ListTextLine(
//                           widgetL: const Text('Состояние подключения'),
//                           widgetR: ConnectionStatus(
//                             state.carrierStatus,
//                             connectionChecker: () =>
//                                 state.carrierInfo?.isCarrierConnected ?? false,
//                           ),
//                         ),
//                       ],
//                     ),
//                     RoundedList(
//                       children: [
//                         ListTextLine(
//                           widgetL: const Text('Внешний IP-адрес'),
//                           subtitle: const Text('Нажмите, чтобы обновить'),
//                           widgetR: state.extIpStatus == NetworkStatus.inital ||
//                                   state.extIpStatus == NetworkStatus.loading
//                               ? const ListCircularProgressIndicator()
//                               : state.extIpStatus == NetworkStatus.failure
//                                   ? const ErrorCard(
//                                       message:
//                                           'Не удалось получить внешний IP-адрес',
//                                     )
//                                   : SelectableText(
//                                       state.extIP ?? 'N/A',
//                                     ),
//                           onRefreshTap: () => _handleExtIPRefresh(context),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//             }
//           },
//         ),
//       ],
//     );
//   }

//   void _handleExtIPRefresh(BuildContext context) {
//     context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());
//   }
// }
