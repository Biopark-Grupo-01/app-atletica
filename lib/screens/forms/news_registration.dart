import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:app_atletica/services/events_news_service.dart';

class NewsRegistrationForm extends StatefulWidget {
  const NewsRegistrationForm({super.key});

  @override
  State<NewsRegistrationForm> createState() => _NewsRegistrationFormState();
}

class _NewsRegistrationFormState extends State<NewsRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  final TextEditingController _authorController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;
  String? _editingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carrega dados de edição se fornecidos
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, String> && !_isEditing) {
      _loadEditingData(arguments);
    }
  }

  void _loadEditingData(Map<String, String> newsData) {
    setState(() {
      _isEditing = true;
      _editingId = newsData['id'];
      _titleController.text = newsData['title'] ?? '';
      _descriptionController.text = newsData['description'] ?? '';
      _authorController.text = newsData['author'] ?? '';
    });
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
                          child: CustomTitleForms(title: _isEditing 
                            ? 'EDITAR NOTÍCIA' 
                            : 'CADASTRO DE NOTÍCIA'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Título',
                            prefixIcon: Icon(Icons.create, color: AppColors.white),
                            labelStyle: TextStyle(color: AppColors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Campo para adicionar imagem
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () async {
                                  final picker = ImagePicker();
                                  final picked = await picker.pickImage(source: ImageSource.gallery);
                                  if (picked != null) {
                                    setState(() {
                                      _imageFile = File(picked.path);
                                    });
                                  }
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.lightGrey,
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Image.network(
                                      'https://via.placeholder.com/350x150',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.lightGrey,
                                          child: const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _authorController,
                          decoration: InputDecoration(
                            labelText: 'Autor',
                            prefixIcon: Icon(Icons.person, color: AppColors.white),
                            labelStyle: TextStyle(color: AppColors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Label fora do campo com ícone
                        Row(
                          children: const [
                            Icon(Icons.description, color: AppColors.white),
                            SizedBox(width: 8),
                            Text(
                              'Descrição',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.yellow, width: 2),
                            ),
                          ),
                          style: const TextStyle(color: AppColors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: CustomButton(
                            text: _isLoading 
                              ? (_isEditing ? 'Atualizando...' : 'Salvando...') 
                              : (_isEditing ? 'Atualizar' : 'Salvar'),
                            onPressed: _isLoading
                                ? () {}
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);
                                      
                                      // Data atual em formato ISO (horário local)
                                      final String currentDate = DateTime.now().toIso8601String();
                                      
                                      bool success;
                                      if (_isEditing) {
                                        // Atualizar notícia existente
                                        success = await EventsNewsService().updateNews(
                                          newsId: _editingId!,
                                          title: _titleController.text,
                                          description: _descriptionController.text,
                                          date: currentDate,
                                          author: _authorController.text,
                                        );
                                      } else {
                                        // Criar notícia nova
                                        success = await EventsNewsService().createNews(
                                          title: _titleController.text,
                                          description: _descriptionController.text,
                                          date: currentDate,
                                          author: _authorController.text,
                                        );
                                      }
                                      
                                      setState(() => _isLoading = false);
                                      if (!mounted) return;
                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(_isEditing 
                                              ? 'Notícia atualizada com sucesso!' 
                                              : 'Notícia cadastrada com sucesso!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(_isEditing 
                                              ? 'Erro ao atualizar notícia!' 
                                              : 'Erro ao cadastrar notícia!'),
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
