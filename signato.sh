#!/bin/bash

# ===========================================
# SIGNATO - COMANDOS RÁPIDOS
# ===========================================

show_help() {
    echo ""
    echo "╔══════════════════════════════════════════════════╗"
    echo "║        SIGNATO - COMANDOS RÁPIDOS               ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo ""
    echo "Uso: ./signato.sh [comando]"
    echo ""
    echo "Comandos disponibles:"
    echo ""
    echo "  start       Iniciar servicios"
    echo "  stop        Detener servicios"
    echo "  restart     Reiniciar servicios"
    echo "  logs        Ver logs en tiempo real"
    echo "  status      Ver estado de servicios"
    echo "  stats       Ver uso de recursos"
    echo "  cert        Regenerar certificado"
    echo "  backup      Hacer backup de BD"
    echo "  shell       Entrar al contenedor"
    echo "  clean       Limpiar logs antiguos"
    echo ""
}

case "$1" in
    start)
        echo "🚀 Iniciando Signato..."
        docker compose up -d
        echo "✅ Servicios iniciados"
        echo "🌐 https://signato.2asoft.tech"
        ;;
    
    stop)
        echo "🛑 Deteniendo Signato..."
        docker compose down
        echo "✅ Servicios detenidos"
        ;;
    
    restart)
        echo "🔄 Reiniciando Signato..."
        docker compose restart signato
        echo "✅ Servicio reiniciado"
        ;;
    
    logs)
        echo "📋 Logs de Signato (Ctrl+C para salir)..."
        docker compose logs -f signato
        ;;
    
    status)
        echo "📊 Estado de servicios:"
        docker compose ps
        ;;
    
    stats)
        echo "💻 Uso de recursos (Ctrl+C para salir)..."
        docker stats signato-app
        ;;
    
    cert)
        echo "🔐 Regenerando certificado..."
        ./generate-cert.sh
        echo "🔄 Reiniciando para aplicar cambios..."
        docker compose restart signato
        echo "✅ Certificado actualizado"
        ;;
    
    backup)
        BACKUP_FILE="backup_signato_$(date +%Y%m%d_%H%M%S).sql"
        echo "💾 Creando backup: $BACKUP_FILE"
        docker exec central-postgres pg_dump -U signato_user signato > "$BACKUP_FILE"
        echo "✅ Backup creado: $BACKUP_FILE"
        ls -lh "$BACKUP_FILE"
        ;;
    
    shell)
        echo "🐚 Entrando al contenedor..."
        docker exec -it signato-app sh
        ;;
    
    clean)
        echo "🧹 Limpiando logs antiguos..."
        docker compose logs --tail=0 signato
        echo "✅ Logs limpiados"
        ;;
    
    *)
        show_help
        ;;
esac