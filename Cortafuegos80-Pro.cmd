
@ECHO OFF
TITULO CORTAFUEGOS80-Pro
COLOR 02
rem powershell Start-Process cmd -Verb runAs

:: Lista de puertos a bloquear
SET PORTS=80 8080 21 2121 443 8443 10443

:main
cls
ECHO INTRODUCE UN NUMERO DE PROGRAMA
ECHO. [0] DESACTIVAR CORTAFUEGOS
ECHO. [1] ACTIVAR CORTAFUEGOS
ECHO. [2] Test ping
ECHO. [3] Bloquear APP
ECHO. [4] Verificar Reglas
ECHO. [5] Ver puertos activos

set /p n=^>^>^> 
goto handle_choice

:handle_choice
IF "%n%"=="1" GOTO activate_firewall
IF "%n%"=="4" GOTO check_rules
IF "%n%"=="2" GOTO test_ping
IF "%n%"=="3" GOTO block_app
IF "%n%"=="5" GOTO view_ports
IF "%n%"=="0" GOTO deactivate_firewall
goto main

:activate_firewall
:: Bloqueando todo el tráfico
netsh advfirewall firewall add rule name="Bloquear todo el tráfico saliente" dir=out action=block protocol=TCP localport=any
netsh advfirewall firewall add rule name="Bloquear todo el tráfico saliente" dir=out action=block protocol=UDP localport=any
netsh advfirewall firewall add rule name="Bloquear todo el tráfico entrante" dir=in action=block protocol=TCP localport=any
netsh advfirewall firewall add rule name="Bloquear todo el tráfico entrante" dir=in action=block protocol=UDP localport=any

:: Bloquear puertos en la lista
FOR %%P IN (%PORTS%) DO (
    netsh advfirewall firewall add rule name="Bloquear puerto %%P" dir=in action=block protocol=TCP localport=%%P
    netsh advfirewall firewall add rule name="Bloquear puerto %%P" dir=out action=block protocol=TCP localport=%%P
    netsh advfirewall firewall add rule name="Bloquear puerto %%P" dir=in action=block protocol=UDP localport=%%P
    netsh advfirewall firewall add rule name="Bloquear puerto %%P" dir=out action=block protocol=UDP localport=%%P
)

netsh advfirewall set allprofiles state on
PAUSE
goto main

:check_rules
:: Verificar reglas de los puertos bloqueados
start C:\WINDOWS\system32\WF.msc
PAUSE
goto main

:test_ping
:: Prueba el acceso a la red
ping 8.8.8.8
PAUSE
goto main

:block_app
:: Bloquear una aplicación específica
Echo Arrastra a esta ventana el ejecutable (APP) o escribe la ruta completa entre comillas: "C:/ruta_completa"
set /p dir=^>^>^> 
netsh advfirewall firewall add rule name="Bloquear App" dir=out action=block program=%dir%
PAUSE
goto main

:view_ports
:: Ver los puertos activos
netstat -ano
PAUSE
goto main

:deactivate_firewall
:: Desactivar todas las reglas aplicadas
netsh advfirewall firewall delete rule name="Bloquear todo el tráfico saliente"
netsh advfirewall firewall delete rule name="Bloquear todo el tráfico entrante"

FOR %%P IN (%PORTS%) DO (
    netsh advfirewall firewall delete rule name="Bloquear puerto %%P"
)

netsh advfirewall reset
PAUSE
goto main

exit
