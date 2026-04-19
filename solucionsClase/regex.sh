#!/bin/bash

# ============================================================
#  Entorno de práctica: grep con expresiones regulares
#  Módulo: Sistemas Operativos / Aplicacións Ofimáticas
#  Datos: DNI, Email, Teléfono móvil
# ============================================================

DIR="practica_grep"
mkdir -p "$DIR"

# ── 1. Fichero principal: listado de personas ───────────────
cat > "$DIR/personas.txt" << 'EOF'
# Base de datos de clientes - Empresa XYZ S.L.

Nombre: Ana García López
DNI: 12345678A
Email: ana.garcia@gmail.com
Teléfono: 612 345 678
Ciudad: A Coruña

Nombre: Carlos Fernández Ramos
DNI: 87654321B
Email: carlos.fernandez@empresa.es
Teléfono: 698 765 432
Ciudad: Madrid

Nombre: Lucía Martínez
DNI: 00123456C
Email: lucia@hotmail.com
Teléfono: 655-123-456
Ciudad: Barcelona

Nombre: Pedro Gómez
DNI: 99999999Z
Email: pedro_gomez@correo.org
Teléfono: 744123456
Ciudad: Sevilla

Nombre: Elena Torres
DNI: 5678901D
Email: elena.torres[arroba]gmail.com
Teléfono: 512 000 111
Ciudad: Valencia

Nombre: Roberto Silva
DNI: 11223344E
Email: roberto@invalid
Teléfono: 34 699 001 122
Ciudad: Bilbao

Nombre: María Iglesias
DNI: 45678901F
Email: m.iglesias@univ.edu.es
Teléfono: 666000000
Ciudad: Santiago de Compostela
EOF

# ── 2. Fichero con datos mezclados / ruido ──────────────────
cat > "$DIR/formularios.txt" << 'EOF'
# Formularios recibidos por correo (datos sin validar)

Solicitante: Javier Núñez | doc: 22334455G | contacto: javier.nunez@work.com | mob: 677-889-900
Solicitante: Isabel Ramos | doc: 9876543H | contacto: no disponible | mob: 600123456
Solicitante: Tomás López | doc: 33445566J | contacto: tomas@lopez.net | mob: 34-655-987-321
Solicitante: Sofía Castro | doc: 11001100K | contacto: sofia.castro | mob: 777 444 222
Solicitante: Marcos Díaz | doc: A1234567 | contacto: marcos@diaz.org | mob: 688 000 111
Solicitante: Nuria Herrero | doc: 55667788L | contacto: nuria@herrero.es | mob: 5551234
Solicitante: Diego Morales | doc: 44556677M | contacto: diego.morales@empresa.com | mob: 699 112 233
EOF

# ── 3. Fichero de logs con datos sueltos ────────────────────
cat > "$DIR/registros.log" << 'EOF'
2024-01-15 10:23:01 INFO  Alta de usuario: DNI=12345678A email=ana.garcia@gmail.com
2024-01-15 10:45:22 INFO  Alta de usuario: DNI=87654321B email=carlos.fernandez@empresa.es
2024-01-15 11:00:03 WARN  Datos incompletos: DNI=5678901D email=elena.torres[arroba]gmail.com
2024-01-15 11:15:44 INFO  Contacto actualizado: tel=612345678 usuario=ana.garcia@gmail.com
2024-01-15 12:30:00 ERROR Formato inválido: DNI=A1234567 (no válido)
2024-01-15 12:45:19 INFO  Alta de usuario: DNI=45678901F email=m.iglesias@univ.edu.es tel=666000000
2024-01-15 13:00:55 INFO  Alta de usuario: DNI=44556677M email=diego.morales@empresa.com tel=699112233
2024-01-16 09:10:10 WARN  Email no válido detectado: sofia.castro (sin dominio)
2024-01-16 09:22:33 INFO  Nuevo registro: 33445566J - tomas@lopez.net - 655987321
EOF

# ── 4. Fichero con datos internacionales (casos borde) ──────
cat > "$DIR/internacional.txt" << 'EOF'
# Clientes internacionales con DNI español

Cliente A: NIF 12345678-A  mail: clienteA@service.io  móvil: +34 612 345 678
Cliente B: N.I.F. 87654321B  mail: b@b.com  móvil: 0034699001122
Cliente C: dni: 00123456c  mail: cliente.c@example.co.uk  móvil: 655123456
Cliente D: sin documento  mail: d@empresa  móvil: 123456789
Cliente E: DNI 99999999Z  mail: z@test.net  móvil: +34-666-000-000
EOF

echo "========================================================"
echo "  Entorno creado en el directorio: ./$DIR"
echo "========================================================"