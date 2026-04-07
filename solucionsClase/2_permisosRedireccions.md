![IES Castro da Uz](https://www.edu.xunta.gal/centros/iescastrodauz/system/files/zeropoint3_logo.jpg)

# Práctica de Permisos y redirecciones

## 1. Crear estructura de directorios

empresa/
├── documentos/
├── scripts/
└── backups/

```
mkdir -p empresa/{documentos,scripts,backups}
```

---

## 2. Crear archivos

Dentro de documentos, crea los siguientes archivos: 
•	clientes.txt 
•	empleados.txt 
•	errores.log 

```
touch empresa/documentos/clientes.txt
touch empresa/documentos/empleados.txt
touch empresa/documentos/errores.log
```

---

## 3. Introducir contenido con echo

Introduce contenido en los archivos utilizando echo y redirección: 
• Añade al menos 5 líneas en clientes.txt (nombre y ciudad) 
• Añade al menos 5 líneas en empleados.txt (nombre y departamento) 
• Añade varias líneas en errores.log, incluyendo algunas con la palabra ERROR 

```
echo "Ana - Madrid" > empresa/documentos/clientes.txt
echo "Luis - Coruña" >> empresa/documentos/clientes.txt
echo "Marta - Vigo" >> empresa/documentos/clientes.txt
echo "Pedro - Lugo" >> empresa/documentos/clientes.txt
echo "Sara - Ferrol" >> empresa/documentos/clientes.txt

echo "Juan - IT" > empresa/documentos/empleados.txt
echo "Laura - RRHH" >> empresa/documentos/empleados.txt
echo "Carlos - Ventas" >> empresa/documentos/empleados.txt
echo "Elena - Marketing" >> empresa/documentos/empleados.txt
echo "Mario - Finanzas" >> empresa/documentos/empleados.txt

echo "Inicio del sistema" > empresa/documentos/errores.log
echo "ERROR: fallo de red" >> empresa/documentos/errores.log
echo "Proceso completado" >> empresa/documentos/errores.log
echo "ERROR: acceso denegado" >> empresa/documentos/errores.log
echo "ERROR: disco lleno" >> empresa/documentos/errores.log
```

---

## 4. Cambiar propietario y permisos

Cambia el propietario de toda la carpeta empresa al usuario usuario1 y grupo grupo1. 

```
chown -R usuario1:grupo1 empresa
```

Configura los siguientes permisos: 
- documentos: lectura y escritura para el propietario, solo lectura para el grupo
- scripts: todos los permisos para el propietario, ninguno para el resto
- backups: lectura y ejecución para todos 

```
chmod 640 empresa/documentos
chmod 700 empresa/scripts
chmod 755 empresa/backups
```

Muestra los permisos de toda la estructura y guarda el resultado en un archivo llamado permisos.txt. 

```
ls -lR empresa > permisos.txt
```

---

## 6. Enlaces

Crea un enlace duro de clientes.txt llamado clientes_hard.txt dentro de backups.
Crea un enlace simbólico de empleados.txt llamado empleados_soft.txt dentro de backups. 


```
ln empresa/documentos/clientes.txt empresa/backups/clientes_hard.txt
ln -s empresa/documentos/empleados.txt empresa/backups/empleados_soft.txt
```

Comprueba el número de enlaces duros del archivo clientes.txt usando ls. 

```
ls -l empresa/documentos/clientes.txt
```

Eliminar archivo original:

```
rm empresa/documentos/empleados.txt
```

¿Qué ocurre al acceder al enlace simbólico? ¿Y al enlace duro? 

> 
> - **Enlace simbólico**: deja de funcionar (apunta a un archivo inexistente)
> - **Enlace duro**: sigue funcionando (los datos siguen existiendo en disco)
> 

---

## 7. Búsqueda de errores

Busca todas las líneas que contienen la palabra ERROR dentro de errores.log. 

```
grep "ERROR" empresa/documentos/errores.log
```

Usa un pipe para contar cuántas líneas contienen ERROR. 

```
grep "ERROR" empresa/documentos/errores.log | wc -l
```

---

## 8. Uso de find

Busca dentro de empresa: 
• Todos los archivos con extensión .txt 
• Todos los archivos modificados en los últimos 2 días 
Guarda el resultado de ambas búsquedas en un archivo llamado busquedas.txt. 

```
find empresa -name "*.txt" > busquedas.txt
find empresa -mtime -2 >> busquedas.txt
```

---

## 9. Búsqueda avanzada

Busca en todos los archivos .txt dentro de empresa las líneas que contienen la letra a. 
Ordena el resultado alfabéticamente. 
Guarda el resultado en un archivo llamado resultado_final.txt. 


```
find empresa -name "*.txt" -exec grep "a" {} \; | sort > resultado_final.txt
```

---

## 10. Redirección de errores

Ejecuta un comando incorrecto (por ejemplo, buscar en un archivo inexistente). 
Redirige el error a un archivo llamado errores_comandos.log. 



```
cat archivo_inexistente.txt 2> errores_comandos.log
```

> 
> **`2>` redirige la salida de error (stderr) a un archivo**
> 

---
