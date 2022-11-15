// /// @author: cairuoyu
// /// @homepage: http://cairuoyu.com
// /// @github: https://github.com/cairuoyu/flutter_admin
// /// @date: 2021/6/21
// /// @version: 1.0
// /// @description:
// import 'package:cry/cry_button.dart';
// import 'package:cry/cry_button_bar.dart';
// import 'package:cry/cry_buttons.dart';
// import 'package:cry/form/cry_input.dart';
// import 'package:cry/utils/cry_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_admin/api/api_dio_controller.dart';
// import 'package:flutter_admin/generated/l10n.dart';
// import 'package:flutter_admin/models/device_model.dart';
// import 'package:flutter_admin/models/dict_item.dart';
// import 'package:quiver/strings.dart';
//
// class DeviceItemListEdit extends StatefulWidget {
//   DeviceItemListEdit(
//     this.stationId, {
//     Key? key,
//     this.onSave,
//   }) : super(key: key);
//
//   final String stationId;
//   final Function? onSave;
//
//   @override
//   DeviceItemListEditState createState() => DeviceItemListEditState();
// }
//
// class DeviceItemListEditState extends State<DeviceItemListEdit> {
//   final GlobalKey<FormState> tableFormKey = GlobalKey<FormState>();
//   List<DeviceModel> deviceModels = [];
//
//   @override
//   void initState() {
//     super.initState();
//     this.init();
//   }
//
//   init() async {
//     _loadData();
//     // ResponseBodyApi responseBodyApi = await DictItemApi.list(DictItem(dictId: widget.dict!.id).toMap());
//     // this.dictItemList = List.from(responseBodyApi.data).map((e) => DictItem.fromMap(e)).toList();
//     this.setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var buttonBar = CryButtonBar(
//       children: [CryButtons.add(context, () => this._add())],
//     );
//     int i = 0;
//     var table = DataTable(
//       columns: [
//         DataColumn(label: Text('#')),
//         DataColumn(label: Text(S.of(context).operating)),
//         DataColumn(label: Text(S.of(context).dictItemCode)),
//         DataColumn(label: Text(S.of(context).dictItemName)),
//       ],
//       rows: this.deviceModels.map((device) {
//         int rowIndex = i + 1;
//         var result = DataRow(
//           cells: [
//             DataCell(Text((rowIndex).toString())),
//             DataCell(CryButtonBar(
//               children: [
//                 CryButton(
//                   iconData: Icons.delete,
//                   onPressed: () => _delete(device),
//                 ),
//               ],
//             )),
//             DataCell(CryInput(
//               width: 200,
//               padding: 0,
//               contentPadding: 0,
//               value: device.deviceId,
//               onSaved: (v) {
//                 device.deviceId = v;
//               },
//             )),
//             DataCell(CryInput(
//               width: 200,
//               padding: 0,
//               contentPadding: 0,
//               value: device.name,
//               onSaved: (v) {
//                 device.name = v;
//               },
//             )),
//           ],
//         );
//         i++;
//         return result;
//       }).toList(),
//     );
//     var tableForm = Form(
//       key: tableFormKey,
//       child: table,
//     );
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buttonBar,
//         tableForm,
//       ],
//     );
//   }
//
//   _loadData() async {
//     deviceModels =
//         await ApiDioController.getDeviceByStationId(widget.stationId);
//
//     setState(() {});
//   }
//
//   _add() {
//     this.tableFormKey.currentState!.save();
//     this.deviceModels.add(DictItem(dictId: widget.dict!.id));
//     this.setState(() {});
//   }
//
//   _delete(deviceModel) {
//     this.tableFormKey.currentState!.save();
//     this.deviceModels.remove(deviceModel);
//     this.setState(() {});
//   }
//
//   validate() {
//     this.tableFormKey.currentState!.save();
//
//     if (this
//         .dictItemList
//         .any((element) => isEmpty(element.name) || isEmpty(element.code))) {
//       CryUtils.message(S.of(context).completeTheTableData);
//       return false;
//     }
//     return true;
//   }
//
//   save() {
//     widget.onSave!(this.dictItemList);
//   }
// }
