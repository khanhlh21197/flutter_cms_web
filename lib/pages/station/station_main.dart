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
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/constants/constant_dict.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/pages/station/station_edit.dart';
import 'package:flutter_admin/utils/dict_util.dart';
import 'package:flutter_admin/utils/excel_export.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class StationMain extends StatefulWidget {
  @override
  _StationMainState createState() => _StationMainState();
}

class _StationMainState extends State<StationMain> {
  StationDataSource ds = StationDataSource();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StationModel stationModel = StationModel();
  bool isAdmin = StoreUtil.read(Constant.IS_ADMIN) ?? false;
  String? userId = StoreUtil.read(Constant.USER_ID) ?? null;

  @override
  void initState() {
    Map? params;
    if (userId != null) {
      params = {'userId': userId};
    } else {
      params = null;
    }
    ds.loadData(params: params);
    print('loadData initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buttonBar = CryButtonBar(
      children: [
        // CryButtons.query(context, query),
        CryButtons.reset(context, reset),
        isAdmin ? CryButtons.add(context, ds.edit) : Container(),
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
    var dataGrid = SfDataGridTheme(
      data: SfDataGridThemeData(
          rowHoverTextStyle:
              TextStyle(color: Colors.red, fontFamily: 'BeVietnamPro-Medium')),
      child: SfDataGrid(
        source: ds,
        columns: <GridColumn>[
          isAdmin
              ? GridColumn(
                  columnName: 'operation',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).operating,
                      style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  width: 120,
                )
              : GridColumn(
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
              columnName: 'Admin ID',
              label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).adminId,
                  style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
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
                  style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: 150),
          GridColumn(
              columnName: 'Number of device',
              label: Container(
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).numberOfDevice,
                  style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              width: 150),
          GridColumn(
            columnName: 'Description',
            label: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).description,
                style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
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
                style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            width: 120,
          ),
        ],
      ),
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
    await ExcelExportUtil.export(Constant.STATION_WORKBOOK, 'stations.xlsx');
  }

  query() {
    formKey.currentState!.save();
    ds.loadData();
    print('loadData query');
  }

  reset() async {
    stationModel = StationModel();
    formKey.currentState!.reset();
    await ds.loadData();
  }
}

class StationDataSource extends DataGridSource {
  // PageModel pageModel = PageModel();
  Map params = {};
  List<DataGridRow> _rows = [];
  late List<StationModel> stations;
  bool isAdmin = StoreUtil.read(Constant.IS_ADMIN) ?? false;

  loadData({Map? params}) async {
    if (params != null) {
      this.params = params;
      stations = (await ApiDioController.getStationByUser(params));
    } else {
      stations = (await ApiDioController.getAllStation());
    }

    if (stations.isNotEmpty) {
      StoreUtil.write(Constant.EVN_STATIONS, stations);
      ExcelExportUtil.createWorkbook(
          Constant.STATION_WORKBOOK, _buildReportDataRows(stations));
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
        ExcelDataCell(columnHeader: 'Mã trạm', value: dataRow.stationId),
        ExcelDataCell(columnHeader: 'Admin', value: dataRow.adminId),
        ExcelDataCell(columnHeader: 'Tên', value: dataRow.name),
        ExcelDataCell(columnHeader: 'Ghi chú', value: dataRow.description),
        ExcelDataCell(columnHeader: 'Vị trí', value: dataRow.location),
      ]);
    }).toList();

    return excelDataRows;
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
    StationModel stationModel = row.getCells()[0].value;
    return DataGridRowAdapter(cells: [
      CryButtonBar(
        children: [
          CryButtons.edit(Cry.context, () => edit(stationModel: stationModel),
              showLabel: false),
          isAdmin
              ? CryButtons.delete(
                  Cry.context, () => delete(stationModel.stationId),
                  showLabel: false)
              : Container(),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.stationId ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.adminId ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.name ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
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
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.description ?? '--',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.location ?? '--',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
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
    }
  }
}
