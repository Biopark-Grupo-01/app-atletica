import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedModel = 'PP';
  int selectedQuantity = 1;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B40),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091B40),
        title: const Text('Produto', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          children: [
            // Carrossel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: PageView(
                  controller: _pageController,

                  children: [
                  Image.asset("assets/images/roupa1.png", fit: BoxFit.contain),
                  Image.asset("assets/images/roupa2.png", fit: BoxFit.contain),
                  ],
                ),
              ),
            ),

            // Indicador de página
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 2,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.grey,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Nome do produto
            const Text(
              'Colete Biologia 025',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Link clicável
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/store', arguments: 'ROUPAS');
              },
              child: const Text(
                'Categoria: Roupas',
                style: TextStyle(color: Color.fromARGB(230, 255, 255, 255), decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 24),

            // Preço destacado
            const Text(
              'A partir de',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'R\$ 29,00',
              style: GoogleFonts.archivoBlack(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Modelo dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Modelo',
                  style: TextStyle(
                    color: Colors.white70, 
                    fontSize: 12, 
                    fontWeight: FontWeight.w300
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(128, 52, 90, 167),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xff3e6cc9)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    dropdownColor: const Color.fromARGB(255, 52, 90, 167),
                    value: selectedModel,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: ['PP', 'P', 'M', 'G', 'GG']
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(
                                '$size (R\$29,00)',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedModel = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Quantidade dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quantidade',
                  style: TextStyle(
                    color: Colors.white70, 
                    fontSize: 12, 
                    fontWeight: FontWeight.w300, 
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(128, 52, 90, 167),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xff3e6cc9)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<int>(
                    dropdownColor: const Color.fromARGB(255, 52, 90, 167),
                    value: selectedQuantity,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: List.generate(10, (index) => index + 1)
                        .map((qty) => DropdownMenuItem(
                              value: qty,
                              child: Text(
                                '$qty',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedQuantity = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Botão de compra
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Ação de compra
                },
                child: const Text('Comprar agora', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 25),

            // Card de retirada
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xff345aa7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xff3e6cc9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.info_outline, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Retirada',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'A retirada dos produtos deverá ser alinhada com o resposável por essa seção da atlética.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Descrição
            const Text('Descrição', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Colete do Kit Bixo Biologia 025!', style: TextStyle(color: Colors.white)),

            // Mais produtos
            const SizedBox(height: 24),
            const Text(
              'Mais produtos disponíveis na loja',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildProductCard(
                    image: 'assets/images/roupa1.png',
                    title: 'Camiseta Biologia',
                  ),
                  _buildProductCard(
                    image: 'assets/images/roupa2.png',
                    title: 'Caneca + Tirante',
                  ),
                  _buildProductCard(
                    image: 'assets/images/caneca.png',
                    title: 'Shorts Doll Biologia',
                  ),
                ],
              ),
            ),
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

  Widget _buildProductCard({
    required String image,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/store', arguments: 'ROUPAS');
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                width: 140,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
