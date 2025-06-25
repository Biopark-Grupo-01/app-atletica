import 'dart:io';
import 'package:app_atletica/models/product_model.dart';
import 'package:app_atletica/widgets/forms/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/forms/custom_text_field.dart';
import 'package:app_atletica/widgets/forms/custom_text_box.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/services/store_service.dart';

class ProductRegistrationForm extends StatefulWidget {
  const ProductRegistrationForm({super.key});

  @override
  State<ProductRegistrationForm> createState() =>
      _ProductRegistrationFormState();
}

class _ProductRegistrationFormState extends State<ProductRegistrationForm> {
  File? _imageUrl;
  final _formKey = GlobalKey<FormState>();

  List<ProductCategory> _categories = [];
  bool _loadingCategories = true;
  String? _selectedCategoryId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
    });
    final categoryService = CategoryService();
    final categories = await categoryService.getCategories();
    setState(() {
      _categories = categories;
      _loadingCategories = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageUrl = File(image.path);
      });
    }
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
                          child: const CustomTitleForms(
                            title: 'CADASTRO DE PRODUTO',
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: double.infinity,
                              height: 250,
                              child: Image.network(
                                _imageUrl != null
                                    ? _imageUrl!.path
                                    : 'https://via.placeholder.com/350x150',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.lightGrey,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                },
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
                                          value: cat.id,
                                          child: Text(cat.name),
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
                            text: 'Salvar',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await CategoryService.createProduct(
                                  name: _nameController.text,
                                  description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                                  price: double.parse(_priceController.text.replaceAll(',', '.')),
                                  categoryId: _selectedCategoryId!,
                                );
                                if (success) {
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Erro ao criar produto.')),
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
