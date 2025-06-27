import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_text_field.dart';
import 'package:app_atletica/widgets/custom_button.dart';

class NewsRegistrationScreen extends StatefulWidget {
  const NewsRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<NewsRegistrationScreen> createState() => _NewsRegistrationScreenState();
}

class _NewsRegistrationScreenState extends State<NewsRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Aqui você faria a chamada para o backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notícia cadastrada com sucesso!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('Cadastro de Notícia', style: TextStyle(color: AppColors.yellow, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Título',
                  controller: _titleController,
                  icon: Icons.title,
                  validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Descrição',
                  controller: _descriptionController,
                  icon: Icons.description,
                  validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Autor',
                  controller: _authorController,
                  icon: Icons.person,
                  validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 32),
                Center(
                  child: CustomButton(
                    text: _isLoading ? 'Salvando...' : 'Salvar',
                    onPressed: _isLoading ? () {} : _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
