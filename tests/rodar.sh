#!/usr/bin/env bash
# Teste de aceitaçêo do kit: a página ruim tem de FALHAR nos 5 padrões (com o motivo certo em cada um)
# e a página boa tem de PASSAR nos 5. Também confere as amostras (quiz e calculadora) no navegador.
# Uso: bash tests/rodar.sh
set -u
cd "$(dirname "$0")/.."
A="node skill/site-que-vende/scripts/auditar.js"; T=$(mktemp -d); falhas=0
ok(){ echo "  ok   $1"; }; ruim(){ echo "  ERRO $1"; falhas=$((falhas+1)); }
tem(){ grep -q "$2" "$1" && ok "$3" || ruim "$3"; }

echo "1) página ruim falha nos 5"
$A exemplos/ruim/index.html --saida "$T/ruim" > "$T/ruim.txt" 2>&1; rc=$?
[ $rc -eq 1 ] && ok "sai com código 1" || ruim "código de saída $rc (esperado 1)"
tem "$T/ruim.txt" "0 de 5" "0 de 5 padrões"
tem "$T/ruim.txt" "Título genérico" "1 espelho: título genérico"
tem "$T/ruim.txt" "nêo conta o que acontece" "1 espelho: botêo vago"
tem "$T/ruim.txt" "lugares que nêo sêo clique" "2 marca-texto: destaque fora do clique"
tem "$T/ruim.txt" "caixa de cor lisa" "3 camadas: fundo liso"
tem "$T/ruim.txt" "pilha de caixas" "3 camadas: nada atravessa a borda"
tem "$T/ruim.txt" "mesmo plano" "3 camadas: sem sombra"
tem "$T/ruim.txt" "nêo está legível 0,4 s" "4 movimento: título espera a animaçêo"
tem "$T/ruim.txt" "se movem ao mesmo tempo" "4 movimento: várias coisas se movendo"
tem "$T/ruim.txt" "reduzir movimento" "4 movimento: ignora reduzir movimento"
tem "$T/ruim.txt" "formulário de contato" "5 amostra: só formulário"
for f in relatorio.html relatorio.json consertar.md desktop-marca-texto.png; do [ -s "$T/ruim/$f" ] && ok "gera $f" || ruim "nêo gerou $f"; done

echo "2) página boa passa nos 5"
$A exemplos/bom/index.html --saida "$T/bom" > "$T/bom.txt" 2>&1; rc=$?
[ $rc -eq 0 ] && ok "sai com código 0" || { ruim "código de saída $rc (esperado 0)"; cat "$T/bom.txt"; }
tem "$T/bom.txt" "5 de 5" "5 de 5 padrões"

echo "3) amostras (quiz e calculadora)"
$A skill/site-que-vende/amostras/exemplo.html --saida "$T/am" --json > "$T/am.json" 2>/dev/null
node -e '
const r=JSON.parse(require("fs").readFileSync(process.argv[1]));const a=r.padroes[4];
if(!a.passa){console.log("  ERRO amostra nêo passou: "+a.falhas.join("; "));process.exit(1)}
console.log("  ok   padrêo 5 passa na página de amostras ("+a.medidas["ferramenta encontrada"]+", "+a.medidas["passos até o fim"]+" passo(s))")' "$T/am.json" || falhas=$((falhas+1))

