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
import 'package:flutter_admin/models/station_model.dart';

class StationEdit extends StatefulWidget {
  final StationModel? stationModel;

  const StationEdit({Key? key, this.stationModel}) : super(key: key);

  @override
  _StationEditState createState() => _StationEditState();
}

class _StationEditState extends State<StationEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late StationModel stationModel;

  @override
  void initState() {
    stationModel = widget.stationModel ?? StationModel();

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
                value: stationModel.stationId,
                width: 400,
                onSaved: (v) {
                  stationModel.stationId = v;
                },
              ),
              CryInput(
                label: S.of(context).adminId,
                value: stationModel.adminId,
                width: 400,
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
