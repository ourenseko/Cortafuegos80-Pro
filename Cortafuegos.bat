@ECHO OFF
TITULO CORTAFUEGOS80
COLOR 02

:main
cls
ECHO INTRODUCE UN NUMERO DE PROGRAMA
ECHO. [1] ACTIVAR CORTAFUEGOS
ECHO. [0] DESACTIVAR CORTAFUEGOS
set /p n=^>^>^> 
goto handle_choice

:handle_choice
IF "%n%"=="1" GOTO activate_firewall
IF "%n%"=="0" GOTO deactivate_firewall
goto main

:activate_firewall
:: Bloqueando todo el tráfico
netsh advfirewall firewall add rule name="Bloquear todo el tráfico saliente" dir=out action=block protocol=TCP localport=any
netsh advfirewall firewall add rule name="Bloquear todo el tráfico saliente" dir=out action=block protocol=UDP localport=any
netsh advfirewall firewall add rule name="Bloquear todo el tráfico entrante" dir=in action=block protocol=TCP localport=any
netsh advfirewall firewall add rule name="Bloquear todo el tráfico entrante" dir=in action=block protocol=UDP localport=any
netsh advfirewall set allprofiles state on
PAUSE
goto main

:deactivate_firewall
:: Desactivar todas las reglas aplicadas
netsh advfirewall firewall delete rule name="Bloquear todo el tráfico saliente"
netsh advfirewall firewall delete rule name="Bloquear todo el tráfico entrante"
netsh advfirewall reset
PAUSE
goto main

exit
