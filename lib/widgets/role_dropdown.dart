import 'package:flutter/material.dart';
import 'package:app_atletica/services/role_service.dart';
import 'package:app_atletica/theme/app_colors.dart';

class RoleDropdown extends StatefulWidget {
  final List<RoleModel> availableRoles;
  final RoleModel? currentRole;
  final Function(RoleModel) onRoleChanged;
  final bool enabled;

  const RoleDropdown({
    super.key,
    required this.availableRoles,
    required this.currentRole,
    required this.onRoleChanged,
    this.enabled = true,
  });

  @override
  State<RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  RoleModel? selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.currentRole;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selectedRole?.color ?? Colors.grey,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RoleModel>(
          value: selectedRole,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 16,
          ),
          dropdownColor: AppColors.blue,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          hint: Text(
            'Selecionar role',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          items: widget.availableRoles.map((RoleModel role) {
            return DropdownMenuItem<RoleModel>(
              value: role,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: role.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      role.displayName,
                      style: TextStyle(
                        color: role.color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: widget.enabled
              ? (RoleModel? newRole) {
                  if (newRole != null) {
                    setState(() {
                      selectedRole = newRole;
                    });
                    widget.onRoleChanged(newRole);
                  }
                }
              : null,
        ),
      ),
    );
  }
}

class CurrentRoleChip extends StatelessWidget {
  final RoleModel role;
  final VoidCallback? onTap;
  final bool isEditable;

  const CurrentRoleChip({
    super.key,
    required this.role,
    this.onTap,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: role.color,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: role.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              role.displayName,
              style: TextStyle(
                color: role.color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isEditable) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.edit,
                color: role.color,
                size: 12,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
