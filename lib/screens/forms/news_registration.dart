import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/forms/custom_text_field.dart';
import 'package:app_atletica/widgets/forms/custom_text_box.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';

class NewsRegistrationForm extends StatefulWidget {
  const NewsRegistrationForm({super.key});

  @override
  State<NewsRegistrationForm> createState() => _NewsRegistrationFormState();
}

class _NewsRegistrationFormState extends State<NewsRegistrationForm> {
  File? _imageUrl;
  final _formKey = GlobalKey<FormState>();

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
                        const Center(
                          child: CustomTitleForms(
                            title: 'CADASTRO DE NOTÍCIA',
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
                              child: _imageUrl != null // <--- Alteração aqui
                                  ? Image.file( // <--- Usa Image.file para arquivos locais
                                      _imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.lightGrey,
                                          child: const Center(
                                            child: Icon(
                                              Icons.broken_image, // Ícone para erro de arquivo
                                              size: 50,
                                              color: Colors.red,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Image.network( // <--- Mantém Image.network para placeholder inicial
                                      'https://via.placeholder.com/350x150', // Placeholder de rede
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
                        CustomTextField(label: 'Título', icon: Icons.create),
                        CustomTextField(
                          label: 'Data',
                          icon: Icons.calendar_today,
                        ),
                        // O campo de localização foi removido conforme solicitado
                        const SizedBox(height: 15),
                        CustomTextBox(),
                        const SizedBox(height: 25),
                        Center(
                          child: CustomButton(
                            text: 'Salvar',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Lógica para salvar os dados
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
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
