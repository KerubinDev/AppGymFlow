<div align="center">

```
      ___           ___           ___           ___       ___       ___     
     /\__\         /\  \         /\__\         /\__\     /\__\     /\  \    
    /::|  |       /::\  \       /:/  /        /:/  /    /:/  /    /::\  \   
   /:|:|  |      /:/\:\  \     /:/  /        /:/  /    /:/  /    /:/\:\  \  
  /:/|:|  |__   /::\~\:\  \   /:/  /  ___   /:/  /    /:/  /    /:/  \:\  \ 
 /:/ |:| /\__\ /:/\:\ \:\__\ /:/__/  /\__\ /:/__/    /:/__/    /:/__/ \:\__\
 \/__|:|/:/  / \:\~\:\ \/__/ \:\  \ /:/  / \:\  \    \:\  \    \:\  \ /:/  /
     |:/:/  /   \:\ \:\__\    \:\  /:/  /   \:\  \    \:\  \    \:\  /:/  / 
     |::/  /     \:\ \/__/     \:\/:/  /     \:\  \    \:\  \    \:\/:/  /  
     /:/  /       \:\__\        \::/  /       \:\__\    \:\__\    \::/  /   
     \/__/         \/__/         \/__/         \/__/     \/__/     \/__/    

```

<h3>🏋️ Aplicativo de Acompanhamento de Treinos</h3>

[![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-2.19+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://www.android.com/)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue?style=for-the-badge&logo=gnu&logoColor=white)](LICENSE)

[📱 Sobre](#-sobre) • 
[✨ Funcionalidades](#-funcionalidades) • 
[🛠️ Instalação](#️-instalação) • 
[💻 Desenvolvimento](#-desenvolvimento)

</div>

## 📱 Sobre

<div align="center">

```mermaid
graph TD
    A[AppGymFlow] --> B[Registro de Treinos]
    A --> C[Acompanhamento]
    A --> D[Progresso Físico]
    A --> E[Análise de Dados]
    
    B --> B1[Exercícios]
    B --> B2[Séries/Repetições]
    
    C --> C1[Gráficos]
    C --> C2[Métricas]
    
    D --> D1[Peso]
    D --> D2[Medidas]
    
    E --> E1[Histórico]
    E --> E2[Comparativos]

    style A fill:#ff9900,stroke:#fff
    style B fill:#4B8BBE,stroke:#fff
    style C fill:#4B8BBE,stroke:#fff
    style D fill:#4B8BBE,stroke:#fff
    style E fill:#4B8BBE,stroke:#fff
```

AppGymFlow: Seu personal trainer digital, transformando dados em resultados.

</div>

## ✨ Funcionalidades

<table align="center">
  <tr>
    <td align="center" width="25%">
      <img width="64" src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Workout.svg" alt="Registro de Treinos"/>
      <br/><strong>📋 Registro</strong>
      <br/><sub>• Cadastro de exercícios<br/>• Personalização de treinos<br/>• Histórico detalhado</sub>
    </td>
    <td align="center" width="25%">
      <img width="64" src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Graph.svg" alt="Acompanhamento"/>
      <br/><strong>📊 Progresso</strong>
      <br/><sub>• Gráficos interativos<br/>• Análise de evolução<br/>• Comparativos</sub>
    </td>
    <td align="center" width="25%">
      <img width="64" src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/PersonalTrainer.svg" alt="Análise Física"/>
      <br/><strong>💪 Métricas</strong>
      <br/><sub>• Registro de peso<br/>• Medidas corporais<br/>• Evolução física</sub>
    </td>
    <td align="center" width="25%">
      <img width="64" src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Theme.svg" alt="Interface"/>
      <br/><strong>🌓 Interface</strong>
      <br/><sub>• Tema claro/escuro<br/>• Design responsivo<br/>• Acessibilidade</sub>
    </td>
  </tr>
</table>

## 🛠️ Instalação

<details>
<summary>📦 Pré-requisitos</summary>

- Flutter SDK 3.16+
- Android Studio / VS Code
- Git
- Dispositivo Android ou Emulador
</details>

<details>
<summary>⚡ Passos de Instalação</summary>

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/AppGymFlow.git
cd AppGymFlow

# Torne o script executável
chmod +x build_apk.sh

# Gere o APK
./build_apk.sh

# Localize o APK em:
# AppGymFlow/build/app/outputs/flutter-apk/app-debug.apk
```
</details>

## 🛠️ Stack Tecnológica

<div align="center">

| Mobile | State | Storage | Graphics |
|--------|-------|---------|----------|
| ![Flutter](https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Flutter.svg) | ![Provider](https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Flutter-Dark.svg) | ![SharedPrefs](https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Firebase-Dark.svg) | ![Charts](https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Chart.svg) |
| Dart 2.19+ | Provider | Local Storage | FL Chart |

</div>

## 📂 Estrutura do Projeto

```plaintext
🏋️ AppGymFlow/
├── 📊 lib/
│   ├── 🏆 models/
│   ├── 📡 providers/
│   ├── 📱 screens/
│   └── 🧩 widgets/
├── 🖼️ assets/
└── 📦 android/
```

## 🔄 Fluxo de Desenvolvimento

```mermaid
gitGraph
   commit
   branch feature
   checkout feature
   commit
   commit
   checkout main
   merge feature
   commit
```

## 👨‍💻 Autor

<div align="center">
  <img width="200" height="200" src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Github-Dark.svg">
  <h3>Kelvin Moraes</h3>
  <p>Mobile Developer | Fitness Tech Enthusiast</p>
  
[![GitHub](https://img.shields.io/badge/GitHub-KerubinDev-181717?style=for-the-badge&logo=github)](https://github.com/KerubinDev)
[![Email](https://img.shields.io/badge/Email-kelvin.moraes117@gmail.com-EA4335?style=for-the-badge&logo=gmail)](mailto:kelvin.moraes117@gmail.com)
</div>

## 📝 Licença

Projeto sob licença GNU GPL v3. Consulte [LICENSE](LICENSE) para detalhes.

---

<div align="center">
  
  **[⬆ Voltar ao topo](#appgymflow)**
  
  <sub>Desenvolvido com 💪 por Kelvin Moraes</sub>
  
[![Stack](https://img.shields.io/badge/Stack-Flutter%20%7C%20Dart-02569B?style=for-the-badge)](https://github.com/KerubinDev/AppGymFlow)
</div>

# GymFlow

## Configuração do Projeto

### 1. Fontes
O projeto usa a fonte Poppins. Siga os passos abaixo para configurá-la:

1. Baixe os arquivos da fonte Poppins:
   ```bash
   mkdir -p assets/fonts
   cd assets/fonts
   
   # Baixa as fontes
   wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf
   wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Medium.ttf
   wget https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf
   ```

2. Verifique se os arquivos foram baixados corretamente:
   ```bash
   ls -l assets/fonts/
   ```

### 2. Outros Assets
...