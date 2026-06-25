import 'package:flutter/material.dart';
import 'package:deathnote/views/main_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationItem extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final Menus current;
  final Menus name;

  const BottomNavigationItem({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.current,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            color: current == name ? Colors.blue : Colors.grey,
          ),
          Text(
            name.toString().split('.').last,
            style: TextStyle(
              color: current == name ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
