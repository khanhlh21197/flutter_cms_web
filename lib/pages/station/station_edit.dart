/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 文章编辑
import 'package:cry/cry_buttons.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/api/article_api.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/admin_model.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/pages/device/device_main.dart';
import 'package:flutter_admin/utils/cry_select_item_util.dart';
import 'package:flutter_admin/utils/store_util.dart';

class StationEdit extends StatefulWidget {
  final StationModel? stationModel;

  const StationEdit({Key? key, this.stationModel}) : super(key: key);

  @override
  _StationEditState createState() => _StationEditState();
}

class _StationEditState extends State<StationEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late StationModel stationModel;
  List<AdminModel> admins = [];

  @override
  void initState() {
    stationModel = widget.stationModel ?? StationModel();
    stationModel.adminId = StoreUtil.read(Constant.ADMIN_ID)!;

    initData();
    super.initState();
  }

  Future initData() async {
    if (admins.isEmpty) {
      admins = await ApiDioController.getAllAdmin();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: Column(
        children: [
          Wrap(
            children: [
              CryInput(
                label: S.of(context).stationId,
                value: stationModel.stationId,
                width: 400,
                onSaved: (v) {
                  stationModel.stationId = v;
                },
              ),
              CrySelect(
                label: S.of(context).adminId,
                dataList: CrySelectItemUtil.getAdminIdSelectOptionList(admins),
                value: stationModel.adminId,
                onSaved: (v) {
                  stationModel.adminId = v;
                },
              ),
              CryInput(
                label: S.of(context).name,
                value: stationModel.name,
                width: 400,
                onSaved: (v) {
                  stationModel.name = v;
                },
              ),
              CryInput(
                label: S.of(context).description,
                value: stationModel.description,
                width: 400,
                onSaved: (v) {
                  stationModel.description = v;
                },
              ),
              CryInput(
                label: S.of(context).location,
                value: stationModel.location,
                width: 400,
                onSaved: (v) {
                  stationModel.location = v;
                },
              ),
            ],
          ),
        ],
      ),
    );
    var devicesTable = stationModel.stationId != null
        ? Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 3,
                ),
              ),
              child: DeviceMain(
                stationId: stationModel.stationId!,
              ),
            ),
          )
        : Container();
    var result = Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).add),
        actions: [
          CryButtons.save(context, save),
        ],
      ),
      body: Column(children: [
        form,
        devicesTable,
      ]),
    );
    return result;
  }

  save() {
    if (widget.stationModel == null) {
      print('save');
      action((data) async => await ApiDioController.registerStation(data));
    } else {
      print('edit');
      action((data) async => await ApiDioController.updateStation(data));
    }
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

    bool isSuccess = await action(stationModel);
    if (isSuccess) {
      CryUtils.message(S.of(context).success);
      Navigator.pop(context, true);
    }
  }
}
