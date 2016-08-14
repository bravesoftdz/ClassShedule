@echo off
rem Отключает вывод команды вызова в консоль
del EMP.FDB
rem Удаляет файл EMP.FDB, находящийся в той-же папке, что и bat-файл
"%ProgramFiles%\Firebird\Firebird_2_5\bin\isql.exe" -i emp2.sql
rem Загрузка sql файла в СУБД
echo Operation complete
rem Вывод текста в консоль, для русских символов нужно использовать кодировку OEM 866
pause
rem Вывод текста "Для продолжения нажмите любую клавишу..."