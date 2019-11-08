@echo 自動安裝彰化縣公文系統
@echo 本程式修改自https://github.com/lyshie/autoeic
@echo off

echo 00_新增暫存資料夾

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

echo 01_關閉通訊錄程式
taskkill /im "Comp.exe" /f >nul 2>&1

echo 02_移除公文製作系統
wmic product where name="文書編輯-公文製作系統" call uninstall >nul 2>&1

echo 03_刪除未自動移除的檔案 (eic*)
del "%windir%\System32\eicdocn.dll"   >nul 2>&1
del "%windir%\System32\eicsecure.dll" >nul 2>&1
del "%windir%\System32\eicsign.dll"   >nul 2>&1
del "%windir%\System32\eicpdf.dll"    >nul 2>&1
del "%windir%\SysWOW64\eicdocn.dll"   >nul 2>&1
del "%windir%\SysWOW64\eicsecure.dll" >nul 2>&1
del "%windir%\SysWOW64\eicsign.dll"   >nul 2>&1
del "%windir%\SysWOW64\eicpdf.dll"    >nul 2>&1

echo 04_移除(備份)既有通訊錄，處理通訊錄異常問題
ren "%adbook%\chcg"  "chcg_%datetime%"  >nul 2>&1
ren "%adbook%\chcg4" "chcg4_%datetime%" >nul 2>&1

REM 備份原本的資料夾
REM IF EXIST "%origin%" (
REM     ren "%origin%" "%backup%" >nul 2>&1
REM ) ELSE (
REM     REM nothing
REM )

echo 05_設置公文系統為首頁
set IEpath=HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main
reg add "%IEpath%" /v "Start Page" /t REG_SZ /d http://gdms.chcg.gov.tw/ /f

echo 06_IE信任網站設定
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


echo 07_下載與安裝公文系統
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

PAUSE echo 08_ESC取消選擇預設開啟的瀏覽器

echo 09_強制關閉使用中的 IE 瀏覽器
taskkill /im "iexplore.exe" /f >nul 2>&1

REM SET "newwindows=HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\New Windows\Allow"
REM echo 將 chcg.gov.tw 網域加入到快顯封鎖的例外網站
REM reg add "%newwindows%" /v "chcg.gov.tw" /t REG_BINARY /d "0000" /f >nul 2>nul

echo 10_下載預設通訊錄
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

echo 11_下載 Unzip
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

echo 12_修正 106-08-01 新版自然人憑證，更新 HiCOSPKCS11_219.dll
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

echo 13_開啟彰化縣公文網站，請使用者登入執行後系統環境檢測
"%ProgramFiles%\Internet Explorer\iexplore.exe" "http://gdms.chcg.gov.tw"

echo 14_開啟文書編輯-公文製作（會自動轉到文書編輯平台，請使用者登入並下載使用者資料）
"%ProgramFiles%\Internet Explorer\iexplore.exe" "C:\eic\docnet\formbinder\login.htm"

echo 15_再次開啟文書編輯-公文製作（通訊錄的同步）
"%ProgramFiles%\Internet Explorer\iexplore.exe" "C:\eic\docnet\formbinder\login.htm"
