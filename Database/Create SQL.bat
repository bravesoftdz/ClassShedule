@echo off
rem �⪫�砥� �뢮� ������� �맮�� � ���᮫�
del EMP.FDB
rem ������ 䠩� EMP.FDB, ��室�騩�� � ⮩-�� �����, �� � bat-䠩�
"%ProgramFiles%\Firebird\Firebird_2_5\bin\isql.exe" -i emp2.sql
rem ����㧪� sql 䠩�� � ����
echo Operation complete
rem �뢮� ⥪�� � ���᮫�, ��� ���᪨� ᨬ����� �㦭� �ᯮ�짮���� ����஢�� OEM 866
pause
rem �뢮� ⥪�� "��� �த������� ������ ���� �������..."