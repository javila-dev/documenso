#!/bin/bash

# ===========================================
# INSTALADOR DE SIGNATO
# Sistema de Firma Digital - 2ASoft S.A.S.
# ===========================================

set -e

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║     🚀 SIGNATO - INSTALADOR AUTOMÁTICO          ║"
echo "║     Sistema de Firma Digital para 2ASoft        ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Verifica que estemos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: Archivo docker-compose.yml no encontrado"
    echo "   Asegúrate de estar en la carpeta correcta con todos los archivos"
    exit 1
fi

# Verifica que exista .env
if [ ! -f ".env" ]; then
    echo "❌ Error: Archivo .env no encontrado"
    echo "   Copia .env.example a .env y configúralo primero"
    exit 1
fi

echo "📋 Checklist de instalación"
echo "──────────────────────────────────────────────────"
echo ""

# Paso 1: Generar certificado
echo "1️⃣  Certificado de firma digital"
if [ -f "cert.p12" ]; then
    echo "   ✅ cert.p12 ya existe"
else
    echo "   🔐 Generando certificado..."
    chmod +x generate-cert.sh
    ./generate-cert.sh
fi
echo ""

# Paso 2: Verificar MinIO bucket
echo "2️⃣  Bucket de MinIO"
echo "   📦 Necesitas crear el bucket 'signato' en MinIO"
echo ""
echo "   Pasos:"
echo "   1. Accede a https://minio.2asoft.tech"
echo "   2. Login: minio_2asoft_admin"
echo "   3. Crear bucket: signato"
echo "   4. Déjalo PRIVADO (como viene por defecto)"
echo ""
read -p "   ¿Ya creaste el bucket? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "   ⏸️  Por favor crea el bucket y vuelve a ejecutar el script"
    exit 0
fi
echo "   ✅ Bucket configurado"
echo ""

# Paso 3: Verificar email
echo "3️⃣  Configuración de email"
echo "   ℹ️  Usando: contacto@2asoft.tech"
echo "   ✅ Ya está configurado en tu mail server"
echo ""

# Paso 4: Levantar servicios
echo "4️⃣  Iniciando servicios"
echo "   🐳 Levantando contenedores..."
docker compose up -d

echo ""
echo "   ⏳ Esperando inicialización de PostgreSQL..."
sleep 10

echo "   ⏳ Esperando inicialización de Signato (1-2 min)..."
sleep 60

# Paso 5: Verificar estado
echo ""
echo "5️⃣  Verificación de servicios"
echo "──────────────────────────────────────────────────"
docker compose ps
echo ""

# Verificar logs de errores
echo "🔍 Verificando logs recientes..."
if docker compose logs signato | grep -i "error" | tail -n 5; then
    echo "⚠️  Se encontraron algunos errores, revisa los logs completos"
else
    echo "✅ No se detectaron errores críticos"
fi

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║            ✅ INSTALACIÓN COMPLETADA             ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "🌐 URL de acceso:"
echo "   https://signato.2asoft.tech"
echo ""
echo "📋 Próximos pasos:"
echo ""
echo "   1. Accede a la URL de arriba"
echo "   2. Crea tu cuenta de administrador"
echo "   3. Ve a Settings → API Keys"
echo "   4. Genera una API key nueva"
echo "   5. Úsala en tu aplicación React"
echo ""
echo "🔧 Comandos útiles:"
echo "   Ver logs:      docker compose logs -f signato"
echo "   Reiniciar:     docker compose restart signato"
echo "   Estado:        docker compose ps"
echo "   Detener:       docker compose down"
echo ""
echo "📚 Documentación:"
echo "   API Docs:      https://signato.2asoft.tech/api/v1/openapi"
echo "   Documenso:     https://docs.documenso.com"
echo ""