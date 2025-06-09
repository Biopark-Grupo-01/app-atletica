import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Notícia", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Palmeiras faz jogo-treino antes de viagem: veja lista de relacionados para Copa do Mundo de Clubes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Verdão seguirá viagem com 29 atletas, deixando no Brasil apenas Bruno Rodrigues e Figueiredo; Paulinho, assim como no sábado, trabalhou na parte interna do CT, mas vai aos EUA',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Por Redação do ge — São Paulo',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$formattedDate · Atualizado há 4 horas',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),

            /// Descrição principal da notícia
            const Text(
              'O Palmeiras realizou um jogo-treino antes de embarcar para os Estados Unidos, onde disputará a Copa do Mundo de Clubes. A delegação conta com 29 jogadores, e apenas Bruno Rodrigues e Figueiredo permaneceram no Brasil. Paulinho, que treinou separadamente no CT, está confirmado na viagem. O técnico Abel Ferreira deve utilizar os treinos nos EUA para ajustar a equipe titular antes da estreia no torneio. A comissão técnica avaliou o desempenho físico e técnico dos atletas durante a preparação e espera um bom desempenho no campeonato internacional.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 32),

            /// Botões de compartilhamento (estáticos para exemplo)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  onPressed: () {}, // ação de compartilhar
                ),
                IconButton(
                  icon: const Icon(Icons.whatshot_sharp, color: Colors.green),
                  onPressed: () {}, // ação de compartilhar
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.black87),
                  onPressed: () {}, // ação de compartilhar
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
