import 'package:app_atletica/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/widgets/custom_button.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool isChecked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Para testes: preenche os campos com credenciais de teste
    if (emailController.text.isEmpty) {
      // emailController.text = 'admin@atletica.com';
      // passwordController.text = 'admin123';
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final firebaseAuthService =
            Provider.of<FirebaseAuthService>(context, listen: false);
        final user = await firebaseAuthService.signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        
        if (user != null) {
          print('Login por email bem-sucedido: ${user.email}');
          // A navegação será tratada pelo stream de estado de autenticação em main.dart
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'Falha ao fazer login.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ocorreu um erro. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final firebaseAuthService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      print('Iniciando login com Google...');
      final user = await firebaseAuthService.signInWithGoogle();
      
      if (user != null) {
        print('Login com Google bem-sucedido: ${user.email}');
        // A navegação será tratada pelo stream de estado de autenticação em main.dart
      } else {
        print('Login com Google cancelado pelo usuário');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Google Sign-In Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao fazer login com o Google: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
    // Não definimos _isLoading = false aqui no finally porque pode interferir com a navegação automática
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color.fromARGB(255, 30, 30, 30)),
          Opacity(
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
          Container(color: const Color.fromARGB(178, 1, 28, 58)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/aaabe.png', scale: 0.8),
                    SizedBox(height: 30), // Espaço padronizado
                    Text('Login', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 55), // Espaço padronizado
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
                        } else if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(value)) {
                          return 'Insira um email válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock, color: AppColors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
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
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });
                              },
                            ),
                            Text('Lembre-me'),
                          ],
                        ),
                        GestureDetector(
                          onTap:
                              () => Navigator.pushNamed(
                                context,
                                '/password_recovery',
                              ),
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(), // Empurra os elementos restantes para baixo
                    if (_isLoading)
                      CircularProgressIndicator()
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Login',
                              onPressed: _login,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/google_icon.png', // Certifique-se que este caminho está correto
                              height: 24.0,
                            ),
                            onPressed: _signInWithGoogle,
                            tooltip: 'Login com Google',
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 20), // Espaço padronizado
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Registrar-se',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
