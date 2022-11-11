/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 存储工具类:ffi';
import 'package:cry/model/response_body_api.dart';
import 'package:flutter_admin/api/dict_api.dart';
import 'package:flutter_admin/api/menu_api.dart';
import 'package:flutter_admin/api/setting_default_tab.dart';
import 'package:flutter_admin/api/subsystem_api.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/models/menu.dart';
import 'package:flutter_admin/models/subsystem.dart';
import 'package:flutter_admin/models/tab_page.dart';
import 'package:flutter_admin/models/user_info.dart';
import 'package:get_storage/get_storage.dart';

class StoreUtil {
  static read(String key) {
    return GetStorage().read(key);
  }

  static write(String key, value) {
    GetStorage().write(key, value);
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
    print('readOpenedTabPageList $data');
    return data == null
        ? []
        : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  static writeOpenedTabPageList(List<TabPage?> list) {
    var data = list.map((e) => e!.toMap()).toList();
    print('writeOpenedTabPageList $data');
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
        "id": "50e81baa15f412615b2cbe4675173a51",
        "createTime": "2020-08-22 02:11:26",
        "updateTime": "2021-08-27 07:42:38",
        "name": "角色管理",
        "nameEn": "Role List",
        "subsystemId": "1",
        "icon": "role",
        "pid": null,
        "url": "/roleList",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "95edab28a9dff3a16da447710087a6a6",
        "createTime": "2021-08-27 07:48:58",
        "updateTime": "2021-08-27 07:48:58",
        "name": "基本设置",
        "nameEn": "Base Setting",
        "subsystemId": "1",
        "icon": "info",
        "pid": "a9639e0bfffb7b476012a3ff7afdf5ad",
        "url": "/settingBase",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "aa79196feeeeb56f50255c552ad3b186",
        "createTime": "2021-02-20 03:46:53",
        "updateTime": "2021-03-03 06:35:07",
        "name": "人口统计",
        "nameEn": "demographic",
        "subsystemId": "1",
        "icon": "people",
        "pid": "44cfc2b5bdb4614245bf35ed338cb463",
        "url": "/sAreaAgeGenderMain",
        "module": null,
        "remark": "",
        "orderBy": 1
      },
      {
        "id": "e49873ef4282a2121d5368922f66b73b",
        "createTime": "2021-01-04 09:00:37",
        "updateTime": "2021-01-07 06:17:52",
        "name": "子系统管理",
        "nameEn": "Sub System",
        "subsystemId": "1",
        "icon": "subsystem",
        "pid": null,
        "url": "/subsystemList",
        "module": null,
        "remark": "",
        "orderBy": 2
      },
      {
        "id": "77cc18b1b4a9a84ead63b9e3bb950ab4",
        "createTime": "2020-07-23 07:25:22",
        "updateTime": "2020-07-23 07:34:17",
        "name": "菜单管理",
        "nameEn": "Menu List",
        "subsystemId": "1",
        "icon": null,
        "pid": null,
        "url": "/menuList",
        "module": null,
        "remark": "",
        "orderBy": 3
      },
      {
        "id": "d9c714059bd16e658732872b942cf885",
        "createTime": "2020-07-23 05:46:02",
        "updateTime": "2021-07-06 07:51:17",
        "name": "用户管理",
        "nameEn": "User List",
        "subsystemId": "1",
        "icon": "info",
        "pid": null,
        "url": "/userInfoList",
        "module": null,
        "remark": "",
        "orderBy": 4
      },
      {
        "id": "b5ea61ab57edf893d23898d3010c5ca3",
        "createTime": "2021-01-20 01:04:40",
        "updateTime": "2021-07-06 07:51:27",
        "name": "部门管理",
        "nameEn": "Dept List",
        "subsystemId": "1",
        "icon": "dept",
        "pid": null,
        "url": "/deptMain",
        "module": null,
        "remark": "",
        "orderBy": 5
      },
      {
        "id": "80b372de418100bc4478b81ee4983876",
        "createTime": "2020-07-23 05:46:22",
        "updateTime": "2021-07-05 08:09:43",
        "name": "图片上传",
        "nameEn": "Image Upload",
        "subsystemId": "1",
        "icon": "image",
        "pid": "45f78d3f93e1165e1ffdd114f81ad02c",
        "url": "/imageUpload",
        "module": null,
        "remark": "",
        "orderBy": 5
      },
      {
        "id": "4355afd5b50aca324022870f86360e45",
        "createTime": "2020-07-23 05:46:45",
        "updateTime": "2021-07-05 08:09:53",
        "name": "视频上传",
        "nameEn": "Video Upload",
        "subsystemId": "1",
        "icon": "video",
        "pid": "45f78d3f93e1165e1ffdd114f81ad02c",
        "url": "/videoUpload",
        "module": null,
        "remark": "",
        "orderBy": 6
      },
      {
        "id": "45f78d3f93e1165e1ffdd114f81ad02c",
        "createTime": "2021-07-05 08:09:34",
        "updateTime": "2021-07-06 07:51:34",
        "name": "门户管理",
        "nameEn": "Portal",
        "subsystemId": "1",
        "icon": "subsystem",
        "pid": null,
        "url": "",
        "module": null,
        "remark": "",
        "orderBy": 6
      },
      {
        "id": "3e7326f144c015cfe9de96d4e8b11d82",
        "createTime": "2020-07-23 02:36:05",
        "updateTime": null,
        "name": "人员管理",
        "nameEn": "Personnel List",
        "subsystemId": "1",
        "icon": "person",
        "pid": null,
        "url": "/personList",
        "module": null,
        "remark": "",
        "orderBy": 7
      },
      {
        "id": "ebf18e86fa0e086c629e1017a9972bc9",
        "createTime": "2020-10-14 02:51:39",
        "updateTime": null,
        "name": "数据字典管理",
        "nameEn": "Dict List",
        "subsystemId": "1",
        "icon": "dict",
        "pid": null,
        "url": "/dictList",
        "module": null,
        "remark": "",
        "orderBy": 8
      },
      {
        "id": "d03a977b151634f66a7a8d552c5c05fb",
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
        "id": "a9639e0bfffb7b476012a3ff7afdf5ad",
        "createTime": "2021-08-27 07:43:21",
        "updateTime": "2021-08-27 08:06:12",
        "name": "系统设置",
        "nameEn": "Setting",
        "subsystemId": "1",
        "icon": "dict",
        "pid": null,
        "url": "",
        "module": null,
        "remark": "",
        "orderBy": 11
      },
      {
        "id": "44cfc2b5bdb4614245bf35ed338cb463",
        "createTime": "2021-02-20 03:46:05",
        "updateTime": "2021-03-03 06:33:28",
        "name": "图表",
        "nameEn": "chart",
        "subsystemId": "1",
        "icon": "chart",
        "pid": null,
        "url": "",
        "module": null,
        "remark": "",
        "orderBy": 12
      },
      {
        "id": "09717ccdb94e60c56e8dc83665927f73",
        "createTime": "2020-07-23 08:02:13",
        "updateTime": "2020-07-23 08:03:13",
        "name": "二级菜单",
        "nameEn": "Secondary Menu",
        "subsystemId": "1",
        "icon": null,
        "pid": "0f5d542cd9b80eee7022bb4e0182868e",
        "url": "",
        "module": null,
        "remark": "",
        "orderBy": 91
      },
      {
        "id": "e537a5ce3a698117ca8ace5f94890400",
        "createTime": "2020-07-23 08:01:59",
        "updateTime": "2020-07-23 08:03:07",
        "name": "二级菜单",
        "nameEn": "Secondary Menu",
        "subsystemId": "1",
        "icon": null,
        "pid": "0f5d542cd9b80eee7022bb4e0182868e",
        "url": "/secondLevel",
        "module": null,
        "remark": "",
        "orderBy": 92
      },
      {
        "id": "0f5d542cd9b80eee7022bb4e0182868e",
        "createTime": "2020-07-23 07:40:15",
        "updateTime": "2020-11-25 07:38:38",
        "name": "树结构一级菜单",
        "nameEn": "Tree Structure - First level Menu",
        "subsystemId": "1",
        "icon": null,
        "pid": null,
        "url": "",
        "module": null,
        "remark": "",
        "orderBy": 99
      },
      {
        "id": "09d8ce8879e909472330cb203fc9b5b8",
        "createTime": "2020-07-23 08:03:38",
        "updateTime": null,
        "name": "三级菜单",
        "nameEn": "Level Three Menu",
        "subsystemId": "1",
        "icon": null,
        "pid": "09717ccdb94e60c56e8dc83665927f73",
        "url": "/threeLevel",
        "module": null,
        "remark": "",
        "orderBy": 910
      }
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
    return data == null ? null : Subsystem.fromMap(data);
  }

  static List<TabPage> getDefaultTabs() {
    var data = GetStorage().read(Constant.KEY_DEFAULT_TABS);
    print('getDefaultTabs $data');
    return data == null
        ? []
        : List.from(data).map((e) => TabPage.fromMap(e)).toList();
  }

  static Future<bool?> loadDict() async {
    ResponseBodyApi responseBodyApi = await DictApi.map();
    if (responseBodyApi.success!) {
      StoreUtil.write(Constant.KEY_DICT_ITEM_LIST, responseBodyApi.data);
    }
    return responseBodyApi.success;
  }

  static Future<bool?> loadSubsystem() async {
    ResponseBodyApi responseBodyApi = await SubsystemApi.listEnable();
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
    ResponseBodyApi responseBodyApi = await SettingDefaultTabApi.list();
    if (responseBodyApi.success!) {
      StoreUtil.write(Constant.KEY_DEFAULT_TABS, responseBodyApi.data);
    }
    return responseBodyApi.success;
  }
}
