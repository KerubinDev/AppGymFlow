import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = '/welcome';

  const WelcomeScreen({Key? key}) : super(key: key);

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithGoogle();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login com Google: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo e título
              Hero(
                tag: 'app_logo',
                child: Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48.0),
              Text(
                'Bem-vindo ao FitTracker',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Text(
                'Acompanhe seus treinos e evolua com a gente',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),

              // Botões de ação
              CustomButton(
                text: 'Criar Conta',
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                },
                isPrimary: true,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Já tenho conta',
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
                isPrimary: false,
              ),
              const SizedBox(height: 24.0),

              // Divisor
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('ou'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24.0),

              // Botão de login com Google
              OutlinedButton.icon(
                onPressed: () => _handleGoogleSignIn(context),
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: 24.0,
                ),
                label: const Text('Continuar com Google'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 