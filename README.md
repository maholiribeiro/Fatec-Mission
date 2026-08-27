# Fatec Mission — Plataforma de Gamificação

O Fatec Mission é uma plataforma de gamificação desenvolvida para tornar a experiência acadêmica mais interativa, dinâmica e atrativa. A proposta é transformar a própria Fatec em um ambiente de missões, desafios e recompensas, incentivando estudantes a conhecerem melhor a instituição, participarem de eventos e atividades acadêmicas e interagirem com a comunidade.

Durante a **Fatec Expo Week**, os participantes poderão realizar missões presenciais e virtuais, utilizar QR Codes para validar determinadas atividades, acumular XP, desbloquear conquistas e acompanhar sua posição no ranking.

📌 **Sobre o Projeto**

O Fatec Mission transforma atividades acadêmicas e institucionais em uma experiência inspirada em jogos.

Em vez de apenas divulgar uma atividade, a plataforma transforma a participação em uma missão:

> 🎯 **MISSÃO DESBLOQUEADA**
>
> Encontre o QR Code localizado na biblioteca e responda a pergunta corretamente
>
> **+100 XP**
>
> 🏆 Nova conquista disponível!

O sistema possui uma área destinada aos usuários e uma área administrativa para gerenciamento das missões e acompanhamento dos indicadores de participação.

**Principais Objetivos:**

* Criar um sistema de cadastro e autenticação de usuários;
* Permitir que os usuários visualizem e realizem missões;
* Utilizar QR Codes para validar determinadas missões presenciais;
* Criar um sistema de pontuação baseado em XP;
* Criar conquistas/badges;
* Disponibilizar um ranking entre usuários;
* Permitir o acompanhamento do progresso individual;
* Disponibilizar uma área administrativa para criação e gerenciamento de missões;
* Estimular a participação nas atividades da instituição;
* Proporcionar uma experiência simples e intuitiva em diferentes dispositivos.

O projeto foi desenvolvido com foco em uma experiência responsiva, gamificada e de fácil utilização.

**Front-End:** React + React Router 

**Back-End:** Node.js + Express

**Banco de Dados:** MySQL

**Arquitetura:** Cliente-Servidor em três camadas

**API:** REST privada

**Versionamento:** Git + GitHub

**Design/Prototipagem:** Figma

---

# Funcionalidades

### Requisitos Funcionais (RF)

**RF01:** Cadastro de estudantes com nome, e-mail, senha, curso e semestre

**RF02:** Login e logout de estudantes e administradores

**RF03:** Validação dos dados informados no cadastro e impedimento de e-mails duplicados

**RF04:** Visualização e filtragem das missões disponíveis

**RF05:** Visualização dos detalhes das missões, incluindo descrição, dificuldade e XP

**RF06:** Início e conclusão de missões.

**RF07:** Atualização automática do XP e do nível após a conclusão de missões.

**RF08:** Validação de missões presenciais por meio de QR Code quando necessário

**RF09:** Exibição do ranking de estudantes organizado por XP.

**RF10:** Criação, edição e desativação de missões pelo administrador.

**RF11:** Visualização de informações e indicadores sobre missões e participação dos estudantes.

---

### Requisitos Não Funcionais (RNF)

**RNF01:** Interface responsiva para diferentes tamanhos de tela.

**RNF02:** Interface simples, intuitiva e adequada ao público estudantil.

**RNF03:** Autenticação e controle de acesso para proteger funcionalidades restritas.

**RNF04:** Senhas armazenadas utilizando hash seguro.

**RNF05:** Comunicação entre aplicação e back-end realizada por meio de API REST.

**RNF06:** Rotas administrativas protegidas contra acesso não autorizado.

**RNF07:** Mensagens claras de erro e confirmação.

**RNF08:** Resposta adequada às principais ações do sistema, especialmente durante a demonstração.

---

# Sistema de Gamificação

A experiência do Fatec Mission é baseada em elementos comuns de jogos para incentivar a participação dos estudantes.

