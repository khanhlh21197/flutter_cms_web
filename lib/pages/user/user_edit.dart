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
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/user_model.dart';
import 'package:flutter_admin/utils/cry_select_item_util.dart';

class UserEdit extends StatefulWidget {
  final UserModel? userModel;

  const UserEdit({Key? key, this.userModel}) : super(key: key);

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late UserModel userModel;
  List<UserModel> admins = [];

  @override
  void initState() {
    userModel = widget.userModel ?? UserModel();
    super.initState();
    initData();
  }

  Future initData() async {
    // admins = StoreUtil.readAdmins();
    if (admins.isEmpty) {
      admins = await ApiDioController.getAllAdmin();
    }

    if (userModel.adminId == null || userModel.adminId!.isEmpty) {
      userModel.adminId = admins[0].adminId;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              children: [
                CryInput(
                  label: S.of(context).user,
                  value: userModel.user,
                  width: 400,
                  onSaved: (v) {
                    userModel.user = v;
                  },
                ),
                CryInput(
                  label: S.of(context).pass,
                  value: userModel.pass,
                  width: 400,
                  onSaved: (v) {
                    userModel.pass = v;
                  },
                ),
                CryInput(
                  label: S.of(context).name,
                  value: userModel.name,
                  width: 400,
                  onSaved: (v) {
                    userModel.name = v;
                  },
                ),
                CryInput(
                  label: S.of(context).phone,
                  value: userModel.phone,
                  width: 400,
                  onSaved: (v) {
                    userModel.phone = v;
                  },
                ),
                CryInput(
                  label: S.of(context).address,
                  value: userModel.address,
                  width: 400,
                  onSaved: (v) {
                    userModel.address = v;
                  },
                ),
                CryInput(
                  label: S.of(context).birthDate,
                  value: userModel.birthDate,
                  width: 400,
                  onSaved: (v) {
                    userModel.birthDate = v;
                  },
                ),
                CrySelect(
                  label: S.of(context).adminId,
                  dataList:
                      CrySelectItemUtil.getAdminIdSelectOptionList(admins),
                  value: userModel.adminId,
                  onSaved: (v) {
                    userModel.adminId = v;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
    var result = Scaffold(
      appBar: AppBar(
        title: userModel == UserModel()
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
    if (widget.userModel == null) {
      print('save');
      action((data) async => await ApiDioController.registerUser(data));
    } else {
      print('edit');
      action((data) async => await ApiDioController.updateUser(data));
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

    bool isSuccess = await action(userModel);
    if (isSuccess) {
      CryUtils.message(S.of(context).success);
      Navigator.pop(context, true);
    }
  }
}
