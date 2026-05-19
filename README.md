# Lista de Tarefas - Flutter

Aplicativo de Lista de Tarefas desenvolvido em Flutter com tela de Login/Cadastro, Calendário interativo e gerenciamento de tarefas diárias.

## Funcionalidades

- **Tela de Login**: Autenticação com email e senha com validação de campos
- **Tela de Cadastro**: Registro de novo usuário com confirmação de senha
- **Calendário Interativo**: Navegação por meses com indicadores visuais de tarefas
- **Lista de Tarefas**: Adicionar, remover e marcar tarefas como concluídas
- **Ordenação Inteligente**: Tarefas pendentes aparecem primeiro, seguidas das concluídas, ambas em ordem alfabética
- **Dialog de Adição**: Interface elegante para adicionar novas tarefas via ShowDialog

## Estrutura do Projeto

```
lib/
├── main.dart                      # Ponto de entrada do aplicativo
├── models/
│   └── tarefa.dart                # Modelo de dados da tarefa
└── screens/
    ├── login_screen.dart          # Tela de login
    ├── cadastro_screen.dart       # Tela de cadastro
    └── calendario_screen.dart     # Tela de calendário + lista de tarefas
```

## Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento mobile
- **table_calendar** - Widget de calendário interativo
- **google_fonts** - Tipografia Poppins
- **intl** - Internacionalização e formatação de datas

## Design

O aplicativo utiliza um esquema de cores premium com:
- **Fundo**: Gradiente dark navy (#0D1B2A)
- **Primária**: Teal vibrante (#00BFA6 → #00E5CC)
- **Secundária**: Coral/Laranja (#FF6B6B → #FF8E53)
- **Sucesso**: Verde neon (#00E676)
- **Info**: Azul claro (#4FC3F7)

## Como Executar

1. Certifique-se de ter o Flutter instalado
2. Clone o repositório
3. Execute `flutter pub get` para instalar as dependências
4. Execute `flutter run` para rodar o aplicativo

## Autor

Projeto desenvolvido como atividade acadêmica.