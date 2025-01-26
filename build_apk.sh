#!/bin/bash

echo "🚀 Iniciando build do GymFlow..."

# Obtém o diretório base do projeto
BASE_DIR=$(pwd)
echo "📂 Diretório base: $BASE_DIR"

# Função para verificar e baixar fontes
check_and_download_fonts() {
    local fonts_dir="$1"
    local font_files=("Poppins-Regular.ttf" "Poppins-Medium.ttf" "Poppins-Bold.ttf")
    local base_url="https://github.com/google/fonts/raw/main/ofl/poppins"
    
    echo "📁 Criando diretório de fontes em: $fonts_dir"
    mkdir -p "$fonts_dir"
    
    for font in "${font_files[@]}"; do
        if [ ! -f "$fonts_dir/$font" ]; then
            echo "📥 Baixando fonte $font..."
            wget "$base_url/$font" -O "$fonts_dir/$font" || {
                echo "❌ Erro ao baixar $font"
                echo "🔍 Tentando curl como alternativa..."
                curl -L "$base_url/$font" -o "$fonts_dir/$font" || {
                    echo "❌ Falha também com curl"
                    return 1
                }
            }
            echo "✅ Fonte $font baixada com sucesso"
        else
            echo "✓ Fonte $font já existe"
        fi
    done

    # Verifica se todos os arquivos existem e têm tamanho maior que zero
    echo "🔍 Verificando arquivos de fonte..."
    for font in "${font_files[@]}"; do
        if [ ! -s "$fonts_dir/$font" ]; then
            echo "❌ Arquivo $font não existe ou está vazio"
            return 1
        fi
        echo "✅ $font: $(wc -c < "$fonts_dir/$font") bytes"
    done
    
    return 0
}

# Verifica e baixa as fontes no projeto original
if ! check_and_download_fonts "$BASE_DIR/assets/fonts"; then
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
cp -r "$BASE_DIR/lib/"* temp_app/lib/
cp -r "$BASE_DIR/assets/data/exercises_db.json" temp_app/assets/data/
cp -r "$BASE_DIR/assets/images/"* temp_app/assets/images/ 2>/dev/null || true
cp -r "$BASE_DIR/assets/icons/"* temp_app/assets/icons/ 2>/dev/null || true

# Copia as fontes com verificação
echo "📋 Copiando fontes..."
for font in Poppins-{Regular,Medium,Bold}.ttf; do
    if [ -f "$BASE_DIR/assets/fonts/$font" ]; then
        cp "$BASE_DIR/assets/fonts/$font" "temp_app/assets/fonts/"
        echo "✅ Copiado: $font"
    else
        echo "❌ Fonte não encontrada: $font em $BASE_DIR/assets/fonts/"
        ls -la "$BASE_DIR/assets/fonts/"
        exit 1
    fi
done

# Verifica se as fontes foram copiadas corretamente
echo "🔍 Verificando fontes copiadas..."
for font in Poppins-{Regular,Medium,Bold}.ttf; do
    if [ ! -s "temp_app/assets/fonts/$font" ]; then
        echo "❌ Erro: $font não foi copiado corretamente"
        exit 1
    fi
    echo "✅ $font: $(wc -c < "temp_app/assets/fonts/$font") bytes"
done

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