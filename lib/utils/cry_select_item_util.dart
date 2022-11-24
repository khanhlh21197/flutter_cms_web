/// @author: cairuoyu
/// @homepage: http://cairuoyu.com
/// @github: https://github.com/cairuoyu/flutter_admin
/// @date: 2021/6/21
/// @version: 1.0
/// @description: 数据字典工具
import 'package:cry/vo/select_option_vo.dart';
import 'package:flutter_admin/models/admin_model.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/models/user_model.dart';

class CrySelectItemUtil {
  static List<SelectOptionVO> getAdminIdSelectOptionList(
      List<AdminModel> admins) {
    return admins
        .map((e) => SelectOptionVO(value: e.adminId, label: e.adminId))
        .toList();
  }

  static List<SelectOptionVO> getStationIdSelectOptionList(
      List<StationModel> stations) {
    return stations
        .map((e) => SelectOptionVO(value: e.stationId, label: e.stationId))
        .toList();
  }

  static List<SelectOptionVO> getUserIdSelectOptionList(List<UserModel> users) {
    return users
        .map((e) => SelectOptionVO(value: e.userId, label: e.userId))
        .toList();
  }

  static List<SelectOptionVO> getDayNumberSelectOptionList(List<String> days) {
    return days.map((e) => SelectOptionVO(value: e, label: e)).toList();
  }
}
