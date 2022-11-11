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
import 'package:cry/model/page_model.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/api/article_api.dart';
import 'package:flutter_admin/constants/constant_dict.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/models/user_model.dart';
import 'package:flutter_admin/pages/station/station_edit.dart';
import 'package:flutter_admin/utils/dict_util.dart';
import 'package:flutter_admin/utils/utils.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserMain extends StatefulWidget {
  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  UserDataSource ds = UserDataSource();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();
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
          CryInput(
            label: S.of(context).stationId,
            value: userModel.user,
            width: 100,
            onSaved: (v) {
              userModel.user = v;
            },
          ),
          CryInput(
            label: S.of(context).adminId,
            value: userModel.pass,
            width: 100,
            onSaved: (v) {
              userModel.pass = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: userModel.name,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              userModel.name = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: userModel.phone,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              userModel.phone = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: userModel.address,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              userModel.address = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: userModel.birthDate,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              userModel.birthDate = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: userModel.playerId,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              userModel.playerId = v;
            },
          ),
          CrySelect(
            label: S.of(context).name,
            value: userModel.adminId,
            width: 200,
            dataList: DictUtil.getDictSelectOptionList(
                ConstantDict.CODE_ARTICLE_STATUS),
            onSaved: (v) {
              userModel.adminId = v;
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
  }

  reset() async {
    userModel = UserModel();
    formKey.currentState!.reset();
    await ds.loadData(params: {});
  }
}

class UserDataSource extends DataGridSource {
  PageModel pageModel = PageModel();
  Map params = {};
  List<DataGridRow> _rows = [];

  loadData({Map? params}) async {
    if (params != null) {
      this.params = params;
    }
    List<UserModel> stations = (await ApiDioController.getAllUser());

    _rows = stations.map<DataGridRow>((v) {
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

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    StationModel stationModel = row.getCells()[0].value;
    return DataGridRowAdapter(cells: [
      CryButtonBar(
        children: [
          CryButtons.edit(Cry.context, () => edit(stationModel: stationModel),
              showLabel: false),
          CryButtons.delete(Cry.context, () => delete([stationModel.stationId]),
              showLabel: false),
        ],
      ),
      Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          stationModel.stationId!,
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
      if ((await ArticleApi.removeByIds(ids)).success!) {
        loadData();
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
