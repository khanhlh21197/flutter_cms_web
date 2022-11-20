/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:
import 'package:cry/cry.dart';
import 'package:cry/cry_button_bar.dart';
import 'package:cry/cry_buttons.dart';
import 'package:cry/cry_dialog.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/form/cry_select_date.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant_dict.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/pages/device/device_edit.dart';
import 'package:flutter_admin/utils/cry_select_item_util.dart';
import 'package:flutter_admin/utils/dict_util.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportMain extends StatefulWidget {
  const ReportMain({Key? key}) : super(key: key);

  @override
  _ReportMainState createState() => _ReportMainState();
}

class _ReportMainState extends State<ReportMain> {
  late DeviceDataSource ds;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DeviceModel deviceModel = DeviceModel();
  List<StationModel> stations = [];
  String day = '';

  _ReportMainState();

  @override
  void initState() {
    ds = DeviceDataSource();
    initData();
    super.initState();
  }

  void initData() async {
    if (stations.isEmpty) {
      stations = await ApiDioController.getAllStation();
    }

    ds.loadData(stationId: 'evnStaion2', day: '7');
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = CryButtonBar(
      children: [
        CryButtons.query(context, query),
        CryButtons.reset(context, reset),
        CryButtons.add(context, ds.edit),
      ],
    );
    var form = Form(
      key: formKey,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          CrySelect(
            label: S.of(context).stationId,
            dataList: CrySelectItemUtil.getStationIdSelectOptionList(stations),
            value: deviceModel.stationId,
            onSaved: (v) {
              deviceModel.stationId = v;
            },
          ),
          CrySelect(
            label: S.of(context).day,
            dataList: CrySelectItemUtil.getStationIdSelectOptionList(stations),
            value: day,
            onSaved: (v) {
              day = v;
            },
          ),
        ],
      ),
    );
    var dataGrid = SfDataGrid(
      source: ds,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'operation',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).operating,
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
              S.of(context).deviceId,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 80,
        ),
        GridColumn(
          columnName: 'Station ID',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).stationId,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 100,
        ),
        GridColumn(
            columnName: 'Admin ID',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).adminId,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            width: 80),
      ],
    );
    var result = Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          form,
          buttonBar,
          Expanded(child: dataGrid),
        ],
      ),
    );
    return result;
  }

  query() {
    formKey.currentState!.save();
    ds.loadData(stationId: 'evnStaion2', day: day ?? '7');
  }

  reset() async {
    deviceModel = DeviceModel();
    formKey.currentState!.reset();
    await ds.loadData();
  }
}

class DeviceDataSource extends DataGridSource {
  String stationId = '';
  String day = '';
  List<DataGridRow> _rows = [];

  DeviceDataSource();

  loadData({String? stationId, String? day}) async {
    if (stationId != null) {
      this.stationId = stationId;
    }
    if (day != null) {
      this.day = day;
    }

    List<DeviceModel> devices =
        await ApiDioController.queryStation(stationId, day);

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
      CryButtonBar(
        children: [
          CryButtons.edit(Cry.context, () => edit(deviceModel: deviceModel),
              showLabel: false),
          CryButtons.delete(Cry.context, () => delete(deviceModel.deviceId),
              showLabel: false),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.deviceId ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.stationId ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.ozone != null ? '${deviceModel.ozone}' : '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  delete(ids) async {
    cryConfirm(Cry.context, S.of(Cry.context).confirmDelete, (context) async {
      if ((await ApiDioController.deleteDevice(ids))) {
        loadData();
        CryUtils.message(S.of(Cry.context).success);
      }
    });
  }

  edit({DeviceModel? deviceModel}) async {
    var result =
        await Utils.fullscreenDialog(DeviceEdit(deviceModel: deviceModel));
    if (result ?? false) {
      loadData();
    }
  }
}
