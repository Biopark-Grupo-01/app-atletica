import 'dart:io';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/forms/profile_custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.currentUser;
      
      if (user != null) {
        nameController.text = user.name;
        cpfController.text = user.cpf ?? '';
        emailController.text = user.email;
        avatarUrl = user.avatarUrl ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados: $e"))
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nenhum usuário logado!"))
      );
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    
    try {
      final updatedUser = UserModel(
        id: currentUser.id,
        name: nameController.text.trim(),
        cpf: cpfController.text.trim(),
        email: emailController.text.trim(),
        avatarUrl: avatarUrl,
        role: currentUser.role,
        registration: currentUser.registration,
        validUntil: currentUser.validUntil,
      );

      // Atualizando o usuário usando o provider
      final success = await userProvider.updateProfile(updatedUser);
      
      if (success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Perfil atualizado com sucesso!"))
          );
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao atualizar: ${userProvider.errorMessage ?? 'Erro desconhecido'}"))
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao atualizar perfil: $e"))
        );
      }
    } finally {
      setState(() {
        isLoading = false;
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
                                      ? Image(
                                          image: avatarUrl.startsWith('http')
                                              ? NetworkImage(avatarUrl)
                                              : AssetImage(avatarUrl) as ImageProvider,
                                          fit: BoxFit.cover,
                                        )
                                      : const Image(
                                          image: AssetImage("assets/images/emblema.png"),
                                          fit: BoxFit.cover,
                                        )),
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