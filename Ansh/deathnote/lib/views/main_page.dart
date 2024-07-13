// lib/views/main_page.dart

import 'package:flutter/material.dart';
import 'package:deathnote/views/art_view.dart';
import 'package:deathnote/pages/artists_info_page.dart';
import 'package:deathnote/pages/map_view_page.dart';
import 'package:deathnote/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Menus currentIndex = Menus.home;

  final pages = [
    const ArtView(),
    const MapViewPage(),
    ArtistsInfoPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[currentIndex.index],
      bottomNavigationBar: MyBottomNavigation(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}

enum Menus {
  home,
  map,
  artists,
  profile,
}

class MyBottomNavigation extends StatelessWidget {
  final Menus currentIndex;
  final ValueChanged<Menus> onTap;

  const MyBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 87,
      margin: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 17,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: BottomNavigationItem(
                      onPressed: () => onTap(Menus.home),
                      icon: Icons.home,
                      current: currentIndex,
                      name: Menus.home,
                    ),
                  ),
                  Expanded(
                    child: BottomNavigationItem(
                      onPressed: () => onTap(Menus.map),
                      icon: Icons.map,
                      current: currentIndex,
                      name: Menus.map,
                    ),
                  ),
                  
                  Expanded(
                    child: BottomNavigationItem(
                      onPressed: () => onTap(Menus.artists),
                      icon: Icons.people,
                      current: currentIndex,
                      name: Menus.artists,
                    ),
                  ),
                  Expanded(
                    child: BottomNavigationItem(
                      onPressed: () => onTap(Menus.profile),
                      icon: Icons.person,
                      current: currentIndex,
                      name: Menus.profile,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
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
    final bool isSelected = current == name;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isSelected ? Colors.cyan : Colors.grey,
      ),
    );
  }
}
