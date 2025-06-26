import 'package:app_atletica/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String _translateFirebaseAuthExceptionMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este endereço de e-mail já está em uso por outra conta.';
      case 'invalid-email':
        return 'O endereço de e-mail fornecido não é válido.';
      case 'weak-password':
        return 'A senha é muito fraca. Por favor, use uma senha mais forte.';
      case 'operation-not-allowed':
        return 'O registro com e-mail e senha não está habilitado no momento.';
      default:
        return 'Ocorreu um erro inesperado. Tente novamente.';
    }
  }

  String _parseBackendError(Object e) {
    String errorMessage = e.toString();

    if (errorMessage.startsWith('Exception: ')) {
      return errorMessage.substring('Exception: '.length);
    }

    return errorMessage;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final firebaseAuthService =
            Provider.of<FirebaseAuthService>(context, listen: false);
        await firebaseAuthService.registerWithEmailAndPassword(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        // Se a operação foi bem-sucedida, primeiro para o loading
        // e depois navega.
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          final errorMessage = _translateFirebaseAuthExceptionMessage(e.code);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          final errorMessage = _parseBackendError(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/brasao.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Container(color: const Color.fromARGB(178, 1, 28, 58)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                           MediaQuery.of(context).padding.top - 
                           MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Image.asset('assets/images/aaabe.png', scale: 0.8),
                    SizedBox(height: 30), // Espaço padronizado
                    Text('Registrar-se', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 55), // Espaço padronizado
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: Icon(Icons.person, color: AppColors.white),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.yellow,
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(color: AppColors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: AppColors.white),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.yellow,
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(color: AppColors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Insira um email válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock, color: AppColors.white),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.yellow,
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(color: AppColors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        } else if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirme sua senha',
                        prefixIcon: Icon(Icons.lock, color: AppColors.white),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.yellow,
                            width: 2,
                          ),
                        ),
                      ),
                      style: TextStyle(color: AppColors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirme sua senha';
                        }
                        if (value != passwordController.text) {
                          return 'As senhas não correspondem';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    isLoading
                        ? CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : CustomButton(
                            text: 'Registrar-se',
                            onPressed: _register,
                          ),
                    SizedBox(height: 20), // Espaço padronizado
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Já tem uma conta? Login',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
