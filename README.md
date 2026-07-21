# Ancore

Aplicativo Flutter de wellness emocional com reconhecimento de voz.

## Pre-requisitos

| Ferramenta | Versao minima | Como instalar |
|------------|---------------|---------------|
| Git | 2.40+ | [git-scm.com](https://git-scm.com/) |
| Android Studio | Ladybug (2024.2+) | [developer.android.com/studio](https://developer.android.com/studio) |
| FVM | 2.4+ | `dart pub global activate fvm` |
| VS Code (opcional) | recente | [code.visualstudio.com](https://code.visualstudio.com/) |

> **Nota:** O Flutter **nao** precisa ser instalado globalmente. O FVM gerencia a versao do Flutter por projeto.

---

## 1. Instalar o Dart SDK

O Dart vem junto com o Flutter, mas para instalar o FVM precisamos do `dart` no PATH.

### Linux / macOS

```bash
# Instalar Flutter (so para ter o dart)
sudo snap install flutter --classic

# Instalar FVM
dart pub global activate fvm

# Adicionar ao PATH (se nao estiver)
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Windows

```powershell
# Instalar FVM
dart pub global activate fvm

# Verificar se esta no PATH
dart pub global list
```

---

## 2. Configurar o FVM

O projeto usa FVM para garantir que todos os colaboradores usem a mesma versao do Flutter.

```bash
# Instalar a versao do Flutter do projeto
fvm install

# Usar a versao do projeto globalmente (opcional, recomendado)
fvm use
```

A versao esta definida em `.fvmrc`:

```json
{
  "flutter": "3.44.6"
}
```

> **Dica:** A partir de agora, use `fvm flutter` em vez de `flutter` para todos os comandos.

---

## 3. Configurar o Android Studio

### Instalar o Android Studio

1. Baixe em [developer.android.com/studio](https://developer.android.com/studio)
2. Durante a instalacao, marque **Android Virtual Device (AVD)**

### Configurar o SDK

1. Abra o Android Studio
2. Vá em **Settings > Languages & Frameworks > Android SDK**
3. Na aba **SDK Platforms**, instale o **Android 14 (API 34)** ou superior
4. Na aba **SDK Tools**, marque:
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android Emulator
   - Android SDK Platform-Tools

### Criar um emulador

1. Vá em **Tools > Device Manager**
2. Clique em **Create Virtual Device**
3. Escolha um dispositivo (ex: **Pixel 7**)
4. Selecione o sistema operacional **API 34** (ou superior)
5. Clique em **Finish**

### Rodar o emulador

1. No **Device Manager**, clique no icone de play ao lado do dispositivo
2. Aguarde o emulador inicializar completamente

---

## 4. Clonar e executar o projeto

```bash
# Clonar o repositorio
git clone https://github.com/DiegoSabinoMinichiello/ancore-app.git
cd ancore-app

# Instalar a versao correta do Flutter
fvm install

# Instalar as dependencias
fvm flutter pub get

# Verificar se o emulador esta conectado
fvm flutter devices

# Executar o app
fvm flutter run
```

---

## 5. Estrutura do projeto

O projeto segue a arquitetura **MVVM** (Model-View-ViewModel):

```
lib/
├── main.dart                          # Entry point
├── services/
│   └── speech_service.dart            # Servico de reconhecimento de voz
├── viewmodels/
│   └── home_view_model.dart           # Logica de negocio da home
└── views/
    ├── home_view.dart                 # Tela principal
    └── widgets/
        ├── expandable_text_input.dart # Campo de texto expansivel
        └── mic_button.dart            # Botao de microfone com animacao
```

### Camadas

| Camada | Responsabilidade |
|--------|------------------|
| **Model** | Dados e regras de negocio puras |
| **ViewModel** | Estado reativo e logica de UI |
| **View** | Apenas widget/visual, consome o ViewModel |
| **Service** | Integracoes externas (API, hardware, etc.) |

---

## 6. Dependencias principais

| Pacote | Uso |
|--------|-----|
| `speech_to_text` | Reconhecimento de voz (locale `pt_BR`) |
| `cupertino_icons` | Icones estilo iOS |

---

## 7. Comandos uteis

```bash
# Executar em modo debug
fvm flutter run

# Executar com hot reload
r (no terminal do flutter run)

# Rodar testes
fvm flutter test

# Verificar erros de analise
fvm flutter analyze

# Limpar build
fvm flutter clean

# Atualizar dependencias
fvm flutter pub upgrade
```

---

## 8. Permissoes

O app precisa de permissao de microfone para o reconhecimento de voz.

- **Android:** Ja configurado no `AndroidManifest.xml`
- **iOS:** Adicionar em `ios/Runner/Info.plist`:
  ```xml
  <key>NSMicrophoneUsageDescription</key>
  <string>Precisamos de acesso ao microfone para reconhecimento de voz.</string>
  ```

---

## 9. Solucao de problemas

### `fvm: command not found`

```bash
# Adicionar ao PATH
export PATH="$HOME/.pub-cache/bin:$PATH"
```

### `No devices found`

1. Verifique se o emulador esta rodando
2. Execute `fvm flutter devices` para listar dispositivos disponiveis

### `speech_to_text` nao funciona no emulador

O reconhecimento de voz **nao funciona em emuladores Android**. Para testar:
- Use um dispositivo fisico via USB (`fvm flutter run`)
- Ou configure o emulador com Google Play Services

### Build falha apos mudanca de分支

```bash
fvm flutter clean
fvm flutter pub get
fvm flutter run
```

---

## Contribuindo

1. Crie uma branch da feature (`git checkout -b feature/nome-da-feature`)
2. Faca suas alteracoes
3. Commit em ingles (`git commit -m "feat: add new feature"`)
4. Push para a branch (`git push origin feature/nome-da-feature`)
5. Abra um Pull Request

### Padrao de commits

Use o formato [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` nova funcionalidade
- `fix:` correcao de bug
- `refactor:` refatoracao sem mudanca de comportamento
- `docs:` documentacao
- `chore:` tarefas de manutencao
