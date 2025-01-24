import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/routes.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            subtitle: const Text('Editar informações pessoais'),
            onTap: () => Navigator.pushNamed(context, Routes.profile),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            subtitle: const Text('Configurar lembretes de treino'),
            onTap: () {
              // TODO: Implementar configurações de notificações
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Em desenvolvimento'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Tema'),
            subtitle: const Text('Alterar tema do aplicativo'),
            onTap: () => _showThemeDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda'),
            onTap: () {
              // TODO: Implementar tela de ajuda
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Em desenvolvimento'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'GymFlow',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.fitness_center,
                  size: 50,
                  color: Colors.blue,
                ),
                children: const [
                  Text('Um aplicativo para acompanhamento de treinos'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar saída'),
                  content: const Text('Tem certeza que deseja sair?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .signOut();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao fazer logout: ${e.toString()}'),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolher Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Sistema'),
                value: ThemeMode.system,
                groupValue: Provider.of<ThemeProvider>(context).themeMode,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Claro'),
                value: ThemeMode.light,
                groupValue: Provider.of<ThemeProvider>(context).themeMode,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Escuro'),
                value: ThemeMode.dark,
                groupValue: Provider.of<ThemeProvider>(context).themeMode,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
} 