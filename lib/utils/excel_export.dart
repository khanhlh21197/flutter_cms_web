import 'dart:convert';
import 'dart:html';

import 'package:cry/utils/cry_utils.dart';
import 'package:flutter_admin/utils/store_util.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class ExcelExportUtil {
  static export(String key, String fileName) async {
    List<int> bytes = await StoreUtil.readWorkbook(key);

    //Download the output file in web.
    if (bytes.isNotEmpty) {
      AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
        ..setAttribute("download", fileName)
        ..click();
    } else {
      CryUtils.message('Lỗi server');
    }
  }

  static createWorkbook(String key, List<ExcelDataRow> dataRows) async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    sheet.importData(dataRows, 1, 1);

    // Save and dispose the document.
    final List<int> bytes = workbook.saveAsStream();
    StoreUtil.writeWorkbook(key, bytes);
    workbook.dispose();
  }
}
