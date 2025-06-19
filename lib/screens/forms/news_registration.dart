// lib/screens/forms/news_registration.dart
import 'dart:io';
import 'package:flutter/material.dart'; // Este já fornece debugPrint
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// Importações dos seus widgets e serviços customizados
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/forms/custom_text_field.dart';
import 'package:app_atletica/widgets/forms/custom_text_box.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/models/news_model.dart';
import 'package:app_atletica/services/news_service.dart';

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

  File? _selectedImageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl;

      try {
        if (_selectedImageFile != null) {
          imageUrl = await NewsService.uploadImage(_selectedImageFile!);
        }

        final String title = _titleController.text.trim();
        final String date = _dateController.text.trim();
        final String description = _descriptionController.text.trim();

        // O ID é geralmente gerado pelo backend, então pode ser uma string vazia ou nula ao criar
        final News newNews = News(
          id: '',
          title: title,
          date: date,
          description: description,
          imageUrl: imageUrl,
        );

        await NewsService.createNews(newNews);

        // --- CORREÇÃO: Usar !mounted para verificar o contexto ---
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notícia cadastrada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        _titleController.clear();
        _dateController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedImageFile = null;
        });

        // --- CORREÇÃO: Usar !mounted para verificar o contexto ---
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        // --- CORREÇÃO: Usar debugPrint em vez de print ---
        debugPrint('Erro ao cadastrar notícia: $e');
        // --- CORREÇÃO: Usar !mounted para verificar o contexto ---
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar notícia: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: AppColors.white,
              surface: AppColors.lightBlue,
              onSurface: AppColors.black,
            ),
            // --- CORREÇÃO: Usar dialogTheme para backgroundColor ---
            dialogTheme: const DialogTheme(
              backgroundColor: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: const CustomAppBar(showBackButton: true),
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
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.white, width: 1),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: _selectedImageFile != null
                                  ? Image.file(
                                      _selectedImageFile!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.lightGrey,
                                          child: const Center(
                                            child: Icon(Icons.image_not_supported, size: 50, color: AppColors.white),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: AppColors.lightBlue,
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo, size: 50, color: AppColors.white),
                                          SizedBox(height: 8),
                                          Text(
                                            'Toque para selecionar imagem',
                                            style: TextStyle(color: AppColors.white, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _titleController,
                          label: 'Título',
                          icon: Icons.create,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O título é obrigatório.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _dateController,
                          label: 'Data',
                          icon: Icons.calendar_today,
                          readOnly: true,
                          // --- CORREÇÃO: Envolver a função assíncrona _selectDate ---
                          onTap: () async {
                            await _selectDate(context);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A data é obrigatória.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextBox(
                          controller: _descriptionController,
                          label: 'Descrição',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A descrição é obrigatória.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),

                        Center(
                          child: CustomButton(
                            text: _isLoading ? 'Salvando...' : 'Salvar',
                            onPressed: _isLoading ? null : () async {
                              await _submitForm();
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
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }
}