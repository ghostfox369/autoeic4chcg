# 半自動化安裝彰化縣公文系統(semiautoeic)
## 1. 半自動化安裝的項目步驟？
- M_右鍵另存連結「[`semiautoeic.cmd`](https://raw.githubusercontent.com/ghostfox369/autoeic4chcg/master/semiautoeic.cmd)」，右鍵以「系統管理員身分」執行
- A_01_關閉通訊錄程式
- A_02_移除公文製作系統
- A_03_刪除未自動移除的檔案 (eic*)
- A_04_移除(備份)既有通訊錄，處理通訊錄異常問題
- A_05_設置公文系統為首頁（http://gdms.chcg.gov.tw)
- A_06_IE信任網站設定(檔案取自公文系統)，M_請按「確定」
- A_07_下載與安裝公文系統
- M_08_ESC取消「選擇預設開啟的瀏覽器」的提示視窗後請到命令列視窗按下任意鍵繼續(圖002)
- A_09_強制關閉使用中的 IE 瀏覽器
- A_10_下載預設通訊錄(測試中)
- A_11_下載 Unzip，並解壓通訊錄
- A_12_修正 106-08-01 新版自然人憑證，更新 HiCOSPKCS11_219.dll
- M_13_登入[彰化縣公文系統](http://gdms.chcg.gov.tw)，設定「系統環境檢測」
- M_14_自動開啟文書編輯平台，請登入後下載使用者資料
- M_15_自動開啟桌面捷徑「文書編輯-公文製作」，接受`*.cab`檔案下載與安裝
- A_16_等待公文通訊錄同步完成

## 2. 測試環境
- Windows 10 企業版(1903) OK

## 3. 注意事項
- ![001](/001.jpg)

## 4. 作者
- Qing-Zhan Li (@ Ding-Fan elementary school )

## 4. 參考資料
- 原始程式碼取自 https://github.com/lyshie/autoeic
- 哈!!伸港玩資訊!!哈 (http://skjhmis.blogspot.com/2019/09/bat_25.html)