### XP

Cada missão possui uma quantidade de XP definida. Ao concluir uma missão, o estudante recebe os pontos correspondentes.

### Conquistas

Os estudantes podem desbloquear badges ao cumprir determinados objetivos.

Exemplos:

🏆 **Primeiro Passo**

> Complete sua primeira missão

📌 **Marquei presença**

> Complete 10 missões

⚡ **Ligeirinho**

> Complete 3 missões em 15 minutos

🔍 **Onde está o Wally?**

> Conclua a missão especial

### Ranking

O ranking apresenta os estudantes classificados de acordo com a quantidade de XP acumulada, apresentando também a posição atual do prório usuário

Exemplo:

> 🥇 Maria — 1.240 XP
> 
> 🥈 Thiago — 1.180 XP
> 
> 🥉 Giovana — 970 XP

---

# Fluxo da Aplicação

O funcionamento do Fatec Mission é baseado na progressão do estudante por meio de missões, XP e conquistas.

**Fluxo principal do estudante:**

Cadastro → Login → Home → Missões → Detalhes da Missão → Realização da Missão → Validação → XP → Conquista → Ranking

**Fluxo de uma missão presencial:**

Missão → Iniciar → Acessar local indicado → Escanear QR Code → Validar → Concluir missão → Receber XP → Atualizar progresso

**Fluxo administrativo:**

Login Administrativo → Dashboard → Gerenciamento de Missões → Criar/Editar/Desativar Missão → Definir informações e recompensa → Disponibilizar para os estudantes

**Progressão do estudante:**

Ao concluir missões, o estudante acumula XP. O progresso é atualizado de acordo com a pontuação obtida, podendo resultar no desbloqueio de conquistas. O XP acumulado também influencia sua posição no ranking.

---

<!-- # 🏗️ Arquitetura e Estrutura

A aplicação segue uma arquitetura **cliente-servidor em três camadas**, separando a interface, as regras do sistema e o armazenamento dos dados.

**Aplicação Web (React)**
↓
**API / Back-End (Node.js + Express)**
↓
**Banco de Dados (MySQL)**

A aplicação não acessa diretamente o banco de dados. As operações são realizadas por meio da API REST.

Essa estrutura facilita a manutenção, segurança e futura expansão do projeto.

### Estrutura prevista de pastas

```text
/fatec-mission

├── frontend/
│   ├── componentes/
│   ├── paginas/
│   ├── servicos/
│   └── rotas/
│
├── backend/
│   ├── rotas/
│   ├── controllers/
│   ├── models/
│   └── middlewares/
│
├── database/
│   ├── scripts/
│   └── seeds/
│
├── docs/
│   ├── prototipos/
│   └── documentacao/
│
└── README.md
```

---

# 🔌 API

A comunicação entre o aplicativo e o back-end será realizada por uma **API REST privada**.

Principais operações previstas:

```text
POST /login
POST /usuarios
GET /missoes
POST /missoes/:id/concluir
GET /ranking
GET /conquistas
GET /perfil
POST /admin/missoes
```

A API será responsável por controlar as principais regras do sistema, incluindo usuários, autenticação, missões, XP, níveis, conquistas, ranking e funcionalidades administrativas.

---

# 🗄️ Banco de Dados

O Fatec Mission utiliza **MySQL** para armazenamento persistente dos dados.

### USUÁRIO

```text
+ id
+ nome
+ email
+ senha_hash
+ curso
+ semestre
+ xp
+ nivel
+ data_cadastro
```

### MISSÃO

```text
+ id
+ titulo
+ descricao
+ categoria
+ dificuldade
+ xp
+ local
+ tipo
+ status
+ qr_code
```

### CONCLUSÃO

```text
+ id
+ usuario_id
+ missao_id
+ data_conclusao
+ xp_recebido
```

### CONQUISTA

```text
+ id
+ nome
+ descricao
+ requisito
+ icone
```

