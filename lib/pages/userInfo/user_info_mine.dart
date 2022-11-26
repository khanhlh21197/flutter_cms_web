/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description:

import 'package:cry/cry_button_bar.dart';
import 'package:cry/cry_image_upload.dart';
import 'package:cry/form/cry_input.dart';
import 'package:cry/form/cry_select.dart';
import 'package:cry/form/cry_select_custom_widget.dart';
import 'package:cry/form/cry_select_date.dart';
import 'package:cry/utils/adaptive_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/api/file_api.dart';
import 'package:flutter_admin/api/user_info_api.dart';
import 'package:cry/cry_button.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/constants/constant_dict.dart';
import 'package:cry/model/response_body_api.dart';
import 'package:flutter_admin/generated/l10n.dart';
import 'package:flutter_admin/models/admin_model.dart';
import 'package:flutter_admin/models/dept.dart';
import 'package:flutter_admin/models/user_info.dart';
import 'package:flutter_admin/pages/common/dept_selector.dart';
import 'package:cry/utils/cry_utils.dart';
import 'package:flutter_admin/utils/dict_util.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;
import 'package:http_parser/http_parser.dart';

class UserInfoMine extends StatefulWidget {
  UserInfoMine();

  @override
  _UserInfoMineState createState() => _UserInfoMineState();
}

class _UserInfoMineState extends State<UserInfoMine> {
  UserInfo? userInfo;
  late AdminModel adminModel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    try {
      adminModel = StoreUtil.read(Constant.EVN_ADMIN);
    } catch (e) {
      adminModel = new AdminModel();
    }
    ;
    this.userInfo = StoreUtil.getCurrentUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = SizedBox(
      child: CryImageUpload(
        updateAreaSize: 200,
        updateAreaDefault: Icon(Icons.person, size: 200),
        fileList: [this.userInfo?.avatarUrl],
        onUpload: (imageBytes) {
          String filename = "test.png"; //todo
          String mimeType = mime(Path.basename(filename))!;
          var mediaType = MediaType.parse(mimeType);
          MultipartFile file = MultipartFile.fromBytes(imageBytes,
              contentType: mediaType, filename: filename);
          FormData formData = FormData.fromMap({"file": file});
          FileApi.upload(formData).then((res) {
            this.userInfo!.avatarUrl = res.data;
          });
        },
      ),
    );
    List<Widget> propList = <Widget>[
      CryInput(
        label: S.of(context).name,
        value: adminModel.name,
        onSaved: (v) => {adminModel.name = v},
        validator: (v) => v!.isEmpty ? S.of(context).required : null,
      ),
      CryInput(
        label: S.of(context).user,
        value: adminModel.user,
        onSaved: (v) => {adminModel.user = v},
      ),
      CrySelectDate(
        context,
        label: S.of(context).birthDate,
        value: adminModel.birthDate,
        onSaved: (v) => {userInfo!.birthday = v},
      ),
      CrySelect(
        label: S.of(context).personGender,
        dataList: DictUtil.getDictSelectOptionList(ConstantDict.CODE_GENDER),
        value: userInfo!.gender,
        onSaved: (v) => {userInfo!.gender = v},
      ),
      CryInput(
        label: S.of(context).phone,
        value: adminModel.phone,
        onSaved: (v) => {adminModel.phone = v},
      ),
      CryInput(
        label: S.of(context).address,
        value: adminModel.address,
        onSaved: (v) => {adminModel.address = v},
      ),
    ];
    var form = _getForm(avatar, propList);
    var buttonBar = CryButtonBar(
      children: <Widget>[
        CryButton(
          label: S.of(context).save,
          onPressed: () async {
            FormState form = formKey.currentState!;
            if (!form.validate()) {
              return;
            }
            form.save();
            bool updateAdminStatus =
                await ApiDioController.updateAdmin(adminModel);
            if(!updateAdminStatus){
              return;
            }
            UserInfoApi.saveOrUpdate(this.userInfo!.toMap())
                .then((ResponseBodyApi res) {
              if (!res.success!) {
                return;
              }
              StoreUtil.write(
                  Constant.KEY_CURRENT_USER_INFO, this.userInfo!.toMap());
              CryUtils.message(S.of(context).saved);
            });
          },
          iconData: Icons.save,
        ),
      ],
    );
    var result = Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          buttonBar,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[form],
            ),
          ),
        ],
      ),
    );
    return result;
  }

  _getForm(Widget avatar, List<Widget> propList) {
    var form;
    if (isDisplayDesktop(context)) {
      propList = propList
          .map((e) => Expanded(
                child: e,
              ))
          .toList();
      form = Form(
        key: formKey,
        child: Row(
          children: [
            avatar,
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      propList[0],
                      propList[1],
                    ],
                  ),
                  Row(
                    children: [
                      propList[2],
                      propList[3],
                    ],
                  ),
                  Row(
                    children: [
                      propList[4],
                      propList[5],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      form = Form(
        key: formKey,
        child: Column(children: [avatar] + propList),
      );
    }
    return form;
  }
}
