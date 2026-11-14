# Achei

Guia digital do Shopping Capim Dourado — projeto em desenvolvimento.

## Requisitos

- Node.js 20.9 ou superior
- npm

## Executar localmente

```bash
npm install
npm run db:migrate
npm run db:seed
npm run dev
```

Abra <http://localhost:3000>. Para validar a compilação e os tipos:

```bash
npm test
npm run typecheck
npm run build
```

## Estado da implementação

A aplicação Next.js com App Router e navegação responsiva é a fundação do projeto.
O fluxo de conta do consumidor permite cadastro, login, logout e edição de nome/e-mail,
com senha armazenada por hash e sessão persistida no SQLite. A tela de mapa já apresenta
os dois pavimentos da planta fornecida, com 21 pontos de lojas selecionáveis e consulta
aos produtos cadastrados para cada loja. A visualização usa perspectiva CSS sobre a planta
2D; ainda não é um modelo arquitetônico 3D completo nem oferece cálculo oficial de rotas.

O banco SQLite local é armazenado em `.data/achei.sqlite` (ignorado pelo Git).
`DATABASE_PATH` pode apontar para outro caminho. Migrações ficam em
`migrations/`; `npm run db:migrate` aplica as versões pendentes e
`npm run db:seed` carrega os pontos das lojas transcritos da planta operacional
fornecida (com posições aproximadas) e registros fictícios separados, identificados pela API como
demonstração. Produtos reais não são inventados: precisam ser cadastrados pelos lojistas. As rotas públicas incluem `/api/stores`, `/api/products`, `/api/promotions`,
`/api/services` e `/api/map`, com coleções no formato `{ "items": [] }`.
Preços são armazenados em centavos inteiros e expostos como valores em reais
pelas APIs. `/promotions` exibe apenas ofertas habilitadas e vigentes; a gestão
da loja fica em `/merchant` e valida no servidor o papel e a loja associada à
sessão.

Para criar uma conta sintética de demonstração, configure `DEMO_MERCHANT_PASSWORD`
com uma senha própria de pelo menos 12 caracteres e, opcionalmente,
`DEMO_MERCHANT_EMAIL` antes de executar `npm run db:seed`. O projeto não fornece
uma senha padrão nem registra a senha em documentação ou logs. Sem essas
variáveis, o seed não cria uma conta de lojista.

SQLite é apenas a configuração local de demonstração: confirme suporte a
armazenamento persistente no ambiente de deploy e escolha um banco hospedado,
se necessário, antes da publicação.

## Persistência dos dados

O Achei utiliza SQLite em `.data/achei.sqlite` por padrão. Cadastros de consumidores e lojistas, senhas com hash, sessões, lojas, produtos e promoções ficam gravados nesse arquivo e continuam disponíveis quando o servidor é encerrado e iniciado novamente. Não apague a pasta `.data` se quiser manter os cadastros. Para backup, copie o arquivo `achei.sqlite` com o servidor parado.

## Mapa 3D inicial

O mapa foi reconstruído como uma cena isométrica interativa usando as plantas técnicas fornecidas para o térreo e o segundo pavimento. Os blocos representam lojas selecionáveis e abrem o painel com os produtos associados no banco. A cena é uma visualização inicial de navegação, não um levantamento arquitetônico executável nem um sistema oficial de rotas internas.

Alguns produtos de demonstração foram associados a Renner, Centauro e Leitura. Eles aparecem identificados como exemplos, sem preço e com disponibilidade não confirmada. Não representam catálogo ou estoque real dessas empresas. Os lojistas podem cadastrar os dados verdadeiros pelo painel.


## Identidade visual e tema
A interface usa preto e dourado como identidade principal. O botão no cabeçalho alterna entre tema escuro e claro com uma transição circular expansiva, e a preferência fica salva no navegador.

As promoções exibidas devem ser cadastradas e confirmadas pelos lojistas; não foram inventados descontos reais. O mapa atual continua sendo uma representação em desenvolvimento e suas rotas precisam de validação física.


## Campanhas demonstrativas sem preços

O inicializador prepara duas campanhas ilustrativas por loja cadastrada na planta. Elas exibem somente o percentual demonstrativo e o texto da campanha; nenhum preço promocional é apresentado nas telas públicas. As campanhas de demonstração devem ser substituídas ou confirmadas pelos lojistas antes de qualquer divulgação oficial.

O mapa utiliza um desenho vetorial próprio, sem carregar a imagem da planta como fundo. A planta técnica serve apenas como referência visual para a reconstrução. A rota atual é demonstrativa e precisa de validação presencial antes de uso operacional.

## Publicação no Netlify

Há um `netlify.toml` para o adaptador Next.js. Ele serve para facilitar uma
prévia, mas **não é uma configuração de produção para os dados**: SQLite em
arquivo não oferece persistência compartilhada no ambiente serverless do
Netlify. Para cadastros e promoções reais, migre primeiro para um banco SQL
hospedado. Consulte `HOSPEDAR.md` antes de publicar.
