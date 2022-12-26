import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_admin/pages/draggable_test/size_change.dart';

typedef void OnWidgetSizeChange(SizeChange size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;
    double ratioHeight = 1;
    double ratioWidth = 1;
    if (oldSize != null) {
      ratioHeight = newSize.height / oldSize!.height;
      ratioWidth = newSize.height / oldSize!.width;
    }

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(
        SizeChange(newSize, ratioWidth, ratioHeight),
      );
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}
