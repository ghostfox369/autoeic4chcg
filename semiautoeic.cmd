@echo �۰ʦw�˹��ƿ�����t��
@echo ���{���ק��https://github.com/lyshie/autoeic
@echo off

echo 00_�s�W�Ȧs��Ƨ�

md "%~dp0eictemp"

SET "doc_source=https://edit.chcg.gov.tw/kw/docnet/service/formbinder/install/down/docNinstall.msi"
SET "doc_target=%~dp0eictemp\docNinstall.msi"
SET "ieset_source=http://gdms.chcg.gov.tw/HOME/FKI_IEReg.exe"
SET "ieset_target=%~dp0eictemp\FKI_IEReg.exe"
SET "unzip_source=http://www2.cs.uidaho.edu/~jeffery/win32/unzip.exe"
SET "unzip_exec=%~dp0eictemp\unzip.exe"
SET "adbook_source=https://edit.chcg.gov.tw/kw/docnet/service/module/docn/adbook/chcg.zip"
SET "adbook_target=%~dp0eictemp\chcg.zip"
SET "hicos_source=http://api-hisecurecdn.cdn.hinet.net/HiCOS_Client.zip"
SET "hicos_target=%~dp0eictemp\HiCOS_Client.zip"
SET "wget=%~dp0\wget.exe"
SET "adbook=C:\eic\adbook"
SET "downloads=%~dp0eictemp"
SET "hicos_exec=%~dp0eictemp\HiCOS_Client.exe"

FOR /F %%A IN ('WMIC OS GET LocalDateTime ^| FINDSTR \.') DO @SET B=%%A
SET "datetime=%B:~0,8%-%B:~8,6%"
REM SET "backup=eic_%B:~0,8%-%B:~8,6%"

echo 01_�����q�T���{��
taskkill /im "Comp.exe" /f >nul 2>&1

echo 02_��������s�@�t��
wmic product where name="��ѽs��-����s�@�t��" call uninstall >nul 2>&1

echo 03_�R�����۰ʲ������ɮ� (eic*)
del "%windir%\System32\eicdocn.dll"   >nul 2>&1
del "%windir%\System32\eicsecure.dll" >nul 2>&1
del "%windir%\System32\eicsign.dll"   >nul 2>&1
del "%windir%\System32\eicpdf.dll"    >nul 2>&1
del "%windir%\SysWOW64\eicdocn.dll"   >nul 2>&1
del "%windir%\SysWOW64\eicsecure.dll" >nul 2>&1
del "%windir%\SysWOW64\eicsign.dll"   >nul 2>&1
del "%windir%\SysWOW64\eicpdf.dll"    >nul 2>&1

echo 04_����(�ƥ�)�J���q�T���A�B�z�q�T�����`���D
ren "%adbook%\chcg"  "chcg_%datetime%"  >nul 2>&1
ren "%adbook%\chcg4" "chcg4_%datetime%" >nul 2>&1

REM �ƥ��쥻����Ƨ�
REM IF EXIST "%origin%" (
REM     ren "%origin%" "%backup%" >nul 2>&1
REM ) ELSE (
REM     REM nothing
REM )

echo 05_�]�m����t�ά�����
set IEpath=HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main
reg add "%IEpath%" /v "Start Page" /t REG_SZ /d http://gdms.chcg.gov.tw/ /f

echo 06_IE�H�������]�w
IF EXIST "%ieset_target%" (
    REM nothing
) ELSE (
    "%wget%" --no-check-certificate -q -O "%ieset_target%" "%ieset_source%" >nul 2>nul
)
IF EXIST "%ieset_target%" (
    REM nothing
) ELSE (
    bitsadmin /transfer "ieset" /download /priority normal "%ieset_source%" "%ieset_target%"
)
%ieset_target%


echo 07_�U���P�w�ˤ���t��
IF EXIST "%doc_target%" (
    REM nothing
) ELSE (
   "%wget%" --no-check-certificate -q -O "%doc_target%" "%doc_source%" >nul 2>&1
)
IF EXIST "%doc_target%" (
    REM nothing
) ELSE (
    bitsadmin /transfer "docinstall" /download /priority normal "%doc_source%" "%doc_target%"
)
msiexec /i "%doc_target%" /quiet >nul 2>&1

PAUSE echo 08_ESC������ܹw�]�}�Ҫ��s����

echo 09_�j�������ϥΤ��� IE �s����
taskkill /im "iexplore.exe" /f >nul 2>&1

REM SET "newwindows=HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows\Allow"
REM echo �N chcg.gov.tw ����[�J�������ꪺ�ҥ~����
REM reg add "%newwindows%" /v "chcg.gov.tw" /t REG_BINARY /d "0000" /f >nul 2>nul

echo 10_�U���w�]�q�T��
IF EXIST "%adbook_target%" (
    REM nothing
) ELSE (
    "%wget%" --no-check-certificate -q -O "%adbook_target%" "%adbook_source%" >nul 2>nul
)
IF EXIST "%adbook_target%" (
    REM nothing
) ELSE (
    bitsadmin /transfer "adbook" /download /priority normal "%adbook_source%" "%adbook_target%"
)

echo 11_�U�� Unzip
IF EXIST "%unzip_exec%" (
    REM nothing
) ELSE (
    "%wget%" --no-check-certificate -q -O "%unzip_exec%" "%unzip_source%" >nul 2>nul
)
IF EXIST "%unzip_exec%" (
    REM nothing
) ELSE (
    bitsadmin /transfer "unzip" /download /priority normal "%unzip_source%" "%unzip_exec%"
)
%unzip_exec% -o "%adbook_target%" -d "%adbook%"

echo 12_�ץ� 106-08-01 �s���۵M�H���ҡA��s HiCOSPKCS11_219.dll
IF EXIST "%hicos_target%" (
    REM nothing
) ELSE (
    "%wget%" --no-check-certificate -q -O "%hicos_target%" "%hicos_source%" >nul 2>nul
)
IF EXIST "%hicos_target%" (
    REM nothing
) ELSE (
    bitsadmin /transfer "hicos" /download /priority normal "%hicos_source%" "%hicos_target%"
)
%unzip_exec% -o "%hicos_target%" -d "%downloads%"
"%hicos_exec%" /install /passive /quiet /norestart >nul 2>&1

del "%windir%\System32\HiCOSPKCS11_219.dll.old"    >nul 2>&1
del "%windir%\SysWOW64\HiCOSPKCS11_219.dll.old"    >nul 2>&1

ren "%windir%\System32\HiCOSPKCS11_219.dll" "HiCOSPKCS11_219.dll.old"    >nul 2>&1
ren "%windir%\SysWOW64\HiCOSPKCS11_219.dll" "HiCOSPKCS11_219.dll.old"    >nul 2>&1

copy /y "%windir%\System32\HiCOSPKCS11.dll" "%windir%\System32\HiCOSPKCS11_219.dll"    >nul 2>&1
copy /y "%windir%\SysWOW64\HiCOSPKCS11.dll" "%windir%\SysWOW64\HiCOSPKCS11_219.dll"    >nul 2>&1

echo 13_�}�ҹ��ƿ���������A�ШϥΪ̵n�J�����t�������˴�
"%ProgramFiles%\Internet Explorer\iexplore.exe" "http://gdms.chcg.gov.tw"

echo 14_�}�Ҥ�ѽs��-����s�@�]�|�۰�����ѽs�襭�x�A�ШϥΪ̵n�J�äU���ϥΪ̸�ơ^
"%ProgramFiles%\Internet Explorer\iexplore.exe" "C:\eic\docnet\formbinder\login.htm"

echo 15_�A���}�Ҥ�ѽs��-����s�@�]�q�T�����P�B�^
"%ProgramFiles%\Internet Explorer\iexplore.exe" "C:\eic\docnet\formbinder\login.htm"
