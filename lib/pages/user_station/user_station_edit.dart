/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 文章编辑
import 'package:cry/cry_buttons.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/api/article_api.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/admin_model.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/models/user_model.dart';
import 'package:flutter_admin/models/user_station_model.dart';
import 'package:flutter_admin/utils/cry_select_item_util.dart';

class UserStationEdit extends StatefulWidget {
  final UserStationModel? userStationModel;

  const UserStationEdit({Key? key, this.userStationModel}) : super(key: key);

  @override
  _UserStationEditState createState() => _UserStationEditState();
}

class _UserStationEditState extends State<UserStationEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late UserStationModel userStationModel;
  List<AdminModel> admins = [];
  List<StationModel> stations = [];
  List<UserModel> users = [];

  @override
  void initState() {
    userStationModel = widget.userStationModel ?? UserStationModel();
    initData();
    super.initState();
  }

  Future initData() async {
    // admins = StoreUtil.readAdmins();
    // stations = StoreUtil.readStations();
    // users = StoreUtil.readUsers();

    if (admins.isEmpty) {
      admins = await ApiDioController.getAllAdmin();
    }

    if (stations.isEmpty) {
      stations = await ApiDioController.getAllStation();
    }

    if (users.isEmpty) {
      users = await ApiDioController.getAllUser();
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
              CrySelect(
                label: S.of(context).userId,
                value: userStationModel.userId,
                width: 200,
                dataList: CrySelectItemUtil.getUserIdSelectOptionList(users),
                onSaved: (v) {
                  userStationModel.userId = v;
                },
              ),
              CrySelect(
                label: S.of(context).stationId,
                value: userStationModel.stationId,
                width: 200,
                dataList:
                    CrySelectItemUtil.getStationIdSelectOptionList(stations),
                onSaved: (v) {
                  userStationModel.stationId = v;
                },
              ),
              CrySelect(
                label: S.of(context).adminId,
                value: userStationModel.adminId,
                width: 200,
                dataList: CrySelectItemUtil.getAdminIdSelectOptionList(admins),
                onSaved: (v) {
                  userStationModel.adminId = v;
                },
              ),
            ],
          ),
        ],
      ),
    );
    var result = Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).add),
        actions: [
          CryButtons.save(context, save),
        ],
      ),
      body: form,
    );
    return result;
  }

  save() {
    if (widget.userStationModel == null) {
      print('save');
      action((data) async => await ApiDioController.registerUserStation(data));
    } else {
      print('edit');
      action((data) async => await ApiDioController.updateUserStation(data));
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

    bool isSuccess = await action(userStationModel);
    if (isSuccess) {
      CryUtils.message(S.of(context).success);
      Navigator.pop(context, true);
    }
  }
}
