import 'dart:ui';

import 'package:flutter/material.dart';

class CanvasObject<T> {
  final double dx;
  final double dy;
  final double width;
  final double height;
  final Color mau;
  final T? child;
  final String? id;

  CanvasObject({
    this.dx = 0,
    this.dy = 0,
    this.width = 100,
    this.height = 100,
    this.mau = Colors.black,
    this.child,
    this.id,
  });

  CanvasObject<T> copyWith({
    double? dx,
    double? dy,
    double? width,
    double? height,
    Color? mau,
    T? child,
    String? id,
  }) {
    return CanvasObject<T>(
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      width: width ?? this.width,
      height: height ?? this.height,
      mau: mau ?? this.mau,
      child: child ?? this.child,
      id: id,
    );
  }

  Size get size => Size(width, height);

  Offset get offset => Offset(dx, dy);

  Rect get rect => offset & size;
}
