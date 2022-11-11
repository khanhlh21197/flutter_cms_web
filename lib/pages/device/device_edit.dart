/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 文章编辑
import 'package:cry/cry_buttons.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/api/article_api.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/device_model.dart';

class DeviceEdit extends StatefulWidget {
  final DeviceModel? deviceModel;

  const DeviceEdit({Key? key, this.deviceModel}) : super(key: key);

  @override
  _DeviceEditState createState() => _DeviceEditState();
}

class _DeviceEditState extends State<DeviceEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late DeviceModel deviceModel;

  @override
  void initState() {
    deviceModel = widget.deviceModel ?? DeviceModel();

    super.initState();
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
                value: deviceModel.stationId,
                width: 400,
                onSaved: (v) {
                  deviceModel.stationId = v;
                },
              ),
              CryInput(
                label: S.of(context).adminId,
                value: deviceModel.adminId,
                width: 400,
                onSaved: (v) {
                  deviceModel.adminId = v;
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

    bool isSuccess = await action(deviceModel);
    if (isSuccess) {
      CryUtils.message(S.of(context).success);
      Navigator.pop(context, true);
    }
  }
}