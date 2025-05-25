import 'dart:io';
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

class ProductRegistrationForm extends StatefulWidget {
  const ProductRegistrationForm({super.key});

  @override
  State<ProductRegistrationForm> createState() =>
      _ProductRegistrationFormState();
}

class _ProductRegistrationFormState extends State<ProductRegistrationForm> {
  File? _imageUrl;
  final _formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem<String>> category = [
    const DropdownMenuItem(value: 'Caneca', child: Text('Caneca')),
    const DropdownMenuItem(
      value: 'Camiseta Masculina',
      child: Text('Camiseta Masculina'),
    ),
    const DropdownMenuItem(
      value: 'Camiseta Feminina',
      child: Text('Camiseta Feminina'),
    ),
    const DropdownMenuItem(
      value: 'Chaveiro Tigre',
      child: Text('Chaveiro Tigre'),
    ),
    const DropdownMenuItem(
      value: 'Tatuagem Temporaria',
      child: Text('Tatuagem Temporária'),
    ),
    const DropdownMenuItem(
      value: 'Caneca Personalizada',
      child: Text('Caneca Personalizada'),
    ),
    const DropdownMenuItem(
      value: 'Caneca Estampada Premium',
      child: Text('Caneca Estampada Premium'),
    ),
    const DropdownMenuItem(value: 'Bone Oficial', child: Text('Boné Oficial')),
  ];

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
      appBar: CustomAppBar(),
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
                        CustomTextField(label: 'Nome', icon: Icons.create),
                        CustomTextField(
                          label: 'Valor',
                          icon: Icons.attach_money,
                        ),
                        const SizedBox(height: 15),
                        CustomDropdown(
                          label: 'Categoria',
                          icon: Icons.interests,
                          items: category,
                        ),
                        const SizedBox(height: 15),
                        CustomTextBox(),
                        const SizedBox(height: 25),
                        Center(
                          child: CustomButton(
                            text: 'Salvar',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Handle bottom navigation tap
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
}
