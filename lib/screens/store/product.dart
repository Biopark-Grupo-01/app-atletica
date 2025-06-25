import 'package:app_atletica/services/product_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  String selectedModel = 'PP';
  int selectedQuantity = 1;
  final PageController _pageController = PageController();

  List<ProductModel> _moreProducts = [];
  bool _loadingMoreProducts = true;
  String? _categoryName;
  @override
  void initState() {
    super.initState();
    _loadMoreProducts();
    // Carregará o nome da categoria após o primeiro build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoryName();
    });
  }
  Future<void> _loadCategoryName() async {
    final product = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (product != null && product['category_id'] != null) {
      try {
        final categories = await _categoryService.getCategories();
        final category = categories.firstWhere(
          (cat) => cat.id == product['category_id'],
          orElse: () => ProductCategory(id: '', name: product['category_id'], icon: ''),
        );
        setState(() {
          _categoryName = category.name;
        });
      } catch (e) {
        print('Erro ao carregar nome da categoria: $e');
        setState(() {
          _categoryName = product['category_id'];
        });
      }
    }
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _loadingMoreProducts = true;
    });
    final products = await _productService.getProducts();
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
      appBar: CustomAppBar(showBackButton: true),
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
                    // Verificar se a imagem é URL ou asset local
                    product['image'].toString().startsWith('http')
                        ? Image.network(
                          product['image'],
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.white,
                                  size: 80,
                                ),
                              ),
                        )
                        : Image.asset(
                          product['image'],
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.white,
                                  size: 80,
                                ),
                              ),
                        ),
                    // Segunda imagem do carrossel (mesma lógica)
                    product['image'].toString().startsWith('http')
                        ? Image.network(
                          product['image'],
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.white,
                                  size: 80,
                                ),
                              ),
                        )
                        : Image.asset(
                          product['image'],
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.white,
                                  size: 80,
                                ),
                              ),
                        ),
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
                    activeDotColor: AppColors.white,
                    dotColor: AppColors.lightGrey,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Nome do produto
            Text(
              product['name'],
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Link clicável
            if (product['category_id'].isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/store',
                    arguments: product['category_id'],
                  );
                },
                child: Text(
                        'Categoria: $_categoryName',
                        style: const TextStyle(
                          color: AppColors.lightGrey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
              ),

            const SizedBox(height: 24),

            // Preço destacado
            const Text(
              'A partir de',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'R\$ ${product['price']}',
              style: GoogleFonts.archivoBlack(
                textStyle: const TextStyle(color: AppColors.white, fontSize: 28),
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
                      color: AppColors.lightGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xff3e6cc9)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(
                      dropdownColor: AppColors.lightBlue,
                      value: selectedModel,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.white,
                      ),
                      items:
                          ['PP', 'P', 'M', 'G', 'GG']
                              .map(
                                (size) => DropdownMenuItem(
                                  value: size,
                                  child: Text(
                                    '$size (R\$${product['price']})',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                    ),
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
                    color: AppColors.lightGrey,
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
                      color: AppColors.white,
                    ),
                    items:
                        List.generate(10, (index) => index + 1)
                            .map(
                              (qty) => DropdownMenuItem(
                                value: qty,
                                child: Text(
                                  '$qty',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),
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
                  final String category = product['category'] ?? 'Sem categoria';
                  final double price = product['price'];
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
                    color: AppColors.white,
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
                      Icon(Icons.info_outline, color: AppColors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Retirada',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'A retirada dos produtos deverá ser alinhada com o resposável por essa seção da atlética.',
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Descrição
            const Text(
              'Descrição',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['description'] ?? 'Sem descrição disponível.',
              style: TextStyle(color: AppColors.white),
            ),

            // Mais produtos
            const SizedBox(height: 24),
            Text(
              'Mais produtos disponíveis na loja',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child:
                  _loadingMoreProducts
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            _moreProducts
                                .where((p) => p.id != product['id'])
                                .map(
                                  (p) => _buildProductCard(
                                    image:
                                        p.image ?? 'assets/images/brasao.png',
                                    title: p.name,
                                    product: {
                                      'id': p.id,
                                      'name': p.name,
                                      'description': p.description,
                                      'price': p.price.toStringAsFixed(2),
                                      'image':
                                          p.image ?? 'assets/images/brasao.png',
                                      'category_id': p.categoryId,
                                    },
                                  ),
                                )
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
              child:
                  image.startsWith('http')
                      ? Image.network(
                        image,
                        width: 140,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              color: AppColors.white,
                            ),
                      )
                      : Image.asset(
                        image,
                        width: 140,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              color: AppColors.white,
                            ),
                      ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
