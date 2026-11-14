# Como colocar o Achei na internet

O Achei usa **SQLite** (um arquivo de banco). Por isso a hospedagem precisa de
um **disco persistente**. Vercel e Netlify NAO servem: la o disco e apagado a
cada deploy e os cadastros somem.

Todas as opcoes abaixo usam o `Dockerfile` deste projeto. O banco fica em
`/data/achei.sqlite` e e criado/atualizado sozinho ao iniciar.

## Passo 0 — subir o codigo para o GitHub
1. Crie uma conta em github.com e um repositorio privado "achei".
2. Na pasta do projeto: `git init`, `git add .`, `git commit -m "achei"`,
   depois siga as instrucoes do GitHub para `git push`.

## Opcao A — Render (mais facil, ~US$ 7/mes)
1. render.com > New > **Blueprint** > escolha o repositorio (usa `render.yaml`).
2. Aguarde o build. O site abre em `https://achei.onrender.com`.
3. Opcional: em Settings > Custom Domains, ligue seu dominio.

## Opcao B — Fly.io (barato, servidor em Sao Paulo)
1. Instale o `flyctl` e rode `fly auth login`.
2. Na pasta do projeto:
   ```
   fly launch --no-deploy --copy-config
   fly volumes create achei_data --region gru --size 1
   fly deploy
   ```

## Opcao C — Railway
1. railway.app > New Project > Deploy from GitHub.
2. Em Settings > **Volumes**, crie um volume montado em `/data`.
3. Em Variables, adicione `DATABASE_PATH=/data/achei.sqlite`.

## Variaveis opcionais
- `DEMO_MERCHANT_EMAIL` e `DEMO_MERCHANT_PASSWORD` (12+ caracteres): cria a
  conta de lojista de demonstracao. Sem elas, nenhuma senha padrao e criada.

## Importante
- Nao ha cobranca de HTTPS: todas as opcoes ja entregam HTTPS (os cookies de
  login exigem isso em producao).
- Faca backup do arquivo `/data/achei.sqlite` de vez em quando.
- Sem disco persistente, os cadastros de usuarios sao perdidos a cada deploy.

## Netlify (prévia / demonstração)

O projeto também inclui `netlify.toml` com o adaptador Next.js para facilitar a
implantação de uma prévia no Netlify:

1. Envie o projeto para um repositório Git no GitHub.
2. No Netlify, escolha **Add new site > Import an existing project** e conecte
   o repositório.
3. O Netlify lerá `netlify.toml`; mantenha Node.js 22 e execute o deploy.

**Atenção: esta configuração não torna o banco de dados adequado para produção.**
O app usa `better-sqlite3` e SQLite em arquivo. O filesystem das Functions do
Netlify não é um disco persistente compartilhado: dados gravados em runtime
podem desaparecer e diferentes instâncias podem enxergar bancos diferentes.
Login, cadastros, favoritos, produtos e promoções não devem ser considerados
persistentes/seguros em uma publicação Netlify com a configuração atual.

Antes de abrir ao público ou cadastrar dados reais, migre o adaptador de banco
para um serviço SQL hospedado (por exemplo, PostgreSQL gerenciado ou Turso/libSQL)
e configure as variáveis/credenciais desse serviço no Netlify. Não coloque
segredos no repositório. Se a prioridade for manter SQLite sem reescrever a
camada de dados, use Render, Fly.io ou Railway com volume persistente, conforme
as opções acima.
