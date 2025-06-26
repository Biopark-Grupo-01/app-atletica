import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/models/product_model.dart';
import 'package:app_atletica/services/store_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedModel = 'PP';
  int selectedQuantity = 1;

  List<ProductModel> _moreProducts = [];
  bool _loadingMoreProducts = true;

  @override
  void initState() {
    super.initState();
    _loadMoreProducts();
  }

  // ========== MÉTODOS DE IMAGEM ==========
  
  bool _hasValidProductImage(String imageUrl) {
    return imageUrl.isNotEmpty && 
           imageUrl != 'null' && 
           !imageUrl.contains('placeholder') && 
           !imageUrl.contains('via.placeholder') &&
           !imageUrl.contains('assets/images/brasao.png');
  }

  String _getProductImageUrl(String imageUrl) {
    // Se já é uma URL completa, usa diretamente
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    
    // Se é um caminho relativo, constrói a URL completa
    return StoreService.getFullImageUrl(imageUrl);
  }

  Widget _buildProductImage(String imageUrl) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _hasValidProductImage(imageUrl) 
          ? _buildImageWidget(_getProductImageUrl(imageUrl))
          : Image.asset(
              'assets/images/brasao.png', // Imagem mockada como fallback
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF345aa7),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported, 
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Widget helper para construir a imagem correta (asset ou network)
  Widget _buildImageWidget(String imageUrl) {
    // Se for um asset local, usa Image.asset
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Erro ao carregar asset: $error');
          return Container(
            color: const Color(0xFF345aa7),
            child: const Center(
              child: Icon(
                Icons.image_not_supported, 
                size: 60,
                color: Colors.white70,
              ),
            ),
          );
        },
      );
    }
    
    // Se for uma URL do servidor, usa Image.network
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xFF345aa7),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('Erro ao carregar imagem do produto: $error');
        // Se falhar carregamento da rede, usa imagem mockada
        return Image.asset(
          'assets/images/brasao.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF345aa7),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported, 
                  size: 60,
                  color: Colors.white70,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _loadingMoreProducts = true;
    });
    final products = (await StoreService.getProducts(context)).take(5).toList();
    setState(() {
      _moreProducts = products;
      _loadingMoreProducts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: const Color(0xFF091B40),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091B40),
        title: const Text(
          'Produto',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                child: Container(
                  width: double.infinity,
                  child: _buildProductImage(product['imageUrl'] ?? 'assets/images/brasao.png'),
                ),
              ),
            ),

            // Indicador de página (só aparece se houver mais de uma página)
            const SizedBox(height: 16),
            const SizedBox(height: 8),

            // Nome do produto
            Text(
              product['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Link clicável
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/store',
                  arguments: product['category_id'],
                );
              },
              child: Text(
                'Categoria: ${product['category'].toString().toUpperCase()}',
                style: TextStyle(
                  color: Color.fromARGB(230, 255, 255, 255),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Preço destacado
            const Text(
              'A partir de',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'R\$ ${product['price']}',
              style: GoogleFonts.archivoBlack(
                textStyle: const TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),

            const SizedBox(height: 16),

            // Modelo dropdown
            if (product['category'] == 'ROUPAS')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Modelo',
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
                    child: DropdownButton<String>(
                      dropdownColor: const Color.fromARGB(255, 52, 90, 167),
                      value: selectedModel,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items:
                          ['PP', 'P', 'M', 'G', 'GG']
                              .map(
                                (size) => DropdownMenuItem(
                                  value: size,
                                  child: Text(
                                    '$size (R\$${product['price']})',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
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
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    items:
                        List.generate(10, (index) => index + 1)
                            .map(
                              (qty) => DropdownMenuItem(
                                value: qty,
                                child: Text(
                                  '$qty',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                onPressed: () async {
                  final String phoneNumber = '5544999719743';
                  final String productName = product['name'];
                  final String category = product['category'];
                  final String price = product['price'];
                  final String model = selectedModel;
                  final int quantity = selectedQuantity;

                  final String message = Uri.encodeComponent(
                    'Olá! Tenho interesse em comprar o produto:\n'
                    '- Produto: $productName\n'
                    '- Categoria: $category\n'
                    '- Modelo: $model\n'
                    '- Quantidade: $quantity\n'
                    '- Preço unitário: $price\n\n'
                    'Poderia me ajudar com o próximo passo?',
                  );

                  final Uri url = Uri.parse(
                    'https://wa.me/$phoneNumber?text=$message',
                  );

                  // if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
                  //   );
                  // }
                },

                child: const Text(
                  'Comprar agora',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            const Text(
              'Descrição',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['description'] ?? 'Sem descrição disponível.',
              style: TextStyle(color: Colors.white),
            ),

            // Mais produtos
            const SizedBox(height: 24),
            Text(
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
              child: _loadingMoreProducts
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: _moreProducts
                          .where((p) => p.id != product['id'])
                          .map((p) => _buildProductCard(
                                image: p.imageUrl ?? 'assets/images/brasao.png',
                                title: p.name,
                                product: {
                                  'id': p.id,
                                  'name': p.name,
                                  'description': p.description,
                                  'price': p.price.toStringAsFixed(2),
                                  'imageUrl': p.imageUrl ?? 'assets/images/brasao.png',
                                  'category_id': p.categoryId,
                                  'category': product['category'],
                                },
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildProductCard({
    required String image,
    required String title,
    required Map<String, dynamic> product,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productDetail', arguments: product);
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      width: 140,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white),
                    )
                  : Image.asset(
                      image,
                      width: 140,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white),
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
