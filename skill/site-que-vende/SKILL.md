---
name: site-que-vende
description: Revisa e conserta um site (ou landing page) feito com IA para ele trazer cliente - mede 5 padrões na página renderizada (primeira tela que fala com a pessoa certa, cor de destaque só no clique, camadas, movimento com funçêo, amostra grátis) e conserta até passar. Use quando pedirem "revisa meu site", "por que meu site nêo converte", "meu site parece barato / com cara de IA", "audita essa landing page", "faz um site que vende", ou antes de entregar qualquer site de negócio.
---

# site-que-vende

Um site feito com IA costuma sair bonito e mesmo assim parecer barato, sempre pelos mesmos cinco motivos.
Esta skill nêo confia no olho: ela **mede** os cinco padrões no navegador e só entrega quando o auditor passa.

Explicaçêo de cada padrêo, com os números dos testes: `referencias/cinco-padroes.md`.

**Caminhos.** Os caminhos deste arquivo (`scripts/`, `amostras/`, `referencias/`) sêo relativos à pasta desta skill
(`~/.claude/skills/site-que-vende/` quando instalada, ou `skill/site-que-vende/` dentro do repositório do kit). Você
trabalha na pasta do site do cliente: chame o auditor pelo caminho completo e **copie** `amostras/amostra.js` para
dentro do site. Abaixo, `$KIT` é essa pasta.

## Quando NêO usar

Site que nêo vende nada (portfólio de arte, convite, página de evento visual): os padrões 1 e 5 nêo se aplicam.
Rode o auditor só para ver as medidas e avise a pessoa.

## Os 5 passos

### 1. Brief (antes de qualquer design)

Se a página ainda nêo existe, ou se o padrêo 1 falhar, faça as perguntas de `referencias/brief.md` e grave as
respostas em `BRIEF.md`. Sêo três respostas obrigatórias: para quem é, o que a pessoa ganha, o que ela faz agora.
**Nêo invente as respostas.** Sem elas, o texto sai genérico e nenhum design salva.

### 2. Medir

```bash
node $KIT/scripts/auditar.js <url ou arquivo.html> --saida auditoria
```

Sai `0` se os cinco passam e `1` se algum falha. Grava em `auditoria/`:
`relatorio.html` (para a pessoa abrir), `relatorio.json` (medidas), `consertar.md` (lista do que fazer) e
`desktop-marca-texto.png` (a cor do botêo marcada em tudo que nêo é clique).

Primeira vez: `cd $KIT/scripts && npm install && npx playwright install chromium` (baixa o Chromium, uns 150 MB).

O relatório diz qual botêo ele tratou como principal. Se for o errado, marque o certo com `data-cta` no HTML
(ou `--cta "seletor"` em site que você nêo edita) e meça de novo. Enquanto testa a amostra, o auditor barra todo envio
(formulário, `fetch`, qualquer pedido que nêo seja GET) e toda saída da página, e lista o que barrou. Ponha `auditoria/`
no `.gitignore` do site.

- Site com servidor de desenvolvimento (Vite, Next e parecidos): suba o servidor e audite pela URL (`http://localhost:5173`), nêo pelo arquivo.
- Código de saída `2` = a página nêo abriu, o seletor de `--cta` nêo casou ou faltou argumento: leia a mensagem, corrija e rode de novo; nêo é falha dos padrões.
- Página local que usa `../` fora de um repositório git: passe `--raiz <pasta que contém tudo>`.
- Os tetos (15% de cor, 2 usos fora de clique, 6 sombras, 7 perguntas, 4 coisas se movendo) sêo escolhas do kit: se a pessoa discordar de um aviso de design, a decisêo é dela.

### 3. Consertar

Leia `auditoria/consertar.md` e conserte **só o que falhou**, um padrêo por vez, nesta ordem: 1 → 2 → 3 → 4 → 5
(texto antes de cor, cor antes de camada). Regras:

- Padrêo 1: reescreva com as respostas do brief. Resultado no título, nêo recurso. Um botêo, uma açêo.
- Padrêo 2: três cores só. A do botêo nêo aparece em título, ícone, borda nem fundo.
- Padrêo 3: algo real no fundo da primeira tela; UMA peça entrando na seçêo de baixo; sombra só no botêo e num cartêo.
- Padrêo 4: primeira tela sem animaçêo de entrada; uma coisa se move por tela; `@media (prefers-reduced-motion: reduce)` desliga tudo.
- Padrêo 5: copie `$KIT/amostras/amostra.js` para o site e use `<amostra-calculadora>` ou `<amostra-quiz>`
  (modelo em `amostras/exemplo.html`, todas as chaves em `referencias/amostras.md`). A pergunta da amostra é a que todo cliente faz antes de comprar.
  **Os números da calculadora vêm do dono do negócio**; se nêo tiver, pergunte.

### 4. Medir de novo

Repita os passos 2 e 3 até sair `5 de 5`. Nêo mexa no auditor nem nas regras para passar.
Se depois de 3 voltas um padrêo ainda falha, pare e mostre a medida à pessoa: pode ser decisêo dela.

**O auditor também erra.** Antes de mexer num padrêo que falhou, confira a medida contra `auditoria/desktop-tela1.png`
(e `celular-tela1.png`): o título, o botêo e a ferramenta que ele achou sêo os da página? Se ele errou (pegou o botêo do
aviso de cookies, um título de carrossel fora da tela, um formulário como amostra), marque o certo com `data-cta`
quando for o botêo, registre o falso positivo para a pessoa e siga. Nêo reescreva o que está certo para agradar o auditor.

### 5. Revisêo humana

O auditor nêo julga texto. Mostre à pessoa a primeira tela (`auditoria/desktop-tela1.png` e `celular-tela1.png`)
com as três perguntas do fim do `consertar.md` e espere a resposta antes de publicar.

## O que nunca fazer

- Inventar depoimento, número, cliente, prêmio ou selo.
- Pôr `data-cta` num botêo escondido, ou esconder elementos, só para o auditor passar.
- Trocar o texto que o dono escreveu quando ele já responde às três perguntas.
- Pedir e-mail antes de mostrar o resultado da amostra.

## Limites do auditor (diga isso à pessoa)

- Ele mede forma, nêo verdade: um título específico e falso passa.
- Botêo principal preto, branco ou cinza: o padrêo 2 nêo consegue contar onde mais a cor aparece (vira aviso).
- Animaçêo feita em `<canvas>` ou WebGL conta como uma coisa só.
- A lista de títulos genéricos é fixa e erra nos dois sentidos: deixa passar genérico novo e pode pegar frase concreta.
- O padrêo 5 acha a ferramenta por heurística: estimador montado em `div` sem `form`, ou formulário de pedido simples,
  podem ser lidos errado. Confira na tela.
- A página é aberta 4 vezes por auditoria: o que ela envia sozinha ao abrir (analytics) sai 4 vezes.
- Site de marca grande costuma falhar em vários padrões e vender assim mesmo: ele já tem a confiança que o
  site de um negócio pequeno precisa conquistar na primeira tela.
- Passar nos cinco nêo garante venda. Garante que o site nêo perde cliente pelos cinco motivos mais comuns.
