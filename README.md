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
6. [Requisitos](#6-requisitos)
7. [Gamificação](#7-gamificação)
8. [Fluxos da aplicação](#8-fluxos-da-aplicação)
9. [Como executar](#9-como-executar)
10. [Funcionalidades futuras](#10-funcionalidades-futuras)
11. [Equipe](#11-equipe)

---

## 1. Visão geral

O sistema é formado por três aplicações que se comunicam por uma **API REST privada**:

| Aplicação | Pasta | Descrição |
|---|---|---|
| **App do estudante** | [`fatec-mission-web`](./fatec-mission-web) | Front-end *mobile-first*: missões, leitor de QR Code, quizzes, conquistas, ranking e perfil |
| **Painel administrativo** | [`fatec-mission-admin`](./fatec-mission-admin) | Aplicação desktop com dashboard de indicadores e gestão de missões e quizzes |
| **API** | [`fatec-mission-api`](./fatec-mission-api) | Regras de negócio, autenticação, banco de dados e documentação Swagger |

Cada pasta possui um README próprio com os detalhes técnicos (rotas, telas, banco de dados, testes e variáveis de ambiente).

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

```text
fatec-mission/
├── fatec-mission-api/      # Back-end (routes, controllers, services, models, middlewares)
├── fatec-mission-web/      # App do estudante
├── fatec-mission-admin/    # Painel administrativo
└── iniciar-fatec-mission.bat   # Inicia os 3 projetos (Windows)
```

---

## 6. Requisitos

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

## 7. Gamificação

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
| Primeiro Passo | Concluir a primeira missão |
| Primeiro tombo | Erre sua primeira missão |
| Dei uma olhada | Encontre seu primeiro QR Code |
| Confiei no meu potencial | Erre 3 missões |
| Ligeirinho | Complete 3 missões em 5 minutos |
| Sem parar | Encontre 5 QR Codes |
| Sem errar | Complete 8 missões sem nenhum erro |
| Marquei presença | Complete 10 missões |
| No ritmo | Complete 25 missões |
| Onde está o Wally? | Conclua a missão especial |

### Ranking

Classifica os estudantes pelo XP acumulado, com filtro por curso e destaque da posição do próprio usuário. Empates dividem a posição.

---

## 8. Fluxos da aplicação

**Estudante:**
`Cadastro → Login → Início → Missões → Detalhes → Realização → Validação → XP → Conquista → Ranking`

**Missão presencial:**
`Missão → Ir ao local → Escanear QR Code → Validação → XP atualizado → Conquistas verificadas`

**Administrador:**
`Login administrativo → Dashboard → Gerenciar missões → Criar/Editar/Desativar → Disponibilizar aos estudantes`

---

## 9. Como executar

**Pré-requisitos:** Node.js 18+ e MySQL 8.0+ em execução.

**Início rápido (Windows):** execute `iniciar-fatec-mission.bat`, que instala as dependências e inicia os três projetos.

**Execução manual:**

```bash
# 1. API (crie antes o arquivo .env — variáveis descritas no README da API)
cd fatec-mission-api
npm install
npm run db:seed      # cria o banco, as tabelas e dados de exemplo
npm run dev          # http://localhost:3000  (documentação em /api-docs)

# 2. App do estudante
cd fatec-mission-web
npm install
npm run dev          # http://localhost:5173

# 3. Painel administrativo
cd fatec-mission-admin
npm install
npm run dev          # http://localhost:5175
```

**Modo demonstração (sem back-end):** `npm run dev:mock` na pasta `fatec-mission-web`.

**Testes da API:** `npm test` na pasta `fatec-mission-api`.

**Acesso de exemplo (apenas desenvolvimento):** administrador `admin@fatec.sp.gov.br` / `Admin@123`.

---

## 10. Funcionalidades futuras

Fora do escopo obrigatório inicial:

- Missões em grupo e sistema de equipes;
- Sistema de indicação e notificações;
- Mapa interativo da Fatec e integração com eventos;
- Personalização de avatar;
- Conquistas especiais;
- Ranking entre diferentes Fatecs.

---

## 11. Equipe

| Integrante | Função | Responsabilidades |
|---|---|---|
| **Maria Carolina Ribeiro de Oliveira** | Líder de Projeto | Organização, planejamento, *backlog* e acompanhamento |
| **Beatriz Kimberlin do Carmo Barssoti** | Missões e QA | Definição do MVP, critérios de aceite, gerenciamento de missões e testes |
| **Luana Camila Ribeiro Silva** | Front-End | Interfaces, fluxos de missões, conquistas, ranking e responsividade |
| **Eliete Santos da Silva** | Back-End | Arquitetura, API REST, integração e painel administrativo |
| **Francianny Leite da Silva** | Banco de Dados e Documentação | Modelagem do banco, autenticação, permissões e documentação |

---

**Projeto acadêmico** desenvolvido no curso de **Desenvolvimento de Software Multiplataforma (DSM)** da **Fatec Osasco**, no **4º semestre de 2026**, para a proposta da **Fatec Expo Week**.
