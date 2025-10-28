# 🚀 Bus2 Test - Random Users App

Um aplicativo Flutter que busca usuários aleatoriamente, permite favoritar e compartilhar informações detalhadas com uma interface premium e totalmente responsiva.

## ✨ Características

- 🎨 **UI/UX Premium** - Design moderno com animações suaves
- 🔍 **Busca em Tempo Real** - Filtre usuários por nome ou email
- ❤️ **Sistema de Favoritos** - Salve usuários favoritos localmente
- 📱 **Responsivo** - Suporta portrait e landscape
- 🧪 **Testes Robustos** - 69 testes unitários de cobertura
- 🏗️ **Clean Architecture** - Separação clara de camadas
- 🔄 **BLoC Pattern** - State management profissional

## 🎯 Arquitetura
```
lib/
├── modules/
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── cubit/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── use_cases/
│   │   └── data/
│   │       ├── datasources/
│   │       └── repositories/
│   ├── persisted_user/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   ├── details/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   └── core/
│       ├── presentation/
│       ├── domain/
│       └── data/
```

**Padrão**: Clean Architecture + BLoC (Cubit) + Repository Pattern

## 🚀 Como Usar

### Pré-requisitos
- Flutter 3.0+
- Dart 3.0+

### Instalação
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/bus2_test.git
cd bus2_test

# Instale dependências
flutter pub get

# Gere os mocks para testes
flutter pub run build_runner build

# Execute o app
flutter run
```

### Rodar Testes
```bash
# Todos os testes
flutter test

# Teste específico
flutter test test/modules/core/presentation/cubit/favorites_cubit_test.dart

# Com cobertura
flutter test --coverage
```

## 📊 Testes

Total de **69 testes** com cobertura completa:

| Componente | Testes | Descrição |
|-----------|--------|-----------|
| **FavoritesCubit** | 16 | State management de favoritos (add, remove, search, load) |
| **HomePageCubit** | 11 | State management de busca de usuários |
| **SearchFavoritesUseCase** | 18 | Lógica de filtro por nome e email |
| **SharedPreferencesService** | 11 | Persistência local de favoritos |
| **HomePageDatasource** | 13 | Integração com RandomUser API |

### Status dos Testes
```
✅ FavoritesCubit - 16/16 testes passando
✅ HomePageCubit - 11/11 testes passando
✅ SearchFavoritesUseCase - 18/18 testes passando
✅ SharedPreferencesService - 11/11 testes passando
✅ HomePageDatasource - 13/13 testes passando

📊 Total: 69/69 testes passando (100%)
```

### Detalhes dos Testes

#### FavoritesCubit (16 testes)
- ✅ Load, add, remove favoritos
- ✅ Search com query
- ✅ Proteção contra duplicatas
- ✅ Rollback em caso de erro
- ✅ Reset de search
- ✅ Estado vazio
- ✅ Retry após erro

#### HomePageCubit (11 testes)
- ✅ Fetch automático de usuários
- ✅ Search em tempo real
- ✅ Filtro mantendo allUsers
- ✅ Reset de busca
- ✅ Stop/Start de ticker
- ✅ Persistência de query
- ✅ Error handling

#### SearchFavoritesUseCase (18 testes)
- ✅ Filtro por firstName, lastName, email
- ✅ Case-insensitive
- ✅ Query vazia retorna tudo
- ✅ Sem match retorna vazio
- ✅ Lista vazia retorna vazio
- ✅ Espaços em query
- ✅ Ordem dos resultados

#### SharedPreferencesService (11 testes)
- ✅ Salvar favorito
- ✅ Rejeitar duplicado
- ✅ Remover favorito
- ✅ Obter todos
- ✅ Persistência entre chamadas
- ✅ Handle ID inexistente
- ✅ Remover último

#### HomePageDatasource (13 testes)
- ✅ Parse correto de JSON
- ✅ Retorna UserModel
- ✅ Error handling (status code, lista vazia)
- ✅ DioException handling
- ✅ Múltiplos resultados
- ✅ Validação de dados
- ✅ Chamada correta de API
