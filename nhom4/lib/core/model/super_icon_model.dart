import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuperIcon extends StatelessWidget {
  final String iconPath;
  final double size;

  const SuperIcon({Key? key, required this.iconPath, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        width: size,
        height: size,
        child: Center(child: SvgPicture.asset(iconPath, fit: BoxFit.contain)),
      );
    } catch (e) {
      print('Lỗi load icon SVG: $e');
      // Trả về icon mặc định khi lỗi
      return Container(
        width: size,
        height: size,
        child: Center(child: Icon(Icons.error, size: size, color: Colors.red)),
      );
    }
  }
}

