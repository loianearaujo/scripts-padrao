#!/bin/bash

#
# SCRIPT DE ESPERA DE RESPOSTA - VERSÃO BASH/SHELL
# 
# Descrição: Editor usando vim para experiência completa de edição
# Linguagem: Bash Shell Script
# Versão: 7.2-bash - Editor Vim Otimizado UX
# Data: 30 de setembro de 2025
# 
# Funcionalidades:
# - Editor vim completo e profissional
# - Navegação, edição, busca nativas do vim
# - Suporte total a quebras de linha
# - Salvamento automático no resultado
# - Interface familiar para desenvolvedores
#

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

# Função para mostrar menu principal
show_main_menu() {
    clear_screen
    
    printf "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}           ${BOLD}${WHITE}🚀 SISTEMA DE RESPOSTA INTERATIVA V7.2${NC}             ${CYAN}║${NC}\n"
    printf "${CYAN}║${NC}                 ${WHITE}Editor Vim Otimizado UX${NC}                        ${CYAN}║${NC}\n"
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
    printf "${CYAN}║${NC}                                                                  ${CYAN}║${NC}\n"
    printf "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}\n"
    
    printf "\n${CYAN}🎯 VERSÃO 7.2 - EDITOR VIM OTIMIZADO:${NC}\n"
    printf "• ${BLUE}[4]${NC} Abre vim vazio, já em modo de edição!\n"
    printf "• Nova UX: sem placeholder, entrada direta\n"
    printf "• Salvamento: :wq (salvar e sair)\n"
    
    printf "\n${BOLD}${WHITE}➤ Digite sua opção:${NC} "
}

# Função para editor usando vim
vim_text_editor() {
    local result=""
    
    # Criar arquivo temporário vazio para vim (sem placeholder)
    touch "$TEMP_FILE" 2>/dev/null || {
        echo "Erro: Não foi possível criar arquivo temporário"
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
    
    # Abrir vim com configuração de entrada automática
    vim "+startinsert" "$TEMP_FILE"
    local vim_result=$?
    
    # Verificar se usuário cancelou
    if [ $vim_result -ne 0 ]; then
        rm -f "$TEMP_FILE"
        return 1
    fi
    
    # Verificar se arquivo existe e tem conteúdo
    if [ ! -f "$TEMP_FILE" ]; then
        return 1
    fi
    
    # Ler o arquivo resultante e verificar se tem conteúdo válido
    local has_content=false
    while IFS= read -r line || [ -n "$line" ]; do
        # Verificar se tem conteúdo real (não apenas espaços/tabs)
        if [[ "$line" =~ [^[:space:]] ]]; then
            has_content=true
            break
        fi
    done < "$TEMP_FILE"
    
    if [ "$has_content" = false ]; then
        rm -f "$TEMP_FILE"
        return 1
    fi
    
    # Ler todo o conteúdo
    result=$(cat "$TEMP_FILE")
    
    # Limpar arquivo temporário
    rm -f "$TEMP_FILE"
    
    # Verificar se tem conteúdo válido
    if [ -z "$result" ] || [[ ! "$result" =~ [^[:space:]] ]]; then
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
                    printf "\n${YELLOW}⚠️  Editor cancelado ou texto vazio. Pressione Enter para voltar...${NC}"
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