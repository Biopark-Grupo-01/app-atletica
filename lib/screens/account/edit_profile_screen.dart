import 'dart:io';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/forms/profile_custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './mock_user_repository.dart';
import './user_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userRepo = MockUserRepository();
  final nameController = TextEditingController();
  final cpfController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final phoneMask = MaskTextInputFormatter(mask: '(##) #####-####');
  final birthDateMask = MaskTextInputFormatter(mask: '##/##/####');
  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

  File? _imageFile;
  String avatarUrl = "";
  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await userRepo.getUser();
    if (user != null) {
      setState(() {
        nameController.text = user.name;
        cpfController.text = user.cpf!;
        emailController.text = user.email;
        avatarUrl = user.avatarUrl!;
        // phoneController.text = user.phone;
        // birthDateController.text = user.birthDate;
      });
    }
  }

  Future<void> _saveProfile() async {
    final updatedUser = UserModel(
      id: "1", // mockado
      name: nameController.text.trim(),
      cpf: cpfController.text.trim(),
      email: emailController.text.trim(),
      avatarUrl: avatarUrl,
      // phone: phoneController.text.trim(),
      // birthDate: birthDateController.text.trim(),
    );

    await userRepo.updateUser(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil atualizado com sucesso!")),
    );

    Navigator.pop(context);
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
                          child: CustomTitleForms(title: 'EDITAR PERFIL'),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _imageFile != null
                                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                                  : (avatarUrl.isNotEmpty
                                      ? Image.network(avatarUrl, fit: BoxFit.cover)
                                      : Image.asset('assets/images/aaabe.png', fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        
                        CustomTextFieldProfile(
                          controller: nameController,
                          label: 'Nome: ',
                          icon: Icons.create,
                        ),

                        CustomTextFieldProfile(
                          controller: cpfController,
                          label: 'CPF: ',
                          icon: Icons.create,
                          inputFormatters: [cpfMask],
                        ),

                        CustomTextFieldProfile(
                          controller: emailController,
                          label: 'E-mail: ',
                          icon: Icons.create,
                        ),

                        CustomTextFieldProfile(
                          controller: passwordController,
                          label: 'Senha: ',
                          icon: Icons.create,
                          obscureText: obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => obscurePassword = !obscurePassword),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                        ),

                        CustomTextFieldProfile(
                          controller: phoneController,
                          label: 'Telefone: ',
                          icon: Icons.create,
                          inputFormatters: [phoneMask],
                        ),

                        CustomTextFieldProfile(
                          controller: birthDateController,
                          label: 'Data de Nascimento: ',
                          icon: Icons.create,
                          inputFormatters: [birthDateMask],
                        ),

                        const SizedBox(height: 45),
                        Center(
                          child: CustomButton(
                            text: 'Salvar',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveProfile();
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
