import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/models/user_model.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MembershipCardScreen extends StatelessWidget {
  const MembershipCardScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Consumindo o Provider para garantir a reconstrução do widget quando o usuário mudar
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        // Verifica se há um usuário logado
        final currentUser = userProvider.currentUser;
        
        return Scaffold(
          appBar: CustomAppBar(showBackButton: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: currentUser != null 
                    ? _buildMembershipCard(context, currentUser) 
                    : _buildNoCardMessage(context),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
        );
      }
    );
  }
  
  // Widget que mostra o cartão do associado quando o usuário está logado
  Widget _buildMembershipCard(BuildContext context, UserModel user) {
    return Padding(
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
              user.name,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.09,
              backgroundImage: _getAvatarImage(user.avatarUrl),
            ),
            _buildInfoRow(
              'Matrícula:',
              user.registration?.toString() ?? 'Não informado',
            ),
            _buildInfoRow('CPF:', user.cpf ?? 'Não informado'),
            _buildInfoRow('E-mail:', user.email),
            _buildInfoRow('Validade:', user.validUntil ?? '31/12/2025'),
            Column(
              children: [
                const Text(
                  'Associação Tigre Branco - 2025',
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
                const Text(
                  '(01/01/2025 - 31/12/2025)',
                  style: TextStyle(color: AppColors.white, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar mensagem quando não há usuário logado
  Widget _buildNoCardMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_membership, size: 80, color: Colors.white54),
            const SizedBox(height: 16),
            const Text(
              'Carteira de Associado não disponível',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Você precisa estar logado para visualizar sua carteira de associado.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
              ),
              child: const Text('Fazer Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para obter a imagem do avatar
  ImageProvider _getAvatarImage(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return const AssetImage('assets/images/selfieCarteirinha.png');
    }
    
    if (avatarUrl.startsWith('http')) {
      return NetworkImage(avatarUrl);
    } else {
      return AssetImage(avatarUrl);
    }
  }

  _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
