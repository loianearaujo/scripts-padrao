#!/bin/bash

# Script de espera de resposta

# Verificar suporte a cores e definir variáveis
if command -v tput >/dev/null 2>&1 && [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
    CYAN=$(tput setaf 6)
    GREEN=$(tput setaf 2)
    RED=$(tput setaf 1)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    WHITE=$(tput setaf 7)
    BOLD=$(tput bold)
    NC=$(tput sgr0)
else
    # Fallback sem cores se tput não disponível ou terminal não suporta
    CYAN=""
    GREEN=""
    RED=""
    YELLOW=""
    BLUE=""
    WHITE=""
    BOLD=""
    NC=""
fi

# Definições de segurança
readonly MAX_INPUT_SIZE=8192
readonly TEMP_FILE="/tmp/esperar_resposta_input.txt"

# Função para limpar a tela - Usando tput para portabilidade
clear_screen() {
    tput clear 2>/dev/null || printf '\033[2J\033[H'
}

# Função para editor de texto simples (fallback)
simple_text_editor() {
    local result=""
    local line_count=0
    local text_content=""
    
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
    
    while IFS= read -r line; do
        printf "${BLUE}│${NC} "
        
        # Verificar comandos de controle
        case "$line" in
            "EOF")
                break
                ;;
            "CANCEL")
                printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
                printf "\n${YELLOW}⚠️  Edição cancelada${NC}\n"
                return 1
                ;;
        esac
        
        # Adicionar linha ao conteúdo
        text_content="${text_content:+$text_content$'\n'}$line"
        line_count=$((line_count + 1))
        
        # Limite de linhas para evitar spam
        if [ $line_count -gt 100 ]; then
            printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
            printf "\n${RED}❌ Limite de 100 linhas atingido${NC}\n"
            return 1
        fi
    done
    
    printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
    
    # Verificar conteúdo válido
    if [ -z "$text_content" ] || [ "$(printf '%s' "$text_content" | tr -d '[:space:]')" = "" ]; then
        printf "\n${YELLOW}⚠️  Nenhum conteúdo válido inserido${NC}\n"
        return 1
    fi
    
    printf '%s\n' "$text_content"
    return 0
}

# Função para verificar se vim está disponível (otimizada)
check_vim_available() {
    command -v vim >/dev/null 2>&1 || {
        printf "\n${RED}❌ Erro: vim não está instalado no sistema!${NC}\n"
        printf "${YELLOW}💡 Instale com: sudo apt install vim${NC}\n"
        printf "\n${BOLD}${WHITE}Pressione Enter para voltar ao menu...${NC}"
        read -r
        return 1
    }
    return 0
}

# Função para editor usando vim - Otimizada para reduzir I/O e melhorar tratamento de erros
vim_text_editor() {
    local temp_file="/tmp/esperar_resposta_$$_$(date +%s).txt"
    
    # Verificar vim e criar arquivo temporário
    check_vim_available || return 1
    touch "$temp_file" 2>/dev/null || {
        printf "\n${RED}❌ Erro: Não foi possível criar arquivo temporário${NC}\n"
        printf "${YELLOW}💡 Verifique permissões da pasta /tmp${NC}\n"
        printf "\n${BOLD}${WHITE}Pressione Enter para voltar ao menu...${NC}"
        read -r
        return 1
    }
    
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
    
    # Abrir vim e verificar sucesso
    if vim "$temp_file" </dev/tty >/dev/tty 2>&1; then
        [ -f "$temp_file" ] && [ -s "$temp_file" ] || {
            rm -f "$temp_file"
            printf "\n${YELLOW}⚠️  Arquivo vazio ou não salvo${NC}\n"
            return 1
        }
    else
        rm -f "$temp_file"
        printf "\n${RED}❌ Erro: Falha ao executar o vim${NC}\n"
        printf "\n${BOLD}${WHITE}Pressione Enter para voltar ao menu...${NC}"
        read -r
        return 1
    fi
    
    # Ler conteúdo e limpar
    local result
    result=$(cat "$temp_file")
    rm -f "$temp_file"
    
    # Verificar conteúdo válido
    [ -n "$result" ] && [ "$(printf '%s' "$result" | tr -d '[:space:]')" != "" ] || {
        printf "\n${YELLOW}⚠️  Conteúdo contém apenas espaços em branco${NC}\n"
        return 1
    }
    
    printf '%s\n' "$result"
    return 0
}

# Função para processar e exibir resposta - Otimizada para eficiência
show_response_confirmation() {
    local response="$1"
    
    clear_screen
    printf "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${GREEN}║${NC}                      ${BOLD}${WHITE}✅ RESPOSTA CONFIRMADA${NC}                       ${GREEN}║${NC}\n"
    printf "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    printf "\n${CYAN}💬 Texto editado:${NC}\n"
    printf "${BLUE}┌────────────────────────────────────────────────────────────────┐${NC}\n"
    
    printf '%s\n' "$response" | while IFS= read -r line; do
        printf "${BLUE}│${NC} %s\n" "$line"
    done
    
    printf "${BLUE}└────────────────────────────────────────────────────────────────┘${NC}\n"
}

# Função para mostrar menu principal
show_main_menu() {
    clear_screen

    printf "${BOLD}${WHITE}🚀 SISTEMA DE RESPOSTA ${NC}\n\n"
    printf "${GREEN}[1]${NC} ▶️  Continuar com próxima tarefa\n"
    printf "${RED}[2]${NC} ⏸️  Parar e aguardar instrução\n"
    printf "${YELLOW}[3]${NC} 🔄 Tentar novamente\n"
    printf "${BLUE}[4]${NC} 📝 Editor Vim (edição completa de texto)\n"
    printf "${BLUE}[5]${NC} ✏️  Editor Simples (alternativa ao vim)\n"
    printf "\n${BOLD}${WHITE}➤ Digite sua opção:${NC}"
}

# Função principal
main() {
    local response=""
    
    while [ -z "$response" ]; do
        show_main_menu
        read -r input
        
        case "$input" in
            1)
                response="1"
                ;;
            2)
                response="2"
                ;;
            3)
                response="3"
                ;;
            4)
                if result=$(vim_text_editor); then
                    response="$result"
                else
                    printf "\n${YELLOW}⚠️  Editor Vim cancelado ou falhou.${NC}\n"
                    printf "${CYAN}💡 Experimente a opção [5] para editor simples${NC}\n"
                    printf "\n${BOLD}${WHITE}Pressione Enter para voltar...${NC}"
                    read -r
                fi
                ;;
            5)
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
    
    show_response_confirmation "$response"
    printf "\n${CYAN}🎯 Processando resposta...${NC}\n"
    
    case "$response" in
        1)
            printf "${GREEN}✅ Continuando com próxima tarefa...${NC}\n"
            return 0
            ;;
        2)
            printf "${RED}⏸️  Parando execução e aguardando...${NC}\n"
            return 1
            ;;
        3)
            printf "${YELLOW}🔄 Tentando novamente...${NC}\n"
            return 3
            ;;
        *)
            printf "${BLUE}📝 Processando instrução personalizada...${NC}\n"
            return 3
            ;;
    esac
}

# Executar função principal
main "$@"
exit $?