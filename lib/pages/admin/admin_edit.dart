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
import 'package:flutter_admin/models/user_model.dart';

class AdminEdit extends StatefulWidget {
  final UserModel? adminModel;

  const AdminEdit({Key? key, this.adminModel}) : super(key: key);

  @override
  _AdminEditState createState() => _AdminEditState();
}

class _AdminEditState extends State<AdminEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late UserModel adminModel;

  @override
  void initState() {
    adminModel = widget.adminModel ?? UserModel();

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
                label: S.of(context).user,
                value: adminModel.user,
                width: 400,
                onSaved: (v) {
                  adminModel.user = v;
                },
              ),
              CryInput(
                label: S.of(context).pass,
                value: adminModel.pass,
                width: 400,
                onSaved: (v) {
                  adminModel.pass = v;
                },
              ),
              CryInput(
                label: S.of(context).name,
                value: adminModel.name,
                width: 400,
                onSaved: (v) {
                  adminModel.name = v;
                },
              ),
              CryInput(
                label: S.of(context).phone,
                value: adminModel.phone,
                width: 400,
                onSaved: (v) {
                  adminModel.phone = v;
                },
              ),
              CryInput(
                label: S.of(context).address,
                value: adminModel.address,
                width: 400,
                onSaved: (v) {
                  adminModel.address = v;
                },
              ),
              CryInput(
                label: S.of(context).birthDate,
                value: adminModel.birthDate,
                width: 400,
                onSaved: (v) {
                  adminModel.birthDate = v;
                },
              ),
              CryInput(
                label: S.of(context).playerId,
                value: adminModel.playerId,
                width: 400,
                onSaved: (v) {
                  adminModel.playerId = v;
                },
              ),
            ],
          ),
        ],
      ),
    );
    var result = Scaffold(
      appBar: AppBar(
        title: adminModel == UserModel()
            ? Text(S.of(context).add)
            : Text(S.of(context).update),
        actions: [
          CryButtons.save(context, save),
        ],
      ),
      body: form,
    );
    return result;
  }

  save() {
    if (widget.adminModel == null) {
      print('save');
      action((data) async => await ApiDioController.registerAdmin(data));
    } else {
      print('edit');
      action((data) async => await ApiDioController.updateAdmin(data));
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

    bool isSuccess = await action(adminModel);
    if (isSuccess) {
      CryUtils.message(S.of(context).success);
      Navigator.pop(context, true);
    }
  }
}
