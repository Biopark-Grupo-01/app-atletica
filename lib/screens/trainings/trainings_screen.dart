import 'package:app_atletica/screens/store/store_screen.dart';
import 'package:app_atletica/screens/trainings/expandable_text.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingsScreen extends StatefulWidget {
  const TrainingsScreen({super.key});

  @override
  State<TrainingsScreen> createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
final List<Map<String, dynamic>> sports = [
  {'label': 'Futebol', 'icon': Icons.sports_soccer, 'category': 'FUTEBOL'},
  {'label': 'Vôlei', 'icon': Icons.sports_volleyball, 'category': 'VOLEI'},
  {'label': 'Tênis', 'icon': Icons.sports_tennis, 'category': 'TENIS'},
  {'label': 'Basquete', 'icon': Icons.sports_basketball, 'category': 'BASQUETE'},
  {'label': 'Handebol', 'icon': Icons.sports_handball, 'category': 'HANDEBOL'},
  {'label': 'Natação', 'icon': Icons.pool, 'category': 'NATACAO'},
];

final List<Map<String, String>> _allEvents = [
  {
    'title': 'Futebol Amistoso',
    'description': 'Jogo amistoso contra o time X no estádio municipal.',
    'type': 'AMISTOSOS',
    'category': 'FUTEBOL',
    'date': '12/05/2025',
    'location': 'Estádio Municipal'
  },
  {
    'title': 'Treino de Vôlei',
    'description': 'Treino técnico para o campeonato estadual.',
    'type': 'TREINOS',
    'category': 'VOLEI',
    'date': '15/05/2025',
    'location': 'Ginásio Poliesportivo'
  },
  {
    'title': 'Treino de Tênis Avançado',
    'description': 'Sessão intensa para atletas avançados. Treino específico para resistência física e técnica.',
    'type': 'TREINOS',
    'category': 'TENIS',
    'date': '18/05/2025',
    'location': 'Quadra de Tênis A'
  },
  {
    'title': 'Basquete Amistoso',
    'description': 'Jogo amistoso contra o time Y. Venha torcer!',
    'type': 'AMISTOSOS',
    'category': 'BASQUETE',
    'date': '20/05/2025',
    'location': 'Ginásio Central'
  },
  {
    'title': 'Treino de Handebol - Iniciantes',
    'description': 'Treino aberto para novos atletas, venha experimentar handebol!',
    'type': 'TREINOS',
    'category': 'HANDEBOL',
    'date': '22/05/2025',
    'location': 'Quadra B'
  },
  {
    'title': 'Natação Amistosa - Revezamento',
    'description': 'Competição amistosa de revezamento 4x50m entre clubes locais.',
    'type': 'AMISTOSOS',
    'category': 'NATACAO',
    'date': '25/05/2025',
    'location': 'Piscina Olímpica'
  },
  {
    'title': 'Treino de Futebol - Tática Avançada',
    'description': 'Treinamento exclusivo focado em jogadas táticas e estratégias de campo, recomendado para jogadores experientes que desejam melhorar a visão de jogo.',
    'type': 'TREINOS',
    'category': 'FUTEBOL',
    'date': '28/05/2025',
    'location': 'Campo A'
  },
  {
    'title': 'Vôlei Amistoso - Equipe Feminina',
    'description': 'Jogo amistoso entre equipes femininas. Compareça para apoiar!',
    'type': 'AMISTOSOS',
    'category': 'VOLEI',
    'date': '30/05/2025',
    'location': 'Ginásio Feminino'
  },
];

  int _selectedIndex = -1;
  int _selectedTabIndex = 0;
  List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
  final selectedType = _selectedTabIndex == 0 ? 'AMISTOSOS' : 'TREINOS';
  final filteredEvents = _allEvents.where((event) {
    final matchesType = event['type'] == selectedType;
    final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(event['category']);
    return matchesType && matchesCategory;
  }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001835),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Sports list horizontal
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: sports.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final sport = sports[index];
                    final isLast = index == sports.length - 1;
                    final isSelected = _selectedCategories.contains(sport['category']);

                    return Padding(
                      padding: EdgeInsets.only(right: isLast ? 16 : 0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              final category = sport['category'];
                              if (_selectedCategories.contains(category)) {
                                _selectedCategories.remove(category);
                              } else {
                                _selectedCategories.add(category);
                              }
                            });
                          },
                          child: _buildSportIcon(
                            sport['label'],
                            sport['icon'],
                            isSelected: isSelected,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildTab('AMISTOSOS', 0)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTab('TREINOS', 1)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Event list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredEvents.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'Nenhum valor encontrado.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Column(
                    children: filteredEvents.map((event) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/trainingDetail', arguments: 'productId');
                          },
                          child: _buildEventCard(
                            event['title']!,
                            event['description']!,
                            event['date']!,
                            event['location']!,
                            event['category']!,
                          ),
                        )
                      );
                    }).toList(),
                  ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/trainings');
              break;
            case 2:
              Navigator.pushNamed(context, '/store');
              break;
            case 3:
              Navigator.pushNamed(context, '/events');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildSportIcon(String label, IconData icon, {bool isSelected = false}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                ? [const Color(0xFFFFD700), const Color(0xFFFFE066)]
                : [const Color.fromARGB(128, 52, 90, 167), const Color.fromARGB(128, 52, 90, 167)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 30,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = index == _selectedTabIndex;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFD700) : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String description, String date, String location, String category) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.location_on, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFFFFD700),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ExpandableText(
            key: ValueKey(description),
            text: description,
            trimLines: 2,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}