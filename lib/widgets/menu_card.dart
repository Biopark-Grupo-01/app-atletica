import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.yellow),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.yellow),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 22,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.white,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}
