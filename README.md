# site-que-vende

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="48" />
  <p><strong>Arckhé AI</strong></p>
</div>


[![site-que-vende](guia/assets/banner.jpg)](https://inematds.github.io/site-que-vende/guia/)

**ðŸ‡§ðŸ‡· [PortuguÃªs](README.md) Â· ðŸ‡ºðŸ‡¸ [English](README.en.md) Â· ðŸ‡ªðŸ‡¸ [EspaÃ±ol](README.es.md)**

## O que Ã©

O site-que-vende Ã© um kit que mede, no navegador, os cinco padrÃµes que separam o site que traz cliente do site
"bonito e barato" feito com IA, e diz o que consertar. Ele abre a sua pÃ¡gina no computador e no celular, mede
texto, cor, camadas, movimento e amostra grÃ¡tis, e devolve um relatÃ³rio com a lista de consertos pronta para colar
no seu agente de cÃ³digo. Vem com uma skill para o Claude Code, dois componentes de amostra grÃ¡tis (quiz e
calculadora) e um par de pÃ¡ginas de exemplo, uma ruim e uma boa.

[Guia completo](https://inematds.github.io/site-que-vende/guia/) Â·
[Exemplo ruim](https://inematds.github.io/site-que-vende/exemplos/ruim/) (0 de 5) Â·
[Exemplo bom](https://inematds.github.io/site-que-vende/exemplos/bom/) (5 de 5) Â·
[Amostras](https://inematds.github.io/site-que-vende/skill/site-que-vende/amostras/exemplo.html)

## Os 5 padrÃµes

| # | PadrÃ£o | Em uma frase | O auditor mede |
|---|---|---|---|
| 1 | Teste do espelho | A primeira tela diz para quem Ã©, o que a pessoa ganha e o que fazer agora | tÃ­tulo genÃ©rico, botÃ£o na 1Âª tela (computador e celular), texto do botÃ£o, botÃµes disputando |
| 2 | Regra do marca-texto | A cor de destaque sÃ³ aparece no que Ã© clique (60/30/10) | onde a cor do botÃ£o aparece fora de clique, quanto da pÃ¡gina ela ocupa |
| 3 | Frente, meio e fundo | CenÃ¡rio atrÃ¡s, conteÃºdo no meio, botÃ£o na frente | fundo da 1Âª tela, peÃ§a atravessando a borda, quantas sombras |
| 4 | Movimento com funÃ§Ã£o | Texto pronto no instante, uma coisa se move por tela, dÃ¡ para desligar | tÃ­tulo em 0,4 s, coisas se movendo por tela, "reduzir movimento" |
| 5 | Amostra grÃ¡tis | O visitante prova o resultado antes de deixar o contato | existe ferramenta, ela responde na hora, Ã© curta |

Detalhes e nÃºmeros dos testes: [`cinco-padroes.md`](skill/site-que-vende/referencias/cinco-padroes.md).

## Usar em 2 minutos

```bash
git clone https://github.com/inematds/site-que-vende && cd site-que-vende
cd skill/site-que-vende/scripts && npm install && npx playwright install chromium && cd -

node skill/site-que-vende/scripts/auditar.js https://seusite.com.br --saida auditoria
# ou um arquivo:  node skill/site-que-vende/scripts/auditar.js minha-pagina/index.html
```

SaÃ­da (o exemplo ruim deste repositÃ³rio):

```
FALHA  1. Teste do espelho
         - TÃ­tulo genÃ©rico: "SoluÃ§Ãµes inovadoras de agendamento com IA" serve para qualquer empresa
         - O botÃ£o diz "Enviar": nÃ£o conta o que acontece depois do clique.
FALHA  2. Regra do marca-texto
         - A cor do botÃ£o (#8b5cf6) aparece em 35 lugares que nÃ£o sÃ£o clique (9 borda, 11 texto, 11 tÃ­tulo, 4 Ã­cone ou selo).
...
0 de 5 padrÃµes passam.  RelatÃ³rio: auditoria/relatorio.html
O que consertar (cole no seu agente): auditoria/consertar.md
```

CÃ³digo de saÃ­da: `0` passou nos cinco, `1` algum falhou, `2` erro de uso ou a pÃ¡gina nÃ£o abriu. Serve em CI.

O que saber antes de rodar:

- Cada auditoria leva de 20 a 60 segundos e grava de 1 a 20 MB em `auditoria/` (fotos e relatÃ³rio). Ponha `auditoria/` no `.gitignore` do site.
- A pÃ¡gina Ã© aberta 4 vezes (computador e celular, com e sem "reduzir movimento"): o que ela envia sozinha ao abrir, como analytics, sai 4 vezes. Ao mexer na amostra, o auditor barra todo pedido de rede (envio, GET com dados, pixel, WebSocket), menos arquivos estÃ¡ticos do prÃ³prio site. A lista de tÃ­tulos genÃ©ricos Ã© fixa e erra nos dois sentidos: confira o tÃ­tulo vocÃª mesmo.
- Enquanto testa a amostra, o auditor barra todo envio da pÃ¡gina (formulÃ¡rio, `fetch`, qualquer pedido que nÃ£o seja GET) e toda saÃ­da para outro endereÃ§o. Nada Ã© enviado ao site, e o relatÃ³rio lista o que foi barrado.
- O auditor rola a pÃ¡gina e **mexe nos controles** da amostra (sliders, opÃ§Ãµes, botÃµes) para ver se ela responde. Ele **nÃ£o envia formulÃ¡rio e nÃ£o segue link**.
- **Qual Ã© o botÃ£o principal?** Ele escolhe o maior botÃ£o cheio da primeira tela e diz qual escolheu no relatÃ³rio. Se escolheu errado, marque o certo no HTML com o atributo `data-cta` (`<a data-cta href="...">`), ou, em site que vocÃª nÃ£o pode editar, rode com `--cta "seletor-css"`.
- PÃ¡gina local que usa arquivos fora da pasta dela (`../`) e nÃ£o estÃ¡ num repositÃ³rio git: passe `--raiz <pasta que contÃ©m tudo>`. O auditor avisa quando algum arquivo deu 404.
- Os padrÃµes 1 e 4 sÃ£o medidos no computador (1440Ã—900) e no celular (390Ã—844); os padrÃµes 2, 3 e 5, no computador.
- `node skill/site-que-vende/scripts/auditar.js --help` mostra todas as opÃ§Ãµes.

## O que tem aqui

| PeÃ§a | Arquivo | Faz |
|---|---|---|
| Auditor | `skill/site-que-vende/scripts/auditar.js` | abre a pÃ¡gina (URL ou arquivo), mede os 5 padrÃµes, grava `relatorio.html`, `relatorio.json`, `consertar.md` e as fotos |
| MediÃ§Ãµes | `skill/site-que-vende/scripts/medir.js` | o cÃ³digo que roda dentro da pÃ¡gina (cor, botÃ£o, camadas, movimento, amostra) |
| Amostras | `skill/site-que-vende/amostras/amostra.js` | `<amostra-calculadora>` e `<amostra-quiz>`: um arquivo, sem dependÃªncia, configurados por JSON |
| Modelo das amostras | `skill/site-que-vende/amostras/exemplo.html` | quiz e calculadora funcionando, para copiar |
| Skill | `skill/site-que-vende/SKILL.md` | os 5 passos para o agente: brief â†’ medir â†’ consertar â†’ medir â†’ revisÃ£o humana |
| Brief | `skill/site-que-vende/referencias/brief.md` | as perguntas antes do design e o pedido pronto para colar |
| Chaves das amostras | `skill/site-que-vende/referencias/amostras.md` | todas as chaves do JSON do quiz e da calculadora, variÃ¡veis de cor e o evento de resultado |
| Os 5 padrÃµes | `skill/site-que-vende/referencias/cinco-padroes.md` | a ideia, os nÃºmeros dos testes e o que Ã© medido |
| Exemplos | `exemplos/ruim/` e `exemplos/bom/` | o mesmo negÃ³cio fictÃ­cio: um falha nos 5, o outro passa nos 5 |
| Testes | `tests/rodar.sh` | 38 verificaÃ§Ãµes: o ruim falha com o motivo certo, o bom passa, as amostras funcionam e 7 casos que jÃ¡ enganaram o auditor |

## O processo, do inÃ­cio ao fim (7 passos)

ðŸ§  = sessÃ£o com a pessoa (gasta tokens) Â· âš™ï¸ = script (zero token) Â· ðŸ‘¤ = vocÃª

| # | Passo | Comando / o que acontece | Quem |
|---|---|---|---|
| 1 | Brief | responder Ã s perguntas de `referencias/brief.md` (para quem, o que ganha, o que faz agora, trÃªs cores, pergunta da amostra) | ðŸ‘¤ + ðŸ§  |
| 2 | PÃ¡gina | a IA gera a pÃ¡gina com o "pedido pronto" do brief (ou vocÃª jÃ¡ tem o site no ar) | ðŸ§  |
| 3 | Medir | `node skill/site-que-vende/scripts/auditar.js <url ou arquivo> --saida auditoria` | âš™ï¸ |
| 4 | Consertar | colar `auditoria/consertar.md` no agente; ele conserta sÃ³ o que falhou, na ordem 1 â†’ 5 | ðŸ§  |
| 5 | Amostra | se o padrÃ£o 5 falhou: copiar `amostras/amostra.js` e configurar o quiz ou a calculadora com os nÃºmeros do negÃ³cio | ðŸ‘¤ + ðŸ§  |
| 6 | Medir de novo | repetir 3 e 4 atÃ© `5 de 5` (no mÃ¡ximo 3 voltas; depois disso, decidir com a pessoa) | âš™ï¸ |
| 7 | RevisÃ£o humana e publicar | olhar `desktop-tela1.png` e `celular-tela1.png`, responder Ã s trÃªs perguntas do espelho, publicar | ðŸ‘¤ |

Testes do kit: `bash tests/rodar.sh`.

## Instalar a skill no Claude Code

```bash
ln -s "$PWD/skill/site-que-vende" ~/.claude/skills/site-que-vende
```

Depois Ã© sÃ³ pedir: "audita meu site com o site-que-vende" ou "por que meu site nÃ£o converte?".
Em outro agente (Codex, Cursor), diga: "leia `skill/site-que-vende/SKILL.md` e siga os passos".
Sem agente nenhum, o auditor e as amostras funcionam sozinhos.

## Usar uma amostra no seu site

```html
<amostra-calculadora>
  <script type="application/json">
  { "titulo": "Quanto custa pintar a sua casa?", "base": 350,
    "campos": [
      {"rotulo": "Ãrea de parede", "tipo": "faixa", "min": 20, "max": 300, "passo": 10, "valor": 80, "unidade": "mÂ²", "porUnidade": 28},
      {"rotulo": "Acabamento", "tipo": "opcoes", "opcoes": [{"rotulo": "EconÃ´mico", "vezes": 1}, {"rotulo": "Premium", "vezes": 1.6}]}
    ],
    "margem": 12, "prefixo": "Sua pintura fica entre",
    "botao": {"texto": "Receber o orÃ§amento exato", "href": "#contato"} }
  </script>
</amostra-calculadora>
<script src="amostra.js"></script>
```

A cor do botÃ£o vem da sua pÃ¡gina: `:root { --amostra-destaque: #c2410c; }`. Nada Ã© enviado a servidor nenhum.
Todas as chaves (inclusive `multiplica`, `margem`, `moeda`, `idioma`): [`amostras.md`](skill/site-que-vende/referencias/amostras.md).

## Limites (leia antes de confiar)

- O auditor mede forma, nÃ£o verdade: um tÃ­tulo especÃ­fico e falso passa. A revisÃ£o humana do passo 7 existe por isso.
- BotÃ£o principal preto, branco ou cinza: o padrÃ£o 2 vira aviso, porque nÃ£o dÃ¡ para contar onde mais a cor aparece.
- Site de marca grande costuma falhar em vÃ¡rios padrÃµes e vender assim mesmo: ele jÃ¡ tem a confianÃ§a que o site de
  um negÃ³cio pequeno precisa conquistar na primeira tela.
- Passar nos cinco nÃ£o garante venda. Tira do caminho cinco motivos comuns de um site perder cliente; o resto Ã© oferta, preÃ§o e trÃ¡fego.
- "Sombra", "peÃ§a atravessando a borda" e "uma coisa se move por tela" sÃ£o escolhas de design deste kit. Um site chapado bem resolvido pode vender; o auditor avisa onde ele difere do padrÃ£o.
- As mensagens do auditor estÃ£o em portuguÃªs. As pÃ¡ginas auditadas podem estar em portuguÃªs, inglÃªs ou espanhol.
- Os tetos do auditor (15% de cor de destaque, 2 usos fora de clique, 6 sombras, 7 perguntas, 4 coisas se movendo) sÃ£o escolhas deste kit, nÃ£o nÃºmeros de estudo.
- Um arquivo local Ã© servido em 127.0.0.1 a partir da raiz do repositÃ³rio git, sÃ³ enquanto a mediÃ§Ã£o roda.

## LicenÃ§a

MIT. As pÃ¡ginas de exemplo usam uma empresa fictÃ­cia.

---

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="32" />
  <p><strong>Arckhé AI</strong></p>
</div>