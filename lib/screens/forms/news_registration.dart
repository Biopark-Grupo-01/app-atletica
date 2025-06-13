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
import 'package:app_atletica/services/news_service.dart';
import 'package:app_atletica/models/news_model.dart';

class NewsRegistrationForm extends StatefulWidget {
  const NewsRegistrationForm({super.key});

  @override
  State<NewsRegistrationForm> createState() => _NewsRegistrationFormState();
}

class _NewsRegistrationFormState extends State<NewsRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;

    // Cria objeto News sem enviar imagem
    final news = News(
      id: '',
      title: _titleController.text,
      date: _dateController.text,
      description: _descriptionController.text,
      imageUrl: null, // imagem não está sendo enviada aqui
    );

    final success = await NewsService().createNews(news);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notícia salva com sucesso')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar notícia')),
      );
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
                          child: CustomTitleForms(title: 'CADASTRO DE NOTÍCIA'),
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
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _errorImage(),
                                    )
                                  : Image.network(
                                      'https://via.placeholder.com/350x150',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _errorImage(),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Título',
                          icon: Icons.create,
                          controller: _titleController,
                        ),
                        CustomTextField(
                          label: 'Data',
                          icon: Icons.calendar_today,
                          controller: _dateController,
                        ),
                        const SizedBox(height: 15),
                        CustomTextBox(controller: _descriptionController),
                        const SizedBox(height: 25),
                        Center(
                          child: CustomButton(
                            text: 'Salvar',
                            onPressed: _saveNews,
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

  Widget _errorImage() {
    return Container(
      color: AppColors.lightGrey,
      child: const Center(
        child: Icon(Icons.broken_image, size: 50, color: Colors.red),
      ),
    );
  }
}
