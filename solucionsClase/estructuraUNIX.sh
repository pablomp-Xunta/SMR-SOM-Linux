#!/bin/bash

mkdir -p lab_find_grep/{docs,logs,scripts,data/secret,tmp}

# DOCS
echo "Guía de uso del sistema" > lab_find_grep/docs/manual.txt
echo "Este proyecto usa Linux y bash scripting" > lab_find_grep/docs/readme.md
echo -e "admin:1234\nuser:abcd\nroot:toor" > lab_find_grep/docs/passwords.txt

# LOGS
echo -e "INFO: App started\nERROR: Failed to load config\nINFO: Running" > lab_find_grep/logs/app.log
echo -e "INFO: Boot OK\nWARNING: Low memory\nERROR: Disk not found" > lab_find_grep/logs/system.log
echo -e "ERROR: Segmentation fault\nERROR: Null pointer" > lab_find_grep/logs/errors.log

# SCRIPTS
echo -e "#!/bin/bash\necho Backup iniciado" > lab_find_grep/scripts/backup.sh
echo -e "#!/bin/bash\necho Deploy en curso" > lab_find_grep/scripts/deploy.sh
echo -e "#!/bin/bash\necho Script oculto" > lab_find_grep/scripts/hidden_script.sh

# DATA
echo -e "id,name,role\n1,Ana,admin\n2,Juan,user\n3,Luis,user" > lab_find_grep/data/users.csv
echo -e "id,product,price\n1,Laptop,1200\n2,Mouse,25" > lab_find_grep/data/products.csv
echo "TOP SECRET DATA" > lab_find_grep/data/secret/hidden.txt

# TMP
touch lab_find_grep/tmp/test1.tmp
touch lab_find_grep/tmp/test2.tmp
echo "DEBUG: testing" > lab_find_grep/tmp/debug.log

# PERMISOS
chmod 600 lab_find_grep/docs/passwords.txt
chmod 700 lab_find_grep/data/secret
chmod 000 lab_find_grep/data/secret/hidden.txt
chmod +x lab_find_grep/scripts/*.sh

# Symlink a un log
ln -s ../logs/system.log lab_find_grep/docs/system_link.log

# Symlink a directorio completo
ln -s ../logs lab_find_grep/logs_link

# Symlink roto (trampa)
ln -s ../no_existe lab_find_grep/docs/broken_link

# Symlink a archivo sin permisos
ln -s ../data/secret/hidden.txt lab_find_grep/docs/hidden_link.txt

# Hard link a un log
ln lab_find_grep/logs/app.log lab_find_grep/logs/app_hardlink.log

# Hard link a passwords (ojo permisos)
ln lab_find_grep/docs/passwords.txt lab_find_grep/data/passwords_copy.txt

# Cambiar propietario simulado (si eres root)
# chown root:root lab_find_grep/data/secret/hidden.txt

# Crear archivo con múltiples enlaces duros
ln lab_find_grep/logs/errors.log lab_find_grep/tmp/errors_copy.log
ln lab_find_grep/logs/errors.log lab_find_grep/tmp/errors_copy2.log

# Crear bucle con symlink (MUY interesante para find)
ln -s ../ lab_find_grep/tmp/loop

# logs con nombres variables
touch lab_find_grep/logs/app1.log
touch lab_find_grep/logs/app2.log
touch lab_find_grep/logs/app-final.log
touch lab_find_grep/logs/app_backup.log

# archivos con un solo carácter variable
touch lab_find_grep/docs/file1.txt
touch lab_find_grep/docs/file2.txt
touch lab_find_grep/docs/fileA.txt

# nombres con múltiples extensiones
touch lab_find_grep/data/report.csv
touch lab_find_grep/data/report_backup.csv
touch lab_find_grep/data/report-final.csv

# nombres con caracteres especiales
touch lab_find_grep/tmp/test_a.tmp
touch lab_find_grep/tmp/test_b.tmp
touch lab_find_grep/tmp/test_1.tmp

echo "error: fallo crítico" >> lab_find_grep/logs/app1.log
echo "Error: fallo menor" >> lab_find_grep/logs/app2.log
echo "ERROR: fallo grave" >> lab_find_grep/logs/app-final.log

echo "user1 login ok" >> lab_find_grep/data/users.csv
echo "user2 login fail" >> lab_find_grep/data/users.csv
echo "admin1 login ok" >> lab_find_grep/data/users.csv

echo "test123 passed" >> lab_find_grep/tmp/debug.log
echo "testABC failed" >> lab_find_grep/tmp/debug.log
echo "test999 warning" >> lab_find_grep/tmp/debug.log