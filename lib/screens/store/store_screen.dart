import 'package:app_atletica/models/product_model.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/services/product_service.dart';
import 'package:app_atletica/services/store_service.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _error;

  final CategoryService _categoryService = CategoryService();
  List<ProductCategory> _categories = [];
  bool _isLoadingCategories = true;
  String? _categoriesError;

  final List<String> _selectedCategories = [];
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoriesError = null;
    });

    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
      print('Categorias carregadas: $_categories');
    } catch (e) {
      setState(() {
        _categoriesError = 'Não foi possível carregar as categorias: $e';
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await _productService.getProducts();
      // print('Produtos carregados: ${products}');
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Não foi possível carregar os produtos: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String? categoriaId;
      if (args is String) {
        categoriaId = args;
      }
      if (categoriaId != null && !_selectedCategories.contains(categoriaId)) {
        setState(() {
          _selectedCategories.add(categoriaId!);
          _initialized = true;
        });
      }
    }
  }

  // Método para converter os produtos da API para o formato da UI
  List<Map<String, String>> _getProductsForUI() {
    if (_products.isNotEmpty) {
      return _products.map((product) {
        final map = product.toJson();
        debugPrint('Convertendo produtos para UI: $map');
        // Garante que o campo category_id esteja presente para o filtro
        map['category_id'] = product.categoryId ?? '';
        return map;
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final allProductsForUI = _getProductsForUI();
    // print('Produtos para UI: $allProductsForUI');

    final filteredProducts =
        allProductsForUI.where((product) {
          final productCategoryId = product['category_id'] ?? '';
          final matchesCategory =
              _selectedCategories.isEmpty ||
              _selectedCategories.contains(productCategoryId);
          final matchesSearch = (product['name'] ?? '').toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
          return matchesCategory && matchesSearch;
        }).toList();

    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                )
                : _error != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(color: AppColors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProducts,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
                : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    CustomSearchBar(
                      hintText: 'Buscar',
                      controller: _searchController,
                    ),
                    const SizedBox(height: 16),
                    if (_categories.isNotEmpty)
                      // Categories horizontal list
                      if (_isLoadingCategories)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                          ),
                        )
                      else if (_categoriesError != null)
                        Center(
                          child: Text(
                            _categoriesError!,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        )
                      else
                        SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 0),
                            itemCount: _categories.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(width: 20),
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              final isLast = index == _categories.length - 1;
                              final isSelected = _selectedCategories.contains(
                                category.id,
                              );

                              return Padding(
                                padding: EdgeInsets.only(
                                  right: isLast ? 16 : 0,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        if (_selectedCategories.contains(
                                          category.id,
                                        )) {
                                          _selectedCategories.remove(
                                            category.id,
                                          );
                                        } else {
                                          _selectedCategories.add(category.id);
                                        }
                                      });
                                    },
                                    child: _buildCategoryIcon(
                                      category.name,
                                      _getIconData(
                                        category.icon!.isNotEmpty
                                            ? category.icon
                                            : 'category',
                                      ),
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
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
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
                              // Busca o nome da categoria pelo id
                              final categoryName =
                                  _categories
                                      .firstWhere(
                                        (cat) =>
                                            cat.id == product['category_id'],
                                        orElse:
                                            () => ProductCategory(
                                              id: '',
                                              name: '',
                                              icon: '',
                                            ),
                                      )
                                      .name;
                              Navigator.pushNamed(
                                context,
                                '/productDetail',
                                arguments: {
                                  ...product,
                                  'category_id': product['category_id'],
                                  'category': categoryName,
                                },
                              );
                            },
                            child: _buildHorizontalProductCard(
                              product['name'] ?? '',
                              product['price'] ?? '',
                              product['image'] ?? '',
                              MediaQuery.of(context).size.width - 32,
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'checkroom':
        return Icons.checkroom;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'sports_baseball':
        return Icons.sports_baseball;
      case 'emoji_objects':
        return Icons.emoji_objects;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'key':
        return Icons.key;
      case 'brush':
        return Icons.brush;
      default:
        return Icons.category;
    }
  }

  Widget _buildCategoryIcon(
    String label,
    IconData icon, {
    bool isSelected = false,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isSelected
                      ? [const Color(0xFFFFD700), const Color(0xFFFFE066)]
                      : [
                        const Color.fromARGB(128, 52, 90, 167),
                        const Color.fromARGB(128, 52, 90, 167),
                      ],
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
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildHorizontalProductCard(
    String productName,
    String price,
    String imageUrl,
    double maxWidth,
  ) {
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
              child:
                  imageUrl.startsWith('http')
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 120,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                            ),
                      )
                      : Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 120,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                            ),
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
                      style: TextStyle(fontSize: 14, color: Color(0xFFFFD700)),
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
