import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin/models/device_model.dart';
import 'package:flutter_admin/pages/draggable/canvas.dart';
import 'package:flutter_admin/pages/draggable/canvas_object.dart';

class DraggableMain extends StatefulWidget {
  const DraggableMain({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<DraggableMain> {
  GlobalKey stackKey = GlobalKey(); // declare a global key
  final _controller = CanvasController();

  List<DeviceModel> devices = [
    DeviceModel(x: 15, y: 20, name: 'device1'),
    DeviceModel(x: 25, y: 30, name: 'device2'),
    DeviceModel(x: 35, y: 40, name: 'device3'),
    DeviceModel(x: 45, y: 50, name: 'device4'),
    DeviceModel(x: 150, y: 120, name: 'device5'),
    DeviceModel(x: 120, y: 150, name: 'device6'),
    DeviceModel(x: 250, y: 200, name: 'device7'),
  ];

  List<Widget> positioneds = [];
  late double stackY;
  late double stackX;

  @override
  void initState() {
    _controller.init();
    initWidget();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void initWidget() async {
    // _controller.addObject(
    //   CanvasObject(
    //     dx: 0,
    //     dy: 0,
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //     child: Container(
    //       decoration: new BoxDecoration(
    //         image: new DecorationImage(
    //           image: new AssetImage("assets/images/sodo.jpg"),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    devices.forEach((element) {
      _controller.addObject(
        CanvasObject(
          width: 20,
          height: 20,
          dx: element.x!,
          dy: element.y!,
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
          return Stack(children: [
            Image.asset(
              "assets/images/sodo.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
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
                  _controller.addTouch(
                    details.pointer,
                    details.localPosition,
                    details.position,
                  );
                },
                onPointerUp: (details) {
                  _controller.removeTouch(details.pointer);
                },
                onPointerCancel: (details) {
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
                                    .objects[instance.objects.length - 1].size,
                                child: instance
                                    .objects[instance.objects.length - 1].child,
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
              // floatingActionButton: FloatingActionButton(
              //   child: Icon(Icons.add),
              //   backgroundColor: Colors.green,
              //   onPressed: () {
              //     setState(() {
              //       print("doi mau");
              //       test = Colors.pinkAccent;
              //     });
              //   },
              // ),
            ),
          ]);
        });
  }

  // util function
  bool isInObject(Map<String, double> data, double dx, double dy) {
    Path _tempPath = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(data['x']!, data['y']!), radius: data['r']!));
    return _tempPath.contains(Offset(dx, dy));
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
