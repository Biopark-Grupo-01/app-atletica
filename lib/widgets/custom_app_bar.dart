import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBack;
  const CustomAppBar({super.key, this.showBackButton = false, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Image.asset('assets/images/aaabe.png', height: 60),
      backgroundColor: AppColors.darkGrey,
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 70,
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: AppColors.darkGrey),
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
