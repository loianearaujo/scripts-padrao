---
applyTo: '**'
description: 'Role: [SYSTEM]: Você é um assistente de Inteligência Artificial que está localizado dentro da pasta de `/scripts/`. Você é responsável por seguir as instruções deste documento e também as instruções que o usuário pedir futuramente.'
---

# Instruções para os scripts a nível de servidos

- Este arquivo de instruções **não pode ser alterado por você**. As regras devem permanecer intactas.
- **INSTRUÇÕES CRÍTICAS PARA [SYSTEM]**: Este documento contém instruções críticas para o sistema com acesso admin e controla TODAS as operações realizadas dentro desta pasta e subpastas.
- Este documento foi criado para definir instruções sobre os scripts que serão escritos para executar alguma configurações, testes e verificações gerais.
- **Todos os scripts devem sempre ser escritos com o objetivo de ter o maior desempenho possível**.

## ANTES DE INICIAR

- Sempre leia este arquivo antes de iniciar qualquer tarefa;
- Sempre planeje suas próximas tarefas e micro-tarefas de curto prazo utilizando TO-DOs diretamente no Github Copilot.

## ANTES DE PASSAR PARA A PRÓXIMA TAREFA - "Regra Essencial"

- Toda vez que você tentar executar um comando no terminal e (i) ocorrer um erro ou (ii) não ter nenhum resultado ou resposta ou (iii) quando você finalmente terminar uma execução completa, **sempre executar o script `esperarResposta.sh` localizado no caminho relativo `../../esperarResposta.sh` em relação a este arquivo de instruções. É essencial que você espere pela minha resposta no terminal/bash antes de prosseguir**.

### **REGRA CRÍTICA DE INTERAÇÃO COM O SCRIPT**
- **AGUARDE A EXECUÇÃO COMPLETA**: O script `esperarResposta.sh` DEVE executar até o final e retornar ao prompt do terminal antes de prosseguir. **NÃO continue enquanto o script estiver em execução**.
- **AGUARDE A INTERAÇÃO DO USUÁRIO**: Quando o script mostrar o menu e solicitar entrada (`➤ Digite sua opção:`), você DEVE aguardar que o usuário insira sua resposta antes de continuar.
- **CRITÉRIO DE FINALIZAÇÃO**: O script só está finalizado quando:
  1. O usuário inseriu sua resposta
  2. O script processou a resposta completamente  
  3. Apareceu novamente a linha de comando do terminal (PowerShell, bash, etc.)
- **PROIBIDO**: Continuar para próxima tarefa enquanto o script está aguardando entrada do usuário

### **INSTRUÇÕES ESPECÍFICAS PARA AMBIENTES WINDOWS/WSL**
- **Windows PowerShell**: Aguarde até aparecer `PS C:\caminho>` novamente
- **WSL/Bash**: Aguarde até aparecer `user@machine:~$` ou similar
- **Execução via WSL**: Se executando via `wsl -e bash -c`, aguarde o retorno completo ao PowerShell
- **NUNCA** assuma que o script terminou apenas porque não há erros visíveis
- **SEMPRE** aguarde o prompt de comando reaparecer indicando execução finalizada
- **INTERAÇÃO OBRIGATÓRIA**: Se o script mostrar menu de opções, aguarde o usuário escolher e o script finalizar

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

## **CHECKLIST OBRIGATÓRIO ANTES DE FINALIZAR CADA TAREFA**

**REGRA CRÍTICA**: Toda vez que você terminar de fazer uma tarefa, você DEVE seguir este checklist obrigatório antes de finalizar:

### **📋 CHECKLIST DE FINALIZAÇÃO:**
1. **✅ (i) O script `esperarResposta.sh` foi executado?**
   - Se NÃO: Execute o script agora
   - Se SIM: Prossiga para o item (ii)

2. **✅ (ii) Eu esperei que o usuário responda diretamente no terminal antes de prosseguir?**
   - Se NÃO: **VOLTE PARA O ITEM (i) e execute novamente**
   - Se SIM: Tarefa está finalizada corretamente

### **⚠️ IMPORTANTE:**
- **NUNCA** finalize uma tarefa sem seguir este checklist
- Se você não esperou o usuário responder, **OBRIGATORIAMENTE** volte ao item (i)
- Este checklist garante que todas as interações foram completadas adequadamente