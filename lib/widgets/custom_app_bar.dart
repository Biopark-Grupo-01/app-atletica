import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Image.asset(
        'assets/images/aaabe.png',
        height: 60, // Diminuído
      ),
      backgroundColor: AppColors.darkGrey, // Cor escura sólida
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 70, // Altura reduzida
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: AppColors.darkGrey, // Garante fundo fixo escuro
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: AppColors.lightGrey, height: 1),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
