import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'dart:convert';

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
                    Image.network("https://images.tcdn.com.br/img/img_prod/586374/camiseta_masculina_lisa_basica_adulto_malwee_azul_marinho_7218_1_d5de3fbde1ffc6cc2f83ecfcf0003a3b.jpg", fit: BoxFit.contain),
                    Image.network("data:image/jpeg;base64,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", fit: BoxFit.contain),
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
              'Camiseta Masculina',
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
              'R\$ 50,00',
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
                                '$size (R\$50,00)',
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
            const Text('Camiseta do Kit Atlética Biopark 2025!', style: TextStyle(color: Colors.white)),

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
                    image: 'assets/images/camisetaa_masculina.png',
                    title: 'Camiseta Masculina',
                  ),
                  _buildProductCard(
                    image: 'assets/images/camiseta_feminina_1.png',
                    title: 'Camiseta Feminina',
                  ),
                  _buildProductCard(
                    image: 'assets/images/caneca_oficial.png',
                    title: 'Caneca Oficial',
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
