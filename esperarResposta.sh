#!/bin/bash

# Script de espera de resposta simplificado
# Versão: 8.1 - Ultra Simples com Vim

echo ""
echo "🚀 SISTEMA DE RESPOSTA INTERATIVA"
echo ""
echo "[1] ▶️  Continuar com próxima tarefa"
echo "[2] ⏸️  Parar e aguardar instrução" 
echo "[3] 🔄 Tentar novamente"
echo "[4] 📝 Editor Vim"
echo ""
echo -n "➤ Digite sua opção: "

read opcao

case "$opcao" in
    "1")
        echo "✅ Continuando..."
        exit 0
        ;;
    "2")
        echo "⏸️ Parando execução..."
        exit 1
        ;;
    "3")
        echo "🔄 Tentando novamente..."
        exit 3
        ;;
    "4")
        echo "📝 Digite seu texto (Ctrl + C para finalizar):"
        texto=$(cat)

        if [ -n "$texto" ]; then
            echo ""
            echo "✅ Texto capturado:"
            echo "$texto"
            exit 3
        else
            echo "❌ Texto vazio, voltando ao menu..."
            exec "$0"
        fi
        ;;
    *)
        if [ -n "$opcao" ]; then
            echo "📝 Processando: $opcao"
            exit 3
        else
            echo "❌ Opção inválida!"
            exec "$0"
        fi
        ;;
esac

# Definições de segurança
readonly MAX_INPUT_SIZE=8192
readonly TEMP_FILE="/tmp/esperar_resposta_input.txt"

# Cores para output formatado
readonly GREEN='\x1b[32m'
readonly RED='\x1b[31m'
readonly YELLOW='\x1b[33m'
readonly BLUE='\x1b[34m'
readonly CYAN='\x1b[36m'
readonly WHITE='\x1b[37m'
readonly BOLD='\x1b[1m'
readonly NC='\x1b[0m'

# Função para limpar a tela
clear_screen() {
    printf "\033[2J\033[H"
}

# Função para editor de texto simples (fallback)
simple_text_editor() {
    local result=""
    
    clear_screen
    printf "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${BLUE}║${NC}                  ${BOLD}${WHITE}📝 EDITOR DE TEXTO SIMPLES${NC}                     ${BLUE}║${NC}\n"
    printf "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    printf "\n${CYAN}💡 Editor Alternativo:${NC}\n"
    printf "• ${GREEN}Digite seu texto${NC} (múltiplas linhas permitidas)\n"
    printf "• ${GREEN}Finalizar:${NC} Digite 'EOF' em linha separada\n"
    printf "• ${RED}Cancelar:${NC} Digite 'CANCEL' em linha separada\n"
    
    printf "\n${YELLOW}📝 Digite seu texto (termine com 'EOF'):${NC}\n"
    printf "${BLUE}┌────────────────────────────────────────────────────────────────┐${NC}\n"
    
    local line_count=0
    local text_content=""
    
    while true; do
        printf "${BLUE}│${NC} "
        read -r line
        
        # Verificar comandos de controle
        if [ "$line" = "EOF" ]; then
            break
        elif [ "$line" = "CANCEL" ]; then
            printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
            printf "\n${YELLOW}⚠️  Edição cancelada${NC}\n"
            return 1
        fi
        
        # Adicionar linha ao conteúdo
        if [ $line_count -eq 0 ]; then
            text_content="$line"
        else
            text_content="$text_content"$'\n'"$line"
        fi
        line_count=$((line_count + 1))
        
        # Verificar limite de linhas para evitar spam
        if [ $line_count -gt 100 ]; then
            printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
            printf "\n${RED}❌ Limite de 100 linhas atingido${NC}\n"
            return 1
        fi
    done
    
    printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
    
    # Verificar se há conteúdo válido
    if [ -z "$text_content" ] || [ "$(echo "$text_content" | tr -d '[:space:]')" = "" ]; then
        printf "\n${YELLOW}⚠️  Nenhum conteúdo válido inserido${NC}\n"
        return 1
    fi
    
    echo "$text_content"
    return 0
}

