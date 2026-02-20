#!/bin/bash

set -e

echo "🔐 Generando certificado de firma digital para Signato"
echo "======================================================"

# Información del certificado
COUNTRY="CO"
STATE="Antioquia"
CITY="Medellin"
ORG="2ASoft S.A.S."
CN="Signato - 2ASoft S.A.S."
DAYS=3650
CERT_PASS="Signato2ASoft2025"

echo "📋 Organización: $ORG"
echo "📍 Ubicación: $CITY, $STATE, $COUNTRY"
echo "⏰ Validez: $DAYS días (10 años)"
echo ""

# Genera clave privada
echo "🔑 Generando clave privada RSA 2048..."
openssl genrsa -out private.key 2048 2>/dev/null

# Genera certificado X.509
echo "📜 Generando certificado X.509..."
openssl req -new -x509 -key private.key -out certificate.crt -days $DAYS \
  -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/CN=$CN" 2>/dev/null

# Combina en .p12 CON PASSWORD (compatible con OpenSSL 3.x)
echo "📦 Creando archivo .p12 con password..."
openssl pkcs12 -export -out cert.p12 \
  -inkey private.key \
  -in certificate.crt \
  -name "Signato-2ASoft" \
  -passout pass:$CERT_PASS \
  -keypbe PBE-SHA1-3DES \
  -certpbe PBE-SHA1-3DES \
  -macalg sha1 2>/dev/null

# Limpia archivos temporales
rm private.key certificate.crt

# Permisos para Docker (UID 1001)
chmod 644 cert.p12
chown 1001:1001 cert.p12 2>/dev/null || true

echo ""
echo "✅ Certificado generado: cert.p12"
echo "🔑 Password: $CERT_PASS"
echo ""
openssl pkcs12 -info -in cert.p12 -passin pass:$CERT_PASS -noout 2>/dev/null
echo ""
echo "✨ Listo para usar"
