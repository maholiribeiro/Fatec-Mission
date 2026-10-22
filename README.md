# Fatec Mission — Plataforma de Gamificação

O **Fatec Mission** é uma plataforma de gamificação que tem como objetivo transformar a Fatec em um ambiente de missões, desafios e recompensas, incentivando os estudantes a conhecerem a instituição, participarem dos eventos e interagirem com a comunidade.

Durante a **Fatec Expo Week**, os participantes realizam missões presenciais e virtuais, validam atividades por **QR Code**, respondem a **quizzes**, acumulam **XP**, desbloqueiam **conquistas** e acompanham sua posição no **ranking**.

> **MISSÃO DESBLOQUEADA**
>
> Encontre o QR Code localizado na biblioteca e leia-o com o aplicativo.
>
> **+75 XP** · Nova conquista disponível!

---

## Sumário

1. [Visão geral](#1-visão-geral)
2. [Objetivos](#2-objetivos)
3. [Metodologia](#3-metodologia)
4. [Tecnologias](#4-tecnologias)
5. [Arquitetura e estrutura](#5-arquitetura-e-estrutura)
6. [Banco de dados](#6-banco-de-dados)
7. [Requisitos](#7-requisitos)
8. [Gamificação](#8-gamificação)
9. [Fluxos da aplicação](#9-fluxos-da-aplicação)
10. [Como executar](#10-como-executar)
11. [Funcionalidades futuras](#11-funcionalidades-futuras)
12. [Equipe](#12-equipe)

---

## 1. Visão geral

O Fatec Mission é formado por **três aplicações**, cada uma em seu próprio repositório, que se comunicam por uma **API REST privada**. Este é o **repositório principal**, que reúne a documentação e as explicações gerais do projeto.

| Aplicação | Repositório | Descrição |
|---|---|---|
| **App do estudante** | [`fatec-mission-web`](https://github.com/maholiribeiro/fatec-mission-web) | Front-end *mobile-first*: missões, leitor de QR Code, quizzes, conquistas, ranking e perfil |
| **Painel administrativo** | [`fatec-mission-admin`](https://github.com/maholiribeiro/fatec-mission-admin) | Aplicação desktop com dashboard de indicadores e gestão de missões e quizzes |
| **API** | [`fatec-mission-api`](https://github.com/maholiribeiro/fatec-mission-api) | Regras de negócio, autenticação, banco de dados e documentação Swagger |

Cada repositório possui um README próprio com os detalhes técnicos (rotas, telas, banco de dados, testes e variáveis de ambiente).

---

## 2. Objetivos

**Objetivo geral:** desenvolver uma plataforma web responsiva que use elementos de gamificação para estimular a participação dos estudantes nas atividades da Fatec.

**Objetivos específicos:**

- Implementar cadastro e autenticação de estudantes e administradores;
- Permitir que os estudantes visualizem, filtrem e realizem missões;
- Validar missões presenciais por QR Code e oferecer missões do tipo quiz;
- Implementar pontuação por XP e conquistas desbloqueadas automaticamente;
- Disponibilizar ranking entre estudantes e acompanhamento do progresso individual;
- Oferecer área administrativa para gerenciar missões e acompanhar indicadores de participação.

---

## 3. Metodologia

O projeto foi conduzido com **metodologia ágil**, adotando o framework **Scrum**. O planejamento, o *backlog* e o acompanhamento das tarefas foram organizados no **Trello**. O código foi versionado com **Git/GitHub** e as interfaces foram prototipadas no **Figma**.

---

## 4. Tecnologias

| Camada | Tecnologias |
|---|---|
| **App do estudante** | React 19, Vite, React Router, jsQR |
| **Painel administrativo** | React 19, Vite, React Router, Mantine 8, Recharts |
| **Back-end** | Node.js (≥ 18), Express, JWT, bcrypt, Joi, Swagger |
| **Banco de dados** | MySQL 8.0+ |
| **Testes** | Jest e Supertest |
| **Ferramentas** | Git, GitHub, Figma e Trello |

---

## 5. Arquitetura e estrutura

Arquitetura **cliente-servidor em três camadas**. Os clientes nunca acessam o banco diretamente: todas as operações passam pela API REST.

```
App do estudante (React)  ┐
                          ├──► API REST (Node.js + Express) ──► MySQL
Painel admin (React)      ┘
```

**Organização dos repositórios.** Cada aplicação tem seu repositório. Para executar o projeto completo com o script `.bat`, os três devem ser clonados **dentro da pasta do repositório principal**, com os nomes abaixo:

```text
fatec-mission/                  # Repositório principal (documentação)
├── iniciar-fatec-mission.bat   # Script que inicia os 3 projetos (Windows)
├── README.md
├── fatec-mission-api/          # Repositório da API (back-end)
├── fatec-mission-web/          # Repositório do app do estudante
└── fatec-mission-admin/        # Repositório do painel administrativo
```

---

## 6. Banco de dados

O Fatec Mission utiliza **MySQL** (charset `utf8mb4`, mecanismo InnoDB). O banco e as tabelas são criados automaticamente pela API, sem necessidade de executar SQL manualmente.

| Tabela | Principais campos | Descrição |
|---|---|---|
| `usuario` | `usuario_id`, `nome`, `email` (único), `senha_hash`, `curso`, `semestre`, `xp`, `role` | Estudantes e administradores. O `role` pode ser `estudante` ou `administrador` |
| `missao` | `missao_id`, `titulo`, `descricao`, `dificuldade`, `tipo`, `xp`, `status`, `qr_code` (único) | Missões disponíveis. A dificuldade define o XP |
| `historico` | `historico_id`, `usuario_id`, `missao_id`, `resultado`, `xp_variacao` | Registra cada tentativa (`sucesso` ou `erro`) e a variação de XP |
| `conquista` | `conquista_id`, `nome`, `descricao`, `icone`, `requisito` | Conquistas e o requisito para desbloqueá-las |
| `usuario_conquista` | `usuario_id`, `conquista_id`, `data_desbloqueio` | Conquistas desbloqueadas por cada usuário |
| `pergunta` | `pergunta_id`, `missao_id`, `enunciado`, `ordem` | Perguntas das missões do tipo quiz |
| `alternativa` | `alternativa_id`, `pergunta_id`, `texto`, `correta`, `ordem` | Alternativas de cada pergunta (somente uma correta) |

**Relacionamentos:**

```text
usuario ──< historico >── missao ──< pergunta ──< alternativa
   │
   └──< usuario_conquista >── conquista
```

**Observações:**

- O XP do usuário é a soma das variações registradas em `historico`, o que torna o saldo auditável.
- O ranking não é armazenado: é calculado por consulta, ordenando os usuários pelo XP.
- Uma missão com histórico de tentativas não pode ser excluída, apenas desativada.
- O banco garante uma única alternativa correta por pergunta.
- Detalhes completos do esquema estão no README da API.

---

## 7. Requisitos

### Requisitos funcionais (RF)

| Código | Descrição |
|---|---|
| **RF01** | Cadastro de estudantes com nome, e-mail, senha, curso e semestre |
| **RF02** | Login e logout de estudantes e administradores |
| **RF03** | Validação dos dados de cadastro e bloqueio de e-mails duplicados |
| **RF04** | Visualização e filtragem das missões disponíveis |
| **RF05** | Detalhes da missão, incluindo descrição, dificuldade e XP |
| **RF06** | Realização e conclusão de missões (por QR Code, quiz ou confirmação) |
| **RF07** | Atualização automática do XP após a conclusão de missões |
| **RF08** | Validação de missões presenciais por QR Code |
| **RF09** | Ranking de estudantes organizado por XP |
| **RF10** | Criação, edição e desativação de missões pelo administrador |
| **RF11** | Indicadores sobre missões e participação dos estudantes |

### Requisitos não funcionais (RNF)

| Código | Descrição |
|---|---|
| **RNF01** | Interface responsiva |
| **RNF02** | Interface simples, intuitiva e adequada ao público estudantil |
| **RNF03** | Autenticação (JWT) e controle de acesso por perfil |
| **RNF04** | Senhas armazenadas com hash seguro (bcrypt) |
| **RNF05** | Comunicação entre aplicações e back-end por API REST |
| **RNF06** | Rotas administrativas protegidas contra acesso não autorizado |
| **RNF07** | Mensagens claras de erro e confirmação |
| **RNF08** | Boa resposta nas principais ações, especialmente na demonstração (inclui modo demo sem back-end) |

### Decisões de escopo

- **Sem níveis:** a progressão é medida apenas pelo XP acumulado, que também define a posição no ranking.
- **XP definido pela dificuldade** da missão, e não livremente pelo administrador.
- **Penalidade de XP** em tentativas incorretas.
- **Quizzes** incluídos como tipo de missão, além das missões por QR Code.

---

## 8. Gamificação

### XP e penalidades

| Dificuldade | XP no sucesso | Penalidade no erro |
|---|---|---|
| Fácil | +75 | −15 |
| Médio | +100 | −25 |
| Difícil | +150 | −75 |

Cada missão pode ser concluída com sucesso **uma única vez** por estudante. Em quizzes, o XP é **proporcional ao número de acertos**.

### Conquistas

Desbloqueadas automaticamente ao atingir o requisito:

| Conquista | Requisito |
|---|---|
| Primeiros Passos | Concluir a primeira missão |
| Explorador | Concluir 5 missões |
| Veterano do Campus | Concluir 10 missões |
| Colecionador de XP | Acumular 500 de XP |
| Mestre do XP | Acumular 1000 de XP |
| Destemido | Concluir uma missão difícil |
| Caçador de Desafios | Concluir 3 missões difíceis |
| Pé na Estrada | Concluir 2 missões do Tipo 1 |

### Ranking

Classifica os estudantes pelo XP acumulado, com filtro por curso e destaque da posição do próprio usuário. Empates dividem a posição.

---

## 9. Fluxos da aplicação

**Estudante:**
`Cadastro → Login → Início → Missões → Detalhes → Realização → Validação → XP → Conquista → Ranking`

**Missão presencial:**
`Missão → Ir ao local → Escanear QR Code → Validação → XP atualizado → Conquistas verificadas`

**Administrador:**
`Login administrativo → Dashboard → Gerenciar missões → Criar/Editar/Desativar → Disponibilizar aos estudantes`

---

## 10. Como executar

**Pré-requisitos:** [Git](https://git-scm.com), [Node.js](https://nodejs.org) 18+ e MySQL 8.0+ instalado e **em execução**.

### 10.1 Clonar os repositórios

```bash
# 1. Repositório principal (documentação e script .bat)
git clone https://github.com/maholiribeiro/Fatec-Mission fatec-mission
cd fatec-mission

# 2. Dentro da pasta criada, clone os três projetos (mantenha estes nomes de pasta)
git clone https://github.com/maholiribeiro/fatec-mission-api fatec-mission-api
git clone https://github.com/maholiribeiro/fatec-mission-web fatec-mission-web
git clone https://github.com/maholiribeiro/fatec-mission-admin fatec-mission-admin
```

> O nome da pasta no final de cada comando é importante: o script `.bat` procura exatamente por `fatec-mission-api`, `fatec-mission-web` e `fatec-mission-admin`.

### 10.2 Configurar a API

Na pasta `fatec-mission-api`, crie o arquivo `.env` a partir do modelo `.env.example` e preencha, no mínimo, `DB_PASSWORD` (senha do MySQL) e `JWT_SECRET` (valor longo e aleatório). As demais variáveis estão descritas no README da API.

```bash
cd fatec-mission-api
copy .env.example .env      # Windows (no Linux/macOS: cp .env.example .env)
```

Na primeira execução, defina `DB_AUTO_SEED=true` no `.env` (ou rode `npm run db:seed`) para criar o administrador e as missões de exemplo.

> O arquivo `.env` contém credenciais e **não deve ser versionado**. Se você usar o script `.bat`, ele cria o `.env` automaticamente (veja a seção 10.4).

### 10.3 Executar

**Opção A — Script `.bat` (Windows):** execute `iniciar-fatec-mission.bat` com um duplo clique. Ele prepara e inicia os três projetos ([detalhes abaixo](#104-script-iniciar-fatec-missionbat)).

**Opção B — Execução manual** (qualquer sistema), cada projeto em um terminal:

```bash
# API
cd fatec-mission-api
npm install
npm run db:seed      # cria o banco, as tabelas e dados de exemplo
npm run dev          # http://localhost:3000  (documentação em /api-docs)

# App do estudante
cd fatec-mission-web
npm install
npm run dev          # http://localhost:5173

# Painel administrativo
cd fatec-mission-admin
npm install
npm run dev          # http://localhost:5175
```

**Modo demonstração (sem back-end):** `npm run dev:mock` na pasta `fatec-mission-web`.

**Testes da API:** `npm test` na pasta `fatec-mission-api`.

**Acesso de exemplo (apenas desenvolvimento):** administrador `admin@fatec.sp.gov.br` / `Admin@123`.

### 10.4 Script `iniciar-fatec-mission.bat`

Script para **Windows** que prepara e inicia as três aplicações com um duplo clique, cada uma em sua própria janela. Ele deve ficar na pasta que contém os três projetos (`fatec-mission-api`, `fatec-mission-web` e `fatec-mission-admin`), como mostrado na seção 5.

**O que o script faz, em ordem:**

1. **Verifica os pré-requisitos:** se o Node.js está instalado e se as três pastas existem (com `package.json`). Caso contrário, exibe o erro e encerra.
2. **Configura a API:** se não existir o arquivo `.env`, cria um a partir do `.env.example` e o abre no Bloco de Notas para você preencher `DB_PASSWORD` e `JWT_SECRET`.
3. **Instala as dependências:** em cada projeto, executa `npm install` quando a pasta `node_modules` não existe ou está incompleta. Se já estiver tudo instalado, apenas segue.
4. **Pergunta o modo do app do estudante:** `[1]` Normal (HTTP) ou `[2]` HTTPS, necessário para usar a câmera do celular na rede local. Sem resposta em 30 segundos, usa o modo normal.
5. **Inicia os projetos**, cada um em uma janela, pulando os que já estiverem rodando:

   | Projeto | Endereço | Observação |
   |---|---|---|
   | API | http://localhost:3000 | Documentação Swagger em `/api-docs`. O script aguarda até 60 s a API ficar pronta |
   | App do estudante | http://localhost:5173 (ou `https://` no modo 2) | No celular, use o endereço *Network* exibido na janela do app |
   | Painel administrativo | http://localhost:5175 | |

6. **Abre o navegador** no painel administrativo e no app do estudante e exibe um resumo com os endereços.

**Antes de executar:**

- O **MySQL precisa estar ligado**. A API cria o banco e as tabelas ao iniciar; para criar também o administrador e os dados de exemplo, use `DB_AUTO_SEED=true` no `.env`.
- Para **encerrar**, feche a janela de cada projeto (ou pressione `Ctrl + C` nela).
- O script é exclusivo do **Windows**. Em Linux ou macOS, use a execução manual (Opção B).

**Problemas comuns:**

| Mensagem | Causa provável | Como resolver |
|---|---|---|
| `Node.js não encontrado` | Node.js não instalado ou fora do PATH | Instale em [nodejs.org](https://nodejs.org) e abra o script novamente |
| `Projeto não encontrado` | O `.bat` não está na pasta dos três projetos, ou as pastas têm outros nomes | Reclone com os nomes exatos da seção 10.1 |
| `A API não respondeu em 60s` | MySQL desligado ou credenciais incorretas no `.env` | Ligue o MySQL, confira `DB_USER` e `DB_PASSWORD` e veja a janela da API |
| `Falha ao instalar as dependências` | Sem conexão com a internet ou erro do npm | Verifique a conexão, leia a mensagem do npm e execute novamente |

---

## 11. Funcionalidades futuras

Fora do escopo obrigatório inicial:

- Missões em grupo e sistema de equipes;
- Sistema de indicação e notificações;
- Mapa interativo da Fatec e integração com eventos;
- Personalização de avatar;
- Conquistas especiais;
- Ranking entre diferentes Fatecs.

---

## 12. Equipe

| Integrante | Função | Responsabilidades |
|---|---|---|
| **Maria Carolina Ribeiro de Oliveira** | Líder de Projeto | Organização, planejamento, *backlog* e acompanhamento |
| **Beatriz Kimberlin do Carmo Barssoti** | Missões e QA | Definição do MVP, critérios de aceite, gerenciamento de missões e testes |
| **Luana Camila Ribeiro Silva** | Front-End | Interfaces, fluxos de missões, conquistas, ranking e responsividade |
| **Eliete Santos da Silva** | Back-End | Arquitetura, API REST, integração e painel administrativo |
| **Francianny Leite da Silva** | Banco de Dados e Documentação | Modelagem do banco, autenticação, permissões e documentação |

---

## Agradecimentos

Agradecemos a todos que fizeram parte do desenvolvimento do Fatec Mission.

E um agradecimento especial ao **Thiago Martins** pela contribuição nos bastidores.

---

**Projeto acadêmico** desenvolvido no curso de **Desenvolvimento de Software Multiplataforma (DSM)** da **Fatec Osasco** no **4º semestre**, para a proposta da **Fatec Expo Week 2026.2**.
