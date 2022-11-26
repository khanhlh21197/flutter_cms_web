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
import 'package:cry/model/page_model.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/user_station_model.dart';
import 'package:flutter_admin/pages/user_station/user_station_edit.dart';
import 'package:flutter_admin/utils/excel_export.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class UserStationMain extends StatefulWidget {
  @override
  _UserStationMainState createState() => _UserStationMainState();
}

class _UserStationMainState extends State<UserStationMain> {
  UserStationDataSource ds = UserStationDataSource();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserStationModel userStation = UserStationModel();
  bool isAdmin = StoreUtil.read(Constant.IS_ADMIN) ?? false;

  @override
  void initState() {
    ds.loadData();
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
            value: userStation.userId,
            width: 100,
            onSaved: (v) {
              userStation.userId = v;
            },
          ),
          CryInput(
            label: S.of(context).name,
            value: userStation.username,
            width: 200,
            onSaved: (v) {
              userStation.username = v;
            },
          ),
          CryInput(
            label: S.of(context).name,
            value: userStation.adminId,
            width: 200,
            onSaved: (v) {
              userStation.adminId = v;
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
              S.of(context).user,
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
            width: 100),
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

  query() {
    formKey.currentState!.save();
    ds.loadData();
  }

  reset() async {
    userStation = UserStationModel();
    formKey.currentState!.reset();
    await ds.loadData();
  }

  Future<void> exportExcel() async {
    await ExcelExportUtil.export(
        Constant.USER_STATION_WORKBOOK, 'user_station.xlsx');
  }
}

class UserStationDataSource extends DataGridSource {
  PageModel pageModel = PageModel();
  Map params = {};
  List<DataGridRow> _rows = [];
  bool isAdmin = StoreUtil.read(Constant.IS_ADMIN) ?? false;

  loadData({Map? params}) async {
    if (params != null) {
      this.params = params;
    }
    List<UserStationModel> userStations =
        (await ApiDioController.getAllUserStation());

    if (userStations.isNotEmpty) {
      ExcelExportUtil.createWorkbook(
          Constant.USER_STATION_WORKBOOK, _buildReportDataRows(userStations));
    }

    _rows = userStations.map<DataGridRow>((v) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'userModel', value: v),
      ]);
    }).toList(growable: false);

    notifyDataSourceListeners();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    pageModel.current = newPageIndex + 1;
    await loadData();
    return true;
  }

  List<ExcelDataRow> _buildReportDataRows(List<UserStationModel> userStations) {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = userStations.map<ExcelDataRow>((UserStationModel dataRow) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(columnHeader: 'Mã trạm', value: dataRow.stationId),
        ExcelDataCell(columnHeader: 'Admin', value: dataRow.adminId),
        ExcelDataCell(columnHeader: 'User', value: dataRow.username),
      ]);
    }).toList();

    return excelDataRows;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    UserStationModel userStation = row.getCells()[0].value;
    return DataGridRowAdapter(cells: [
      isAdmin
          ? CryButtonBar(
              children: [
                CryButtons.edit(
                    Cry.context, () => edit(userStation: userStation),
                    showLabel: false),
                CryButtons.delete(
                    Cry.context, () => delete(userStation.adminId),
                    showLabel: false),
              ],
            )
          : Container(),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          userStation.username ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          userStation.adminId ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          userStation.stationId ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  delete(ids) async {
    cryConfirm(Cry.context, S.of(Cry.context).confirmDelete, (context) async {
      if ((await ApiDioController.deleteUser(ids))) {
        loadData();
        CryUtils.message(S.of(Cry.context).success);
      }
    });
  }

  edit({UserStationModel? userStation}) async {
    var result = await Utils.fullscreenDialog(
        UserStationEdit(userStationModel: userStation));
    if (result ?? false) {
      loadData();
    }
  }
}
