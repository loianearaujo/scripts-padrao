---
applyTo: '**'
description: 'Role: [SYSTEM]: Você é um assistente de Inteligência Artificial que está localizado dentro da pasta de `/scripts/`. Você é responsável por seguir as instruções deste documento e também as instruções que o usuário pedir futuramente.'
---

# Instruções para os scripts a nível de servidos

- Este arquivo de instruções **não pode ser alterado por você**. As regras devem permanecer intactas.
- Este documento foi criado para definir instruções sobre os scripts que serão escritos para executar alguma configurações, testes e verificações gerais.
- **Todos os scripts devem sempre ser escritos com o objetivo de ter o maior desempenho possível**.

## ANTES DE INICIAR

- Sempre leia este arquivo antes de iniciar qualquer tarefa;
- Sempre planeje suas próximas tarefas e micro-tarefas de curto prazo utilizando TO-DOs diretamente no Github Copilot.

## ANTES DE PASSAR PARA A PRÓXIMA TAREFA - "Regra Essencial"

- Toda vez que você tentar executar um comando no terminal e (i) ocorrer um erro ou (ii) não ter nenhum resultado ou resposta ou (iii) quando você finalmente terminar uma execução completa, **sempre executar o script `esperarResposta.sh` localizado no caminho relativo `../../esperarResposta.sh` em relação a este arquivo de instruções. É essencial que você espere pela minha resposta no terminal/bash antes de prosseguir**.

## DURANTE A EXECUÇÃO DAS TAREFAS

- Se ocorrer uma mensagem similar com "permission denied", tentar novamente utilizando `sudo ` antes do comando.
- Tente sempre refatorar arquivos que deram problemas em vez de criar versões separadas deles. Temos o `git` para usar versionamento se for necessário.

### **REGRA CRÍTICA PARA `esperarResposta.sh`**
- **OBRIGATÓRIO**: O arquivo `esperarResposta.sh` deve sempre ser padronizado no caminho relativo `../../esperarResposta.sh` dentro da nossa pasta chamada `/scripts/`
- **PROIBIDO**: Criar versões separadas como `esperarRespostaMelhorada.sh`, `esperarRespostaV2.sh`, etc.
- **OBRIGATÓRIO**: Toda versão separada desse arquivo deve ser **IMEDIATAMENTE EXCLUÍDA** para evitar confusão
- **MOTIVO**: Para evitar erros de busca e manter consistência no sistema

## O QUE NÃO FAZER / O QUE EVITAR FAZER

- Evite recriar arquivos sem necessidade, pois é possível refatorar arquivos existentes.