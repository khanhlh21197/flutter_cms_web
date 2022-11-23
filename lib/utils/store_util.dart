/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 存储工具类:ffi';
import 'dart:convert';

import 'package:cry/model/response_body_api.dart';
import 'package:flutter_admin/api/dict_api.dart';
import 'package:flutter_admin/api/menu_api.dart';
import 'package:flutter_admin/api/subsystem_api.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/models/admin_model.dart';
import 'package:flutter_admin/models/menu.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/models/subsystem.dart';
import 'package:flutter_admin/models/tab_page.dart';
import 'package:flutter_admin/models/user_info.dart';
import 'package:flutter_admin/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class StoreUtil {
  static read(String key) {
    return GetStorage().read(key);
  }

  static write(String key, value) {
    GetStorage().write(key, value);
  }

  static writeStations(List<StationModel> stations) {
    GetStorage().write(Constant.EVN_STATIONS, stations);
  }

  static writeWorkbook(String key, List<int> workbookBytes) {
    GetStorage().write(key, workbookBytes);
  }

  static writeAdmins(List<AdminModel> admins) {
    GetStorage().write(Constant.EVN_ADMINS, admins);
  }

  static writeUsers(List<UserModel> users) {
    GetStorage().write(Constant.EVN_USERS, users);
  }

  static List<int> readWorkbook(String key) {
    return GetStorage().read(key) ?? [];
  }

  static List<StationModel> readStations() {
    List<StationModel> stations =
        GetStorage().read(Constant.EVN_STATIONS) ?? <StationModel>[];
    return stations;
  }

  static List<UserModel> readUsers() {
    List<UserModel> users =
        GetStorage().read(Constant.EVN_USERS) ?? <UserModel>[];
    return users;
  }

  static List<AdminModel> readAdmins() {
    List<AdminModel> admins =
        GetStorage().read(Constant.EVN_ADMINS) ?? <AdminModel>[];
    print('readAdmins: $admins');
    return admins;
  }

  static hasData(String key) {
    return GetStorage().hasData(key);
  }

  static cleanAll() {
    GetStorage().erase();
  }

  static init() {
    var list = getDefaultTabs();
    writeOpenedTabPageList(list);
    if (list.length > 0) {
      writeCurrentOpenedTabPageId(list.first.id);
    }
  }

  static List<TabPage?> readOpenedTabPageList() {
    var data = read(Constant.KEY_OPENED_TAB_PAGE_LIST);
    return data == null
        ? []
        : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  static writeOpenedTabPageList(List<TabPage?> list) {
    var data = list.map((e) => e!.toMap()).toList();
    write(Constant.KEY_OPENED_TAB_PAGE_LIST, data);
  }

  static String? readCurrentOpenedTabPageId() {
    return read(Constant.KEY_CURRENT_OPENED_TAB_PAGE_ID);
  }

  static writeCurrentOpenedTabPageId(String? data) {
    write(Constant.KEY_CURRENT_OPENED_TAB_PAGE_ID, data);
  }

  static UserInfo getCurrentUserInfo() {
    var data = GetStorage().read(Constant.KEY_CURRENT_USER_INFO);
    return data == null ? UserInfo() : UserInfo.fromMap(data);
  }

  static List<Menu> getMenuList() {
    var data = GetStorage().read(Constant.KEY_MENU_LIST);
    final menuJson = [
      {
        "id": "d03a977b151634f66a117a8d552c5c05fb",
        "createTime": "2021-03-19 05:56:18",
        "updateTime": "2021-07-05 08:10:11",
        "name": "文章管理",
        "nameEn": "Article",
        "subsystemId": "1",
        "icon": "dept",
        "pid": "45f78d3f93e1165e1ffdd114f81ad02c",
        "url": "/articleMain",
        "module": null,
        "remark": "",
        "orderBy": 9
      },
      {
        "id": "stationMenuId",
        "createTime": "2020-08-22 02:11:26",
        "updateTime": "2021-08-27 07:42:38",
        "name": "Stations",
        "nameEn": "Stations",
        "subsystemId": "1",
        "icon": "role",
        "pid": null,
        "url": "/stationMain",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "userStationMenuId",
        "createTime": "2020-08-22 02:11:26",
        "updateTime": "2021-08-27 07:42:38",
        "name": "User Stations",
        "nameEn": "User Stations",
        "subsystemId": "1",
        "icon": "role",
        "pid": null,
        "url": "/userStationMain",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "deviceMenuId",
        "createTime": "2020-08-22 02:11:26",
        "updateTime": "2021-08-27 07:42:38",
        "name": "Devices",
        "nameEn": "Devices",
        "subsystemId": "1",
        "icon": "role",
        "pid": null,
        "url": "/deviceMain",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "adminMenuId",
        "createTime": "2020-08-22 02:11:26",
        "updateTime": "2021-08-27 07:42:38",
        "name": "Admins",
        "nameEn": "Admins",
        "subsystemId": "1",
        "icon": "role",
        "pid": null,
        "url": "/adminMain",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "userMenuId",
        "createTime": "2020-08-22 02:11:26",
        "updateTime": "2021-08-27 07:42:38",
        "name": "Users",
        "nameEn": "Users",
        "subsystemId": "1",
        "icon": "role",
        "pid": null,
        "url": "/userMain",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "reportMenuId",
        "createTime": "2020-08-22 02:11:26",
        "updateTime": "2021-08-27 07:42:38",
        "name": "Report",
        "nameEn": "Report",
        "subsystemId": "1",
        "icon": "role",
        "pid": null,
        "url": "/reportMain",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
    ];

    return List.from(menuJson).map((e) => Menu.fromMap(e)).toList();
    return data == null
        ? []
        : List.from(data).map((e) => Menu.fromMap(e)).toList();
  }

  static List<Subsystem> getSubsystemList() {
    var data = GetStorage().read(Constant.KEY_SUBSYSTEM_LIST);
    return data == null
        ? []
        : List.from(data).map((e) => Subsystem.fromMap(e)).toList();
  }

  static Subsystem? getCurrentSubsystem() {
    var data = GetStorage().read(Constant.KEY_CURRENT_SUBSYSTEM);
    data = jsonDecode(
        '{"id":"1","code":"flutterAdmin","name":"Evn Manage System","url":"","orderBy":"1","remark":"1","state":"1","createTime":"2021-01-07 01:43:16","updateTime":"2021-01-07 08:49:12","createrId":null,"updateId":null}');
    return data == null ? null : Subsystem.fromMap(data);
  }

  static List<TabPage> getDefaultTabs() {
    var data = GetStorage().read(Constant.KEY_DEFAULT_TABS);
    return data == null
        ? []
        : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  static Future<bool?> loadDict() async {
    ResponseBodyApi responseBodyApi = await DictApi.map();

    print('loadDict: ${(responseBodyApi)}');

    if (responseBodyApi.success!) {
      StoreUtil.write(Constant.KEY_DICT_ITEM_LIST, responseBodyApi.data);
    }
    return responseBodyApi.success;
  }

  static Future<bool?> loadSubsystem() async {
    ResponseBodyApi responseBodyApi = await SubsystemApi.listEnable();

    print('loadSubSystem: ${(responseBodyApi)}');

    if (responseBodyApi.success!) {
      StoreUtil.write(Constant.KEY_SUBSYSTEM_LIST, responseBodyApi.data);
      List<Subsystem> list = responseBodyApi.data == null
          ? []
          : List.from(responseBodyApi.data)
              .map((e) => Subsystem.fromMap(e))
              .toList();
      if (list.isNotEmpty) {
        StoreUtil.write(Constant.KEY_CURRENT_SUBSYSTEM, list[0].toMap());
      }
    }
    return responseBodyApi.success;
  }

  static Future<bool?> loadMenuData() async {
    var currentSubsystem = StoreUtil.getCurrentSubsystem();
    if (currentSubsystem == null) {
      return true;
    }
    ResponseBodyApi responseBodyApi =
        await MenuApi.listAuth(currentSubsystem.id);
    if (responseBodyApi.success!) {
      StoreUtil.write(Constant.KEY_MENU_LIST, responseBodyApi.data);
    }

    return responseBodyApi.success;
  }

  static Future<bool?> loadDefaultTabs() async {
    ResponseBodyApi responseBodyApi =
        ResponseBodyApi(success: true, code: '0', message: null, data: []);

    if (responseBodyApi.success!) {
      StoreUtil.write(Constant.KEY_DEFAULT_TABS, responseBodyApi.data);
    }
    return responseBodyApi.success;
  }
}
