#!/bin/bash

echo "🚀 Iniciando build do GymFlow..."

# Função para verificar e baixar fontes
check_and_download_fonts() {
    local fonts_dir="$1"
    local font_files=("Poppins-Regular.ttf" "Poppins-Medium.ttf" "Poppins-Bold.ttf")
    local base_url="https://github.com/google/fonts/raw/main/ofl/poppins"
    
    mkdir -p "$fonts_dir"
    
    for font in "${font_files[@]}"; do
        if [ ! -f "$fonts_dir/$font" ]; then
            echo "📥 Baixando fonte $font..."
            wget -q "$base_url/$font" -O "$fonts_dir/$font"
            if [ $? -ne 0 ]; then
                echo "❌ Erro ao baixar $font"
                return 1
            fi
        fi
    done
    return 0
}

# Verifica e baixa as fontes no projeto original
if ! check_and_download_fonts "AppGymFlow/assets/fonts"; then
    echo "❌ Erro ao configurar fontes"
    exit 1
fi

# Cria novo projeto
echo "📁 Criando novo projeto..."
cd ..
rm -rf temp_app
flutter create -t app temp_app

# Cria estrutura de diretórios
echo "📂 Criando estrutura de diretórios..."
mkdir -p temp_app/assets/{icons,fonts,images,data}

# Cria um pubspec.yaml com todas as dependências necessárias
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
  cupertino_icons: ^1.0.6
  dio: ^5.4.1
  equatable: ^2.0.7
  fl_chart: ^0.55.2
  provider: ^6.1.2
  shared_preferences: ^2.2.2
  intl: ^0.17.0
  flutter_local_notifications: ^16.3.2
  timezone: ^0.9.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.3

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/logo.png
    - assets/images/google_logo.png
    - assets/icons/
    - assets/data/
    - assets/data/exercises_db.json

  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
EOL

# Copia os arquivos necessários
echo "📋 Copiando arquivos..."
cp -r AppGymFlow/lib/* temp_app/lib/
cp -r AppGymFlow/assets/data/exercises_db.json temp_app/assets/data/
cp -r AppGymFlow/assets/images/* temp_app/assets/images/ 2>/dev/null || true
cp -r AppGymFlow/assets/icons/* temp_app/assets/icons/ 2>/dev/null || true
cp -r AppGymFlow/assets/fonts/* temp_app/assets/fonts/

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
    echo "📲 O APK está disponível em:"
    echo "   /workspaces/AppGymFlow/build/app/outputs/flutter-apk/app-debug.apk"
    echo ""
    echo "💡 Para baixar:"
    echo "1. No VS Code, abra o explorador de arquivos"
    echo "2. Navegue até AppGymFlow/build/app/outputs/flutter-apk/"
    echo "3. Clique com o botão direito em app-debug.apk"
    echo "4. Selecione 'Download'"
    
    # Limpa o projeto temporário
    cd ..
    rm -rf temp_app
else
    echo "❌ Erro ao gerar o APK"
    cd ../AppGymFlow
    exit 1
fi 