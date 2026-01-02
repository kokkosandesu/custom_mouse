#Requires AutoHotkey v2.0
; mouse_shortcuts.ahk
; 目的：単体の左/右クリック動作は残しつつ、5ボタンマウスのカスタム割当てを行う

; --- 設定（調整可） ---
; 同時押し判定で少し待つ（ミリ秒）
comboDetectDelay := 50
; 右クリック＋中クリック → Ctrl+A
RButton & MButton::Send "^a"


; --- ユーティリティ関数 ---
IsDown(key) => GetKeyState(key, "P")  ; 押下中判定

; --- XButton1（戻る）押下ハンドラ ---
XButton1:: {
    Sleep comboDetectDelay  ; 同時押し判定の猶予
    ; 1) 戻る＋進む（両方押し） -> Alt+Tab
    if IsDown("XButton2") {
        Send "{Alt down}{Tab}{Alt up}"
        return
    }
    ; 2) 左クリック＋戻る -> Ctrl+Z (取り消し)
    if IsDown("LButton") {
        Send "^z"
        return
    }
    ; 3) 右クリック＋戻る -> Ctrl+F (検索)
    if IsDown("RButton") {
        Send "^f"
        return
    }

    
    ; 4) 単体：Copy (Ctrl+C)
    Send "^c"
}

; --- XButton2（進む）押下ハンドラ ---
XButton2:: {
    Sleep comboDetectDelay
    ; 1) 進む＋戻る（両方押し） -> Alt+Tab
    if IsDown("XButton1") {
        Send "{Alt down}{Tab}{Alt up}"
        return
    }
    ; 2) 左クリック＋進む -> Ctrl+Y (やり直し)
    if IsDown("LButton") {
        Send "^y"
        return
    }
    ; 3) 右クリック＋進む -> Ctrl+H (置換)
    if IsDown("RButton") {
        Send "^h"
        return
    }
    ; 4) 単体：Paste (Ctrl+V)
    Send "^v"
}

; --- ホイール関連：優先順に「両方押し」「XButton1押し」「XButton2押し」 ---
; ※ #HotIf は上から評価されるので「両方押し」条件を先に置く。

#HotIf (IsDown("XButton1") && IsDown("XButton2"))
WheelUp:: { ; 両方押し＋ホイール上 -> アプリ選択（Alt+Tab進む）
    Send "{Alt down}{Tab}{Alt up}"
}
WheelDown:: { ; 両これ
}
#HotIf

#HotIf IsDown("XButton1")
WheelUp:: { ; 戻る押し＋ホイール上 -> ズームイン (Ctrl+WheelUp)
    Send "{Ctrl down}{WheelUp}{Ctrl up}"
}
WheelDown:: { ; 戻る押し＋ホイール下 -> ズームアウト (Ctrl+WheelDown)
    Send "{Ctrl down}{WheelDown}{Ctrl up}"
}
#HotIf

#HotIf IsDown("XButton2")
WheelUp:: { ; 進む押し＋ホイール上 -> ページ送り上 (PageUp)
    Send "{PgUp}"
}
WheelDown:: { ; 進む押し＋ホイール下 -> ページ送り下 (PageDown)
    Send "{PgDn}"
}
#HotIf

; --- 補助：左/右/中クリックは何もしない定義を入れていないため単体動作はそのまま動作します ---
; もし特定アプリで無効化したい場合は #If WinActive("アプリ名") を利用してください。
