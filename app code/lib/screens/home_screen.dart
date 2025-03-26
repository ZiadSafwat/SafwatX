import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/table.dart';
import '../providers/network_provider.dart';

class NetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NetworkProvider>(context, );

    return Scaffold(
      appBar: AppBar(title: Text("SafwatX 🚀 - Network Control 💻")),
      body: Column(
       children: [
         Row(
           children: [
             ElevatedButton(
               onPressed: provider.isSearchLoading
                   ? null
                   : () {
                 provider.exportToExcel( );
               },
               child: provider.isSearchLoading
                   ? FittedBox(fit:BoxFit.contain,child: CircularProgressIndicator())
                   : Text("📈 Excel Export"),
             ),
             ElevatedButton(
               onPressed: provider.isSearchLoading
                   ? null
                   : () {
                       provider.scanNetwork(context);
                     },
               child: provider.isSearchLoading
                   ? CircularProgressIndicator()
                   : Text("🔍 Scan Network"),
             ),
             IconButton(
               onPressed: provider.setMode,
               icon: Icon(
                 provider.mode == ThemeMode.light
                     ? Icons.light_mode
                     : Icons.dark_mode,
               ),
               tooltip: "Toggle Theme",
             ),
           ],
         ),
         Expanded(child: DevicesTabel(context: context)
             // ListView.builder(
             //   itemCount: provider.devices.length,
             //   itemBuilder: (context, index) {
             //     final device = provider.devices[index];
             //     return ListTile(
             //       title: Text("${device.ip} - ${device.mac}"),
             //       subtitle: Text(device.name ?? "Unknown"),
             //       trailing: Row(
             //         mainAxisSize: MainAxisSize.min,
             //         children: [
             //           IconButton(
             //             icon: device.loading
             //                 ? CircularProgressIndicator()
             //                 : Icon(
             //                     device.blocked
             //                         ? Icons.lock_rounded
             //                         : Icons.lock_open,
             //                     color: Colors.green),
             //             onPressed: device.loading
             //                 ? null
             //                 : () => provider.changeBlockState(
             //                     device.blocked, device.ip!, index),
             //           ),
             //         ],
             //       ),
             //     );
             //   },
             // ),
             ),
       ],
                ),
    );
  }
}