# Função para mostrar menu principal
show_main_menu() {
    clear_screen
    
    printf "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}           ${BOLD}${WHITE}🚀 SISTEMA DE RESPOSTA INTERATIVA V7.3${NC}             ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                 ${WHITE}Editor Vim + Fallback Melhorado${NC}                   ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}╠══════════════════════════════════════════════════════════════════╣${NC}\n"
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                    ${BOLD}${YELLOW}OPÇÕES RÁPIDAS:${NC}                             ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}    ${GREEN}[1]${NC} ▶️  Continuar com próxima tarefa                       ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}    ${RED}[2]${NC} ⏸️  Parar e aguardar instrução                        ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}    ${YELLOW}[3]${NC} 🔄 Tentar novamente                                   ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}    ${BLUE}[4]${NC} 📝 Editor Vim (edição completa de texto)             ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}    ${BLUE}[5]${NC} ✏️  Editor Simples (alternativa ao vim)              ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    printf "\n${CYAN}🎯 VERSÃO 7.3 - MELHORIAS:${NC}\n"
    printf "• ${BLUE}[4]${NC} Vim com verificações robustas\n"
    printf "• ${BLUE}[5]${NC} Editor alternativo caso vim falhe\n"
    printf "• Arquivos temporários únicos\n"
    printf "• Tratamento de erros melhorado\n"
    
    printf "\n${BOLD}${WHITE}➤ Digite sua opção:${NC} "
}

# Função para verificar se vim está disponível
check_vim_available() {
    if ! command -v vim >/dev/null 2>&1; then
        printf "\n${RED}❌ Erro: vim não está instalado no sistema!${NC}\n"
        printf "${YELLOW}💡 Instale com: sudo apt install vim${NC}\n"
        printf "\n${BOLD}${WHITE}Pressione Enter para voltar ao menu...${NC}"
        read -r
        return 1
    fi
    return 0
}

# Função para editor usando vim
vim_text_editor() {
    local result=""
    
    # Verificar se vim está disponível
    if ! check_vim_available; then
        return 1
    fi
    
    # Criar arquivo temporário com nome único para evitar conflitos
    local temp_file="/tmp/esperar_resposta_$$_$(date +%s).txt"
    
    # Criar arquivo temporário vazio para vim (sem placeholder)
    if ! touch "$temp_file" 2>/dev/null; then
        printf "\n${RED}❌ Erro: Não foi possível criar arquivo temporário${NC}\n"
        printf "${YELLOW}💡 Verifique permissões da pasta /tmp${NC}\n"
        printf "\n${BOLD}${WHITE}Pressione Enter para voltar ao menu...${NC}"
        read -r
        return 1
    fi
    
    clear_screen
    printf "${YELLOW}╔══════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${YELLOW}║${NC}                     ${BOLD}${WHITE}📝 ABRINDO EDITOR VIM${NC}                        ${YELLOW}║${NC}\n"
    printf "${YELLOW}╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    printf "\n${CYAN}🎯 Editor Melhorado:${NC}\n"
    printf "• ${GREEN}Vim abrirá vazio${NC}, pronto para digitar!\n"
    printf "• ${GREEN}Automático:${NC} Já em modo inserção (i)\n"
    printf "• ${GREEN}Confirmação simples:${NC} ESC + :wq + Enter\n"
    printf "• ${RED}Cancelamento:${NC} ESC + :q! + Enter (sair sem salvar)\n"
    
    printf "\n${YELLOW}💡 NOVA UX:${NC} Arquivo vazio, sem placeholder!\n"
    printf "\n${BOLD}${GREEN}Pressione Enter para abrir o vim...${NC}"
    read -r
    
    # Verificar se arquivo ainda existe antes de abrir vim
    if [ ! -f "$temp_file" ]; then
        printf "\n${RED}❌ Erro: Arquivo temporário foi perdido${NC}\n"
        return 1
    fi
    
    # Abrir vim com configuração mais simples e tratamento de erro
    printf "\n${GREEN}🚀 Abrindo vim...${NC}\n"
    sleep 1
    
    # Tentar vim sem startinsert primeiro para evitar problemas de terminal
    if vim "$temp_file" </dev/tty >/dev/tty 2>&1; then
        vim_success=true
    else
        printf "\n${RED}❌ Erro: Falha ao executar o vim${NC}\n"
        rm -f "$temp_file"
        printf "\n${BOLD}${WHITE}Pressione Enter para voltar ao menu...${NC}"
        read -r
        return 1
    fi
    
    # Verificar se arquivo ainda existe após edição
    if [ ! -f "$temp_file" ]; then
        printf "\n${YELLOW}⚠️  Arquivo não foi salvo (usuário cancelou)${NC}\n"
        return 1
    fi
    
    # Verificar tamanho do arquivo primeiro (mais eficiente)
    if [ ! -s "$temp_file" ]; then
        rm -f "$temp_file"
        printf "\n${YELLOW}⚠️  Arquivo vazio (nenhum conteúdo inserido)${NC}\n"
        return 1
    fi
    
    # Ler todo o conteúdo de uma vez
    result=$(cat "$temp_file" 2>/dev/null)
    
    # Limpar arquivo temporário
    rm -f "$temp_file"
    
    # Verificar se tem conteúdo válido (não apenas whitespace)
    if [ -z "$result" ] || [ "$(echo "$result" | tr -d '[:space:]')" = "" ]; then
        printf "\n${YELLOW}⚠️  Conteúdo contém apenas espaços em branco${NC}\n"
        return 1
    fi
    
    # Retornar o resultado através de echo
    echo "$result"
    return 0
}

