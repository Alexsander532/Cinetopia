# 🎬 Cinetopia

<div align="center">
  
  ### O lugar ideal para buscar, salvar e organizar seus filmes favoritos!
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![TMDB](https://img.shields.io/badge/TMDB-01D277?style=for-the-badge&logo=themoviedatabase&logoColor=white)
</div>

---

## 📑 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Funcionalidades](#-funcionalidades)
- [Arquitetura](#-arquitetura)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Integração com API](#-integração-com-api)
- [Como Executar](#-como-executar)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)

---

## 🎯 Sobre o Projeto

**Cinetopia** é um aplicativo Flutter desenvolvido para gerenciar e descobrir filmes utilizando a API do [The Movie Database (TMDB)](https://www.themoviedb.org/). O aplicativo permite aos usuários pesquisar filmes populares, visualizar próximos lançamentos e acessar detalhes completos de cada filme.

Este projeto foi desenvolvido como parte do curso de Flutter da Alura, aplicando conceitos fundamentais de desenvolvimento mobile com Flutter, consumo de APIs REST, arquitetura MVVM e boas práticas de programação.

---

## ✨ Funcionalidades

### 🔍 Busca de Filmes
- Pesquisa de filmes por título usando a API do TMDB
- Listagem de filmes populares quando nenhum termo é digitado
- Interface responsiva com campo de busca intuitivo

### 📅 Próximos Lançamentos
- Visualização de filmes que serão lançados em breve
- Lista atualizada diretamente da API do TMDB
- Navegação simples entre filmes populares e lançamentos

### 🎬 Detalhes do Filme
- Pôster do filme em alta qualidade
- Título e data de lançamento
- Descrição completa (sinopse)
- Interface limpa e fácil de navegar

### 🎨 Interface Moderna
- Design Dark Mode elegante
- Gradientes e animações suaves
- Navegação por abas (Bottom Navigation)
- Layout responsivo que se adapta a diferentes tamanhos de tela

---

## 🏗️ Arquitetura

O projeto utiliza uma arquitetura **MVVM (Model-View-ViewModel)** simplificada, separando claramente as responsabilidades:

```
┌─────────────────────────────────────────────┐
│                    VIEW                     │
│  (UI Screens - Apresentação Visual)         │
│  - HomePage                                 │
│  - Dashboard                                │
│  - SearchMovies                             │
│  - Releases                                 │
│  - MovieDetails                             │
└───────────────┬─────────────────────────────┘
                │
                │ Observa e atualiza
                ▼
┌─────────────────────────────────────────────┐
│                 VIEWMODEL                   │
│  (Lógica de Apresentação)                   │
│  - SearchMoviesViewModel                    │
│  - ReleasesViewModel                        │
│  └─── Gerencia estado e lógica de negócio  │
└───────────────┬─────────────────────────────┘
                │
                │ Solicita dados
                ▼
┌─────────────────────────────────────────────┐
│                  SERVICE                    │
│  (Camada de Serviços - Acesso a Dados)      │
│  - SearchMoviesService (Abstract)           │
│  - SearchPopularMoviesService               │
│  - SearchForMovie                           │
│  - SearchForUpcomingMovies                  │
│  └─── Consome API REST                      │
└───────────────┬─────────────────────────────┘
                │
                │ Retorna dados
                ▼
┌─────────────────────────────────────────────┐
│                   MODEL                     │
│  (Representação dos Dados)                  │
│  - Movie                                    │
│  └─── Estrutura e serialização de dados    │
└─────────────────────────────────────────────┘
```

### 📦 Camadas da Arquitetura

#### **1. Model (Modelo de Dados)**
Localização: `lib/app/models/`

- **Responsabilidade**: Representar a estrutura de dados do aplicativo
- **Movie.dart**: Classe que representa um filme com seus atributos (id, título, poster, data de lançamento, descrição)
- **Métodos**: 
  - `fromMap()`: Converte JSON da API para objeto Movie
  - `toMap()`: Converte objeto Movie para Map
  - `getPosterImageUrl()`: Retorna URL completa da imagem do pôster

#### **2. Service (Camada de Serviço)**
Localização: `lib/app/services/`

- **Responsabilidade**: Comunicação com APIs externas e gerenciamento de dados
- **SearchMoviesService**: Interface abstrata que define o contrato de busca
- **Implementações**:
  - `SearchPopularMoviesService`: Busca filmes populares
  - `SearchForMovie`: Busca filmes por título (query)
  - `SearchForUpcomingMovies`: Busca próximos lançamentos

**Padrão utilizado**: **Strategy Pattern** - Permite trocar dinamicamente a estratégia de busca

#### **3. ViewModel (Lógica de Apresentação)**
Localização: `lib/app/viewmodels/`

- **Responsabilidade**: Gerenciar o estado da UI e intermediar View ↔ Service
- **SearchMoviesViewModel**: 
  - Gerencia lista de filmes pesquisados
  - Decide qual service usar (popular ou busca por título)
- **ReleasesViewModel**: 
  - Gerencia lista de próximos lançamentos

**Características**:
- Mantém estado privado (`_moviesList`)
- Expõe dados através de getters públicos
- Coordena chamadas assíncronas aos serviços

#### **4. View (Interface do Usuário)**
Localização: `lib/ui/screens/` e `lib/ui/components/`

- **Responsabilidade**: Apresentação visual e interação com usuário
- **Screens**:
  - `HomePage`: Tela inicial com splash screen
  - `Dashboard`: Container principal com navegação por abas
  - `SearchMovies`: Tela de busca e filmes populares
  - `Releases`: Tela de próximos lançamentos
  - `MovieDetails`: Detalhes completos de um filme

- **Components**:
  - `MovieCard`: Card reutilizável para exibir filme em lista
  - `Buttons`: Botões personalizados da aplicação

---

## 📂 Estrutura do Projeto

```
cinetopia/
│
├── assets/                          # Recursos visuais
│   ├── logo.png                     # Logo do aplicativo
│   ├── splash.png                   # Imagem da tela inicial
│   ├── movie.png                    # Ícone de filme
│   ├── popular.png                  # Ícone de filmes populares
│   └── upcoming.png                 # Ícone de lançamentos
│
├── lib/
│   ├── main.dart                    # Ponto de entrada do app
│   │
│   ├── app/
│   │   ├── app.dart                 # Configuração do MaterialApp
│   │   ├── api_key.dart            # Chave de API do TMDB
│   │   │
│   │   ├── helpers/
│   │   │   └── consts.dart         # Constantes (URLs, headers, etc)
│   │   │
│   │   ├── models/
│   │   │   └── movie.dart          # Modelo de dados do filme
│   │   │
│   │   ├── services/
│   │   │   └── search_movies_service.dart  # Serviços de busca
│   │   │
│   │   └── viewmodels/
│   │       ├── search_movies_viewmodel.dart
│   │       └── releases_viewmodel.dart
│   │
│   └── ui/
│       ├── components/
│       │   ├── buttons.dart        # Botões customizados
│       │   └── movie_card.dart     # Card de filme
│       │
│       └── screens/
│           ├── home_page.dart      # Tela inicial
│           ├── dashboard.dart      # Dashboard com navegação
│           ├── search_movies.dart  # Tela de busca
│           ├── releases.dart       # Tela de lançamentos
│           └── movie_details.dart  # Detalhes do filme
│
├── pubspec.yaml                     # Dependências e configurações
└── README.md                        # Este arquivo
```

---

## 🌐 Integração com API

### The Movie Database (TMDB) API

O aplicativo consome a API REST do TMDB para obter informações sobre filmes.

#### 🔑 Configuração da API Key

1. Crie uma conta em [The Movie Database](https://www.themoviedb.org/)
2. Acesse [API Settings](https://www.themoviedb.org/settings/api)
3. Copie sua API Key
4. Cole em `lib/app/api_key.dart`:

```dart
const String apiKey = 'SUA_API_KEY_AQUI';
```

#### 📡 Endpoints Utilizados

##### 1. **Filmes Populares**
```
GET https://api.themoviedb.org/3/movie/popular?api_key={api_key}&language=pt-BR&page=1
```
- **Usado em**: Tela de busca (quando não há termo de pesquisa)
- **Service**: `SearchPopularMoviesService`

##### 2. **Busca por Título**
```
GET https://api.themoviedb.org/3/search/movie?query={termo}&include_adult=false&language=pt-BR&page=1&api_key={api_key}
```
- **Usado em**: Tela de busca (ao digitar um termo)
- **Service**: `SearchForMovie`
- **Parâmetro**: `query` - termo de busca digitado

##### 3. **Próximos Lançamentos**
```
GET https://api.themoviedb.org/3/movie/upcoming?language=pt-BR&page=1&api_key={api_key}
```
- **Usado em**: Tela de lançamentos
- **Service**: `SearchForUpcomingMovies`

##### 4. **Imagens (Posters)**
```
https://image.tmdb.org/t/p/w500{poster_path}
```
- **Resolução**: w500 (500px de largura)
- **Usado em**: Todas as telas que exibem imagens de filmes

#### 🔄 Fluxo de Requisição

```
1. User Interface (View)
   └─→ Solicita dados ao ViewModel
       
2. ViewModel
   └─→ Chama método do Service apropriado
       
3. Service
   └─→ Faz requisição HTTP para API TMDB
       └─→ Recebe resposta JSON
           └─→ Converte JSON para List<Movie>
               
4. ViewModel
   └─→ Armazena lista de filmes
       └─→ Retorna Future<List<Movie>>
           
5. View (FutureBuilder)
   └─→ Reconstrói UI com os dados recebidos
```

#### 🛡️ Tratamento de Erros

```dart
try {
  final response = await http.get(url, headers: headers);
  
  if (response.statusCode == 200) {
    // Parse JSON e retorna dados
  } else {
    throw Exception('Falha ao carregar: ${response.statusCode}');
  }
} catch (e) {
  throw Exception('Erro ao buscar filmes: $e');
}
```

#### 📊 Formato de Resposta da API

```json
{
  "page": 1,
  "results": [
    {
      "id": 123,
      "title": "Título do Filme",
      "poster_path": "/caminho_do_poster.jpg",
      "release_date": "2024-12-25",
      "overview": "Descrição completa do filme..."
    }
  ],
  "total_pages": 500,
  "total_results": 10000
}
```

---

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.9.0 ou superior)
- Dart SDK
- Android Studio / VS Code com extensões Flutter
- Emulador Android/iOS ou dispositivo físico

### Passo a Passo

1. **Clone o repositório**
```bash
git clone <seu-repositorio>
cd cinetopia
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure a API Key**
   - Edite o arquivo `lib/app/api_key.dart`
   - Insira sua chave de API do TMDB

4. **Execute o aplicativo**
```bash
flutter run
```

### Comandos Úteis

```bash
# Verificar instalação do Flutter
flutter doctor

# Limpar build anterior
flutter clean

# Atualizar dependências
flutter pub upgrade

# Executar em modo release
flutter run --release

# Gerar APK
flutter build apk
```

---

## 🛠️ Tecnologias Utilizadas

### Framework e Linguagem
- **Flutter 3.9.0+** - Framework de UI multiplataforma
- **Dart 3.9.0+** - Linguagem de programação

### Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8    # Ícones iOS
  http: ^1.6.0               # Cliente HTTP para requisições API

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0      # Análise estática de código
```

### Packages Utilizados

#### **http (^1.6.0)**
- **Propósito**: Realizar requisições HTTP para API REST
- **Uso**: Buscar filmes, posters e informações do TMDB
- **Exemplo**:
```dart
final response = await http.get(
  Uri.parse(url),
  headers: {'Content-Type': 'application/json'}
);
```

### Widgets Flutter Utilizados

- **MaterialApp** - Configuração base do aplicativo
- **Scaffold** - Estrutura básica das telas
- **BottomNavigationBar** - Navegação por abas
- **FutureBuilder** - Construção assíncrona de UI
- **CustomScrollView + Slivers** - Listas com scroll otimizado
- **TextField** - Campo de busca
- **InkWell** - Detectar toques e navegação
- **NetworkImage** - Carregar imagens da internet

---

## 📚 Conceitos Aplicados

### 1. **Programação Assíncrona**
- Uso de `Future` e `async/await`
- `FutureBuilder` para UI reativa
- Tratamento de estados (loading, sucesso, erro)

### 2. **Consumo de API REST**
- Requisições HTTP GET
- Parse de JSON
- Tratamento de erros de rede

### 3. **Gerenciamento de Estado**
- ViewModel pattern
- `setState()` para atualização de UI
- Estado privado com getters públicos

### 4. **Navegação**
- `Navigator.push()` para navegação entre telas
- Passagem de parâmetros entre rotas
- Bottom Navigation Bar

### 5. **Widgets Customizados**
- Componentes reutilizáveis (MovieCard, Buttons)
- Composição de widgets
- Encapsulamento de lógica visual

### 6. **Boas Práticas**
- Separação de responsabilidades (MVVM)
- Código limpo e documentado
- Constantes centralizadas
- Tratamento de erros robusto

---

## 🎓 Aprendizados do Projeto

Este projeto demonstra:

✅ Como estruturar um app Flutter profissionalmente  
✅ Integração com APIs REST externas  
✅ Implementação de arquitetura MVVM  
✅ Navegação e gerenciamento de rotas  
✅ Widgets assíncronos e FutureBuilder  
✅ Design responsivo e UI moderna  
✅ Tratamento de erros e estados de loading  
✅ Reutilização de componentes  

---

## 📝 Licença

Este projeto foi desenvolvido para fins educacionais como parte do curso Flutter da Alura.

---

## 👨‍💻 Autor

Desenvolvido por **Alexsander** durante o curso de Flutter - Nível Junior da Alura.

---

## 🙏 Agradecimentos

- [Alura](https://www.alura.com.br/) - Pela excelente formação em Flutter
- [The Movie Database (TMDB)](https://www.themoviedb.org/) - Pela API gratuita e bem documentada
- [Flutter Team](https://flutter.dev/) - Pelo incrível framework

---

<div align="center">
  
  ### ⭐ Se este projeto foi útil, considere dar uma estrela!
  
  **Cinetopia** - Seus filmes favoritos em um só lugar 🎬
  
</div>

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
