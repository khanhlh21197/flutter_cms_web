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
import 'package:cry/form1/cry_input.dart';
import 'package:cry/model/page_model.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/user_model.dart';
import 'package:flutter_admin/pages/admin/admin_edit.dart';
import 'package:flutter_admin/utils/excel_export.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class AdminMain extends StatefulWidget {
  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  AdminDataSource ds = AdminDataSource();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel adminModel = UserModel();

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
            label: S.of(context).user,
            value: adminModel.user,
            width: 200,
            onSaved: (v) {
              adminModel.user = v;
            },
          ),
          CryInput(
            label: S.of(context).name,
            value: adminModel.name,
            width: 200,
            onSaved: (v) {
              adminModel.name = v;
            },
          ),
          CryInput(
            label: S.of(context).phone,
            value: adminModel.phone,
            width: 200,
            onSaved: (v) {
              adminModel.phone = v;
            },
          ),
          CryInput(
            label: S.of(context).address,
            value: adminModel.address,
            width: 200,
            onSaved: (v) {
              adminModel.address = v;
            },
          ),
          CryInput(
            label: S.of(context).birthDate,
            value: adminModel.birthDate,
            width: 200,
            onSaved: (v) {
              adminModel.birthDate = v;
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
          columnName: 'Description',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).phone,
              style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 150,
        ),
        GridColumn(
          columnName: 'Location',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).address,
              style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          width: 120,
        ),
        GridColumn(
          columnName: 'Location',
          label: Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              S.of(context).birthDate,
              style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
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
    await ExcelExportUtil.export(Constant.ADMIN_WORKBOOK, 'admins.xlsx');
  }

  query() {
    formKey.currentState!.save();
    ds.loadData();
  }

  reset() async {
    adminModel = UserModel();
    formKey.currentState!.reset();
    await ds.loadData();
  }
}

class AdminDataSource extends DataGridSource {
  PageModel pageModel = PageModel();
  Map params = {};
  List<DataGridRow> _rows = [];

  loadData({Map? params}) async {
    if (params != null) {
      this.params = params;
    }
    List<UserModel> admins = (await ApiDioController.getAllAdmin());

    if (admins.isNotEmpty) {
      StoreUtil.writeAdmins(admins);

      ExcelExportUtil.createWorkbook(
          Constant.ADMIN_WORKBOOK, _buildReportDataRows(admins));
    }

    _rows = admins.map<DataGridRow>((v) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'adminModel', value: v),
      ]);
    }).toList(growable: false);
    notifyDataSourceListeners();
  }

  List<ExcelDataRow> _buildReportDataRows(List<UserModel> stations) {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = stations.map<ExcelDataRow>((UserModel dataRow) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(columnHeader: 'Admin', value: dataRow.adminId),
        ExcelDataCell(columnHeader: 'T??i kho???n', value: dataRow.user),
        ExcelDataCell(columnHeader: 'T??n', value: dataRow.name),
        ExcelDataCell(columnHeader: 'S??T', value: dataRow.phone),
        ExcelDataCell(columnHeader: '?????a ch???', value: dataRow.address),
        ExcelDataCell(columnHeader: 'Ng??y sinh', value: dataRow.birthDate),
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
    UserModel adminModel = row.getCells()[0].value;
    return DataGridRowAdapter(cells: [
      CryButtonBar(
        children: [
          CryButtons.edit(Cry.context, () => edit(adminModel: adminModel),
              showLabel: false),
          CryButtons.delete(Cry.context, () => delete(adminModel.user),
              showLabel: false),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          adminModel.user ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          adminModel.name ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          adminModel.phone ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          adminModel.address ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          adminModel.birthDate ?? '--',
          style: TextStyle(fontFamily: 'BeVietnamPro-Medium'),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  delete(ids) async {
    cryConfirm(Cry.context, S.of(Cry.context).confirmDelete, (context) async {
      if ((await ApiDioController.deleteAdmin(ids))) {
        loadData();
        CryUtils.message(S.of(Cry.context).success);
      }
    });
  }

  edit({UserModel? adminModel}) async {
    var result =
        await Utils.fullscreenDialog(AdminEdit(adminModel: adminModel));
    if (result ?? false) {
      loadData();
    }
  }
}