# Função para processar e exibir resposta
show_response_confirmation() {
    local response="$1"
    
    clear_screen
    
    printf "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${GREEN}║${NC}                      ${BOLD}${WHITE}✅ RESPOSTA CONFIRMADA${NC}                       ${GREEN}║${NC}\n"
    printf "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    printf "\n${CYAN}💬 Texto editado no vim:${NC}\n"
    printf "${BLUE}┌────────────────────────────────────────────────────────────────┐${NC}\n"
    
    # Mostrar resposta linha por linha
    while IFS= read -r line; do
        printf "${BLUE}│${NC} %s\n" "$line"
    done <<< "$response"
    
    printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
}

# Função principal
main() {
    local response=""
    
    while [ -z "$response" ]; do
        show_main_menu
        
        read -r input
        
        # Processar entrada
        case "$input" in
            "1")
                response="1"
                ;;
            "2") 
                response="2"
                ;;
            "3")
                response="3"
                ;;
            "4")
                if result=$(vim_text_editor); then
                    response="$result"
                else
                    printf "\n${YELLOW}⚠️  Editor Vim cancelado ou falhou.${NC}\n"
                    printf "${CYAN}💡 Experimente a opção [5] para editor simples${NC}\n"
                    printf "\n${BOLD}${WHITE}Pressione Enter para voltar...${NC}"
                    read -r
                fi
                ;;
            "5")
                if result=$(simple_text_editor); then
                    response="$result"
                else
                    printf "\n${YELLOW}⚠️  Editor simples cancelado ou texto vazio.${NC}\n"
                    printf "\n${BOLD}${WHITE}Pressione Enter para voltar...${NC}"
                    read -r
                fi
                ;;
            "")
                printf "\n${RED}❌ Opção inválida! Pressione Enter para tentar novamente...${NC}"
                read -r
                ;;
            *)
                response="$input"
                ;;
        esac
    done
    
    # Mostrar confirmação
    show_response_confirmation "$response"
    
    printf "\n${CYAN}🎯 Processando resposta...${NC}\n"
    
    # Determinar código de retorno
    local result=1  # Default: parar
    
    case "$response" in
        "1")
            printf "${GREEN}✅ Continuando com próxima tarefa...${NC}\n"
            result=0
            ;;
        "2")
            printf "${RED}⏸️  Parando execução e aguardando...${NC}\n"
            result=1
            ;;
        "3")
            printf "${YELLOW}🔄 Tentando novamente...${NC}\n"
            result=3
            ;;
        *)
            printf "${BLUE}📝 Processando instrução personalizada...${NC}\n"
            result=3
            ;;
    esac
    
    return $result
}

# Executar função principal
main "$@"
exit $?