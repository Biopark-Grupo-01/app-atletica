import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<Map<String, dynamic>> storeCategories = [
    {'label': 'Canecas', 'icon': Icons.local_drink, 'category': 'CANECAS'},
    {'label': 'Roupas', 'icon': Icons.checkroom, 'category': 'ROUPAS'},
    {'label': 'Chaveiros', 'icon': Icons.key, 'category': 'CHAVEIROS'},
    {'label': 'Tatuagens', 'icon': Icons.brush, 'category': 'TATUAGENS'},
  ];

  final List<Map<String, String>> storeProducts = [
    {'name': 'Caneca Oficial', 'category': 'CANECAS', 'price': '25,00', 'image': 'https://via.placeholder.com/150?text=Caneca'},
    {'name': 'Camiseta Masculina', 'category': 'ROUPAS', 'price': '50,00', 'image': 'https://via.placeholder.com/150?text=Camiseta'},
    {'name': 'Camiseta Feminina', 'category': 'ROUPAS', 'price': '50,00', 'image': 'https://via.placeholder.com/150?text=Camiseta'},
    {'name': 'Chaveiro Tigre', 'category': 'CHAVEIROS', 'price': '15,00', 'image': 'https://via.placeholder.com/150?text=Chaveiro'},
    {'name': 'Tatuagem Temporária', 'category': 'TATUAGENS', 'price': '10,00', 'image': 'https://via.placeholder.com/150?text=Tatuagem'},
    {'name': 'Caneca Personalizada', 'category': 'CANECAS', 'price': '30,00', 'image': 'https://via.placeholder.com/150?text=Caneca+'},
    {'name': 'Caneca Estampada Premium', 'category': 'CANECAS', 'price': '35,00', 'image': 'https://via.placeholder.com/150?text=Caneca'},
    {'name': 'Boné Oficial', 'category': 'ROUPAS', 'price': '40,00', 'image': 'https://via.placeholder.com/150'},
  ];

  List<String> _selectedCategories = [];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = storeProducts.where((product) {
      final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(product['category']);
      final matchesSearch = product['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001835),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF003366),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Categories horizontal list
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 0),
                itemCount: storeCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final category = storeCategories[index];
                  final isLast = index == storeCategories.length - 1;
                  final isSelected = _selectedCategories.contains(category['category']);

                  return Padding(
                    padding: EdgeInsets.only(right: isLast ? 16 : 0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            final cat = category['category'];
                            if (_selectedCategories.contains(cat)) {
                              _selectedCategories.remove(cat);
                            } else {
                              _selectedCategories.add(cat);
                            }
                          });
                        },
                        child: _buildCategoryIcon(
                          category['label'],
                          category['icon'],
                          isSelected: isSelected,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Product list or message
            if (filteredProducts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Nenhum produto encontrado para as categorias ou busca selecionadas.',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...filteredProducts.map((product) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/productDetail', arguments: product);
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return _buildHorizontalProductCard(
                          product['name']!,
                          product['price']!,
                          product['image']!,
                          constraints.maxWidth,
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
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

  Widget _buildCategoryIcon(String label, IconData icon, {bool isSelected = false}) {
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

  Widget _buildHorizontalProductCard(String productName, String price, String imageUrl, double maxWidth) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 110,
      child: Row(
        children: [
          // Image - 30%
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/caneca.png",
                fit: BoxFit.cover,
                height: 120,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name - 40%
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Price - 30%
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'R\$ ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    TextSpan(
                      text: price,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
