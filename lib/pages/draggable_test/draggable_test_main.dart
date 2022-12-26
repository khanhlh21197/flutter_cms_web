import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin/api/api_dio_controller.dart';
import 'package:flutter_admin/constants/constant.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:flutter_admin/pages/draggable/canvas.dart';
import 'package:flutter_admin/pages/draggable/canvas_object.dart';
import 'package:flutter_admin/pages/draggable_test/measure_size.dart';
import 'package:flutter_admin/pages/layout/layout_menu_controller.dart';
import 'package:flutter_admin/utils/store_util.dart';

import 'dart:convert';
import 'dart:html' as html;

class DraggableTestMain extends StatefulWidget {
  const DraggableTestMain({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<DraggableTestMain> {
  final _controller = CanvasController();
  final layoutMenuController = LayoutMenuController();
  final GlobalKey key = GlobalKey();
  List<DeviceModel> devices = [];

  // List<DeviceModel> devices = [
  //   DeviceModel(dx: 15, dy: 20, name: 'device1'),
  //   DeviceModel(dx: 25, dy: 30, name: 'device2'),
  //   DeviceModel(dx: 35, dy: 40, name: 'device3'),
  //   DeviceModel(dx: 45, dy: 50, name: 'device4'),
  //   DeviceModel(dx: 150, dy: 120, name: 'device5'),
  //   DeviceModel(dx: 120, dy: 150, name: 'device6'),
  //   DeviceModel(dx: 250, dy: 200, name: 'device7'),
  // ];

  List<Widget> positioneds = [];
  late double stackY;
  late double stackX;

  @override
  void initState() {
    // document.documentElement!.requestFullscreen();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _controller.init();
    // getDevices();
    initWidget();
    super.initState();
  }

  void getDevices() async {
    devices = (await ApiDioController.getAllDevice());
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void initWidget({double? screenWidth, double? screenHeight}) async {
    if (_controller.objects.isNotEmpty) {
      _controller.objects.clear();

      List<CanvasObject<Widget>> canvasObjects =
          StoreUtil.read(Constant.KEY_CANVAS_OBJECTS);
      print('CanvasObjects: ${canvasObjects.length}');
      canvasObjects.forEach((element) {
        _controller.addObject(element);
      });
    }

    if (devices.isEmpty) {
      print('Devices empty');
      devices = [
        DeviceModel(dx: 15, dy: 20, name: 'device1'),
        DeviceModel(dx: 25, dy: 30, name: 'device2'),
        DeviceModel(dx: 35, dy: 40, name: 'device3'),
      ];
    }

    print('Device length: ${devices.length}');

    devices.forEach((element) {
      _controller.addObject(
        CanvasObject(
          width: 20,
          height: 20,
          id: element.name,
          dx: element.dx!,
          dy: element.dy!,
          child: Tooltip(
            message: element.name,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 1)),
              child: Container(),
            ),
          ),
        ),
      );
    });

    var height = AppBar().preferredSize.height;

    var bgObject = CanvasObject(
      dx: 0,
      dy: 0,
      height: 800,
      width: 1000,
      // height: MediaQuery.of(context).size.height - height * 3,
      // width: MediaQuery.of(context).size.width - 120,
      id: 'bgObject',
      child: IgnorePointer(
        child: Container(
          height: 800,
          width: 1000,
          // height: MediaQuery.of(context).size.height - height * 3,
          // width: MediaQuery.of(context).size.width - 120,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/sodo.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );

    _controller.addObject(
      bgObject,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CanvasController>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final instance = snapshot.data;
          return MeasureSize(
            onChange: (size) {
              setState(() {
                // initWidget(
                //     screenWidth: size.size!.width,
                //     screenHeight: size.size!.height);
                print('Ratio ${size.ratioHeight} - ${size.ratioWidth}');
                print('Size: ${size.size!.height} - ${size.size!.width}');
              });
            },
            child: Stack(children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  actions: [
                    FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        tooltip: 'Selection',
                        icon: Icon(Icons.select_all),
                        color: instance!.shiftPressed
                            ? Theme.of(context).accentColor
                            : null,
                        onPressed: _controller.shiftSelect,
                      ),
                    ),
                    FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        tooltip: 'Meta Key',
                        color: instance.metaPressed
                            ? Theme.of(context).accentColor
                            : null,
                        icon: Icon(Icons.category),
                        onPressed: _controller.metaSelect,
                      ),
                    ),
                    FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        tooltip: 'Zoom In',
                        icon: Icon(Icons.zoom_in),
                        onPressed: _controller.zoomIn,
                      ),
                    ),
                    FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        tooltip: 'Zoom Out',
                        icon: Icon(Icons.zoom_out),
                        onPressed: _controller.zoomOut,
                      ),
                    ),
                    FocusScope(
                      canRequestFocus: false,
                      child: IconButton(
                        tooltip: 'Reset the Scale and Offset',
                        icon: Icon(Icons.restore),
                        onPressed: _controller.reset,
                      ),
                    ),
                  ],
                ),
                body: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerSignal: (details) {
                    if (details is PointerScrollEvent) {
                      GestureBinding.instance.pointerSignalResolver
                          .register(details, (event) {
                        if (event is PointerScrollEvent) {
                          if (_controller.shiftPressed) {
                            double zoomDelta = (-event.scrollDelta.dy / 300);
                            _controller.scale = _controller.scale + zoomDelta;
                          } else {
                            _controller.offset =
                                _controller.offset - event.scrollDelta;
                          }
                        }
                      });
                    }
                  },
                  onPointerMove: (details) {
                    _controller.updateTouch(
                      details.pointer,
                      details.localPosition,
                      details.position,
                    );
                  },
                  onPointerDown: (details) {
                    print('onPointerDown');
                    _controller.addTouch(
                      details.pointer,
                      details.localPosition,
                      details.position,
                    );
                  },
                  onPointerUp: (details) {
                    print('onPointerUp');
                    // saveToFile(jsonEncode(_controller.objects));
                    // StoreUtil.write(
                    //     Constant.KEY_CANVAS_OBJECTS, _controller.objects);
                    _controller.removeTouch(details.pointer);
                  },
                  onPointerCancel: (details) {
                    print('onPointerCancel');
                    _controller.removeTouch(details.pointer);
                  },
                  child: RawKeyboardListener(
                    autofocus: true,
                    focusNode: _controller.focusNode,
                    onKey: (key) => _controller.rawKeyEvent(context, key),
                    child: SizedBox.expand(
                      child: Stack(
                        children: [
                          Positioned.fromRect(
                            rect: instance
                                .objects[instance.objects.length - 1].rect
                                .adjusted(
                              _controller.offset,
                              _controller.scale,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: instance.isObjectSelected(
                                        instance.objects.length - 1)
                                    ? Colors.grey
                                    : Colors.transparent,
                              )),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: SizedBox.fromSize(
                                  size: instance
                                      .objects[instance.objects.length - 1]
                                      .size,
                                  child: instance
                                      .objects[instance.objects.length - 1]
                                      .child,
                                ),
                              ),
                            ),
                          ),
                          for (var i = instance.objects.length - 1; i > -1; i--)
                            Positioned.fromRect(
                              rect: instance.objects[i].rect.adjusted(
                                _controller.offset,
                                _controller.scale,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: instance.isObjectSelected(i)
                                      ? Colors.grey
                                      : Colors.transparent,
                                )),
                                child: GestureDetector(
                                  onTapDown: (_) => _controller.selectObject(i),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Container(
                                      child: instance.objects[i].child,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (instance.marquee != null)
                            Positioned.fromRect(
                              rect: instance.marquee!.rect
                                  .adjusted(instance.offset, instance.scale),
                              child: Container(
                                color: Colors.blueAccent.withOpacity(0.3),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          );
        });
  }

  // util function
  bool isInObject(Map<String, double> data, double dx, double dy) {
    Path _tempPath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(data['x']!, data['y']!), radius: data['r']!));
    return _tempPath.contains(Offset(dx, dy));
  }

  void saveToFile(String text){
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'canvas_objects.txt';

    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

    html.document.body!.children.add(anchor);
  }
}

extension RectUtils on Rect {
  Rect adjusted(Offset offset, double scale) {
    final left = (this.left + offset.dx) * scale;
    final top = (this.top + offset.dy) * scale;
    final width = this.width * scale;
    final height = this.height * scale;
    return Rect.fromLTWH(left, top, width, height);
  }
}
