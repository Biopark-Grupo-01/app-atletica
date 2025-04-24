import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Image.asset(
          'assets/images/aaabe.png',
          height: 110,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 16, 16, 16),
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 110,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color.fromARGB(255, 189, 189, 189),
          height: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110.0);
}