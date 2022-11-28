/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 登录
import 'package:cry/common/application_context.dart';
import 'package:cry/cry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/models/user.dart';
import 'package:flutter_admin/models/user_info.dart';
import 'package:flutter_admin/models/user_model.dart';
import 'package:flutter_admin/utils/store_util.dart';

import '../generated/l10n.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  User user = new User();
  UserModel userModel = UserModel();
  String error = "";
  FocusNode focusNodeUserName = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  bool isFaceRecognition = false;
  bool isAdmin = true;

  @override
  void initState() {
    super.initState();
    focusNodeUserName.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: _buildPageContent(),
      ),
    );
  }

  Widget _buildPageContent() {
    var appName = Text(
      "EVN CMS",
      style: TextStyle(fontSize: 16, color: Colors.blue),
      textScaleFactor: 3.2,
    );
    return
        // isFaceRecognition
        //   ? FaceRecognition(
        //       onFountFace: (CameraImage cameraImage, String imagePath,
        //           List<Face> faces) async {
        //         String faceData = FaceService().toData(cameraImage, faces[0]);
        //         var responseBodyApi = await UserApi.loginByFace(faceData);
        //         if (!responseBodyApi.success!) {
        //           setState(() {
        //             this.isFaceRecognition = false;
        //           });
        //           return;
        //         }
        //         _loginSuccess();
        //       },
        //       onBack: () {
        //         setState(() {
        //           this.isFaceRecognition = false;
        //         });
        //       },
        //     )
        //   :
        Container(
      color: Colors.cyan.shade100,
      child: ListView(
        children: <Widget>[
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [LangSwitch()],
          // ),
          SizedBox(height: 20.0),
          Center(child: appName),
          SizedBox(height: 20.0),
          _buildLoginForm(),
          SizedBox(height: 20.0),
          Column(
            children: [
              Text(S.of(context).admin + '：admin/admin',
                  style: TextStyle(fontFamily: 'BeVietnamPro-Medium')),
              Text(S.of(context).loginTip,
                  style: TextStyle(fontFamily: 'BeVietnamPro-Medium')),
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 500,
              height: 360,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodeUserName,
                        initialValue: userModel.user,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'BeVietnamPro-Medium'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).username,
                          icon: Icon(
                            Icons.people,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          userModel.user = v;
                          userModel.user = v;
                        },
                        validator: (v) {
                          return v!.isEmpty
                              ? S.of(context).usernameRequired
                              : null;
                        },
                        onFieldSubmitted: (v) {
                          focusNodePassword.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodePassword,
                        obscureText: true,
                        initialValue: userModel.pass,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'BeVietnamPro-Medium'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).password,
                          icon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          userModel.pass = v;
                          userModel.pass = v;
                        },
                        validator: (v) {
                          return v!.isEmpty
                              ? S.of(context).passwordRequired
                              : null;
                        },
                        onFieldSubmitted: (v) {
                          _login();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('User'),
                        Switch(
                            value: isAdmin,
                            onChanged: (v) {
                              isAdmin = v;
                              setState(() {});
                            }),
                        Text('Admin'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (ApplicationContext.instance.cameras.length > 0)
                          TextButton(
                            child: Text(
                              '123',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'BeVietnamPro-Medium'),
                            ),
                            onPressed: () {
                              setState(() {
                                this.isFaceRecognition = true;
                              });
                            },
                          ),
                        TextButton(
                          child: Text(
                            S.of(context).register,
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'BeVietnamPro-Medium'),
                          ),
                          onPressed: _register,
                        ),
                        TextButton(
                          child: Text(
                            S.of(context).forgetPassword,
                            style: TextStyle(
                                color: Colors.black45,
                                fontFamily: 'BeVietnamPro-Medium'),
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: Icon(Icons.person),
              ),
            ],
          ),
          Container(
            height: 360,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 420,
              child: ElevatedButton(
                onPressed: _login,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0))),
                ),
                child: Text(S.of(context).login,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontFamily: 'BeVietnamPro-Medium')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _register() {
    Cry.pushNamed('/register');
  }

  _login() async {
    var form = formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    form.save();
    StoreUtil.write(Constant.IS_ADMIN, isAdmin);

    UserModel userResponse;
    if (!isAdmin) {
      userResponse = await ApiDioController.loginUser(userModel);
    } else {
      userResponse = await ApiDioController.loginAdmin(userModel);
    }
    if (userResponse == new UserModel()) {
      focusNodePassword.requestFocus();
      return;
    }
    _loginUserSuccess(userResponse);
  }

  _loginUserSuccess(UserModel userResponse) async {
    StoreUtil.write(Constant.KEY_TOKEN,
        'eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxIiwic3ViIjoiZGIyODhkOTUxYzM5MGFmYjA4YzgzNDEwODhiZDkwZmEiLCJpc3MiOiJ1c2VyIiwiaWF0IjoxNjY4NDg3NjQxfQ.jpyNYSphFD9Tu63HcOETPq_1uVrhgx5YNCOHDMN-M7U');
    StoreUtil.write(
        Constant.KEY_CURRENT_USER_INFO,
        UserInfo(
                id: 'ef8297d1c7333cdc6aeefa96bb8fb89f',
                createTime: '2020-08-20 02:39:35',
                updateTime: '2022-11-12 19:09:30',
                userId: 'db288d951c390afb08c8341088bd90fa',
                nickName: 'cry',
                avatarUrl:
                    'http://www.cairuoyu.com/f/p4/u-20221113030922885766914130.png',
                gender: '1',
                country: 'null',
                province: 'null',
                city: 'null',
                name: '怎么来的',
                school: 'null',
                major: 'null',
                birthday: '2025-04-11',
                entrance: 'null',
                hometown: '吉林省,通化市,柳河县',
                memo: 'null',
                deptId: 'c69bf9ba666a60545addbace63103fdb',
                userName: 'admin',
                deptName: 'dd')
            .toMap());

    StoreUtil.write(Constant.EVN_USER, userResponse);
    if (isAdmin) {
      StoreUtil.write(Constant.ADMIN_ID, userResponse.adminId);
    } else {
      StoreUtil.write(Constant.USER_ID, userResponse.userId);
    }

    // await StoreUtil.loadDict();
    // await StoreUtil.loadSubsystem();
    // await StoreUtil.loadMenuData();
    // await StoreUtil.loadDefaultTabs();
    StoreUtil.init();

    Cry.pushNamed('/');
  }
}
