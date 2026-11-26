# FALHAS — site-que-vende

| data | o que quebrou | menor correçêo | prompt \| infra |
|---|---|---|---|
| 11/11/2026 | 3ª revisêo: GET com dados, pixel e WebSocket passavam na sondagem (o texto dizia "nada é enviado"); data-cta ignorado em botêo de contorno; URIError com % no nome; alvo pasta perdia caminhos; amostra.js com moeda/JSON errados mostrava caixa vazia | só GET estático do próprio site passa + routeWebSocket; marca lida antes dos filtros; try no decode; pasta → pasta/index.html; validaçêo na caixa (1.2.1) | prompt |
