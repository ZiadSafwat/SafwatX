import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_notifier/local_notifier.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
 import '../screens/table.dart';

import '../models/device_model.dart';

class NetworkProvider with ChangeNotifier {
  final String baseUrl =
      "http://127.0.0.1:5000"; // Change to your Flask server IP
  List<DeviceElement> devices = [];
  bool isSearchLoading = false;
  int sortColumnIndex;
  bool sortAscending;
    TableData? data;
  NetworkProvider({
    this.sortColumnIndex = 0,
    this.sortAscending = true,
  });
  ThemeData mode = ThemeData.dark();
  void setMode() {
    if (mode == ThemeData.light()) {
      mode = ThemeData.dark();
    } else {
      mode = ThemeData.light();
    }
    notifyListeners();
  }
  void showNotification(String title, String body) {
    LocalNotification notification =
        LocalNotification(title: title, body: body);
    notification.show();
  }

  /// 📡 Scan Network Devices
  Future<void> scanNetwork(BuildContext context) async {
    devices = [];
    isSearchLoading = true;
    notifyListeners();
    initializeData(context);
    try {
      final response = await http.get(Uri.parse("$baseUrl/scan"));
      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body);
        devices = (dataJson['devices'] as List)
            .map((device) => DeviceElement.fromMap(device))
            .toList();
        data!.setData(devices);
      } else {
        if (kDebugMode) print("❌ Error scanning network: ${response.body}");
        showNotification('❌ Error scanning network:', response.body);
      }
    } catch (e) {
      if (kDebugMode) print("❌ Exception: $e");
      showNotification('❌ Error scanning network:', "❌ Exception: $e");
    } finally {
      isSearchLoading = false;
      notifyListeners();
    }
  }

  /// 🔒 Block/Unblock a Device
  Future<void> changeBlockState(bool isLocked, String ip, int index) async {
    data!.changeLoadingState(index, true);
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/${isLocked ? 'unblock' : 'block'}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"ip": ip}),
      );

      if (response.statusCode == 200) {
        data!.changeBlockState(index, !isLocked  );

        showNotification('Done',
            'Successfully change block state of ip:$ip to ${!isLocked}');
      } else {
        if (kDebugMode) print("❌ Error changing block state: ${response.body}");
        showNotification('❌ Error changing block state:', response.body);
      }
    } catch (e) {
      if (kDebugMode) print("❌ Exception: $e");
      showNotification('❌ Error changing block state:', "❌ Exception: $e");
    } finally {
      data!.changeLoadingState(index, false);

      notifyListeners();
    }
  }

  void exportToExcel() async {
    final List<List<dynamic>> excelData = [];

    // Add column headers to the excelData list
    excelData.add([
      'Name',
      'Ip',
      'Mac',
      'Block State',
    ]);

    // Add data rows to the excelData list
    for (final device in devices) {
      excelData.add([
        device.name,
        device.ip,
        device.mac,
        device.blocked,
      ]);
    }

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Write data to the excel sheet
    for (var i = 0; i < excelData.length; i++) {
      for (var j = 0; j < excelData[i].length; j++) {
        // Wrap each value in a TextCellValue (or appropriate type)
        var cellValue = excelData[i][j];
        if (cellValue is String) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i))
              .value = TextCellValue(cellValue); // Wrap String in TextCellValue
        } else if (cellValue is int) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i))
              .value = IntCellValue(cellValue); // Wrap Int in IntCellValue
        } else if (cellValue is double) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i))
              .value = DoubleCellValue(cellValue); // Wrap Double in DoubleCellValue
        } else if (cellValue is bool) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i))
              .value = BoolCellValue(cellValue); // Wrap Bool in BoolCellValue
        } else {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i))
              .value = TextCellValue(cellValue.toString()); // Default to TextCellValue
        }
      }
    }

    // Save the excel file
    const excelFileName = 'table_data.xlsx';

    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$excelFileName');
    await file.writeAsBytes(fileBytes!);
    final url = file.path;

    // Show a success message to the user
    await OpenFilex.open(url);
    showNotification('Export Successful', 'The data has been exported to $excelFileName');
  }


  void filterData(String query) {
    data!.resetData();
    data!.search(query);
    notifyListeners();
  }

  void sort<T>(Comparable<T> Function(DeviceElement d) getField,
      int columnIndex, bool ascending) {
    data!.sort<T>(getField, ascending);

    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    notifyListeners();
  }

  initializeData(BuildContext context) {
    data = TableData(context);
    notifyListeners();
  }
  TableData returnData(BuildContext context) {
    try{  if (data==null){ initializeData(context);}}catch(e){initializeData(context);}

  return data!;

  }
}
