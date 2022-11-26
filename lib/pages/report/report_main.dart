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
import 'package:cry/form/cry_select.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:cry/vo/select_option_vo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/pages/report/report_edit.dart';
import 'package:flutter_admin/utils/cry_select_item_util.dart';
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
  List<SelectOptionVO> stationSelect = [];
  List<String> days = ['7', '15', '30'];
  String day = '7';

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

    stationSelect = CrySelectItemUtil.getStationIdSelectOptionList(stations);
    deviceModel.stationId = stations[0].stationId;

    setState(() {});

    // ds.loadData(stationId: 'evnStation2', day: '7');
  }

  @override
  Widget build(BuildContext context) {
    CrySelectItemUtil.getDayNumberSelectOptionList(days).forEach((element) {
      print('Value: ${element.value}');
      print('Label: ${element.label}');
    });
    var buttonBar = CryButtonBar(
      children: [
        CryButtons.query(context, query),
      ],
    );
    var form = Form(
      key: formKey,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          CrySelect(
            label: S.of(context).stationId,
            dataList: stationSelect,
            value: deviceModel.stationId,
            onSaved: (v) {
              deviceModel.stationId = v;
            },
          ),
          CrySelect(
            label: S.of(context).day,
            dataList: CrySelectItemUtil.getDayNumberSelectOptionList(days),
            value: day,
            onSaved: (v) {
              print('Day: $v');
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
            columnName: 'Số lần vượt',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).solanvuot,
                style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            width: 120),
        GridColumn(
          columnName: 'operation',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).deviceDetail,
              style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 120,
        ),
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
    ds.loadData(stationId: 'evnStation2', day: day);
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
          deviceModel.solanvuot != null ? '${deviceModel.solanvuot}' : '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      CryButtonBar(
        children: [
          CryButtons.edit(
              Cry.context, () => edit(deviceModel: deviceModel, day: day),
              showLabel: false),
        ],
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

  edit({DeviceModel? deviceModel, String? day}) async {
    print('Day select: $day');
    var result = await Utils.fullscreenDialog(ReportEdit(
      deviceModel: deviceModel,
      day: day,
    ));
    if (result ?? false) {
      loadData();
    }
  }
}
