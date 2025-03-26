import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/network_provider.dart';
import '../screens/searchField.dart';

import '../models/device_model.dart';
import 'dropDownMenu.dart';

class DevicesTabel extends StatefulWidget {
  final BuildContext context;

  const DevicesTabel({Key? key, required this.context}) : super(key: key);

  @override
  _DevicesTabelState createState() => _DevicesTabelState();
}

class _DevicesTabelState extends State<DevicesTabel> {
  TextEditingController search = TextEditingController();

  int rowsPerPage = 3;

  void reload() {
    context.read<NetworkProvider>().scanNetwork(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return !(context.watch<NetworkProvider>().isSearchLoading ||
            context.watch<NetworkProvider>().data == null)
        ? SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(height: 0.02 * height),
                CustomSearch(
                  prefix: const Icon(Icons.search),
                  controller: search,
                  hintText: 'search by name',
                  isDigit: false,
                  onChanged: (query) {
                    context.read<NetworkProvider>().filterData(query);
                  },
                ),
                SizedBox(
                  height: height * 0.7,
                  child: ListView(
                    padding: const EdgeInsets.only(left: 8.0),
                    children: [
                      PaginatedDataTable(
                        source: context.read<NetworkProvider>().data!,
                        header: CustomDrawerDropdownButton2(
                          hint: '$rowsPerPage',
                          value: '$rowsPerPage',
                          dropdownItems: const ['3', '6', '9', ],
                          onChanged: (value) {
                            setState(() {
                              rowsPerPage = int.parse(value!);
                            });
                          },
                        ),
                        columns: [
                          DataColumn(
                              label: const Text('Name'),
                              onSort: (int columnIndex, bool ascending) => context
                                  .read<NetworkProvider>()
                                  .sort<String>((DeviceElement d) => d.name,
                                      columnIndex, ascending)),
                          DataColumn(
                              label: const Text('Mac'),
                              onSort: (int columnIndex, bool ascending) => context
                                  .read<NetworkProvider>()
                                  .sort<String>((DeviceElement d) => d.mac,
                                      columnIndex, ascending)),
                          DataColumn(
                              label: const Text('IP'),
                              onSort: (int columnIndex, bool ascending) => context
                                  .read<NetworkProvider>()
                                  .sort<String>(
                                      (DeviceElement d) => d.ip.toString(),
                                      columnIndex,
                                      ascending)),
                          DataColumn(
                              label: const Text('Block State'),
                              onSort: (int columnIndex, bool ascending) => context
                                  .read<NetworkProvider>()
                                  .sort<String>(
                                      (DeviceElement d) => d.blocked.toString(),
                                      columnIndex,
                                      ascending)),
                        ],
                        actions: const [Text('Records Per Page')],
                        columnSpacing: 10,
                        horizontalMargin: 5,
                        rowsPerPage: rowsPerPage,
                        sortColumnIndex:
                            context.read<NetworkProvider>().sortColumnIndex,
                        sortAscending:
                            context.read<NetworkProvider>().sortAscending,
                        showCheckboxColumn: false,
                      )
                    ],
                  ),
                ),
          
              ],
            ),
        )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

// The "soruce" of the table
class TableData extends DataTableSource {
  // Generate some made-up data
  List<DeviceElement> _originalData = [];
  List<DeviceElement> _filteredData = [];
  BuildContext context;

  TableData(this.context);

  void setData(List<DeviceElement> device) {
    _originalData = device;
    _filteredData = device;
    notifyListeners();
  }

  void changeLoadingState(int i, bool loadingState) {
    _filteredData[i] = _filteredData[i].copyWith(loading: loadingState);
    notifyListeners();
  }

  void changeBlockState(int i, bool isLocked) {
    _filteredData[i] = _filteredData[i].copyWith(blocked: isLocked);
    notifyListeners();
  }

  void search(String query) {
    _filteredData = _originalData.where((DeviceElement) {
      return DeviceElement.name.toLowerCase().startsWith(query.toLowerCase());
    }).toList();

    notifyListeners();
  }

  void resetData() {
    _filteredData = _originalData;
    notifyListeners();
  }

  void sort<T>(
      Comparable<T> Function(DeviceElement d) getField, bool ascending) {
    _filteredData.sort((DeviceElement a, DeviceElement b) {
      if (!ascending) {
        final DeviceElement c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _filteredData.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final DeviceElement data = _filteredData[index];
    return DataRow(cells: [
      DataCell(Text(data.name)),
      DataCell(Text(data.mac)),
      DataCell(Text(data.ip)),
      DataCell(
        IconButton(
          icon: data.loading
              ? CircularProgressIndicator()
              : Icon(data.blocked ? Icons.lock_rounded : Icons.lock_open,
                  color: Colors.green),
          onPressed: data.loading || context == null
              ? null
              : () => Provider.of<NetworkProvider>(context!, listen: false)
                  .changeBlockState(data.blocked, data.ip!, index),
        ),
      ),
    ]);
  }
}
