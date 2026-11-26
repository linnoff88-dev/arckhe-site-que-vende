ï»¿# site-que-vende

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="48" />
  <p><strong>Arckhé AI</strong></p>
</div>


[![site-que-vende](guia/assets/banner.jpg)](https://linnoff88-dev.github.io/arckhe-/guia/)

**ê°Å¸â¡Â§ê°Å¸â¡Â· [PortuguêÂªs](README.md) êÂ· ê°Å¸â¡Âºê°Å¸â¡Â¸ [English](README.en.md) êÂ· ê°Å¸â¡Âªê°Å¸â¡Â¸ [EspaêÂ±ol](README.es.md)**

## O que êÂ©

O site-que-vende êÂ© um kit que mede, no navegador, os cinco padrêÂµes que separam o site que traz cliente do site
"bonito e barato" feito com IA, e diz o que consertar. Ele abre a sua pêÂ¡gina no computador e no celular, mede
texto, cor, camadas, movimento e amostra grêÂ¡tis, e devolve um relatêÂ³rio com a lista de consertos pronta para colar
no seu agente de cêÂ³digo. Vem com uma skill para o Claude Code, dois componentes de amostra grêÂ¡tis (quiz e
calculadora) e um par de pêÂ¡ginas de exemplo, uma ruim e uma boa.

[Guia completo](https://linnoff88-dev.github.io/arckhe-/guia/) êÂ·
[Exemplo ruim](https://linnoff88-dev.github.io/arckhe-/exemplos/ruim/) (0 de 5) êÂ·
[Exemplo bom](https://linnoff88-dev.github.io/arckhe-/exemplos/bom/) (5 de 5) êÂ·
[Amostras](https://linnoff88-dev.github.io/arckhe-/skill/site-que-vende/amostras/exemplo.html)

## Os 5 padrêÂµes

| # | PadrêÂ£o | Em uma frase | O auditor mede |
|---|---|---|---|
| 1 | Teste do espelho | A primeira tela diz para quem êÂ©, o que a pessoa ganha e o que fazer agora | têÂ­tulo genêÂ©rico, botêÂ£o na 1êÂª tela (computador e celular), texto do botêÂ£o, botêÂµes disputando |
| 2 | Regra do marca-texto | A cor de destaque sêÂ³ aparece no que êÂ© clique (60/30/10) | onde a cor do botêÂ£o aparece fora de clique, quanto da pêÂ¡gina ela ocupa |
| 3 | Frente, meio e fundo | CenêÂ¡rio atrêÂ¡s, conteêÂºdo no meio, botêÂ£o na frente | fundo da 1êÂª tela, peêÂ§a atravessando a borda, quantas sombras |
| 4 | Movimento com funêÂ§êÂ£o | Texto pronto no instante, uma coisa se move por tela, dêÂ¡ para desligar | têÂ­tulo em 0,4 s, coisas se movendo por tela, "reduzir movimento" |
| 5 | Amostra grêÂ¡tis | O visitante prova o resultado antes de deixar o contato | existe ferramenta, ela responde na hora, êÂ© curta |

Detalhes e nêÂºmeros dos testes: [`cinco-padroes.md`](skill/site-que-vende/referencias/cinco-padroes.md).

## Usar em 2 minutos

```bash
git clone https://github.com/linnoff88-dev/site-que-vende && cd site-que-vende
cd skill/site-que-vende/scripts && npm install && npx playwright install chromium && cd -

node skill/site-que-vende/scripts/auditar.js https://seusite.com.br --saida auditoria
# ou um arquivo:  node skill/site-que-vende/scripts/auditar.js minha-pagina/index.html
```

SaêÂ­da (o exemplo ruim deste repositêÂ³rio):

```
FALHA  1. Teste do espelho
         - TêÂ­tulo genêÂ©rico: "SoluêÂ§êÂµes inovadoras de agendamento com IA" serve para qualquer empresa
         - O botêÂ£o diz "Enviar": nêÂ£o conta o que acontece depois do clique.
FALHA  2. Regra do marca-texto
         - A cor do botêÂ£o (#8b5cf6) aparece em 35 lugares que nêÂ£o sêÂ£o clique (9 borda, 11 texto, 11 têÂ­tulo, 4 êÂ­cone ou selo).
...
0 de 5 padrêÂµes passam.  RelatêÂ³rio: auditoria/relatorio.html
O que consertar (cole no seu agente): auditoria/consertar.md
```

CêÂ³digo de saêÂ­da: `0` passou nos cinco, `1` algum falhou, `2` erro de uso ou a pêÂ¡gina nêÂ£o abriu. Serve em CI.

O que saber antes de rodar:

- Cada auditoria leva de 20 a 60 segundos e grava de 1 a 20 MB em `auditoria/` (fotos e relatêÂ³rio). Ponha `auditoria/` no `.gitignore` do site.
- A pêÂ¡gina êÂ© aberta 4 vezes (computador e celular, com e sem "reduzir movimento"): o que ela envia sozinha ao abrir, como analytics, sai 4 vezes. Ao mexer na amostra, o auditor barra todo pedido de rede (envio, GET com dados, pixel, WebSocket), menos arquivos estêÂ¡ticos do prêÂ³prio site. A lista de têÂ­tulos genêÂ©ricos êÂ© fixa e erra nos dois sentidos: confira o têÂ­tulo vocêÂª mesmo.
- Enquanto testa a amostra, o auditor barra todo envio da pêÂ¡gina (formulêÂ¡rio, `fetch`, qualquer pedido que nêÂ£o seja GET) e toda saêÂ­da para outro endereêÂ§o. Nada êÂ© enviado ao site, e o relatêÂ³rio lista o que foi barrado.
- O auditor rola a pêÂ¡gina e **mexe nos controles** da amostra (sliders, opêÂ§êÂµes, botêÂµes) para ver se ela responde. Ele **nêÂ£o envia formulêÂ¡rio e nêÂ£o segue link**.
- **Qual êÂ© o botêÂ£o principal?** Ele escolhe o maior botêÂ£o cheio da primeira tela e diz qual escolheu no relatêÂ³rio. Se escolheu errado, marque o certo no HTML com o atributo `data-cta` (`<a data-cta href="...">`), ou, em site que vocêÂª nêÂ£o pode editar, rode com `--cta "seletor-css"`.
- PêÂ¡gina local que usa arquivos fora da pasta dela (`../`) e nêÂ£o estêÂ¡ num repositêÂ³rio git: passe `--raiz <pasta que contêÂ©m tudo>`. O auditor avisa quando algum arquivo deu 404.
- Os padrêÂµes 1 e 4 sêÂ£o medidos no computador (1440êâ900) e no celular (390êâ844); os padrêÂµes 2, 3 e 5, no computador.
- `node skill/site-que-vende/scripts/auditar.js --help` mostra todas as opêÂ§êÂµes.

## O que tem aqui

| PeêÂ§a | Arquivo | Faz |
|---|---|---|
| Auditor | `skill/site-que-vende/scripts/auditar.js` | abre a pêÂ¡gina (URL ou arquivo), mede os 5 padrêÂµes, grava `relatorio.html`, `relatorio.json`, `consertar.md` e as fotos |
| MediêÂ§êÂµes | `skill/site-que-vende/scripts/medir.js` | o cêÂ³digo que roda dentro da pêÂ¡gina (cor, botêÂ£o, camadas, movimento, amostra) |
| Amostras | `skill/site-que-vende/amostras/amostra.js` | `<amostra-calculadora>` e `<amostra-quiz>`: um arquivo, sem dependêÂªncia, configurados por JSON |
| Modelo das amostras | `skill/site-que-vende/amostras/exemplo.html` | quiz e calculadora funcionando, para copiar |
| Skill | `skill/site-que-vende/SKILL.md` | os 5 passos para o agente: brief ê¢â â medir ê¢â â consertar ê¢â â medir ê¢â â revisêÂ£o humana |
| Brief | `skill/site-que-vende/referencias/brief.md` | as perguntas antes do design e o pedido pronto para colar |
| Chaves das amostras | `skill/site-que-vende/referencias/amostras.md` | todas as chaves do JSON do quiz e da calculadora, variêÂ¡veis de cor e o evento de resultado |
| Os 5 padrêÂµes | `skill/site-que-vende/referencias/cinco-padroes.md` | a ideia, os nêÂºmeros dos testes e o que êÂ© medido |
| Exemplos | `exemplos/ruim/` e `exemplos/bom/` | o mesmo negêÂ³cio fictêÂ­cio: um falha nos 5, o outro passa nos 5 |
| Testes | `tests/rodar.sh` | 38 verificaêÂ§êÂµes: o ruim falha com o motivo certo, o bom passa, as amostras funcionam e 7 casos que jêÂ¡ enganaram o auditor |

## O processo, do inêÂ­cio ao fim (7 passos)

ê°Å¸Â§Â  = sessêÂ£o com a pessoa (gasta tokens) êÂ· ê¢Å¡â¢ê¯Â¸Â = script (zero token) êÂ· ê°Å¸âÂ¤ = vocêÂª

| # | Passo | Comando / o que acontece | Quem |
|---|---|---|---|
| 1 | Brief | responder êÂ s perguntas de `referencias/brief.md` (para quem, o que ganha, o que faz agora, trêÂªs cores, pergunta da amostra) | ê°Å¸âÂ¤ + ê°Å¸Â§Â  |
| 2 | PêÂ¡gina | a IA gera a pêÂ¡gina com o "pedido pronto" do brief (ou vocêÂª jêÂ¡ tem o site no ar) | ê°Å¸Â§Â  |
| 3 | Medir | `node skill/site-que-vende/scripts/auditar.js <url ou arquivo> --saida auditoria` | ê¢Å¡â¢ê¯Â¸Â |
| 4 | Consertar | colar `auditoria/consertar.md` no agente; ele conserta sêÂ³ o que falhou, na ordem 1 ê¢â â 5 | ê°Å¸Â§Â  |
| 5 | Amostra | se o padrêÂ£o 5 falhou: copiar `amostras/amostra.js` e configurar o quiz ou a calculadora com os nêÂºmeros do negêÂ³cio | ê°Å¸âÂ¤ + ê°Å¸Â§Â  |
| 6 | Medir de novo | repetir 3 e 4 atêÂ© `5 de 5` (no mêÂ¡ximo 3 voltas; depois disso, decidir com a pessoa) | ê¢Å¡â¢ê¯Â¸Â |
| 7 | RevisêÂ£o humana e publicar | olhar `desktop-tela1.png` e `celular-tela1.png`, responder êÂ s trêÂªs perguntas do espelho, publicar | ê°Å¸âÂ¤ |

Testes do kit: `bash tests/rodar.sh`.

## Instalar a skill no Claude Code

```bash
ln -s "$PWD/skill/site-que-vende" ~/.claude/skills/site-que-vende
```

Depois êÂ© sêÂ³ pedir: "audita meu site com o site-que-vende" ou "por que meu site nêÂ£o converte?".
Em outro agente (Codex, Cursor), diga: "leia `skill/site-que-vende/SKILL.md` e siga os passos".
Sem agente nenhum, o auditor e as amostras funcionam sozinhos.

## Usar uma amostra no seu site

```html
<amostra-calculadora>
  <script type="application/json">
  { "titulo": "Quanto custa pintar a sua casa?", "base": 350,
    "campos": [
      {"rotulo": "êÂrea de parede", "tipo": "faixa", "min": 20, "max": 300, "passo": 10, "valor": 80, "unidade": "mêÂ²", "porUnidade": 28},
      {"rotulo": "Acabamento", "tipo": "opcoes", "opcoes": [{"rotulo": "EconêÂ´mico", "vezes": 1}, {"rotulo": "Premium", "vezes": 1.6}]}
    ],
    "margem": 12, "prefixo": "Sua pintura fica entre",
    "botao": {"texto": "Receber o orêÂ§amento exato", "href": "#contato"} }
  </script>
</amostra-calculadora>
<script src="amostra.js"></script>
```

A cor do botêÂ£o vem da sua pêÂ¡gina: `:root { --amostra-destaque: #c2410c; }`. Nada êÂ© enviado a servidor nenhum.
Todas as chaves (inclusive `multiplica`, `margem`, `moeda`, `idioma`): [`amostras.md`](skill/site-que-vende/referencias/amostras.md).

## Limites (leia antes de confiar)

- O auditor mede forma, nêÂ£o verdade: um têÂ­tulo especêÂ­fico e falso passa. A revisêÂ£o humana do passo 7 existe por isso.
- BotêÂ£o principal preto, branco ou cinza: o padrêÂ£o 2 vira aviso, porque nêÂ£o dêÂ¡ para contar onde mais a cor aparece.
- Site de marca grande costuma falhar em vêÂ¡rios padrêÂµes e vender assim mesmo: ele jêÂ¡ tem a confianêÂ§a que o site de
  um negêÂ³cio pequeno precisa conquistar na primeira tela.
- Passar nos cinco nêÂ£o garante venda. Tira do caminho cinco motivos comuns de um site perder cliente; o resto êÂ© oferta, preêÂ§o e trêÂ¡fego.
- "Sombra", "peêÂ§a atravessando a borda" e "uma coisa se move por tela" sêÂ£o escolhas de design deste kit. Um site chapado bem resolvido pode vender; o auditor avisa onde ele difere do padrêÂ£o.
- As mensagens do auditor estêÂ£o em portuguêÂªs. As pêÂ¡ginas auditadas podem estar em portuguêÂªs, inglêÂªs ou espanhol.
- Os tetos do auditor (15% de cor de destaque, 2 usos fora de clique, 6 sombras, 7 perguntas, 4 coisas se movendo) sêÂ£o escolhas deste kit, nêÂ£o nêÂºmeros de estudo.
- Um arquivo local êÂ© servido em 127.0.0.1 a partir da raiz do repositêÂ³rio git, sêÂ³ enquanto a mediêÂ§êÂ£o roda.

## LicenêÂ§a

MIT. As pêÂ¡ginas de exemplo usam uma empresa fictêÂ­cia.

---

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="32" />
  <p><strong>Arckhé AI</strong></p>
</div>