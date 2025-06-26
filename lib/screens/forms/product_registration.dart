import 'dart:io';
import 'package:app_atletica/widgets/forms/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/forms/custom_text_field.dart';
import 'package:app_atletica/widgets/forms/custom_text_box.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/services/store_service.dart';
import 'package:app_atletica/models/product_model.dart';

class ProductRegistrationForm extends StatefulWidget {
  const ProductRegistrationForm({super.key});

  @override
  State<ProductRegistrationForm> createState() =>
      _ProductRegistrationFormState();
}

class _ProductRegistrationFormState extends State<ProductRegistrationForm> {
  File? _imageFile;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  List<Map<String, dynamic>> _categories = [];
  bool _loadingCategories = true;
  String? _selectedCategoryId;
  bool _isEditing = false;
  String? _editingId;
  String? _currentImageUrl; // Para armazenar a URL da imagem atual em edição

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Os dados de edição são carregados no _loadCategories após as categorias serem carregadas
  }

  void _loadEditingData(ProductModel product) {
    print('Carregando dados do produto para edição:');
    print('ID: ${product.id}');
    print('Nome: ${product.name}');
    print('Preço original: ${product.price}');
    print('Preço formatado: ${product.price.toStringAsFixed(2).replaceAll('.', ',')}');
    print('Descrição: ${product.description}');
    print('CategoryId: ${product.categoryId}');
    print('ImageUrl: ${product.imageUrl}');
    
    setState(() {
      _isEditing = true;
      _editingId = product.id;
      _nameController.text = product.name;
      _priceController.text = product.price.toStringAsFixed(2).replaceAll('.', ',');
      _descriptionController.text = product.description ?? '';
      _selectedCategoryId = product.categoryId;
      _currentImageUrl = product.imageUrl; // Armazena a URL da imagem atual
    });
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
    });
    final categories = await StoreService.getCategories(context);
    setState(() {
      _categories = categories;
      _loadingCategories = false;
    });
    
    // Recarregar dados de edição após categorias carregadas
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is ProductModel && !_isEditing) {
      _loadEditingData(arguments);
    }
  }

  // ========== MÉTODOS DE IMAGEM ==========
  
  Future<void> _processSelectedImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Comprime a imagem
      final compressedImage = await _compressImage(imageFile);
      
      setState(() {
        _imageFile = compressedImage ?? imageFile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao processar imagem: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<File?> _compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'\.'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = "${splitted}_compressed.jpg";

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (e) {
      print('Erro ao comprimir imagem: $e');
      return null;
    }
  }

  bool _hasImage() {
    return _imageFile != null || (_currentImageUrl != null && _currentImageUrl!.isNotEmpty);
  }

  String _getImageUrl() {
    if (_imageFile != null) {
      return _imageFile!.path; // Imagem local selecionada
    }
    
    if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      // Se é uma URL completa, usa diretamente
      if (_currentImageUrl!.startsWith('http://') || _currentImageUrl!.startsWith('https://')) {
        return _currentImageUrl!;
      }
      // Se é um caminho relativo, constrói a URL completa
      return StoreService.getFullImageUrl(_currentImageUrl!);
    }
    
    return 'assets/images/brasao.png'; // Fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: CustomTitleForms(
                            title: _isEditing 
                              ? 'EDITAR PRODUTO'
                              : 'CADASTRO DE PRODUTO',
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () async {
                                    // Mostra um modal para escolher entre galeria e câmera
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: AppColors.blue,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      builder: (context) => Container(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Selecionar Imagem',
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    final picker = ImagePicker();
                                                    final picked = await picker.pickImage(
                                                      source: ImageSource.gallery,
                                                      maxWidth: 1920,
                                                      maxHeight: 1080,
                                                      imageQuality: 85,
                                                    );
                                                    if (picked != null) {
                                                      await _processSelectedImage(File(picked.path));
                                                    }
                                                  },
                                                  child: const Column(
                                                    children: [
                                                      Icon(
                                                        Icons.photo_library,
                                                        size: 50,
                                                        color: AppColors.yellow,
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        'Galeria',
                                                        style: TextStyle(
                                                          color: AppColors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    final picker = ImagePicker();
                                                    final picked = await picker.pickImage(
                                                      source: ImageSource.camera,
                                                      maxWidth: 1920,
                                                      maxHeight: 1080,
                                                      imageQuality: 85,
                                                    );
                                                    if (picked != null) {
                                                      await _processSelectedImage(File(picked.path));
                                                    }
                                                  },
                                                  child: const Column(
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                        size: 50,
                                                        color: AppColors.yellow,
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        'Câmera',
                                                        style: TextStyle(
                                                          color: AppColors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _hasImage() ? Colors.transparent : AppColors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.3),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                width: 300,
                                height: 300,
                              child: _hasImage()
                                  ? Stack(
                                      children: [
                                        _imageFile != null
                                            ? Image.file(
                                                _imageFile!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: AppColors.lightGrey,
                                                    child: const Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.image_not_supported,
                                                            size: 50,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(height: 8),
                                                          Text(
                                                            'Erro ao carregar imagem',
                                                            style: TextStyle(color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : Image.network(
                                                _getImageUrl(),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Container(
                                                    color: AppColors.lightGrey,
                                                    child: const Center(
                                                      child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: AppColors.lightGrey,
                                                    child: const Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.image_not_supported,
                                                            size: 50,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(height: 8),
                                                          Text(
                                                            'Erro ao carregar imagem',
                                                            style: TextStyle(color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _imageFile = null;
                                                _currentImageUrl = null;
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Imagem removida'),
                                                  backgroundColor: Colors.orange,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withValues(alpha: 0.8),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 50,
                                            color: AppColors.white,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Toque para adicionar uma imagem',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '(Opcional)',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Nome',
                          icon: Icons.create,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          label: 'Preço',
                          icon: Icons.attach_money,
                          controller: _priceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            if (double.tryParse(value.replaceAll(',', '.')) == null) {
                              return 'Digite um valor válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _loadingCategories
                            ? const Center(child: CircularProgressIndicator())
                            : CustomDropdown(
                                label: 'Categoria',
                                icon: Icons.category,
                                items: _categories
                                    .map((cat) => DropdownMenuItem<String>(
                                          value: cat['id'],
                                          child: Text(cat['name'] ?? ''),
                                        ))
                                    .toList(),
                                value: _selectedCategoryId,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategoryId = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
                              ),
                        const SizedBox(height: 15),
                        CustomTextBox(
                          controller: _descriptionController,
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: CustomButton(
                            text: _isEditing ? 'Atualizar' : 'Salvar',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                // Debug: Verificar se há imagem para enviar
                                print('=== DEBUG PRODUTO ===');
                                print('Tem imagem selecionada: ${_imageFile != null}');
                                if (_imageFile != null) {
                                  print('Caminho da imagem: ${_imageFile!.path}');
                                }
                                print('Modo edição: $_isEditing');

                                bool success;
                                
                                if (_isEditing) {
                                  // Atualizar produto existente
                                  print('Atualizando produto ID: $_editingId');
                                  success = await StoreService.updateProduct(
                                    productId: _editingId!,
                                    name: _nameController.text,
                                    description: _descriptionController.text.isNotEmpty ? _descriptionController.text : '',
                                    price: double.parse(_priceController.text.replaceAll(',', '.')),
                                    categoryId: _selectedCategoryId!,
                                    imageFile: _imageFile, // Passa a imagem se selecionada
                                  );
                                } else {
                                  // Criar produto novo
                                  print('Criando produto novo');
                                  success = await StoreService.createProduct(
                                    name: _nameController.text,
                                    description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                                    price: double.parse(_priceController.text.replaceAll(',', '.')),
                                    categoryId: _selectedCategoryId!,
                                    imageFile: _imageFile, // Passa a imagem se selecionada
                                  );
                                }
                                
                                print('Resultado da operação: $success');
                                
                                setState(() {
                                  _isLoading = false;
                                });
                                
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_isEditing 
                                        ? 'Produto atualizado com sucesso!' 
                                        : 'Produto cadastrado com sucesso!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_isEditing 
                                        ? 'Erro ao atualizar produto.' 
                                        : 'Erro ao cadastrar produto.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
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
}
