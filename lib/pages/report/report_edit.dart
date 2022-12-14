/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 文章编辑
import 'package:cry/cry_buttons.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/api/article_api.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportEdit extends StatefulWidget {
  final DeviceModel? deviceModel;
  final String? day;
  final String? nguong;

  const ReportEdit({Key? key, this.deviceModel, this.day, this.nguong})
      : super(key: key);

  @override
  _ReportEditState createState() => _ReportEditState();
}

class _ReportEditState extends State<ReportEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late DeviceModel deviceModel;
  late String day;
  late String nguong;
  late DeviceDataSource ds;

  @override
  void initState() {
    deviceModel = widget.deviceModel ?? DeviceModel();
    day = widget.day ?? '7';
    nguong = widget.nguong ?? '50';
    ds = DeviceDataSource();
    ds.loadData(deviceId: deviceModel.deviceId, day: day, nguong: nguong);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataGrid = SfDataGrid(
      source: ds,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'Station ID',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).deviceId,
              style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 120,
        ),
        GridColumn(
          columnName: 'Station ID',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).stationId,
              style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 120,
        ),
        GridColumn(
            columnName: 'Ozone',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).ozone,
                style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            width: 120),
        GridColumn(
            columnName: 'Time',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).time,
                style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            width: 250),
      ],
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).deviceDetail),
        actions: [
          CryButtons.save(context, save),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: dataGrid),
        ],
      ),
    );
    return result;
  }

  save() {
    Navigator.pop(context, true);
  }

  audit() {
    action((data) async => await ArticleApi.audit(data));
  }

  public() async {
    action((data) async => await ArticleApi.public(data));
  }

  action(action) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    bool isSuccess = await action(deviceModel);
    if (isSuccess) {
      CryUtils.message(S.of(context).success);
      Navigator.pop(context, true);
    }
  }
}

class DeviceDataSource extends DataGridSource {
  String deviceId = '';
  String day = '';
  String nguong = '';
  List<DataGridRow> _rows = [];

  DeviceDataSource();

  loadData({String? deviceId, String? day, String? nguong}) async {
    if (deviceId != null) {
      this.deviceId = deviceId;
    }
    if (day != null) {
      this.day = day;
    }
    if (nguong != null) {
      this.nguong = nguong;
    }

    print('Nguong: $nguong');
    List<DeviceModel> devices =
        await ApiDioController.queryDetail(deviceId, day, nguong);

    _rows = devices.map<DataGridRow>((v) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'deviceModel', value: v),
      ]);
    }).toList(growable: false);
    notifyDataSourceListeners();
  }

  @override
  List<DataGridRow> get rows => _rows;

  // @override
  // Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
  //   pageModel.current = newPageIndex + 1;
  //   await loadData();
  //   return true;
  // }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    DeviceModel deviceModel = row.getCells()[0].value;
    return DataGridRowAdapter(cells: [
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.deviceId ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.stationId ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.ozone != null ? '${deviceModel.ozone}' : '--',
          style:
              TextStyle(fontFamily: 'BeVietnamPro-Medium', color: Colors.blue),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.time != null ? '${deviceModel.time}' : '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}
