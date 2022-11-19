/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:
import 'dart:convert';
import 'dart:html' hide File;
import 'dart:io';

import 'package:cry/cry.dart';
import 'package:cry/cry_button.dart';
import 'package:cry/cry_button_bar.dart';
import 'package:cry/cry_buttons.dart';
import 'package:cry/cry_dialog.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/form/cry_select_date.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/constants/constant_dict.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/pages/station/StationController.dart';
import 'package:flutter_admin/pages/station/station_edit.dart';
import 'package:flutter_admin/utils/dict_util.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class StationMain extends StatefulWidget {
  @override
  _StationMainState createState() => _StationMainState();
}

class _StationMainState extends State<StationMain> {
  StationController controller = Get.put(StationController());
  StationDataSource ds = StationDataSource();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StationModel stationModel = StationModel();
  GlobalKey<SfDataGridState> sfDataGridKey = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    ds.loadData();
    print('loadData initState');
    super.initState();
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
            onPressed: _createExcel),
      ],
    );
    var form = Form(
      key: formKey,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          CryInput(
            label: S.of(context).stationId,
            value: stationModel.stationId,
            width: 100,
            onSaved: (v) {
              stationModel.stationId = v;
            },
          ),
          CryInput(
            label: S.of(context).adminId,
            value: stationModel.adminId,
            width: 100,
            onSaved: (v) {
              stationModel.adminId = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: stationModel.name,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              stationModel.name = v;
            },
          ),
          CrySelectDate(
            context,
            label: S.of(context).description,
            value: stationModel.description,
            width: 200,
            onSaved: (v) {
              stationModel.description = v;
            },
          ),
          CrySelectDate(
            context,
            label: S.of(context).location,
            value: stationModel.location,
            width: 200,
            onSaved: (v) {
              stationModel.location = v;
            },
          ),
        ],
      ),
    );
    var dataGrid = SfDataGrid(
      key: sfDataGridKey,
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
              S.of(context).stationId,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 80,
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
            columnName: 'Number of device',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).numberOfDevice,
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
          form,
          buttonBar,
          Expanded(child: dataGrid),
          pager,
        ],
      ),
    );

    return result;
  }

  query() {
    formKey.currentState!.save();
    ds.loadData();
    print('loadData query');
  }

  reset() async {
    stationModel = StationModel();
    formKey.currentState!.reset();
    await ds.loadData(params: {});
    print('loadData reset');
  }

  _exportExcel() async {
    final Workbook workbook =
        sfDataGridKey.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    File('DataGrid.xlsx').writeAsBytes(bytes, flush: true);
    workbook.dispose();
  }

  Future<void> _createExcel() async {
// Create a new Excel Document.
    print('SFDataGridKey: $sfDataGridKey');
    if (sfDataGridKey.currentState == null) {
      CryUtils.message('Error');
      return null;
    }
    print('Key current state: ${sfDataGridKey.currentState}');
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    print('Stations: ${ds.stations}');

    // sheet.importData(_buildReportDataRows(await ds.stations), 1, 1);

    // Save and dispose the document.
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    //Download the output file in web.
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "output.xlsx")
      ..click();
  }
}

class StationDataSource extends DataGridSource {
  StationController controller = Get.find();

  // PageModel pageModel = PageModel();
  Map params = {};
  List<DataGridRow> _rows = [];

  loadData({Map? params}) async {
    if (params != null) {
      this.params = params;
    }
    List<StationModel> stations = (await ApiDioController.getAllStation());

    if (stations.isNotEmpty) {
      StoreUtil.write(Constant.EVN_STATIONS, stations);

      final Workbook workbook = Workbook();

      final Worksheet sheet = workbook.worksheets[0];

      sheet.importData(_buildReportDataRows(stations), 1, 1);

      // Save and dispose the document.
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      //Download the output file in web.
      AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
        ..setAttribute("download", "output.xlsx")
        ..click();
    }

    _rows = stations.map<DataGridRow>((v) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'stationModel', value: v),
      ]);
    }).toList(growable: false);
    notifyDataSourceListeners();
  }

  List<ExcelDataRow> _buildReportDataRows(List<StationModel> stations) {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = stations.map<ExcelDataRow>((StationModel dataRow) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(columnHeader: 'StationID', value: dataRow.stationId),
        ExcelDataCell(columnHeader: 'AdminID', value: dataRow.adminId),
        ExcelDataCell(columnHeader: 'Name', value: dataRow.name),
        ExcelDataCell(columnHeader: 'Description', value: dataRow.description),
        ExcelDataCell(columnHeader: 'Location', value: dataRow.location),
      ]);
    }).toList();

    return excelDataRows;
  }

  @override
  List<DataGridRow> get rows => _rows;

  List<StationModel> get stations => stations;

  // @override
  // Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
  //   pageModel.current = newPageIndex + 1;
  //   await loadData();
  //   return true;
  // }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    StationModel stationModel = row.getCells()[0].value;
    return DataGridRowAdapter(cells: [
      CryButtonBar(
        children: [
          CryButtons.edit(Cry.context, () => edit(stationModel: stationModel),
              showLabel: false),
          CryButtons.delete(Cry.context, () => delete(stationModel.stationId),
              showLabel: false),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.stationId ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.adminId ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.name ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          (stationModel.numberofdevice != null)
              ? '${stationModel.numberofdevice}'
              : '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.description ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.location ?? '--',
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  delete(ids) async {
    cryConfirm(Cry.context, S.of(Cry.context).confirmDelete, (context) async {
      if ((await ApiDioController.deleteStation(ids))) {
        loadData();
        print('loadData delete');
        CryUtils.message(S.of(Cry.context).success);
      }
    });
  }

  edit({StationModel? stationModel}) async {
    var result =
        await Utils.fullscreenDialog(StationEdit(stationModel: stationModel));
    if (result ?? false) {
      loadData();
      print('loadData edit');
    }
  }
}
