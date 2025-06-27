# App Atlética Tigre Oficial - Frontend Mobile

O **App Atlética Tigre Oficial** é um aplicativo mobile desenvolvido para a **Atlética Tigre Branco** com o objetivo de centralizar a comunicação, eventos, treinos, notícias e a loja oficial da atlética. A plataforma permite o gerenciamento de conteúdos por administradores e melhora a interação entre os membros. Este repositório contém o código-fonte do frontend do aplicativo, desenvolvido em Flutter.

## Funcionalidades Principais

*   **Cadastro e Login de Usuários**: Sistema robusto para autenticação de membros.
*   **Eventos, Treinos e Notificações**: Exibição e gerenciamento de atividades da atlética.
*   **Loja Virtual**: Plataforma integrada para venda de produtos da atlética.
*   **Perfil Personalizado**: Usuários podem customizar seus perfis e acessar informações relevantes.
*   **Gerenciamento de Conteúdo para Administradores**: Ferramentas para administradores atualizarem o aplicativo.
*   **Canal de Suporte via WhatsApp**: Facilita a comunicação e o suporte aos usuários.

## Tecnologias Utilizadas

*   **Flutter**: Framework de UI do Google para a construção de aplicativos compilados nativamente para mobile, web e desktop a partir de uma única base de código.
*   **Dart**: Linguagem de programação otimizada para UI, desenvolvida pelo Google.
*   **Firebase**: Plataforma de desenvolvimento de aplicativos móveis e web do Google, utilizada para autenticação, banco de dados e mensagens.
*   **Provider**: Gerenciamento de estado para aplicativos Flutter.
*   **Git**: Sistema de controle de versão distribuído.

## Estrutura do Projeto

O projeto Flutter segue uma estrutura organizada, com diretórios para `config`, `models`, `providers`, `screens`, `services`, `theme`, `utils` e `widgets`, garantindo modularidade e fácil manutenção.

## Como Rodar o Projeto (Desenvolvimento)

Para rodar o projeto do aplicativo Flutter, siga os passos abaixo:

### Pré-requisitos

Certifique-se de ter o Flutter SDK instalado e configurado em sua máquina. Você pode verificar a instalação e as dependências executando o seguinte comando no seu terminal:

```bash
flutter doctor
```

Este comando irá listar quaisquer dependências que você precise instalar para completar sua configuração (por exemplo, Android Studio, Xcode, ferramentas de linha de comando). Além disso, certifique-se de ter um emulador Android/iOS configurado e rodando, ou um dispositivo físico conectado e habilitado para depuração USB.

### Passos para Execução

1.  **Clone o repositório:**

    Abra seu terminal ou prompt de comando e execute:

    ```bash
    git clone https://github.com/Biopark-Grupo-01/app-atletica.git
    ```

2.  **Navegue até o diretório do projeto:**

    ```bash
    cd app-atletica
    ```

3.  **Instale as dependências:**

    No diretório raiz do projeto (`app-atletica`), obtenha as dependências do Flutter:

    ```bash
    flutter pub get
    ```

    Este comando irá baixar todos os pacotes listados no arquivo `pubspec.yaml` do projeto.

4.  **Execute o aplicativo:**

    Com um emulador ou dispositivo físico conectado e rodando, execute o aplicativo:

    ```bash
    flutter run
    ```

    *   Se você tiver múltiplos dispositivos ou emuladores, pode ser necessário especificar qual usar. Para listar os dispositivos disponíveis, use `flutter devices`. Em seguida, execute com o ID do dispositivo:

        ```bash
        flutter run -d <device_id>
        ```

    *   O aplicativo será compilado e instalado no dispositivo/emulador selecionado, e você verá os logs de execução no seu terminal.

## Contribuição

Contribuições são bem-vindas! Por favor, siga as diretrizes de contribuição do projeto.

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## Contato

Para dúvidas e suporte, entre em contato com a equipe de desenvolvimento.

