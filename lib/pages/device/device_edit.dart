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
import 'package:cry/vo/select_option_vo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/api/article_api.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/admin_model.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/utils/cry_select_item_util.dart';

class DeviceEdit extends StatefulWidget {
  final DeviceModel? deviceModel;

  const DeviceEdit({Key? key, this.deviceModel}) : super(key: key);

  @override
  _DeviceEditState createState() => _DeviceEditState();
}

class _DeviceEditState extends State<DeviceEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late DeviceModel deviceModel;
  List<AdminModel> admins = [];
  List<StationModel> stations = [];

  List<SelectOptionVO> adminSelect = [];
  List<SelectOptionVO> stationSelect = [];
  List<SelectOptionVO> thresholds = [
    SelectOptionVO(value: '5', label: '5'),
    SelectOptionVO(value: '10', label: '10'),
    SelectOptionVO(value: '15', label: '15'),
  ];

  @override
  void initState() {
    deviceModel = widget.deviceModel ?? DeviceModel();
    if (deviceModel.threshold1 == null || deviceModel.threshold1 == '') {
      deviceModel.threshold1 = '5';
    }
    if (deviceModel.threshold2 == null || deviceModel.threshold2 == '') {
      deviceModel.threshold2 = '10';
    }
    if (deviceModel.threshold3 == null || deviceModel.threshold3 == '') {
      deviceModel.threshold3 = '15';
    }
    super.initState();
    initData();
  }

  void initData() async {
    if (admins.isEmpty) {
      admins = await ApiDioController.getAllAdmin();
    }
    if (stations.isEmpty) {
      stations = await ApiDioController.getAllStation();
    }

    adminSelect = CrySelectItemUtil.getAdminIdSelectOptionList(admins);
    stationSelect = CrySelectItemUtil.getStationIdSelectOptionList(stations);

    if (deviceModel.adminId == null || deviceModel.adminId!.isEmpty) {
      deviceModel.adminId = adminSelect[0].value as String?;
    }

    if (deviceModel.stationId == null || deviceModel.stationId!.isEmpty) {
      deviceModel.stationId = stationSelect[0].value as String?;
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
                label: S.of(context).deviceId,
                value: deviceModel.deviceId,
                width: 400,
                onSaved: (v) {
                  deviceModel.deviceId = v;
                },
              ),
              CrySelect(
                label: S.of(context).adminId,
                dataList: adminSelect,
                value: deviceModel.adminId,
                onSaved: (v) {
                  deviceModel.adminId = v;
                },
              ),
              CrySelect(
                label: S.of(context).stationId,
                dataList: stationSelect,
                value: deviceModel.stationId,
                onSaved: (v) {
                  deviceModel.stationId = v;
                },
              ),
              CryInput(
                label: S.of(context).name,
                value: deviceModel.name,
                width: 400,
                onSaved: (v) {
                  deviceModel.name = v;
                },
              ),
              CryInput(
                label: S.of(context).description,
                value: deviceModel.description,
                width: 400,
                onSaved: (v) {
                  deviceModel.description = v;
                },
              ),
              CryInput(
                label: S.of(context).location,
                value: deviceModel.location,
                width: 400,
                onSaved: (v) {
                  deviceModel.location = v;
                },
              ),
              CrySelect(
                label: S.of(context).threshold1,
                dataList: thresholds,
                value: deviceModel.threshold1,
                width: 400,
                onSaved: (v) {
                  deviceModel.threshold1 = v;
                },
              ),
              CrySelect(
                label: S.of(context).threshold2,
                dataList: thresholds,
                width: 400,
                value: deviceModel.threshold2,
                onSaved: (v) {
                  deviceModel.threshold2 = v;
                },
              ),
              CrySelect(
                label: S.of(context).threshold3,
                dataList: thresholds,
                width: 400,
                value: deviceModel.threshold3,
                onSaved: (v) {
                  deviceModel.threshold3 = v;
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
    if (widget.deviceModel == null) {
      print('save');
      action((data) async => await ApiDioController.registerDevice(data));
    } else {
      print('edit');
      action((data) async => await ApiDioController.updateDevice(data));
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

    bool isSuccess = await action(deviceModel);
    if (isSuccess) {
      CryUtils.message(S.of(context).success);
      Navigator.pop(context, true);
    }
  }
}
