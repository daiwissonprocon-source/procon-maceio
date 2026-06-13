# PROCON Maceió — Sistema de Gestão de Processos Administrativos

Sistema web para cadastro, acompanhamento e julgamento de processos administrativos do PROCON Maceió.

## Funcionalidades

- **Login com perfis:** Admin e Analista (acessos diferenciados)
- **Dashboard:** métricas em tempo real, alertas de atrasos, desempenho por analista
- **Processos:** cadastro, edição, exclusão, busca e filtros
- **Analistas:** cadastro, edição de senha, ativação/desativação
- **Atribuição:** automática (por antiguidade) ou manual (seleção na tabela)
- **Minha Fila (Analista):** julgamento com registro de Multa (valor) ou Arquivamento (motivação)
- **Importação:** Excel (.xlsx/.xls) ou CSV sem sobrescrever processos existentes
- **Relatórios:** filtros por período, analista, fornecedor e situação — exportação HTML ou impressão/PDF

## Credenciais padrão

| Perfil   | Login      | Senha      |
|----------|------------|------------|
| Admin    | admin      | procon2024 |
| Analista | analista1  | ana123     |
| Analista | analista2  | ana456     |

> ⚠️ **Altere as senhas no primeiro acesso** via menu Analistas (admin) ou contate o administrador.

## Como publicar no GitHub + Netlify

### 1. Criar repositório no GitHub

```bash
cd procon-maceio
git init
git add .
git commit -m "feat: sistema PROCON Maceió v1"
```

Crie um repositório em https://github.com/new (ex: `procon-maceio`) e siga as instruções para fazer push:

```bash
git remote add origin https://github.com/SEU_USUARIO/procon-maceio.git
git branch -M main
git push -u origin main
```

### 2. Conectar ao Netlify

1. Acesse https://app.netlify.com e faça login
2. Clique em **"Add new site" → "Import an existing project"**
3. Selecione **GitHub** e autorize o acesso
4. Escolha o repositório `procon-maceio`
5. Configurações de build (deixar em branco, pois é site estático):
   - Build command: *(vazio)*
   - Publish directory: `.` (ponto)
6. Clique em **"Deploy site"**

Após alguns segundos o site estará no ar com URL tipo `https://procon-maceio.netlify.app`.

### 3. Domínio personalizado (opcional)

No painel do Netlify: **Domain settings → Add custom domain**.

## Armazenamento de dados

Os dados são salvos no `localStorage` do navegador de cada usuário. Para uso em produção com múltiplos usuários compartilhando dados, é necessário um backend (Supabase, Firebase, etc.). Entre em contato se quiser essa evolução.

## Estrutura do projeto

```
procon-maceio/
├── index.html      # Aplicação completa (HTML + CSS + JS)
├── netlify.toml    # Configuração de rotas para o Netlify
└── README.md       # Este arquivo
```

## Formato de importação CSV/Excel

| numero | fornecedor | tema | dataAbertura | situacao | analista | valor | motivoArquivamento |
|--------|------------|------|-------------|----------|----------|-------|-------------------|
| 12345/2024 | Empresa XPTO | Cobrança indevida | 2024-03-15 | pendente | analista1 | | |

- `dataAbertura`: formato `AAAA-MM-DD`
- `situacao`: `pendente`, `em_julgamento`, `multa`, `arquivado`
- `analista`: login do analista cadastrado no sistema
