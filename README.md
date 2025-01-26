# AppGymFlow

Um aplicativo para acompanhamento de treinos e progresso físico.

## Funcionalidades

- Registro de treinos
- Acompanhamento de progresso
- Histórico de exercícios
- Tema claro/escuro

## Como executar

### Pré-requisitos

- Flutter SDK
- Git
- Android Studio ou VS Code
- Dispositivo Android ou Emulador

### Passos para executar

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/AppGymFlow.git
cd AppGymFlow
```

2. Torne o script de build executável:
```bash
chmod +x build_apk.sh
```

3. Execute o script para gerar o APK:
```bash
./build_apk.sh
```

4. Para baixar o APK:
   - No VS Code, abra o explorador de arquivos
   - Navegue até `AppGymFlow/build/app/outputs/flutter-apk/`
   - Clique com o botão direito em `app-debug.apk`
   - Selecione 'Download'

5. Instale o APK no seu dispositivo Android

### Desenvolvimento

Para desenvolver o app localmente:

1. Instale as dependências:
```bash
flutter pub get
```

2. Execute em modo de desenvolvimento:
```bash
flutter run
```

## Estrutura do Projeto

```
lib/
├── models/         # Classes de dados
├── providers/      # Gerenciamento de estado
├── screens/        # Telas do app
├── widgets/        # Componentes reutilizáveis
└── main.dart       # Ponto de entrada
```

## Tecnologias

- Flutter
- Provider (Gerenciamento de Estado)
- Shared Preferences (Armazenamento Local)
- FL Chart (Gráficos)

## Contribuindo

1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença GNU GPL 3. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.