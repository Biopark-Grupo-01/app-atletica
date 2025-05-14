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

  String avatarUrl = "";
  bool obscurePassword = true;

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
        avatarUrl = user.avatarUrl;
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

  Widget buildEditableField({
    required String label,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword ? obscurePassword : false,
              style: const TextStyle(color: Colors.white),
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      )
                    : null,
                    // : const Icon(Icons.edit, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B40),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64), // altura controlada
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 2,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Image.asset(
            "assets/images/aaabe.png",
            height: 40, // mais harmonioso para AppBar padrão
            fit: BoxFit.contain,
          ),
        ),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Editar Perfil",
              style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.yellow, thickness: 2),
            const SizedBox(height: 24),

            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.photo_camera, size: 20),
                    onPressed: () {
                      // TODO: lógica para trocar imagem
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Campos editáveis
            buildEditableField(label: "Nome", controller: nameController),
            buildEditableField(label: "CPF", controller: cpfController),
            buildEditableField(
              label: "Telefone",
              controller: phoneController,
              inputFormatters: [phoneMask],
            ),
            buildEditableField(
              label: "Data de Nascimento",
              controller: birthDateController,
              inputFormatters: [birthDateMask],
            ),            buildEditableField(label: "E-mail", controller: emailController),
            buildEditableField(
              label: "Senha",
              controller: passwordController,
              isPassword: true,
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Salvar"),
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
