import 'package:app_atletica/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/screens/account/user_model.dart';

class MembershipCardScreen extends StatelessWidget {
  final UserModel? user;

  const MembershipCardScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.white, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        user!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.09,
                        backgroundImage: AssetImage(user!.avatarUrl!),
                      ),
                      _buildInfoRow(
                        'Matrícula:',
                        user!.registration.toString(),
                      ),
                      _buildInfoRow('CPF:', user!.cpf!),
                      _buildInfoRow('E-mail:', user!.email),
                      _buildInfoRow('Validade:', user!.validUntil!),
                      Column(
                        children: const [
                          Text(
                            'Associação Tigre Branco - 2025',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            '(01/01/2025 - 31/12/2025)',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }

  _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Oswald',
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontFamily: 'Oswald',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
