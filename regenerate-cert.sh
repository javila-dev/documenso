#!/bin/bash
set -e

echo "🔐 Regenerando certificado compatible con Documenso..."

# Variables
COUNTRY="CO"
STATE="Antioquia"
CITY="Medellin"
ORG="2ASoft S.A.S."
CN="Signato - 2ASoft"
DAYS=3650
CERT_PASS="Signato2ASoft2025"

# 1. Generar clave privada
openssl genrsa -out private.key 2048 2>/dev/null

# 2. Generar certificado
openssl req -new -x509 -key private.key -out certificate.crt -days $DAYS \
  -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/CN=$CN" 2>/dev/null

# 3. Crear PKCS#12 con LEGACY format (compatible con versiones antiguas de OpenSSL)
openssl pkcs12 -export -out cert.p12 \
  -inkey private.key \
  -in certificate.crt \
  -name "Signato-2ASoft" \
  -passout pass:$CERT_PASS \
  -legacy

# 4. Limpiar archivos temporales
rm -f private.key certificate.crt

# 5. Permisos correctos
chmod 644 cert.p12
chown 1001:1001 cert.p12 2>/dev/null || true

echo "✅ Certificado regenerado con formato legacy"
echo "🔑 Password: $CERT_PASS"

# Verificar que se puede leer
openssl pkcs12 -info -in cert.p12 -passin pass:$CERT_PASS -noout 2>/dev/null && echo "✅ Certificado válido"