### USUÁRIO_CONQUISTA

```text
+ id
+ usuario_id
+ conquista_id
+ data_desbloqueio
```

Essa estrutura atende às necessidades previstas para o MVP e poderá ser expandida futuramente. 

--- -->

# Autenticação e Segurança

O sistema contará com mecanismos para proteger as informações dos usuários e as funcionalidades administrativas.

Entre eles:

* Autenticação de usuários;
* Controle de acesso para administradores;
* Senhas armazenadas utilizando hash seguro;
* Validação dos dados recebidos pela API;
* Proteção das rotas administrativas;
* Controle de permissões;
* Proteção de informações sensíveis.

---

# Testes e Qualidade

Serão realizados testes para verificar o funcionamento das principais funcionalidades do sistema.

Entre eles:

* Cadastro de usuários;
* Login e logout;
* Validação dos campos;
* E-mails duplicados;
* Criação de missões;
* Edição e desativação de missões;
* Conclusão de missões;
* Validação de QR Codes;
* Cálculo de XP;
* Desbloqueio de conquistas;
* Atualização do ranking;
* Permissões administrativas;
* Responsividade da aplicação.

Também serão realizados testes funcionais e, quando aplicável, TDD para regras de negócio importantes.

---

<!-- # 🎨 UX/UI

A interface do Fatec Mission possui uma proposta **jovem, intuitiva e inspirada em jogos**, sem comprometer a clareza das informações.

Elementos visuais previstos:

* 🎯 Cards de missões;
* 📊 Barras de progresso;
* ⭐ XP;
* 🏆 Badges;
* 🎖️ Indicadores de nível;
* ✨ Animações simples de recompensa;
* 📱 Interface responsiva.

A navegação principal será organizada de maneira simples para facilitar o acesso às principais funcionalidades:

**🏠 Início | 🎯 Missões | 🏆 Conquistas | 🏅 Ranking | 👤 Perfil**

--- -->

# Funcionalidades Futuras

Após a conclusão do MVP, poderão ser adicionadas novas funcionalidades, como:

* Missões em grupo;
* Sistema de equipes;
* Sistema de indicação;
* Notificações;
* Mapa interativo da Fatec;
* Eventos integrados;
* Personalização de avatar;
* Ranking entre diferentes Fatecs.

Essas funcionalidades não fazem parte do escopo obrigatório inicial.

---

# Resultado Esperado

O Fatec Mission busca proporcionar uma experiência acadêmica mais interativa, incentivando os estudantes a:

* Conhecer melhor a instituição;
* Explorar seus espaços;
* Participar de eventos;
* Realizar atividades acadêmicas;
* Interagir com outros estudantes;
* Acompanhar sua própria evolução;
* Participar de uma competição saudável.

Para a instituição, a plataforma também poderá fornecer informações sobre a participação dos estudantes e o desempenho das diferentes missões.

---

# Equipe do Projeto

**Maria Carolina Ribeiro de Oliveira:** Líder de Projeto — Organização, planejamento, backlog e acompanhamento do projeto.

**Beatriz Kimberlin do Carmo Barssoti:** Missões e QA — Definição do MVP, critérios de aceite, gerenciamento de missões e testes.

**Luana Camila Ribeiro Silva:** Front-End — Desenvolvimento das interfaces, fluxos de missões, conquistas, ranking e responsividade.

**Eliete Santos da Silva:** Back-End — Arquitetura, API REST, integração das funcionalidades e painel administrativo.

**Francianny Leite da Silva:** Banco de Dados e Documentação — Modelagem do banco, autenticação, permissões e documentação.

---

# Projeto Acadêmico

**Fatec Mission — Plataforma de Gamificação da Experiência Acadêmica**

Projeto desenvolvido no curso de **Desenvolvimento de Software Multiplataforma (DSM)** da **Fatec Osasco**, durante o **2º semestre de 2026**.

Desenvolvido para a proposta da **Fatec Expo Week**.