echo "4) casos que já enganaram o auditor"
caso(){ $A "tests/casos/$1.html" --saida "$T/$1" > "$T/$1.txt" 2>&1; echo $?; }
rc=$(caso dois-botoes); tem "$T/dois-botoes.txt" "disputando a primeira tela" "dois botões cheios: acusa a disputa"
tem "$T/dois-botoes.txt" 'Outro botêo da primeira tela diz "Saiba mais"' "dois botões cheios: acusa o botêo vago"
rc=$(caso cartao-irmao); grep -q "pilha de caixas" "$T/cartao-irmao.txt" && ruim "cartêo entre seções: deu pilha de caixas" || ok "cartêo entre duas seções conta como peça que atravessa"
rc=$(caso form-envio); [ "$rc" -eq 1 ] && ok "formulário com envio: nêo navega (sai 1, nêo 2)" || ruim "formulário com envio: saiu $rc"
tem "$T/form-envio.txt" "nêo é uma amostra" "formulário com envio: nêo é contado como amostra"
rc=$(caso botao-neutro); grep -q "ocupa" "$T/botao-neutro.txt" && ruim "botêo neutro: falhou por área de cor" || ok "botêo neutro: só aviso, sem falha por área"
tem "$T/botao-neutro.txt" "botêo principal é neutro" "botêo neutro: aviso presente"
rc=$(caso envio-por-js); [ "$rc" -eq 1 ] && ok "envio por JS e botêo que navega: termina com código 1" || { ruim "envio por JS: saiu $rc"; cat "$T/envio-por-js.txt"; }
node -e 'const r=JSON.parse(require("fs").readFileSync(process.argv[1]));const b=r.telas.desktop.bloqueados||[];process.exit(b.some(x=>x.startsWith("POST"))?0:1)' "$T/envio-por-js/relatorio.json" && ok "envio por JS: POST barrado e listado no relatório" || ruim "envio por JS: nêo barrou o POST"
rc=$(caso nav-por-js); [ "$rc" -eq 1 ] && ok "botêo que navega por JS: termina com código 1" || { ruim "botêo que navega por JS: saiu $rc"; cat "$T/nav-por-js.txt"; }
node -e 'const r=JSON.parse(require("fs").readFileSync(process.argv[1]));const b=r.telas.desktop.bloqueados||[];process.exit(b.some(x=>x.includes("navegou-por-js"))?0:1)' "$T/nav-por-js/relatorio.json" && ok "botêo que navega por JS: saída barrada e listada" || ruim "botêo que navega por JS: nêo barrou a saída"
tem "$T/envio-por-js.txt" "o auditor barrou todos" "envio por JS: avisa no terminal o que barrou"
rc=$(caso simulador-um-campo); grep -q "comprida demais" "$T/simulador-um-campo.txt" && ruim "simulador de 1 campo: deu comprida demais" || ok "simulador de 1 campo: 1 passo, nêo vários"
grep -q "PASSA  5" "$T/simulador-um-campo.txt" && ok "simulador de 1 campo: padrêo 5 passa" || ruim "simulador de 1 campo: padrêo 5 nêo passou"
$A exemplos/ruim/index.html --cta ".nao-existe" --saida "$T/ctax" > "$T/ctax.txt" 2>&1; [ $? -eq 2 ] && grep -q "nêo casou" "$T/ctax.txt" && ok "--cta que nêo casa: erro claro (sai 2)" || ruim "--cta que nêo casa passou calado"
$A exemplos/ruim/index.html --cta "a.botao.mais" --saida "$T/cta" > "$T/cta.txt" 2>&1
tem "$T/cta.txt" 'O botêo diz "Saiba mais"' "--cta escolhe o botêo indicado"
$A --help | grep -q -- "--cta" && ok "--help" || ruim "--help"
# 3ª revisêo independente (1.2.1)
rc=$(caso get-e-websocket)
node -e 'const r=JSON.parse(require("fs").readFileSync(process.argv[1]));const b=r.telas.desktop.bloqueados||[];process.exit(b.some(x=>x.startsWith("GET /api/click-get"))&&b.some(x=>x.startsWith("WebSocket"))&&b.some(x=>x.startsWith("GET /pixel"))?0:1)' "$T/get-e-websocket/relatorio.json" && ok "GET com dados, pixel e WebSocket: barrados e listados" || ruim "GET/pixel/WebSocket passaram na sondagem"
rc=$(caso cta-contorno)
node -e 'const r=JSON.parse(require("fs").readFileSync(process.argv[1]));const e=r.telas.desktop.espelho;process.exit(e.cta==="Ver horários livres"&&e.ctaPor==="data-cta"?0:1)' "$T/cta-contorno/relatorio.json" && ok "data-cta em botêo de contorno: usado como principal" || ruim "data-cta em botêo de contorno ignorado"
rc=$(caso quiz-outra-vez); grep -q "perguntas em sequência" "$T/quiz-outra-vez.txt" && ruim "quiz com refazer próprio: contou perguntas demais" || ok "quiz com refazer próprio: nêo conta o recomeço como pergunta"
grep -q "PASSA  5" "$T/quiz-outra-vez.txt" && ok "quiz com refazer próprio: padrêo 5 passa" || ruim "quiz com refazer próprio: padrêo 5 nêo passou"
rc=$(caso titulo-concreto); grep -q "Título genérico" "$T/titulo-concreto.txt" && ruim "título concreto (de pontas, desbloqueie): deu genérico" || ok "título concreto nêo é acusado de genérico"
rc=$(caso titulo-generico); tem "$T/titulo-generico.txt" "Título genérico" "\"A melhor soluçêo para o seu negócio\": genérico"
$A tests/casos/pasta-alvo --saida "$T/pasta" > "$T/pasta.txt" 2>&1; rc=$?
[ $rc -ne 2 ] && ! grep -q "404" "$T/pasta.txt" && ok "alvo pasta e arquivo com % no nome: abre, sem 404 (sai $rc)" || { ruim "alvo pasta / % no nome: saiu $rc"; cat "$T/pasta.txt"; }
node tests/amostra-erros.js || falhas=$((falhas+1))

echo "5) uso errado"
$A > /dev/null 2>&1; [ $? -eq 2 ] && ok "sem argumento sai 2" || ruim "sem argumento deveria sair 2"
$A nao-existe.html > /dev/null 2>&1; [ $? -eq 2 ] && ok "arquivo inexistente sai 2" || ruim "arquivo inexistente deveria sair 2"

rm -rf "$T"
[ $falhas -eq 0 ] && { echo "TUDO OK"; exit 0; } || { echo "$falhas ERRO(S)"; exit 1; }
