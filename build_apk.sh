#!/bin/bash

echo "🚀 Iniciando build do GymFlow..."

# Cria novo projeto
echo "📁 Criando novo projeto..."
cd ..
rm -rf temp_app
flutter create -t app temp_app

# Cria estrutura de diretórios
echo "📂 Criando estrutura de diretórios..."
mkdir -p temp_app/assets/{icons,fonts,images}

# Cria um pubspec.yaml simplificado
echo "📝 Configurando pubspec.yaml..."
cat > temp_app/pubspec.yaml << 'EOL'
name: app_gym_flow
description: Um aplicativo para acompanhamento de treinos e progresso físico.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=2.19.0 <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  provider: ^6.0.5
  shared_preferences: ^2.1.1
  intl: ^0.17.0
  fl_chart: ^0.55.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
EOL

# Copia os arquivos necessários
echo "📋 Copiando arquivos..."
cp -r AppGymFlow/lib/* temp_app/lib/

# Entra no projeto temporário
cd temp_app

# Get dependencies
echo "📦 Instalando dependências..."
flutter pub get

# Build APK
echo "🛠️ Gerando APK..."
flutter build apk --debug

# Verifica se o build foi bem sucedido
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    # Copia o APK para o projeto original
    echo "📱 Preparando APK para download..."
    mkdir -p ../AppGymFlow/build/app/outputs/flutter-apk/
    cp build/app/outputs/flutter-apk/app-debug.apk ../AppGymFlow/build/app/outputs/flutter-apk/app-debug.apk
    
    echo "✅ Build concluído com sucesso!"
    echo "⬇️ Iniciando download automático..."
    
    # Inicia o download
    cd ../AppGymFlow
    download build/app/outputs/flutter-apk/app-debug.apk
    
    # Limpa o projeto temporário
    cd ..
    rm -rf temp_app
else
    echo "❌ Erro ao gerar o APK"
    cd ../AppGymFlow
    exit 1
fi 