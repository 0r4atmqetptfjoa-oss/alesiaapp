import 'package:flutter/material.dart';

int adaptiveCrossAxisCount(BuildContext context, {double minTileWidth = 220}) {
  final width = MediaQuery.of(context).size.width;
  final crossAxis = (width / minTileWidth).floor();
  return crossAxis.clamp(1, 4);
}