/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:
import 'package:cry/cry.dart';
import 'package:cry/cry_button.dart';
import 'package:cry/cry_button_bar.dart';
import 'package:cry/cry_buttons.dart';
import 'package:cry/cry_dialog.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/form/cry_select_date.dart';
import 'package:cry/model/page_model.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/constants/constant_dict.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:flutter_admin/pages/device/device_edit.dart';
import 'package:flutter_admin/pages/mqtt/mqttBrowserWrapper.dart';
import 'package:flutter_admin/utils/dict_util.dart';
import 'package:flutter_admin/utils/excel_export.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class DeviceMain extends StatefulWidget {
  const DeviceMain({Key? key, required this.stationId}) : super(key: key);

  @override
  _DeviceMainState createState() => _DeviceMainState(stationId);

  final String stationId;
}

class _DeviceMainState extends State<DeviceMain> {
  final String stationId;
  late MQTTBrowserWrapper mqttBrowserWrapper;
  late DeviceDataSource ds;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DeviceModel deviceModel = DeviceModel();

  _DeviceMainState(this.stationId);

  @override
  void initState() {
    ds = DeviceDataSource(stationId);
    ds.loadData();
    initMqtt();
    super.initState();
  }

  void initMqtt() async {
    mqttBrowserWrapper = MQTTBrowserWrapper(() {
      print('Connect success');
    }, (p0) => print(p0));

    mqttBrowserWrapper.prepareMqttClient('topic');
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = CryButtonBar(
      children: [
        CryButtons.query(context, query),
        CryButtons.reset(context, reset),
        CryButtons.add(context, ds.edit),
        CryButton(
            iconData: Icons.reply,
            label: S.of(context).exportExcel,
            onPressed: exportExcel),
      ],
    );
    var form = Form(
      key: formKey,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          CryInput(
            label: S.of(context).deviceId,
            value: deviceModel.deviceId,
            width: 100,
            onSaved: (v) {
              deviceModel.deviceId = v;
            },
          ),
          CryInput(
            label: S.of(context).stationId,
            value: deviceModel.stationId,
            width: 100,
            onSaved: (v) {
              deviceModel.stationId = v;
            },
          ),
          CryInput(
            label: S.of(context).adminId,
            value: deviceModel.adminId,
            width: 100,
            onSaved: (v) {
              deviceModel.adminId = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: deviceModel.name,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              deviceModel.name = v;
            },
          ),
          CrySelectDate(
            context,
            label: S.of(context).description,
            value: deviceModel.description,
            width: 200,
            onSaved: (v) {
              deviceModel.description = v;
            },
          ),
          CrySelectDate(
            context,
            label: S.of(context).location,
            value: deviceModel.location,
            width: 200,
            onSaved: (v) {
              deviceModel.location = v;
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
          columnName: 'Device ID',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).deviceId,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 100,
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
            width: 200),
        GridColumn(
            columnName: 'Name',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            width: 80),
        GridColumn(
          columnName: 'Description',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).description,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          columnWidthMode: ColumnWidthMode.fill,
        ),
        GridColumn(
          columnName: 'Location',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).location,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 120,
        ),
      ],
    );
    var pager = SfDataPagerTheme(
      data: SfDataPagerThemeData(
        brightness: Brightness.light,
        selectedItemColor: Get.theme.primaryColor,
      ),
      child: SfDataPager(
        delegate: ds,
        pageCount: 10,
        direction: Axis.horizontal,
      ),
    );
    var result = Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // form,
          buttonBar,
          Expanded(child: dataGrid),
          pager,
        ],
      ),
    );
    return result;
  }

  Future<void> exportExcel() async {
    await ExcelExportUtil.export(Constant.DEVICE_WORKBOOK, 'devices.xlsx');
  }

  query() {
    formKey.currentState!.save();
    ds.loadData();
  }

  reset() async {
    deviceModel = DeviceModel();
    formKey.currentState!.reset();
    await ds.loadData();
  }
}

class DeviceDataSource extends DataGridSource {
  PageModel pageModel = PageModel();
  Map params = {};
  List<DataGridRow> _rows = [];
  final String stationId;

  DeviceDataSource(this.stationId);

  loadData({Map? params}) async {
    if (params != null) {
      this.params = params;
    }

    List<DeviceModel> devices = [];

    if (stationId.isEmpty) {
      devices = (await ApiDioController.getAllDevice());
    } else {
      devices = await ApiDioController.getDeviceByStationId(stationId);
    }

    if (devices.isNotEmpty) {
      ExcelExportUtil.createWorkbook(
          Constant.DEVICE_WORKBOOK, _buildReportDataRows(devices));
    }

    _rows = devices.map<DataGridRow>((v) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'deviceModel', value: v),
      ]);
    }).toList(growable: false);
    notifyDataSourceListeners();
  }

  List<ExcelDataRow> _buildReportDataRows(List<DeviceModel> stations) {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = stations.map<ExcelDataRow>((DeviceModel dataRow) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(columnHeader: 'Mã trạm', value: dataRow.stationId),
        ExcelDataCell(columnHeader: 'Admin', value: dataRow.adminId),
        ExcelDataCell(columnHeader: 'Mã thiết bị', value: dataRow.deviceId),
        ExcelDataCell(columnHeader: 'Tên', value: dataRow.name),
        ExcelDataCell(columnHeader: 'Ghi chú', value: dataRow.description),
        ExcelDataCell(columnHeader: 'Vị trí', value: dataRow.location),
      ]);
    }).toList();

    return excelDataRows;
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    pageModel.current = newPageIndex + 1;
    await loadData();
    return true;
  }

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
          deviceModel.deviceId!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.stationId!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.adminId ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.name ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.description ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          deviceModel.location ?? '--',
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
