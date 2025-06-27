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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.image, color: AppColors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Imagem da Notícia',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
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
                                                        setState(() {
                                                          _imageFile = File(picked.path);
                                                        });
                                                        
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Imagem selecionada da galeria!'),
                                                            backgroundColor: Colors.green,
                                                            duration: Duration(seconds: 2),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Column(
                                                      children: const [
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
                                                        setState(() {
                                                          _imageFile = File(picked.path);
                                                        });
                                                        
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Foto capturada com sucesso!'),
                                                            backgroundColor: Colors.green,
                                                            duration: Duration(seconds: 2),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Column(
                                                      children: const [
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
                                  color: _imageFile != null ? Colors.transparent : AppColors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.white.withValues(alpha: 0.3),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: _imageFile != null
                                      ? Stack(
                                          children: [
                                            Image.file(
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
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _imageFile = null;
                                                  });
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
                          ],
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
                                        // Atualizar notícia existente com imagem opcional
                                        success = await EventsNewsService().updateNewsWithImage(
                                          newsId: _editingId!,
                                          title: _titleController.text,
                                          description: _descriptionController.text,
                                          date: currentDate,
                                          author: _authorController.text,
                                          imageFile: _imageFile, // Pode ser null
                                        );
                                      } else {
                                        // Criar notícia nova com imagem opcional
                                        success = await EventsNewsService().createNewsWithImage(
                                          title: _titleController.text,
                                          description: _descriptionController.text,
                                          date: currentDate,
                                          author: _authorController.text,
                                          imageFile: _imageFile, // Pode ser null
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
