import 'package:cry/utils/cry_utils.dart';
import 'package:cry/vo/select_option_vo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_admin/api/api_url.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:flutter_admin/models/station_model.dart';
import 'package:flutter_admin/models/user_model.dart';
import 'package:flutter_admin/models/user_station_model.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import 'custom_log.dart';

const int kDefaultTimeOut = 60 * 1000;

class ApiDioController {
  static const _baseUrl = 'http://103.237.145.184:3000';

  static BaseOptions options = BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: kDefaultTimeOut,
    receiveTimeout: kDefaultTimeOut,
  );

  // Contruction to use multiple project
  static Future<T?> getData<T>({
    required String url,
    required Dio dio,
    Map<String, dynamic>? query,
    required Function(dynamic) asModel,
  }) async {
    try {
      print(url);
      // dio.options.headers['Authorization'] =
      // "Bearer ${Get.find<GlobalController>().accessToken.value}";
      Response<Map<String, dynamic>> response = await dio.get(
        url,
        queryParameters: query,
      );

      print('ApiResponse: $response');

      if (response.statusCode == 200) {
        if (response.data!['message'] == "success") {
          if (response.data!['data'] != null) {
            return asModel(response.data!['data']);
          } else {
            return asModel(response.data!);
          }
        }
      }
      return null;
    } on DioError catch (e) {
      CustomLog.log(e);
      return null;
    } catch (e) {
      CustomLog.log(e);
      Get.defaultDialog(
          barrierDismissible: false,
          title: 'Có lỗi xảy ra! Vui lòng thử lại.',
          onConfirm: () {
            Get.back();
          });
      return null;
    }
  }

  static Future<T?> postMethods<T>({
    required String url,
    required Dio dio,
    dynamic body,
    required Function(Map<String, dynamic>) asModel,
  }) async {
    try {
      print('Request body: $body');
      print('Request url: $url');
      // dio.options.headers['Authorization'] =
      // "Bearer ${Get.find<GlobalController>().accessToken.value}";
      Response<Map<String, dynamic>> response = await dio.post(
        url,
        data: body,
      );
      CustomLog.log(response);
      print('Response: $response');
      if (response.statusCode == 200) {
        if (response.data!['message'] == "success") {
          return asModel(response.data!);
        } else {
          CryUtils.message('Thất bại');
        }
      }
      return null;
    } on DioError catch (e) {
      CustomLog.log(e);
      CryUtils.message('Lỗi hệ thống, xin vui lòng thử lại sau!');
      return null;
    } catch (e) {
      CustomLog.log(e);
      CryUtils.message('Lỗi hệ thống, xin vui lòng thử lại sau!');
      return null;
    }
  }

  static Future<T?> putMethods<T>({
    required String url,
    required Dio dio,
    dynamic body,
    required Function(Map<String, dynamic>) asModel,
  }) async {
    try {
      print('Request body: $body');
      print('Request url: $url');
      // dio.options.headers['x-access-token'] =
      //     Get.find<GlobalController>().accessToken.value;

      Response<Map<String, dynamic>> response = await dio.put(url, data: body);

      CustomLog.log(response.data);

      if (response.statusCode == 200) {
        if (response.data!['message'] == 'success' ||
            response.data!['message'] == 'true') {
          return asModel(response.data!);
        }
      } else if (response.statusCode == 403) {
        return null;
      }

      return null;
    } on DioError catch (e) {
      CustomLog.log(e);
      return null;
    } catch (e) {
      CustomLog.log(e);
      return null;
    }
  }

  static Future<T?> pathMethods<T>({
    required String url,
    required Dio dio,
    dynamic body,
    required Function(Map<String, dynamic>) asModel,
  }) async {
    try {
      // dio.options.headers['x-access-token'] =
      //     Get.find<GlobalController>().accessToken.value;

      Response<Map<String, dynamic>> response =
          await dio.patch(url, data: body);

      CustomLog.log(response);

      if (response.statusCode == 200) {
        if (response.data!['message'] == "success") {
          return asModel(response.data!);
        }
      } else if (response.statusCode == 403) {
        // Get.find<GlobalController>().refreshToken();
        return null;
      }

      return null;
    } on DioError catch (e) {
      CustomLog.log(e);
      return null;
    } catch (e) {
      CustomLog.log(e);
      return null;
    }
  }

  static Future<T?> deleteMethod<T>({
    required String url,
    required Dio dio,
    Map<String, dynamic>? body,
    required Function(Map<String, dynamic>) asModel,
  }) async {
    try {
      print('Request body: $body');
      print('Request url: $url');
      Response<Map<String, dynamic>> response = await dio.delete(
        url,
        data: body,
      );
      print('Response: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data!['message'] == 'success') {
          return asModel(response.data!);
        }
      }
      return null;
    } on DioError catch (e) {
      CustomLog.log(e);
      return null;
    } catch (e) {
      CustomLog.log(e);
      return null;
    }
  }

  static Future<List<DeviceModel>> getDevice() async {
    Dio dio = Dio(options);

    List<DeviceModel> listDevice = [];
    await getData<List<DeviceModel>>(
      url: ApiURL.getDevice,
      dio: dio,
      asModel: (map) {
        final responseList = map as List;
        listDevice = responseList.map((e) => DeviceModel.fromJson(e)).toList();
      },
    );
    return listDevice;
  }

  static Future<bool> registerAdmin(UserModel adminModel) async {
    Dio dio = Dio(options);

    bool registerStatus = false;
    await postMethods(
      url: ApiURL.registerAdmin,
      dio: dio,
      body: adminModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          registerStatus = true;
          CryUtils.message('Đăng ký thành công');
        } else {
          CryUtils.message('Đăng ký thất bại');
          registerStatus = false;
        }
      },
    );
    return registerStatus;
  }

  static Future<UserModel> loginAdmin(UserModel adminModel) async {
    Dio dio = Dio(options);

    UserModel adminResponse = new UserModel();

    bool loginStatus = false;
    await postMethods(
      url: ApiURL.loginAdmin,
      dio: dio,
      body: adminModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success' && map['data'] != null) {
          final response = map['data'] as List;
          adminResponse =
              response.map((e) => UserModel.fromJson(e)).toList()[0];
          loginStatus = true;
          CryUtils.message('Đăng nhập thành công');
        } else {
          print('else');
          CryUtils.message('Đăng nhập thất bại');
          loginStatus = false;
        }
      },
    );
    return adminResponse;
  }

  static Future<UserModel> loginUser(UserModel userModel) async {
    Dio dio = Dio(options);

    UserModel userResponse = new UserModel();

    bool loginStatus = false;
    await postMethods(
      url: ApiURL.loginUser,
      dio: dio,
      body: userModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success' && map['data'] != null) {
          final response = map['data'] as List;
          userResponse = response.map((e) => UserModel.fromJson(e)).toList()[0];
          loginStatus = true;
          CryUtils.message('Đăng nhập thành công');
        } else {
          print('else');
          CryUtils.message('Đăng nhập thất bại');
          loginStatus = false;
        }
      },
    );
    return userResponse;
  }

  static Future<List<UserModel>> getAdmin(UserModel adminModel) async {
    Dio dio = Dio(options);

    List<UserModel> adminModels = [];
    await postMethods(
      url: ApiURL.getAdmin,
      dio: dio,
      body: adminModel.toJson(),
      asModel: (map) {
        final responseList = map as List;
        adminModels = responseList.map((e) => UserModel.fromJson(e)).toList();
      },
    );
    return adminModels;
  }

  static Future<bool> updateAdmin(UserModel adminModel) async {
    Dio dio = Dio(options);

    bool updateAdminStatus = false;
    await putMethods(
      url: ApiURL.updateAdmin,
      dio: dio,
      body: adminModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          updateAdminStatus = true;
          final response = map['data'] as List;
          UserModel adminResponse =
              response.map((e) => UserModel.fromJson(e)).toList()[0];
          StoreUtil.write(Constant.EVN_ADMIN, adminResponse);
          CryUtils.message('Xóa admin thành công');
        } else {
          CryUtils.message('Xóa admin thất bại');
          updateAdminStatus = false;
        }
      },
    );
    return updateAdminStatus;
  }

  static Future<List<UserModel>> updatePassAdmin(UserModel adminModel) async {
    Dio dio = Dio(options);

    List<UserModel> adminModels = [];
    await postMethods(
      url: ApiURL.updatePassAdmin,
      dio: dio,
      body: adminModel.toJson(),
      asModel: (map) {
        final responseList = map as List;
        adminModels = responseList.map((e) => UserModel.fromJson(e)).toList();
      },
    );
    return adminModels;
  }

  static Future<bool> deleteAdmin(String adminId) async {
    Dio dio = Dio(options);

    bool deleteAdminStatus = false;
    await deleteMethod(
      url: ApiURL.deleteAdmin,
      dio: dio,
      body: {"adminId": adminId},
      asModel: (map) {
        if (map['message'] == 'success') {
          deleteAdminStatus = true;
          CryUtils.message('Xóa admin thành công');
        } else {
          CryUtils.message('Xóa admin thất bại');
          deleteAdminStatus = false;
        }
      },
    );
    return deleteAdminStatus;
  }

  static Future<bool> deleteUser(String userId) async {
    Dio dio = Dio(options);

    bool deleteUserStatus = false;
    await deleteMethod(
      url: ApiURL.deleteUser,
      dio: dio,
      body: {"userId": userId},
      asModel: (map) {
        if (map['message'] == 'success') {
          deleteUserStatus = true;
          CryUtils.message('Xóa user thành công');
        } else {
          CryUtils.message('Xóa user thất bại');
          deleteUserStatus = false;
        }
      },
    );
    return deleteUserStatus;
  }

  static Future<bool> deleteUserStation(String userId) async {
    Dio dio = Dio(options);

    bool deleteUserStatus = false;
    await deleteMethod(
      url: ApiURL.deleteUser,
      dio: dio,
      body: {"userId": userId},
      asModel: (map) {
        if (map['message'] == 'success') {
          deleteUserStatus = true;
          CryUtils.message('Xóa user thành công');
        } else {
          CryUtils.message('Xóa user thất bại');
          deleteUserStatus = false;
        }
      },
    );
    return deleteUserStatus;
  }

  static Future<bool> registerUser(UserModel userModel) async {
    Dio dio = Dio(options);

    bool registerStatus = false;
    await postMethods(
      url: ApiURL.registerUser,
      dio: dio,
      body: userModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          registerStatus = true;
          CryUtils.message('Đăng ký thành công');
        } else {
          CryUtils.message('Đăng ký thất bại');
          registerStatus = false;
        }
      },
    );
    return registerStatus;
  }

  static Future<bool> registerUserStation(
      UserStationModel userStationModel) async {
    Dio dio = Dio(options);

    bool registerStatus = false;
    await postMethods(
      url: ApiURL.registerUserStation,
      dio: dio,
      body: userStationModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          registerStatus = true;
          CryUtils.message('Đăng ký user trạm thành công');
        } else {
          CryUtils.message('Đăng ký user trạm thất bại');
          registerStatus = false;
        }
      },
    );
    return registerStatus;
  }

  static Future<bool> updateUser(UserModel userModel) async {
    Dio dio = Dio(options);

    bool updateUserStatus = false;
    await putMethods(
      url: ApiURL.updateUser,
      dio: dio,
      body: userModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          updateUserStatus = true;
          CryUtils.message('Cập nhật user thành công');
        } else {
          CryUtils.message('Cập nhật user thất bại');
          updateUserStatus = false;
        }
      },
    );
    return updateUserStatus;
  }

  static Future<bool> updateUserStation(
      UserStationModel userStationModel) async {
    Dio dio = Dio(options);

    bool updateUserStatus = false;
    await putMethods(
      url: ApiURL.updateUserStation,
      dio: dio,
      body: userStationModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          updateUserStatus = true;
          CryUtils.message('Cập nhật user trạm thành công');
        } else {
          CryUtils.message('Cập nhật user trạm thất bại');
          updateUserStatus = false;
        }
      },
    );
    return updateUserStatus;
  }

  static Future<bool> registerStation(StationModel stationModel) async {
    Dio dio = Dio(options);

    bool registerStationStatus = false;
    await postMethods(
      url: ApiURL.registerStation,
      dio: dio,
      body: stationModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          registerStationStatus = true;
          CryUtils.message('Thêm trạm thành công');
        } else {
          CryUtils.message('Thêm trạm thất bại');
          registerStationStatus = false;
        }
      },
    );
    return registerStationStatus;
  }

  static Future<List<StationModel>> getStation(
      StationModel stationModel) async {
    Dio dio = Dio(options);

    List<StationModel> stations = [];
    await postMethods(
      url: ApiURL.getStation,
      dio: dio,
      body: stationModel.toJson(),
      asModel: (map) {
        final responseList = map as List;
        stations = responseList.map((e) => StationModel.fromJson(e)).toList();
      },
    );
    return stations;
  }

  static Future<List<StationModel>> getAllStation() async {
    Dio dio = Dio(options);

    List<StationModel> stations = [];
    await getData<List<StationModel>>(
      url: ApiURL.getAllStation,
      dio: dio,
      asModel: (map) {
        final responseList = map as List;
        stations = responseList.map((e) => StationModel.fromJson(e)).toList();
      },
    );
    return stations;
  }

  static Future<List<StationModel>> getStationByUser(Map params) async {
    Dio dio = Dio(options);

    List<StationModel> stations = [];
    await postMethods(
      url: ApiURL.getStationByUser,
      dio: dio,
      body: params,
      asModel: (map) {
        if (map['data'] != null) {
          final responseList = map['data'] as List;
          stations = responseList.map((e) => StationModel.fromJson(e)).toList();
        }
      },
    );
    return stations;
  }

  static Future<List<UserStationModel>> getAllUserStation() async {
    Dio dio = Dio(options);

    List<UserStationModel> stations = [];
    await getData<List<UserStationModel>>(
      url: ApiURL.getAllUserStation,
      dio: dio,
      asModel: (map) {
        final responseList = map as List;
        stations =
            responseList.map((e) => UserStationModel.fromJson(e)).toList();
      },
    );
    return stations;
  }

  static Future<List<UserModel>> getAllUser() async {
    Dio dio = Dio(options);

    List<UserModel> stations = [];
    await getData<List<UserModel>>(
      url: ApiURL.getAllUser,
      dio: dio,
      asModel: (map) {
        final responseList = map as List;
        stations = responseList.map((e) => UserModel.fromJson(e)).toList();
      },
    );
    return stations;
  }

  static Future<List<UserModel>> getAllAdmin() async {
    Dio dio = Dio(options);

    List<UserModel> admins = [];
    await getData<List<UserModel>>(
      url: ApiURL.getAllAdmin,
      dio: dio,
      asModel: (map) {
        final responseList = map as List;
        admins = responseList.map((e) => UserModel.fromJson(e)).toList();
      },
    );
    return admins;
  }

  static Future<List<SelectOptionVO>> getAdminIds() async {
    List<UserModel> admins = (await ApiDioController.getAllAdmin());
    return admins
        .map((e) => SelectOptionVO(value: e.user, label: e.user))
        .toList();
  }

  static Future<bool> updateStation(StationModel stationModel) async {
    Dio dio = Dio(options);

    bool updateStationStatus = false;
    await putMethods(
      url: ApiURL.updateStation,
      dio: dio,
      body: stationModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          updateStationStatus = true;
          CryUtils.message('Cập nhật trạm thành công');
        } else {
          CryUtils.message('Cập nhật trạm thất bại');
          updateStationStatus = false;
        }
      },
    );
    return updateStationStatus;
  }

  static Future<bool> deleteStation(String stationId) async {
    Dio dio = Dio(options);

    bool deleteStationStatus = false;
    await deleteMethod(
      url: ApiURL.deleteStation,
      dio: dio,
      body: {"stationId": stationId},
      asModel: (map) {
        if (map['message'] == 'success') {
          deleteStationStatus = true;
          CryUtils.message('Xóa user thành công');
        } else {
          CryUtils.message('Xóa user thất bại');
          deleteStationStatus = false;
        }
      },
    );
    return deleteStationStatus;
  }

  static Future<bool> registerDevice(DeviceModel deviceModel) async {
    Dio dio = Dio(options);

    bool registerDeviceStatus = false;
    await postMethods(
      url: ApiURL.registerDevice,
      dio: dio,
      body: deviceModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success') {
          registerDeviceStatus = true;
          CryUtils.message('Thêm thiết bị thành công');
        } else {
          CryUtils.message('Thêm thiết bị thất bại');
          registerDeviceStatus = false;
        }
      },
    );
    return registerDeviceStatus;
  }

  static Future<bool> updateDevice(DeviceModel deviceModel) async {
    Dio dio = Dio(options);

    bool updateDeviceStatus = false;
    await putMethods(
      url: ApiURL.updateDevice,
      dio: dio,
      body: deviceModel.toJson(),
      asModel: (map) {
        if (map['message'] == 'success' || map['message'] == 'true') {
          updateDeviceStatus = true;
          CryUtils.message('Cập nhật thiết bị thành công');
        } else {
          CryUtils.message('Cập nhật thiết bị thất bại');
          updateDeviceStatus = false;
        }
      },
    );
    return updateDeviceStatus;
  }

  static Future<List<DeviceModel>> getDeviceByStationId(
      String stationId) async {
    Dio dio = Dio(options);

    List<DeviceModel> devices = [];
    await postMethods(
      url: ApiURL.getDeviceByStationId,
      dio: dio,
      body: {"stationId": stationId},
      asModel: (map) {
        if (map['data'] != null) {
          final responseList = map['data'] as List;
          devices = responseList.map((e) => DeviceModel.fromJson(e)).toList();
        }
      },
    );
    return devices;
  }

  static Future<List<DeviceModel>> queryStation(
      String? stationId, String? day) async {
    Dio dio = Dio(options);

    List<DeviceModel> devices = [];
    await postMethods(
      url: ApiURL.queryStation,
      dio: dio,
      body: {"stationId": stationId ?? '', "day": day ?? '1'},
      asModel: (map) {
        if (map['data'] != null) {
          final responseList = map['data'] as List;
          devices = responseList.map((e) => DeviceModel.fromJson(e)).toList();
        }
      },
    );
    return devices;
  }

  static Future<List<DeviceModel>> queryDetail(
      String? deviceId, String? day) async {
    Dio dio = Dio(options);

    List<DeviceModel> devices = [];
    await postMethods(
      url: ApiURL.queryDetail,
      dio: dio,
      body: {"deviceId": deviceId ?? '', "day": day ?? '7', 'nguong': '5'},
      asModel: (map) {
        if (map['data'] != null) {
          final responseList = map['data'] as List;
          devices = responseList.map((e) => DeviceModel.fromJson(e)).toList();
        }
      },
    );
    return devices;
  }

  static Future<List<DeviceModel>> getAllDevice() async {
    Dio dio = Dio(options);

    List<DeviceModel> devices = [];
    await getData<List<DeviceModel>>(
      url: ApiURL.getAllDevice,
      dio: dio,
      asModel: (map) {
        final responseList = map as List;
        devices = responseList.map((e) => DeviceModel.fromJson(e)).toList();
      },
    );
    return devices;
  }

  static Future<bool> deleteDevice(String deviceId) async {
    Dio dio = Dio(options);

    bool deleteDeviceStatus = false;
    await deleteMethod(
      url: ApiURL.deleteDevice,
      dio: dio,
      body: {"deviceId": deviceId},
      asModel: (map) {
        if (map['message'] == 'success') {
          deleteDeviceStatus = true;
          CryUtils.message('Cập nhật thiết bị thành công');
        } else {
          CryUtils.message('Cập nhật thiết bị thất bại');
          deleteDeviceStatus = false;
        }
      },
    );
    return deleteDeviceStatus;
  }
}
