/*
Script: Ghost
Συγγραφέας: Tasos
Έτος: 2025
MIT License
Copyright (c) 2025 Tasos
LEGITIMATE PRANK SOFTWARE - NOT MALWARE
This is a harmless prank application that:
- Does NOT access files without permission
- Does NOT send data over network
- Does NOT install anything
- Does NOT modify system settings
- ONLY creates temporary visual/audio effects
*/
; ═══════════════════════════════════════════════════════
; 👻 GHOST v1.0 - AutoHotkey v2
; ═══════════════════════════════════════════════════════
#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

if !DirExist("sounds") {
    MsgBox "ΣΦΑΛΜΑ: Ο φάκελος 'sounds' δεν βρέθηκε!`n`nΔημιούργησε τον φάκελο και πρόσθεσε τα αρχεία ήχων (1.mp3 έως 35.mp3)", "Σφάλμα", "IconX"
    ExitApp
}

OnError CatchError

CatchError(exception, mode) {
    if (mode = "Return")
        return true
    MsgBox "Σφάλμα: " exception.Message "`n`nΤο πρόγραμμα θα κλείσει.", "Ghost Error", 16
    ExitApp
}

TraySetIcon "shell32.dll", 238
A_IconTip := "👻 Ghost"

result := MsgBox("
(
⚠️ ΠΡΟΕΙΔΟΠΟΙΗΣΗ - GHOST ⚠️

Αυτό το πρόγραμμα είναι ΦΑΡΣΑ και θα:
• Ανοίξει αυτόματα Notepad και Paint
• Θα γράψει τρομακτικά μηνύματα
• Θα ζωγραφίσει ανατριχιαστικές εικόνες
• Θα μετακινήσει παράθυρα στην οθόνη
• Θα εμφανίσει ψεύτικα μηνύματα λάθους

⚠️ ΣΗΜΑΝΤΙΚΟ:
- Χρησιμοποίησε ΜΟΝΟ για φάρσες με συγκατάθεση
- ΜΗΝ το χρησιμοποιήσεις σε άτομα με προβλήματα υγείας
- Ctrl+Esc για άμεση έξοδο ανά πάσα στιγμή

Συμφωνείς να συνεχίσεις;
)", "👻 Ghost - Συγκατάθεση Χρήστη", "YesNo Icon! Default2")

if (result = "No") {
    MsgBox "Το πρόγραμμα θα κλείσει. Ευχαριστούμε!", "Ακύρωση", "Iconi T1"
    ExitApp
}

global IDLE_TIME := 0
global lastMouseX := 0
global lastMouseY := 0
global idleTimer := 0
global eventActive := false
global notepadOpened := false
global paintOpened := false
global scriptActive := false
global lastMessageIndex := 0
global lastDrawingIndex := 0
global scheduledTime := ""
global scheduledActive := false
global fastFearMode := false
global lastEventTime := 0
global COOLDOWN_TIME := 300000
global activeSounds := []

CreateTrayMenu()
ShowSettingsGUI()
SetTimer CheckScheduledTime, 1000

creepyMessages := ["You have 7 days remaining","I'm behind you right now","Your webcam is watching you","Someone is in your house","I know where you live","Stop trying to close me","You can't escape this","I've been here all along","Look at your window","Check under your bed","Did you hear that noise?","I see you...","You are not alone","They are watching","Behind you...","Don't look back","I know what you did","Help me...","It's too late","You can't escape","I'm still here","Why did you do it?","They're coming for you","I never left","Your time is running out","I'm in your room","Look behind you now","Stop ignoring me","Always watching","I've been watching you sleep","You shouldn't have done that","I know your secrets","They told me everything","I'm always here","You can feel me, can't you?","This is your last warning","I'm closer than you think","Your door just opened","I'm getting closer","You shouldn't have opened this","It's too late to turn back","I can smell your fear","Someone accessed your files at 3:33 AM","All your files belong to me","I know what you did last night","The shadow behind you is real","The darkness has teeth","Don't turn around","I'm in your walls","I'm standing right behind you","Don't check the closet","Your heartbeat is so loud","I count your breaths at night","Can you feel my breath?","Closer now","Psst...","Turn around","Behind you","I'm here","Can you hear me?","Don't look","They're coming","Run while you can","Too late","Taste your fear"]

popupMessages := ["You have 7 days remaining","I'm behind you right now","Your webcam is watching you","Someone is in your house","I know where you live","Stop trying to close me","You can't escape this","I've been here all along","Look at your window","Check under your bed","Did you hear that noise?","I see you...","You are not alone","They are watching","Behind you...","Don't look back","I know what you did","Help me...","It's too late","You can't escape","I'm still here","Why did you do it?","They're coming for you","I never left","Your time is running out","I'm in your room","Look behind you now","Stop ignoring me","Always watching","I've been watching you sleep","You shouldn't have done that","I know your secrets","They told me everything","I'm always here","You can feel me, can't you?","This is your last warning","I'm closer than you think","Your door just opened","I'm getting closer","You shouldn't have opened this","It's too late to turn back","I can smell your fear","Someone accessed your files at 3:33 AM","All your files belong to me","I know what you did last night","The shadow behind you is real","The darkness has teeth","Don't turn around","I'm in your walls","I'm standing right behind you","Don't check the closet","Your heartbeat is so loud","I count your breaths at night","Can you feel my breath?","Closer now","Psst...","Turn around","Behind you","I'm here","Can you hear me?","Don't look","They're coming","Run while you can","Too late","Taste your fear"]

^Esc::{
    CleanupSounds()
    ExitApp
}

CreateTrayMenu() {
    A_TrayMenu.Delete()
    A_TrayMenu.Add("👻 Ghost", (*) => "")
    A_TrayMenu.Disable("👻 Ghost")
    A_TrayMenu.Add()
    A_TrayMenu.Add("👁️ Απόκρυψη Script", (*) => HideScriptSimple())
    A_TrayMenu.Add()
    timeMenu := Menu()
    timeMenu.Add("⏱️ 1 λεπτό", (*) => SetIdleTime(1))
    timeMenu.Add("⏱️ 3 λεπτά", (*) => SetIdleTime(3))
    timeMenu.Add("⏱️ 5 λεπτά", (*) => SetIdleTime(5))
    timeMenu.Add("⏱️ 10 λεπτά", (*) => SetIdleTime(10))
    timeMenu.Add("⏱️ 15 λεπτά", (*) => SetIdleTime(15))
    timeMenu.Add("⏱️ 20 λεπτά", (*) => SetIdleTime(20))
    timeMenu.Add("⏱️ 30 λεπτά", (*) => SetIdleTime(30))
    timeMenu.Add()
    timeMenu.Add("⚙️ Προσαρμοσμένος χρόνος...", (*) => ShowSettingsGUI())
    A_TrayMenu.Add("⏱️ Χρόνος Αδράνειας", timeMenu)
    A_TrayMenu.Add()
    cooldownMenu := Menu()
    cooldownMenu.Add("⏳ 1 λεπτό", (*) => SetCooldown(1))
    cooldownMenu.Add("⏳ 3 λεπτά", (*) => SetCooldown(3))
    cooldownMenu.Add("⏳ 5 λεπτά (default)", (*) => SetCooldown(5))
    cooldownMenu.Add("⏳ 10 λεπτά", (*) => SetCooldown(10))
    cooldownMenu.Add("⏳ 15 λεπτά", (*) => SetCooldown(15))
    A_TrayMenu.Add("⏳ Cooldown Period", cooldownMenu)
    A_TrayMenu.Add()
    A_TrayMenu.Add("🕐 Προγραμματισμός Ώρας", (*) => ShowScheduleGUI())
    A_TrayMenu.Add("🚫 Ακύρωση Προγραμματισμού", (*) => CancelSchedule())
    A_TrayMenu.Disable("🚫 Ακύρωση Προγραμματισμού")
    A_TrayMenu.Add()
    A_TrayMenu.Add("✅ Ενεργοποίηση", MenuActivate)
    A_TrayMenu.Add("⛔ Απενεργοποίηση", MenuDeactivate)
    A_TrayMenu.Add()
    A_TrayMenu.Add("❌ Έξοδος", (*) => ExitApp())
    A_TrayMenu.Disable("✅ Ενεργοποίηση")
}

SetIdleTime(minutes) {
    global IDLE_TIME, scriptActive
    IDLE_TIME := minutes * 60000
    if !scriptActive
        ActivateScript()
    TrayTip "⏱️ Χρόνος Ενημερώθηκε", "Νέος χρόνος αδράνειας: " minutes " λεπτά", 1
    UpdateTrayTooltip()
}

SetCooldown(minutes) {
    global COOLDOWN_TIME
    COOLDOWN_TIME := minutes * 60000
    TrayTip "⏳ Cooldown Ενημερώθηκε", "Νέο cooldown period: " minutes " λεπτά", 1
    UpdateTrayTooltip()
}

MenuActivate(*) {
    global IDLE_TIME
    if (IDLE_TIME = 0) {
        MsgBox "Παρακαλώ επίλεξε πρώτα χρόνο αδράνειας!", "⚠️ Προσοχή", 48
        return
    }
    ActivateScript()
}

MenuDeactivate(*) {
    DeactivateScript()
}

ActivateScript() {
    global scriptActive, idleTimer
    scriptActive := true
    idleTimer := 0
    SetTimer CheckIdle, 1000
    A_TrayMenu.Disable("✅ Ενεργοποίηση")
    A_TrayMenu.Enable("⛔ Απενεργοποίηση")
    TrayTip "✅ Script Ενεργό", "Το Ghost είναι πλέον ενεργό!`nCtrl+Esc για έξοδο", 1
    UpdateTrayTooltip()
}

DeactivateScript() {
    global scriptActive, idleTimer
    scriptActive := false
    idleTimer := 0
    SetTimer CheckIdle, 0
    A_TrayMenu.Enable("✅ Ενεργοποίηση")
    A_TrayMenu.Disable("⛔ Απενεργοποίηση")
    TrayTip "⛔ Script Ανενεργό", "Το Ghost είναι πλέον ανενεργό", 1
    UpdateTrayTooltip()
}

UpdateTrayTooltip() {
    global IDLE_TIME, scriptActive, scheduledActive, scheduledTime, fastFearMode, COOLDOWN_TIME
    minutes := IDLE_TIME // 60000
    cooldownMinutes := COOLDOWN_TIME // 60000
    status := scriptActive ? "✅ ΕΝΕΡΓΟ" : "⛔ ΑΝΕΝΕΡΓΟ"
    mode := fastFearMode ? "⚡ Fast Fear" : "👻 Full Fear"
    tooltip := "👻 Ghost - " status
    if (IDLE_TIME > 0)
        tooltip .= "`nΧρόνος: " minutes " λεπτά"
    else
        tooltip .= "`nΧρόνος: Μη ορισμένος"
    tooltip .= "`nMode: " mode "`nCooldown: " cooldownMinutes " λεπτά"
    if (scheduledActive && scheduledTime != "")
        tooltip .= "`n🕐 Προγραμματισμένη: " scheduledTime
    A_IconTip := tooltip
}


ShowSettingsGUI() {
    settingsGui := Gui("+AlwaysOnTop +Border", "Ghost")
    settingsGui.SetFont("s10", "Segoe UI")
    settingsGui.BackColor := "0x0F1419"
    
    ; === CUSTOM TITLE BAR ===
    titleBar := settingsGui.Add("Text", "x0 y0 w700 h50 Background0x1A1F2E")
    settingsGui.Add("Text", "x20 y15 w20 h20 Background0x6366F1 Center", "👻")
    settingsGui.SetFont("s13 bold cFFFFFF")
    settingsGui.Add("Text", "x50 y13 BackgroundTrans", "Ghost")
    settingsGui.SetFont("s9 norm c9CA3AF")
    settingsGui.Add("Text", "x50 y35 BackgroundTrans", "Εργαλείο Αυτοματισμού v1.0")
    
    ; Make title bar draggable
    titleBar.OnEvent("Click", (*) => PostMessage(0xA1, 2,,, "A"))
    
    ; === LEFT PANEL - IDLE MODE ===
    settingsGui.Add("Text", "x0 y50 w350 h570 Background0x151B23")
    
    settingsGui.SetFont("s11 bold c6366F1")
    settingsGui.Add("Text", "x30 y75 BackgroundTrans", "⏱️ ΛΕΙΤΟΥΡΓΙΑ ΑΔΡΑΝΕΙΑΣ")
    
    settingsGui.SetFont("s9 norm cCBD5E1")
    settingsGui.Add("Text", "x30 y105 w290 BackgroundTrans", "Το script ενεργοποιείται αυτόματα όταν`nο υπολογιστής παραμείνει αδρανής")
    
    ; Minutes slider
    settingsGui.Add("Text", "x30 y145 w290 h1 Background0x334155")
    
    settingsGui.SetFont("s9 bold cF59E0B")
    minutesText := settingsGui.Add("Text", "x30 y160 w290 Center BackgroundTrans", "Χρόνος Αδράνειας: 1 λεπτό")
    
    settingsGui.SetFont("s9 norm")
    slider := settingsGui.Add("Slider", "x40 y185 w270 Range1-30 TickInterval5 Thick25 vMinutes Background0x1E293B", 1)
    slider.OnEvent("Change", (*) => minutesText.Text := "Χρόνος Αδράνειας: " slider.Value " " (slider.Value = 1 ? "λεπτό" : "λεπτά"))
    
    settingsGui.SetFont("s8 c64748B")
    settingsGui.Add("Text", "x40 y220 BackgroundTrans", "1'")
    settingsGui.Add("Text", "x285 y220 Right BackgroundTrans", "30'")
    
    ; Cooldown slider
    settingsGui.Add("Text", "x30 y250 w290 h1 Background0x334155")
    
    settingsGui.SetFont("s9 bold c10B981")
    cooldownText := settingsGui.Add("Text", "x30 y265 w290 Center BackgroundTrans", "Cooldown Period: 5 λεπτά")
    
    settingsGui.SetFont("s8 norm c94A3B8")
    settingsGui.Add("Text", "x30 y290 w290 Center BackgroundTrans", "Χρόνος αναμονής μεταξύ events")
    
    settingsGui.SetFont("s9 norm")
    cooldownSlider := settingsGui.Add("Slider", "x40 y315 w270 Range1-15 TickInterval2 Thick25 vCooldown Background0x1E293B", 5)
    cooldownSlider.OnEvent("Change", (*) => cooldownText.Text := "Cooldown Period: " cooldownSlider.Value " " (cooldownSlider.Value = 1 ? "λεπτό" : "λεπτά"))
    
    settingsGui.SetFont("s8 c64748B")
    settingsGui.Add("Text", "x40 y350 BackgroundTrans", "1'")
    settingsGui.Add("Text", "x285 y350 Right BackgroundTrans", "15'")
    
    ; Mode selection
    settingsGui.Add("Text", "x30 y380 w290 h1 Background0x334155")
    
    settingsGui.SetFont("s9 bold cEC4899")
    settingsGui.Add("Text", "x30 y395 w290 Center BackgroundTrans", "Επιλογή Λειτουργίας")
    
    settingsGui.SetFont("s9 norm cE2E8F0")
    idleModeRadio1 := settingsGui.Add("Radio", "x60 y420 w230 Checked Background0x151B23", "👻 Full Fear Mode (Πλήρης)")
    idleModeRadio2 := settingsGui.Add("Radio", "x60 y445 w230 Background0x151B23", "⚡ Fast Fear Mode (Γρήγορο)")
    
    ; Start button
    settingsGui.SetFont("s11 bold cFFFFFF")
    idleBtn := settingsGui.Add("Button", "x50 y555 w250 h50", "🚀 Έναρξη Λειτουργίας")
    idleBtn.OnEvent("Click", (*) => StartScriptIdle(slider.Value, cooldownSlider.Value, settingsGui, idleModeRadio2.Value))
    
    ; === VERTICAL DIVIDER ===
    settingsGui.Add("Text", "x350 y50 w2 h570 Background0x334155")
    
    ; === RIGHT PANEL - SCHEDULED MODE ===
    settingsGui.Add("Text", "x352 y50 w348 h570 Background0x151B23")
    
    settingsGui.SetFont("s11 bold c6366F1")
    settingsGui.Add("Text", "x380 y75 BackgroundTrans", "🕐 ΠΡΟΓΡΑΜΜΑΤΙΣΜΟΣ")
    
    settingsGui.SetFont("s9 norm cCBD5E1")
    settingsGui.Add("Text", "x380 y105 w290 BackgroundTrans", "Το script θα ξεκινήσει αυτόματα`nτην ώρα που θα ορίσεις")
    
    ; Current time
    settingsGui.Add("Text", "x380 y145 w290 h1 Background0x334155")
    
    settingsGui.SetFont("s9 bold c10B981")
    settingsGui.Add("Text", "x380 y160 w290 Center BackgroundTrans", "Τρέχουσα Ώρα")
    settingsGui.SetFont("s12 bold c22C55E")
    currentTimeText := settingsGui.Add("Text", "x380 y185 w290 Center BackgroundTrans", FormatTime(, "HH:mm:ss"))
    global mainTimeText := currentTimeText
    SetTimer UpdateMainTime, 1000
    
    ; Time selection
    settingsGui.Add("Text", "x380 y220 w290 h1 Background0x334155")
    
    settingsGui.SetFont("s9 bold cF59E0B")
    settingsGui.Add("Text", "x380 y235 w290 Center BackgroundTrans", "Ορισμός Ώρας Εκκίνησης")
    
    settingsGui.SetFont("s9 norm cE2E8F0")
    settingsGui.Add("Text", "x400 y260 BackgroundTrans", "Ώρα:")
    settingsGui.Add("Text", "x535 y260 BackgroundTrans", "Λεπτά:")
    
    hours := []
    Loop 24
        hours.Push(Format("{:02}", A_Index - 1))
    hourDDL := settingsGui.Add("DropDownList", "x400 y280 w110 Background0x1E293B cFFFFFF", hours)
    hourDDL.Choose(StrSplit(FormatTime(, "HH:mm"), ":")[1] + 1)
    
    minutes := []
    Loop 60
        minutes.Push(Format("{:02}", A_Index - 1))
    minuteDDL := settingsGui.Add("DropDownList", "x535 y280 w110 Background0x1E293B cFFFFFF", minutes)
    minuteDDL.Choose(1)
    
    ; Cooldown for scheduled mode
    settingsGui.Add("Text", "x380 y320 w290 h1 Background0x334155")
    
    settingsGui.SetFont("s9 bold c10B981")
    cooldownText2 := settingsGui.Add("Text", "x380 y335 w290 Center BackgroundTrans", "Cooldown Period: 5 λεπτά")
    
    settingsGui.SetFont("s8 norm c94A3B8")
    settingsGui.Add("Text", "x380 y360 w290 Center BackgroundTrans", "Χρόνος αναμονής μεταξύ events")
    
    settingsGui.SetFont("s9 norm")
    cooldownSlider2 := settingsGui.Add("Slider", "x390 y385 w270 Range1-15 TickInterval2 Thick25 vCooldown2 Background0x1E293B", 5)
    cooldownSlider2.OnEvent("Change", (*) => cooldownText2.Text := "Cooldown Period: " cooldownSlider2.Value " " (cooldownSlider2.Value = 1 ? "λεπτό" : "λεπτά"))
    
    settingsGui.SetFont("s8 c64748B")
    settingsGui.Add("Text", "x390 y420 BackgroundTrans", "1'")
    settingsGui.Add("Text", "x635 y420 Right BackgroundTrans", "15'")
    
    ; Mode selection for scheduled
    settingsGui.Add("Text", "x380 y450 w290 h1 Background0x334155")
    
    settingsGui.SetFont("s9 bold cEC4899")
    settingsGui.Add("Text", "x380 y465 w290 Center BackgroundTrans", "Επιλογή Λειτουργίας")
    
    settingsGui.SetFont("s9 norm cE2E8F0")
    scheduleModeRadio1 := settingsGui.Add("Radio", "x410 y490 w230 Checked Background0x151B23", "👻 Full Fear Mode (Πλήρης)")
    scheduleModeRadio2 := settingsGui.Add("Radio", "x410 y515 w230 Background0x151B23", "⚡ Fast Fear Mode (Γρήγορο)")
    
    ; Schedule button
    settingsGui.SetFont("s11 bold cFFFFFF")
    scheduleBtn := settingsGui.Add("Button", "x400 y555 w250 h50", "📅 Προγραμματισμός")
    scheduleBtn.OnEvent("Click", (*) => StartScriptScheduled(hourDDL.Text, minuteDDL.Text, cooldownSlider2.Value, settingsGui, scheduleModeRadio2.Value))
    
    ; === FOOTER ===
    settingsGui.Add("Text", "x0 y620 w700 h1 Background0x334155")
    settingsGui.SetFont("s8 c64748B")
    settingsGui.Add("Text", "x0 y630 w700 h40 Center BackgroundTrans", "⚡ Ctrl + Esc για άμεση έξοδο  •  Το script τρέχει στο background")
    
    settingsGui.OnEvent("Close", (*) => CloseMainGUI(settingsGui))
    settingsGui.Show("w700 h670")
}

CloseMainGUI(guiObj) {
    SetTimer UpdateMainTime, 0
    guiObj.Destroy()
}

UpdateMainTime() {
    global mainTimeText
    try {
        mainTimeText.Text := FormatTime(, "HH:mm:ss")
    }
}

StartScriptIdle(minutes, cooldownMinutes, guiObj, isFastFear := false) {
    global IDLE_TIME, fastFearMode, COOLDOWN_TIME
    IDLE_TIME := minutes * 60000
    COOLDOWN_TIME := cooldownMinutes * 60000
    fastFearMode := isFastFear
    SetTimer UpdateMainTime, 0
    guiObj.Destroy()
    if (isFastFear)
        TrayTip "⚡ F.F. Mode Ενεργό!", "Fast Fear Mode: Μόνο ήχοι & pop-ups!`nCooldown: " cooldownMinutes " λεπτά", 2
    else
        TrayTip "👻 Full Fear Mode", "Cooldown Period: " cooldownMinutes " λεπτά", 2
    ActivateScript()
}

StartScriptScheduled(hour, minute, cooldownMinutes, guiObj, isFastFear := false) {
    global scheduledTime, scheduledActive, fastFearMode, COOLDOWN_TIME
    scheduledTime := hour ":" minute
    scheduledActive := true
    fastFearMode := isFastFear
    COOLDOWN_TIME := cooldownMinutes * 60000
    SetTimer UpdateMainTime, 0
    guiObj.Destroy()
    A_TrayMenu.Enable("🚫 Ακύρωση Προγραμματισμού")
    modeText := isFastFear ? "(Fast Fear)" : "(Full Fear)"
    TrayTip "🕐 Προγραμματισμός Ενεργός", "Το script θα ξεκινήσει στις " scheduledTime " " modeText "`nCooldown: " cooldownMinutes " λεπτά", 2
    UpdateTrayTooltip()
}

CheckScheduledTime() {
    global scheduledTime, scheduledActive, eventActive, lastEventTime
    if (!scheduledActive || scheduledTime = "" || eventActive)
        return
    currentTime := FormatTime(, "HH:mm")
    if (currentTime = scheduledTime) {
        scheduledActive := false
        eventActive := true
        lastEventTime := A_TickCount
        TrayTip "⏰ Ώρα Έναρξης!", "Το Ghost ξεκινά ΤΩΡΑ!", 1
        ActivateScript()
        StartHauntingSequence()
    }
}

CheckIdle() {
    global lastMouseX, lastMouseY, idleTimer, eventActive, scriptActive, lastEventTime, COOLDOWN_TIME
    if !scriptActive || eventActive
        return
    timeSinceLastEvent := A_TickCount - lastEventTime
    if (lastEventTime > 0 && timeSinceLastEvent < COOLDOWN_TIME)
        return
    MouseGetPos &currentX, &currentY
    if (currentX != lastMouseX || currentY != lastMouseY) {
        lastMouseX := currentX
        lastMouseY := currentY
        idleTimer := 0
        return
    }
    idleTimer += 1000
    if (idleTimer >= IDLE_TIME) {
        idleTimer := 0
        eventActive := true
        lastEventTime := A_TickCount
        StartHauntingSequence()
    }
}

StartHauntingSequence() {
    global eventActive, notepadOpened, paintOpened, fastFearMode
    Sleep Random(3000, 8000)
    if (fastFearMode) {
        FastFearSequence()
    } else {
        Phase1_CreepyTyping()
        Sleep Random(5000, 10000)
        Phase2_CreepyPaint()
        Sleep Random(3000, 6000)
        Phase3_GlitchEffect()
        Sleep Random(2000, 4000)
        ExtraCreepyEvents()
    }
    notepadOpened := false
    paintOpened := false
    eventActive := false
}

FastFearSequence() {
    global popupMessages, COOLDOWN_TIME
    PlayCreepySound()
    Sleep Random(1000, 2000)
    numPopups := Random(5, 8)
    Loop numPopups {
        msg := popupMessages[Random(1, popupMessages.Length)]
        x := Random(100, A_ScreenWidth - 500)
        y := Random(100, A_ScreenHeight - 250)
        popupStyle := Random(1, 3)
        switch popupStyle {
            case 1: FastFearPopupStyle1(msg, x, y)
            case 2: FastFearPopupStyle2(msg, x, y)
            case 3: FastFearPopupStyle3(msg, x, y)
        }
        if (A_Index < numPopups) {
            PlayCreepySound()
            Sleep Random(2000, 4000)
        }
    }
    PlayCreepySound()
    Sleep 2000
    TrayTip "👻 Fast Fear Complete", "Το event ολοκληρώθηκε. Cooldown: " (COOLDOWN_TIME//60000) " λεπτά", 2
}

FastFearPopupStyle1(msg, x, y) {
    popup := Gui("+AlwaysOnTop -Caption +ToolWindow")
    popup.BackColor := "Black"
    popup.SetFont("s14 cRed", "Courier New")
    popup.Add("Text", "x20 y20 w450", msg)
    popup.Show("x" x " y" y " w490 h100")
    PlayCreepySound()
    Loop 8 {
        popup.Move(x + Random(-5, 5), y + Random(-5, 5))
        Sleep 100
    }
    Sleep 2000
    popup.Destroy()
}

FastFearPopupStyle2(msg, x, y) {
    popup := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    popup.BackColor := "White"
    popup.SetFont("s12 cBlack", "Segoe UI")
    popup.Add("Text", "x0 y0 w490 h30 Background0x000080 cWhite Center", "⚠️ System Error")
    popup.SetFont("s40 cRed Bold")
    popup.Add("Text", "x20 y50 w60 h60", "⨯")
    popup.SetFont("s11 cBlack", "Segoe UI")
    popup.Add("Text", "x90 y55 w380", msg)
    popup.SetFont("s10", "Segoe UI")
    okBtn := popup.Add("Button", "x390 y130 w80 h30", "OK")
    okBtn.OnEvent("Click", (*) => popup.Destroy())
    popup.Show("x" x " y" y " w490 h180")
    Loop 10 {
        popup.Move(x + Random(-3, 3), y + Random(-3, 3))
        Sleep 80
    }
    Sleep 2500
    try popup.Destroy()
}

FastFearPopupStyle3(msg, x, y) {
    popup := Gui("+AlwaysOnTop -Caption +ToolWindow")
    popup.BackColor := "0x001100"
    popup.SetFont("s13 cLime", "Consolas")
    popup.Add("Text", "x5 y5 w480 h90 Background0x003300")
    popup.Add("Text", "x10 y10 w470 h80 Background0x001100")
    popup.Add("Text", "x15 y15 w450", msg)
    popup.Show("x" x " y" y " w490 h100")
    Loop 15 {
        popup.Move(x + Random(-10, 10), y + Random(-10, 10))
        if (Random(1, 3) = 1) {
            colors := ["cLime", "cRed", "cWhite", "cYellow"]
            popup.SetFont("s13 " colors[Random(1, colors.Length)], "Consolas")
        }
        Sleep 60
    }
    Sleep 1500
    popup.Destroy()
}

Phase1_CreepyTyping() {
    global creepyMessages, notepadOpened, lastMessageIndex
    if notepadOpened
        return
    Run "notepad.exe"
    notepadOpened := true
    try {
        WinWait "ahk_exe notepad.exe", , 5
        Sleep 500
        WinMaximize "ahk_exe notepad.exe"
        Sleep 300
        WinActivate "ahk_exe notepad.exe"
        Sleep 300
        WinGetPos &winX, &winY, &winW, &winH, "ahk_exe notepad.exe"
        centerX := winX + (winW // 2)
        centerY := winY + (winH // 2)
        Click centerX, centerY
        Sleep 500
    } catch {
        Sleep 2000
    }
    newIndex := GetDifferentRandomIndex(creepyMessages.Length, lastMessageIndex)
    lastMessageIndex := newIndex
    message := creepyMessages[newIndex]
    PlayCreepySound()
    Loop Parse message {
        Send A_LoopField
        Sleep Random(100, 400)
        if (Random(1, 5) = 1) {
            try GlitchWindow("ahk_exe notepad.exe")
        }
    }
    Sleep 1000
    Loop 5 {
        Send "{Home}+{End}"
        Sleep 200
        Send "{Delete}"
        Sleep 100
        SendText message
        Sleep Random(300, 700)
    }
    Loop 10 {
        try GlitchWindow("ahk_exe notepad.exe")
        Sleep 50
    }
    Sleep 500
    try WinRestore "ahk_exe notepad.exe"
}


GetDifferentRandomIndex(maxIndex, lastIndex) {
    if (maxIndex <= 1)
        return 1
    newIndex := Random(1, maxIndex)
    while (newIndex = lastIndex && maxIndex > 1) {
        newIndex := Random(1, maxIndex)
    }
    return newIndex
}

Phase2_CreepyPaint() {
    global paintOpened, lastDrawingIndex
    if paintOpened
        return
    Run "mspaint.exe"
    paintOpened := true
    try {
        WinWait "ahk_exe mspaint.exe", , 5
        Sleep 500
        WinMaximize "ahk_exe mspaint.exe"
        Sleep 300
        WinActivate "ahk_exe mspaint.exe"
        Sleep 300
        WinGetPos &winX, &winY, &winW, &winH, "ahk_exe mspaint.exe"
        centerX := winX + (winW // 2)
        centerY := winY + (winH // 2)
        Click centerX, centerY
        Sleep 500
    } catch {
        Sleep 2000
    }
    PlayCreepySound()
    drawChoice := GetDifferentRandomIndex(20, lastDrawingIndex)  ; Αύξησα από 7 σε 20
    lastDrawingIndex := drawChoice
    switch drawChoice {
        case 1: DrawSkull()
        case 2: DrawEye()
        case 3: DrawPentagram()
        case 4: DrawHandprint()
        case 5: DrawSpider()
        case 6: DrawGhost()
        case 7: DrawCreepyText()
        case 8: Draw666()
        case 9: DrawInvertedCross()
        case 10: DrawDevil()
        case 11: DrawDemonicSymbol()
        case 12: DrawPossessedFace()
        case 13: DrawSacrificeAltar()
        case 14: DrawDemonicRunes()
        case 15: DrawVoodooSkull()
        case 16: DrawChainedSouls()
        case 17: DrawBloodMoon()
        case 18: DrawNecromancerCircle()
        case 19: DrawDemonicPortal()
        case 20: DrawCursedDoll()
    }
    Sleep 2000
    PlayCreepySound()
    Loop 15 {
        try GlitchWindow("ahk_exe mspaint.exe")
        Sleep 70
    }
    Sleep 500
    try WinRestore "ahk_exe mspaint.exe"
}

; === ΑΡΧΙΚΑ ΣΧΕΔΙΑ ===

DrawSkull() {
    Sleep 500
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    DrawCircle(centerX, centerY, 80)
    Sleep 500
    DrawCircle(centerX - 30, centerY - 20, 15)
    Sleep 300
    DrawCircle(centerX + 30, centerY - 20, 15)
    Sleep 500
    DrawTriangle(centerX, centerY + 10)
    Sleep 500
    MouseClickDrag "Left", centerX - 40, centerY + 50, centerX + 40, centerY + 50, 2
    Sleep 300
}

DrawCircle(x, y, radius) {
    angle := 0
    lastX := x + radius
    lastY := y
    Loop 36 {
        angle += 10
        newX := x + Round(radius * Cos(angle * 0.0174533))
        newY := y + Round(radius * Sin(angle * 0.0174533))
        MouseClickDrag "Left", lastX, lastY, newX, newY, 1
        lastX := newX
        lastY := newY
        Sleep 30
    }
}

DrawTriangle(x, y) {
    MouseClickDrag "Left", x, y, x - 15, y + 25, 2
    Sleep 100
    MouseClickDrag "Left", x - 15, y + 25, x + 15, y + 25, 2
    Sleep 100
    MouseClickDrag "Left", x + 15, y + 25, x, y, 2
}

DrawEye() {
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    DrawOval(centerX, centerY, 120, 70)
    Sleep 500
    DrawCircle(centerX, centerY, 40)
    Sleep 300
    DrawCircle(centerX, centerY, 20)
    Sleep 300
    Loop 6 {
        startX := centerX + Random(-80, 80)
        startY := centerY + Random(-40, 40)
        endX := centerX + Random(-120, 120)
        endY := centerY + Random(-70, 70)
        MouseClickDrag "Left", startX, startY, endX, endY, 1
        Sleep 200
    }
}

DrawPentagram() {
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    radius := 100
    DrawCircle(centerX, centerY, radius + 10)
    Sleep 500
    points := []
    Loop 5 {
        angle := (A_Index - 1) * 72 - 90
        x := centerX + Round(radius * Cos(angle * 0.0174533))
        y := centerY + Round(radius * Sin(angle * 0.0174533))
        points.Push({x: x, y: y})
    }
    order := [1, 3, 5, 2, 4, 1]
    Loop order.Length - 1 {
        p1 := points[order[A_Index]]
        p2 := points[order[A_Index + 1]]
        MouseClickDrag "Left", p1.x, p1.y, p2.x, p2.y, 2
        Sleep 400
    }
}

DrawHandprint() {
    baseX := A_ScreenWidth // 2 - 50
    baseY := A_ScreenHeight // 2 + 50
    DrawOval(baseX + 40, baseY, 60, 80)
    Sleep 300
    fingers := [{x: baseX, len: 50}, {x: baseX + 20, len: 70}, {x: baseX + 40, len: 80}, {x: baseX + 60, len: 75}, {x: baseX + 80, len: 60}]
    for finger in fingers {
        DrawOval(finger.x, baseY - finger.len // 2, 15, finger.len)
        Sleep 200
    }
    Loop 8 {
        dropX := baseX + Random(-20, 100)
        dropY := baseY + Random(80, 150)
        MouseClickDrag "Left", dropX, dropY, dropX, dropY + Random(10, 30), 1
        Sleep 150
    }
}

DrawSpider() {
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    DrawCircle(centerX, centerY - 15, 25)
    Sleep 200
    DrawCircle(centerX, centerY + 20, 35)
    Sleep 300
    legAngles := [-135, -110, -70, -45, 45, 70, 110, 135]
    for angle in legAngles {
        rad := angle * 0.0174533
        x1 := centerX + Round(40 * Cos(rad))
        y1 := centerY + Round(40 * Sin(rad))
        MouseClickDrag "Left", centerX, centerY, x1, y1, 2
        x2 := x1 + Round(45 * Cos(rad + 0.5))
        y2 := y1 + Round(45 * Sin(rad + 0.5))
        MouseClickDrag "Left", x1, y1, x2, y2, 1
        Sleep 150
    }
    DrawCircle(centerX - 8, centerY - 18, 4)
    DrawCircle(centerX + 8, centerY - 18, 4)
}

DrawGhost() {
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    DrawCircle(centerX, centerY - 30, 50)
    Sleep 300
    MouseClickDrag "Left", centerX - 50, centerY - 30, centerX - 55, centerY + 40, 2
    Sleep 200
    points := [{x: centerX - 55, y: centerY + 40}, {x: centerX - 40, y: centerY + 55}, {x: centerX - 20, y: centerY + 45}, {x: centerX, y: centerY + 55}, {x: centerX + 20, y: centerY + 45}, {x: centerX + 40, y: centerY + 55}, {x: centerX + 55, y: centerY + 40}]
    Loop points.Length - 1 {
        p1 := points[A_Index]
        p2 := points[A_Index + 1]
        MouseClickDrag "Left", p1.x, p1.y, p2.x, p2.y, 1
        Sleep 100
    }
    MouseClickDrag "Left", centerX + 55, centerY + 40, centerX + 50, centerY - 30, 2
    Sleep 300
    DrawX(centerX - 20, centerY - 35, 12)
    Sleep 200
    DrawX(centerX + 20, centerY - 35, 12)
    Sleep 300
    DrawCircle(centerX, centerY - 10, 8)
}

DrawCreepyText() {
    startX := A_ScreenWidth // 2 - 150
    startY := A_ScreenHeight // 2
    messages := ["HELP", "ME"]
    currentY := startY
    for msg in messages {
        currentX := startX
        Loop Parse msg {
            DrawCreepyLetter(A_LoopField, currentX, currentY)
            currentX += 70
            Sleep 300
        }
        currentY += 100
    }
    Loop 15 {
        dropX := Random(startX - 50, startX + 350)
        dropY := Random(startY - 50, currentY + 50)
        MouseClickDrag "Left", dropX, dropY, dropX + Random(-5, 5), dropY + Random(20, 50), 1
        Sleep 100
    }
}

; === ΝΕΑ ΔΕΜΟΝΙΚΑ ΣΧΕΔΙΑ ===

Draw666() {
    ; Ζωγραφίζει τον αριθμό 666 με φλόγες γύρω του
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Κύκλος γύρω από τον αριθμό
    DrawCircle(centerX, centerY, 120)
    Sleep 300
    
    ; Ζωγραφίζει 666
    startX := centerX - 90
    Draw6(startX, centerY)
    Sleep 400
    Draw6(startX + 60, centerY)
    Sleep 400
    Draw6(startX + 120, centerY)
    Sleep 500
    
    ; Φλόγες γύρω
    Loop 8 {
        angle := (A_Index - 1) * 45
        rad := angle * 0.0174533
        flameX := centerX + Round(130 * Cos(rad))
        flameY := centerY + Round(130 * Sin(rad))
        DrawFlame(flameX, flameY)
        Sleep 200
    }
}

Draw6(x, y) {
    ; Πάνω καμπύλη
    DrawOval(x, y - 15, 30, 30)
    Sleep 150
    ; Κάτω κύκλος
    DrawCircle(x, y + 15, 20)
    Sleep 150
}

DrawFlame(x, y) {
    ; Φλόγα σαν τρίγωνο με καμπύλες
    MouseClickDrag "Left", x, y + 20, x - 8, y - 5, 2
    MouseClickDrag "Left", x - 8, y - 5, x, y - 20, 1
    MouseClickDrag "Left", x, y - 20, x + 8, y - 5, 1
    MouseClickDrag "Left", x + 8, y - 5, x, y + 20, 2
}

DrawInvertedCross() {
    ; Ανάποδος σταυρός (Petrine Cross)
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Κύριος σταυρός
    MouseClickDrag "Left", centerX, centerY - 80, centerX, centerY + 80, 3
    Sleep 300
    MouseClickDrag "Left", centerX - 50, centerY + 40, centerX + 50, centerY + 40, 3
    Sleep 300
    
    ; Διπλές γραμμές για πάχος
    MouseClickDrag "Left", centerX - 5, centerY - 80, centerX - 5, centerY + 80, 2
    MouseClickDrag "Left", centerX + 5, centerY - 80, centerX + 5, centerY + 80, 2
    Sleep 300
    
    ; Αίμα που στάζει
    Loop 12 {
        dropX := centerX + Random(-30, 30)
        dropY := Random(centerY + 50, centerY + 120)
        MouseClickDrag "Left", dropX, dropY, dropX + Random(-3, 3), dropY + Random(15, 40), 1
        Sleep 150
    }
    
    ; Κύκλος τριγύρω με αγκάθια
    DrawCircle(centerX, centerY, 110)
    Sleep 200
    Loop 12 {
        angle := (A_Index - 1) * 30
        rad := angle * 0.0174533
        x1 := centerX + Round(110 * Cos(rad))
        y1 := centerY + Round(110 * Sin(rad))
        x2 := centerX + Round(130 * Cos(rad))
        y2 := centerY + Round(130 * Sin(rad))
        MouseClickDrag "Left", x1, y1, x2, y2, 2
        Sleep 100
    }
}

DrawDevil() {
    ; Διάβολος με κέρατα και ουρά
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Κεφάλι
    DrawCircle(centerX, centerY - 30, 50)
    Sleep 300
    
    ; Αριστερό κέρας
    MouseClickDrag "Left", centerX - 35, centerY - 60, centerX - 50, centerY - 95, 2
    MouseClickDrag "Left", centerX - 50, centerY - 95, centerX - 40, centerY - 100, 1
    Sleep 200
    
    ; Δεξί κέρας
    MouseClickDrag "Left", centerX + 35, centerY - 60, centerX + 50, centerY - 95, 2
    MouseClickDrag "Left", centerX + 50, centerY - 95, centerX + 40, centerY - 100, 1
    Sleep 300
    
    ; Μάτια (X)
    DrawX(centerX - 20, centerY - 35, 10)
    Sleep 150
    DrawX(centerX + 20, centerY - 35, 10)
    Sleep 300
    
    ; Διαβολικό χαμόγελο
    angle := 0
    lastX := centerX - 30
    lastY := centerY - 5
    Loop 18 {
        angle += 10
        newX := centerX - 30 + (A_Index * 3.3)
        newY := centerY - 5 + Round(15 * Sin(angle * 0.0174533))
        MouseClickDrag "Left", lastX, lastY, newX, newY, 1
        lastX := newX
        lastY := newY
        Sleep 30
    }
    Sleep 300
    
    ; Κόκκινη λάμψη στα μάτια (κύκλοι)
    DrawCircle(centerX - 20, centerY - 35, 5)
    DrawCircle(centerX + 20, centerY - 35, 5)
    Sleep 200
    
    ; Σώμα με φλόγες
    MouseClickDrag "Left", centerX, centerY + 20, centerX - 40, centerY + 80, 2
    MouseClickDrag "Left", centerX, centerY + 20, centerX + 40, centerY + 80, 2
    Sleep 200
    
    ; Ουρά με αιχμή
    MouseClickDrag "Left", centerX + 30, centerY + 60, centerX + 80, centerY + 40, 2
    MouseClickDrag "Left", centerX + 80, centerY + 40, centerX + 75, centerY + 50, 1
    MouseClickDrag "Left", centerX + 75, centerY + 50, centerX + 85, centerY + 50, 1
    MouseClickDrag "Left", centerX + 85, centerY + 50, centerX + 80, centerY + 40, 1
}

DrawDemonicSymbol() {
    ; Σύμβολο με τρεις συνδεδεμένους κύκλους και ρούνους
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Κεντρικός κύκλος
    DrawCircle(centerX, centerY, 60)
    Sleep 300
    
    ; Τρίγωνο μέσα
    points := []
    Loop 3 {
        angle := (A_Index - 1) * 120 - 90
        x := centerX + Round(45 * Cos(angle * 0.0174533))
        y := centerY + Round(45 * Sin(angle * 0.0174533))
        points.Push({x: x, y: y})
    }
    Loop 3 {
        p1 := points[A_Index]
        p2 := points[Mod(A_Index, 3) + 1]
        MouseClickDrag "Left", p1.x, p1.y, p2.x, p2.y, 2
        Sleep 200
    }
    Sleep 300
    
    ; Τρεις μικρότεροι κύκλοι γύρω
    angles := [0, 120, 240]
    for angle in angles {
        rad := angle * 0.0174533
        x := centerX + Round(100 * Cos(rad))
        y := centerY + Round(100 * Sin(rad))
        DrawCircle(x, y, 30)
        Sleep 200
        ; Σύμβολο μέσα στον κύκλο
        DrawX(x, y, 15)
        Sleep 150
    }
    
    ; Γραμμές που συνδέουν
    for angle in angles {
        rad := angle * 0.0174533
        x := centerX + Round(100 * Cos(rad))
        y := centerY + Round(100 * Sin(rad))
        MouseClickDrag "Left", centerX, centerY, x, y, 2
        Sleep 150
    }
}

DrawPossessedFace() {
    ; Πρόσωπο κατεχόμενο με στραβά χαρακτηριστικά
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Περίγραμμα προσώπου
    DrawOval(centerX, centerY, 100, 140)
    Sleep 300
    
    ; Αριστερό μάτι - μεγάλο και τρελό
    DrawCircle(centerX - 25, centerY - 20, 20)
    Sleep 150
    DrawCircle(centerX - 25, centerY - 20, 10)
    Sleep 150
    DrawCircle(centerX - 25, centerY - 20, 5)
    Sleep 200
    
    ; Δεξί μάτι - μικρό και στραβό
    DrawOval(centerX + 30, centerY - 15, 25, 15)
    Sleep 150
    DrawCircle(centerX + 30, centerY - 15, 7)
    Sleep 200
    
    ; Μύτη - παραμορφωμένη
    MouseClickDrag "Left", centerX, centerY, centerX - 5, centerY + 15, 2
    MouseClickDrag "Left", centerX, centerY, centerX + 8, centerY + 12, 2
    Sleep 200
    
    ; Στόμα - διαστρεβλωμένο χαμόγελο
    points := []
    Loop 10 {
        x := centerX - 40 + (A_Index * 8)
        y := centerY + 30 + Random(-10, 15)
        points.Push({x: x, y: y})
    }
    Loop points.Length - 1 {
        p1 := points[A_Index]
        p2 := points[A_Index + 1]
        MouseClickDrag "Left", p1.x, p1.y, p2.x, p2.y, 2
        Sleep 80
    }
    Sleep 200
    
    ; Δόντια
    Loop 7 {
        toothX := centerX - 35 + (A_Index * 10)
        MouseClickDrag "Left", toothX, centerY + 35, toothX, centerY + 45, 1
        Sleep 80
    }
    Sleep 200
    
    ; Ρωγμές και σημάδια
    Loop 8 {
        startX := centerX + Random(-45, 45)
        startY := centerY + Random(-60, 60)
        endX := startX + Random(-20, 20)
        endY := startY + Random(-25, 25)
        MouseClickDrag "Left", startX, startY, endX, endY, 1
        Sleep 100
    }
    
    ; Αίμα από τα μάτια
    Loop 6 {
        dropX := centerX - 25 + Random(-5, 5)
        dropY := centerY - 5
        MouseClickDrag "Left", dropX, dropY, dropX + Random(-3, 3), dropY + Random(30, 50), 1
        Sleep 150
    }
}

DrawSacrificeAltar() {
    ; Θυσιαστήριο με κερί και σύμβολα
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Βάση θυσιαστηρίου
    MouseClickDrag "Left", centerX - 100, centerY + 60, centerX + 100, centerY + 60, 3
    Sleep 200
    MouseClickDrag "Left", centerX - 90, centerY + 40, centerX + 90, centerY + 40, 2
    Sleep 200
    
    ; Πεντάγραμμο στη βάση
    radius := 30
    points := []
    Loop 5 {
        angle := (A_Index - 1) * 72 - 90
        x := centerX + Round(radius * Cos(angle * 0.0174533))
        y := centerY + 50 + Round(radius * Sin(angle * 0.0174533))
        points.Push({x: x, y: y})
    }
    order := [1, 3, 5, 2, 4, 1]
    Loop order.Length - 1 {
        p1 := points[order[A_Index]]
        p2 := points[order[A_Index + 1]]
        MouseClickDrag "Left", p1.x, p1.y, p2.x, p2.y, 1
        Sleep 200
    }
    Sleep 300
    
    ; Αριστερό κερί
    DrawCandle(centerX - 60, centerY - 20)
    Sleep 300
    
    ; Δεξί κερί
    DrawCandle(centerX + 60, centerY - 20)
    Sleep 300
    
    ; Κρανίο στο κέντρο
    DrawCircle(centerX, centerY - 10, 25)
    Sleep 200
    DrawCircle(centerX - 10, centerY - 15, 5)
    DrawCircle(centerX + 10, centerY - 15, 5)
    Sleep 150
    DrawTriangle(centerX, centerY - 5)
    Sleep 200
    
    ; Σταγόνες αίματος
    Loop 10 {
        dropX := centerX + Random(-80, 80)
        dropY := centerY + Random(20, 55)
        MouseClickDrag "Left", dropX, dropY, dropX + Random(-2, 2), dropY + Random(5, 15), 1
        Sleep 100
    }
}

DrawCandle(x, y) {
    ; Σώμα κεριού
    MouseClickDrag "Left", x - 8, y, x - 8, y + 40, 2
    MouseClickDrag "Left", x + 8, y, x + 8, y + 40, 2
    MouseClickDrag "Left", x - 8, y + 40, x + 8, y + 40, 2
    Sleep 150
    
    ; Φλόγα
    DrawFlame(x, y - 15)
    Sleep 100
    
    ; Λειωμένο κερί
    Loop 3 {
        dripX := x + Random(-6, 6)
        MouseClickDrag "Left", dripX, y + 40, dripX + Random(-2, 2), y + 50, 1
        Sleep 80
    }
}

DrawDemonicRunes() {
    ; Μυστηριώδη σύμβολα και ρούνοι σε κύκλο
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Εξωτερικός κύκλος
    DrawCircle(centerX, centerY, 110)
    Sleep 200
    
    ; Εσωτερικός κύκλος
    DrawCircle(centerX, centerY, 80)
    Sleep 300
    
    ; Κεντρικό σύμβολο - οχτώ ακτίνες
    Loop 8 {
        angle := (A_Index - 1) * 45
        rad := angle * 0.0174533
        x := centerX + Round(70 * Cos(rad))
        y := centerY + Round(70 * Sin(rad))
        MouseClickDrag "Left", centerX, centerY, x, y, 2
        Sleep 150
    }
    Sleep 300
    
    ; Ρούνοι γύρω από τον κύκλο
    Loop 8 {
        angle := (A_Index - 1) * 45
        rad := angle * 0.0174533
        runeX := centerX + Round(95 * Cos(rad))
        runeY := centerY + Round(95 * Sin(rad))
        
        ; Διαφορετικά σύμβολα για κάθε θέση
        switch Mod(A_Index, 4) {
            case 1:
                ; Κάθετη γραμμή με οριζόντιες
                MouseClickDrag "Left", runeX, runeY - 10, runeX, runeY + 10, 2
                MouseClickDrag "Left", runeX - 5, runeY - 5, runeX + 5, runeY - 5, 1
                MouseClickDrag "Left", runeX - 5, runeY + 5, runeX + 5, runeY + 5, 1
            case 2:
                ; Τρίγωνο
                MouseClickDrag "Left", runeX, runeY - 8, runeX - 7, runeY + 8, 1
                MouseClickDrag "Left", runeX - 7, runeY + 8, runeX + 7, runeY + 8, 1
                MouseClickDrag "Left", runeX + 7, runeY + 8, runeX, runeY - 8, 1
            case 3:
                ; X με κύκλο
                DrawX(runeX, runeY, 8)
                DrawCircle(runeX, runeY, 5)
            case 0:
                ; Σπειροειδές
                DrawCircle(runeX, runeY, 7)
                MouseClickDrag "Left", runeX, runeY, runeX + 10, runeY, 1
        }
        Sleep 200
    }
    
    ; Μικρότεροι κύκλοι στις τομές
    Loop 4 {
        angle := (A_Index - 1) * 90 + 45
        rad := angle * 0.0174533
        x := centerX + Round(80 * Cos(rad))
        y := centerY + Round(80 * Sin(rad))
        DrawCircle(x, y, 8)
        Sleep 150
    }
}

DrawVoodooSkull() {
    ; Κρανίο Voodoo με καρφιά και ράμματα
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Κεφάλι
    DrawCircle(centerX, centerY, 70)
    Sleep 300
    
    ; Μάτια - X σε κύκλους
    DrawCircle(centerX - 25, centerY - 15, 18)
    Sleep 150
    DrawX(centerX - 25, centerY - 15, 12)
    Sleep 200
    DrawCircle(centerX + 25, centerY - 15, 18)
    Sleep 150
    DrawX(centerX + 25, centerY - 15, 12)
    Sleep 300
    
    ; Μύτη
    DrawTriangle(centerX, centerY + 5)
    Sleep 200
    
    ; Στόμα με ράμματα
    MouseClickDrag "Left", centerX - 35, centerY + 40, centerX + 35, centerY + 40, 2
    Sleep 200
    Loop 8 {
        stitchX := centerX - 35 + (A_Index * 9)
        MouseClickDrag "Left", stitchX, centerY + 35, stitchX, centerY + 45, 1
        Sleep 80
    }
    Sleep 300
    
    ; Καρφιά που πονάνε
    pins := [{x: centerX - 50, y: centerY - 40, angle: -30}, 
             {x: centerX + 50, y: centerY - 40, angle: 30},
             {x: centerX - 40, y: centerY + 20, angle: -45},
             {x: centerX, y: centerY - 60, angle: 0}]
    
    for pin in pins {
        rad := pin.angle * 0.0174533
        endX := pin.x + Round(40 * Cos(rad))
        endY := pin.y - Round(40 * Sin(rad))
        MouseClickDrag "Left", pin.x, pin.y, endX, endY, 2
        ; Κεφαλή καρφιού
        DrawCircle(endX, endY, 5)
        Sleep 200
    }
    
    ; Ρωγμές
    Loop 6 {
        crackX := centerX + Random(-60, 60)
        crackY := centerY + Random(-50, 50)
        MouseClickDrag "Left", crackX, crackY, crackX + Random(-25, 25), crackY + Random(-25, 25), 1
        Sleep 120
    }
}

DrawChainedSouls() {
    ; Ψυχές δεμένες με αλυσίδες
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Κεντρική αλυσίδα
    Loop 8 {
        linkY := centerY - 80 + (A_Index * 20)
        DrawChainLink(centerX, linkY)
        Sleep 150
    }
    Sleep 300
    
    ; Αριστερή ψυχή
    DrawSoul(centerX - 80, centerY - 20)
    Sleep 300
    ; Αλυσίδα προς αριστερά
    Loop 4 {
        linkX := centerX - (A_Index * 20)
        DrawChainLink(linkX, centerY)
        Sleep 100
    }
    Sleep 300
    
    ; Δεξιά ψυχή
    DrawSoul(centerX + 80, centerY + 20)
    Sleep 300
    ; Αλυσίδα προς δεξιά
    Loop 4 {
        linkX := centerX + (A_Index * 20)
        DrawChainLink(linkX, centerY + 40)
        Sleep 100
    }
    Sleep 300
    
    ; Κάτω ψυχή
    DrawSoul(centerX, centerY + 100)
}

DrawChainLink(x, y) {
    DrawCircle(x, y, 8)
    Sleep 50
}

DrawSoul(x, y) {
    ; Σώμα ψυχής - ωοειδές
    DrawOval(x, y, 40, 60)
    Sleep 200
    
    ; Μάτια - κενά και τρομακτικά
    DrawCircle(x - 10, y - 10, 6)
    DrawCircle(x + 10, y - 10, 6)
    Sleep 150
    
    ; Στόμα που ουρλιάζει
    DrawOval(x, y + 10, 20, 25)
    Sleep 150
    
    ; Κυματιστή αύρα
    Loop 8 {
        angle := (A_Index - 1) * 45
        rad := angle * 0.0174533
        x1 := x + Round(25 * Cos(rad))
        y1 := y + Round(35 * Sin(rad))
        x2 := x + Round(35 * Cos(rad))
        y2 := y + Round(45 * Sin(rad))
        MouseClickDrag "Left", x1, y1, x2, y2, 1
        Sleep 80
    }
}

DrawBloodMoon() {
    ; Ματωμένο φεγγάρι με νυχτερίδες
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2 - 40
    
    ; Το φεγγάρι
    DrawCircle(centerX, centerY, 60)
    Sleep 300
    
    ; Κρατήρες (μικροί κύκλοι)
    Loop 8 {
        craterX := centerX + Random(-40, 40)
        craterY := centerY + Random(-40, 40)
        DrawCircle(craterX, craterY, Random(5, 12))
        Sleep 120
    }
    Sleep 300
    
    ; Αίμα που τρέχει
    Loop 12 {
        bloodX := centerX + Random(-50, 50)
        bloodY := centerY + 60
        endY := bloodY + Random(40, 80)
        ; Κυματιστό αίμα
        lastX := bloodX
        lastY := bloodY
        Loop 5 {
            newX := lastX + Random(-5, 5)
            newY := lastY + 15
            MouseClickDrag "Left", lastX, lastY, newX, newY, 1
            lastX := newX
            lastY := newY
            Sleep 60
        }
        Sleep 100
    }
    Sleep 300
    
    ; Νυχτερίδες
    batPositions := [{x: centerX - 100, y: centerY - 80}, 
                     {x: centerX + 100, y: centerY - 60},
                     {x: centerX - 80, y: centerY + 60},
                     {x: centerX + 90, y: centerY + 50}]
    
    for bat in batPositions {
        DrawBat(bat.x, bat.y)
        Sleep 250
    }
}

DrawBat(x, y) {
    ; Σώμα
    DrawOval(x, y, 15, 20)
    Sleep 80
    
    ; Αριστερή φτερούγα
    MouseClickDrag "Left", x - 7, y, x - 25, y - 15, 1
    MouseClickDrag "Left", x - 25, y - 15, x - 30, y - 5, 1
    MouseClickDrag "Left", x - 30, y - 5, x - 20, y + 5, 1
    MouseClickDrag "Left", x - 20, y + 5, x - 7, y, 1
    Sleep 80
    
    ; Δεξιά φτερούγα
    MouseClickDrag "Left", x + 7, y, x + 25, y - 15, 1
    MouseClickDrag "Left", x + 25, y - 15, x + 30, y - 5, 1
    MouseClickDrag "Left", x + 30, y - 5, x + 20, y + 5, 1
    MouseClickDrag "Left", x + 20, y + 5, x + 7, y, 1
}

DrawNecromancerCircle() {
    ; Κύκλος νεκρομαντείας με κρανία και σύμβολα
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Τρεις ομόκεντροι κύκλοι
    DrawCircle(centerX, centerY, 120)
    Sleep 200
    DrawCircle(centerX, centerY, 90)
    Sleep 200
    DrawCircle(centerX, centerY, 60)
    Sleep 300
    
    ; Πεντάγραμμο στο κέντρο
    radius := 50
    points := []
    Loop 5 {
        angle := (A_Index - 1) * 72 - 90
        x := centerX + Round(radius * Cos(angle * 0.0174533))
        y := centerY + Round(radius * Sin(angle * 0.0174533))
        points.Push({x: x, y: y})
    }
    order := [1, 3, 5, 2, 4, 1]
    Loop order.Length - 1 {
        p1 := points[order[A_Index]]
        p2 := points[order[A_Index + 1]]
        MouseClickDrag "Left", p1.x, p1.y, p2.x, p2.y, 2
        Sleep 200
    }
    Sleep 300
    
    ; Μικρά κρανία γύρω από τον κύκλο
    Loop 6 {
        angle := (A_Index - 1) * 60
        rad := angle * 0.0174533
        skullX := centerX + Round(105 * Cos(rad))
        skullY := centerY + Round(105 * Sin(rad))
        
        ; Μικρό κρανίο
        DrawCircle(skullX, skullY, 15)
        Sleep 100
        DrawCircle(skullX - 5, skullY - 3, 3)
        DrawCircle(skullX + 5, skullY - 3, 3)
        Sleep 150
    }
    Sleep 300
    
    ; Μυστικά γράμματα μεταξύ των κύκλων
    Loop 12 {
        angle := (A_Index - 1) * 30
        rad := angle * 0.0174533
        textX := centerX + Round(75 * Cos(rad))
        textY := centerY + Round(75 * Sin(rad))
        
        ; Μικρά σύμβολα
        DrawX(textX, textY, 5)
        Sleep 80
    }
}

DrawDemonicPortal() {
    ; Πύλη για δαίμονες με στρόβιλο
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Εξωτερικό πλαίσιο
    DrawCircle(centerX, centerY, 110)
    Sleep 200
    
    ; Στρόβιλος (σπείρα)
    angle := 0
    radius := 100
    lastX := centerX + radius
    lastY := centerY
    
    Loop 50 {
        angle += 15
        radius -= 2
        if (radius < 5)
            break
        rad := angle * 0.0174533
        newX := centerX + Round(radius * Cos(rad))
        newY := centerY + Round(radius * Sin(rad))
        MouseClickDrag "Left", lastX, lastY, newX, newY, 1
        lastX := newX
        lastY := newY
        Sleep 40
    }
    Sleep 300
    
    ; Αστραπές που βγαίνουν από την πύλη
    Loop 8 {
        angle := (A_Index - 1) * 45
        rad := angle * 0.0174533
        x1 := centerX + Round(110 * Cos(rad))
        y1 := centerY + Round(110 * Sin(rad))
        
        ; Τρεμάμενη αστραπή
        currentX := x1
        currentY := y1
        Loop 4 {
            nextX := currentX + Round(20 * Cos(rad)) + Random(-10, 10)
            nextY := currentY + Round(20 * Sin(rad)) + Random(-10, 10)
            MouseClickDrag "Left", currentX, currentY, nextX, nextY, 1
            currentX := nextX
            currentY := nextY
            Sleep 60
        }
        Sleep 150
    }
    Sleep 300
    
    ; Σκιές που βγαίνουν
    Loop 6 {
        shadowAngle := Random(0, 360)
        rad := shadowAngle * 0.0174533
        x := centerX + Round(30 * Cos(rad))
        y := centerY + Round(30 * Sin(rad))
        DrawSoul(x, y)
        Sleep 200
    }
}

DrawCursedDoll() {
    ; Καταραμένη κούκλα με κουμπιά για μάτια
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    
    ; Κεφάλι
    DrawCircle(centerX, centerY - 30, 45)
    Sleep 300
    
    ; Κουμπιά για μάτια
    DrawButton(centerX - 15, centerY - 35)
    Sleep 200
    DrawButton(centerX + 15, centerY - 35)
    Sleep 300
    
    ; Ράμματα στο κεφάλι (σαν του Frankenstein)
    Loop 5 {
        stitchY := centerY - 50 + (A_Index * 8)
        MouseClickDrag "Left", centerX - 35, stitchY, centerX + 35, stitchY, 1
        Sleep 80
        ; Κάθετες γραμμές
        Loop 6 {
            stitchX := centerX - 35 + (A_Index * 12)
            MouseClickDrag "Left", stitchX, stitchY - 3, stitchX, stitchY + 3, 1
            Sleep 40
        }
    }
    Sleep 300
    
    ; Στόμα ραμμένο
    MouseClickDrag "Left", centerX - 20, centerY - 15, centerX + 20, centerY - 15, 2
    Loop 6 {
        mouthX := centerX - 20 + (A_Index * 7)
        MouseClickDrag "Left", mouthX, centerY - 18, mouthX, centerY - 12, 1
        Sleep 70
    }
    Sleep 300
    
    ; Σώμα - σαν κουρέλι
    MouseClickDrag "Left", centerX, centerY + 15, centerX - 30, centerY + 70, 2
    MouseClickDrag "Left", centerX, centerY + 15, centerX + 30, centerY + 70, 2
    Sleep 200
    
    ; Χέρια
    MouseClickDrag "Left", centerX - 30, centerY + 30, centerX - 60, centerY + 50, 2
    MouseClickDrag "Left", centerX + 30, centerY + 30, centerX + 60, centerY + 50, 2
    Sleep 300
    
    ; Ρωγμές σε όλο το πρόσωπο
    Loop 10 {
        crackX := centerX + Random(-35, 35)
        crackY := centerY - 30 + Random(-35, 20)
        MouseClickDrag "Left", crackX, crackY, crackX + Random(-15, 15), crackY + Random(-15, 15), 1
        Sleep 100
    }
    Sleep 200
    
    ; Αίμα από τα μάτια
    Loop 4 {
        dropX := centerX - 15 + Random(-3, 3)
        dropY := centerY - 25
        MouseClickDrag "Left", dropX, dropY, dropX + Random(-2, 2), dropY + Random(20, 35), 1
        Sleep 120
    }
    Loop 4 {
        dropX := centerX + 15 + Random(-3, 3)
        dropY := centerY - 25
        MouseClickDrag "Left", dropX, dropY, dropX + Random(-2, 2), dropY + Random(20, 35), 1
        Sleep 120
    }
}

DrawButton(x, y) {
    ; Κουμπί με 4 τρύπες
    DrawCircle(x, y, 10)
    Sleep 80
    DrawCircle(x - 3, y - 3, 2)
    DrawCircle(x + 3, y - 3, 2)
    DrawCircle(x - 3, y + 3, 2)
    DrawCircle(x + 3, y + 3, 2)
}

; === ΒΟΗΘΗΤΙΚΕΣ ΣΥΝΑΡΤΗΣΕΙΣ ===

DrawOval(centerX, centerY, width, height) {
    angle := 0
    lastX := centerX + width // 2
    lastY := centerY
    Loop 36 {
        angle += 10
        rad := angle * 0.0174533
        newX := centerX + Round((width // 2) * Cos(rad))
        newY := centerY + Round((height // 2) * Sin(rad))
        MouseClickDrag "Left", lastX, lastY, newX, newY, 1
        lastX := newX
        lastY := newY
        Sleep 20
    }
}

DrawX(centerX, centerY, size) {
    MouseClickDrag "Left", centerX - size, centerY - size, centerX + size, centerY + size, 2
    Sleep 100
    MouseClickDrag "Left", centerX + size, centerY - size, centerX - size, centerY + size, 2
}

DrawCreepyLetter(letter, x, y) {
    switch letter {
        case "H":
            MouseClickDrag "Left", x, y - 30, x, y + 30, 2
            MouseClickDrag "Left", x, y, x + 20, y, 2
            MouseClickDrag "Left", x + 20, y - 30, x + 20, y + 30, 2
        case "E":
            MouseClickDrag "Left", x, y - 30, x, y + 30, 2
            MouseClickDrag "Left", x, y - 30, x + 20, y - 30, 2
            MouseClickDrag "Left", x, y, x + 15, y, 2
            MouseClickDrag "Left", x, y + 30, x + 20, y + 30, 2
        case "L":
            MouseClickDrag "Left", x, y - 30, x, y + 30, 2
            MouseClickDrag "Left", x, y + 30, x + 20, y + 30, 2
        case "P":
            MouseClickDrag "Left", x, y - 30, x, y + 30, 2
            MouseClickDrag "Left", x, y - 30, x + 20, y - 30, 2
            MouseClickDrag "Left", x + 20, y - 30, x + 20, y, 2
            MouseClickDrag "Left", x + 20, y, x, y, 2
        case "M":
            MouseClickDrag "Left", x, y + 30, x, y - 30, 2
            MouseClickDrag "Left", x, y - 30, x + 10, y, 2
            MouseClickDrag "Left", x + 10, y, x + 20, y - 30, 2
            MouseClickDrag "Left", x + 20, y - 30, x + 20, y + 30, 2
    }
    Loop 3 {
        MouseMove x + Random(-3, 3), y + Random(-3, 3), 0
        Sleep 50
    }
}


Phase3_GlitchEffect() {
    PlayCreepySound()
    Loop 20 {
        GlitchAllWindows()
        Sleep 100
    }
    Loop 15 {
        MouseMove Random(0, A_ScreenWidth), Random(0, A_ScreenHeight), 0
        Sleep Random(50, 150)
    }
    ScreenShake(30)
}

ExtraCreepyEvents() {
    events := Random(1, 3)
    Loop events {
        choice := Random(1, 3)
        switch choice {
            case 1: FakeBSOD()
            case 2: CreepyPopup()
            case 3: AudioWhisper()
        }
        Sleep Random(3000, 7000)
    }
}

FakeBSOD() {
    bsod := Gui("+AlwaysOnTop -Caption +ToolWindow")
    bsod.BackColor := "0x0000AA"
    bsod.SetFont("s20 cWhite", "Consolas")
    bsod.Add("Text", "x50 y50 w800", ":(")
    bsod.Add("Text", "x50 y120 w900", "Your PC ran into a problem and needs to restart.")
    bsod.Add("Text", "x50 y180 w900", "We're just collecting some error info, and then")
    bsod.Add("Text", "x50 y220 w900", "we'll restart for you.")
    bsod.Add("Text", "x50 y300 w900", "CRITICAL_PROCESS_DIED")
    bsod.Show("w" A_ScreenWidth " h" A_ScreenHeight)
    PlayCreepySound()
    Sleep Random(3000, 6000)
    bsod.Destroy()
}

CreepyPopup() {
    global popupMessages
    msg := popupMessages[Random(1, popupMessages.Length)]
    x := Random(100, A_ScreenWidth - 500)
    y := Random(100, A_ScreenHeight - 250)
    popupStyle := Random(1, 3)
    switch popupStyle {
        case 1: CreepyPopupStyle1(msg, x, y)
        case 2: CreepyPopupStyle2(msg, x, y)
        case 3: CreepyPopupStyle3(msg, x, y)
    }
}

CreepyPopupStyle1(msg, x, y) {
    popup := Gui("+AlwaysOnTop -Caption +ToolWindow")
    popup.BackColor := "Black"
    popup.SetFont("s14 cRed", "Courier New")
    popup.Add("Text", "x20 y20 w450", msg)
    popup.Show("x" x " y" y " w490 h100")
    PlayCreepySound()
    Loop 10 {
        popup.Move(x + Random(-5, 5), y + Random(-5, 5))
        Sleep 100
    }
    Sleep 3000
    popup.Destroy()
}

CreepyPopupStyle2(msg, x, y) {
    popup := Gui("+AlwaysOnTop -Caption +ToolWindow +Border")
    popup.BackColor := "White"
    popup.SetFont("s12 cBlack", "Segoe UI")
    popup.Add("Text", "x0 y0 w490 h30 Background0x000080 cWhite Center", "⚠️ System Error")
    popup.SetFont("s40 cRed Bold")
    popup.Add("Text", "x20 y50 w60 h60", "⨯")
    popup.SetFont("s11 cBlack", "Segoe UI")
    popup.Add("Text", "x90 y55 w380", msg)
    popup.SetFont("s10", "Segoe UI")
    okBtn := popup.Add("Button", "x390 y130 w80 h30", "OK")
    okBtn.OnEvent("Click", (*) => popup.Destroy())
    popup.Show("x" x " y" y " w490 h180")
    PlayCreepySound()
    Loop 15 {
        popup.Move(x + Random(-3, 3), y + Random(-3, 3))
        Sleep 80
    }
    Sleep 4000
    try popup.Destroy()
}

CreepyPopupStyle3(msg, x, y) {
    popup := Gui("+AlwaysOnTop -Caption +ToolWindow")
    popup.BackColor := "0x001100"
    popup.SetFont("s13 cLime", "Consolas")
    popup.Add("Text", "x5 y5 w480 h90 Background0x003300")
    popup.Add("Text", "x10 y10 w470 h80 Background0x001100")
    popup.Add("Text", "x15 y15 w450", msg)
    popup.Show("x" x " y" y " w490 h100")
    PlayCreepySound()
    Loop 20 {
        popup.Move(x + Random(-15, 15), y + Random(-15, 15))
        if (Random(1, 3) = 1) {
            colors := ["cLime", "cRed", "cWhite", "cYellow"]
            popup.SetFont("s13 " colors[Random(1, colors.Length)], "Consolas")
        }
        Sleep 50
    }
    Sleep 2000
    popup.Destroy()
}

AudioWhisper() {
    PlayCreepySound()
    Sleep Random(2000, 4000)
    PlayCreepySound()
}

; ═══════════════════════════════════════════════════════
; 🎵 ΠΑΡΑΛΛΗΛΗ ΑΝΑΠΑΡΑΓΩΓΗ ΗΧΩΝ ΜΕ COM
; ═══════════════════════════════════════════════════════

PlayCreepySoundParallel() {
    global activeSounds
    
    soundNum := Random(1, 35)  ; Ένας τυχαίος αριθμός
    soundFile := "sounds\" soundNum ".mp3"
    
    if !FileExist(soundFile)
        return
    
    try {
        wmp := ComObject("WMPlayer.OCX.7")
        wmp.settings.volume := 100
        wmp.settings.autoStart := true
        
        fullPath := A_ScriptDir "\" soundFile  ; Χρησιμοποιούμε το ίδιο
        wmp.URL := fullPath
        
        activeSounds.Push(wmp)
        
        if (activeSounds.Length > 10) {
            activeSounds.RemoveAt(1)
        }
    } catch as err {
        try SoundPlay soundFile
    }
}

PlayCreepySound() {
    ; Wrapper function για backward compatibility
    PlayCreepySoundParallel()
}

CleanupSounds() {
    global activeSounds
    
    for sound in activeSounds {
        try {
            sound.controls.stop()  ; Σταμάτημα πρώτα
            sound.close()
        }
    }
    activeSounds := []
}

GlitchWindow(winTitle) {
    try {
        WinGetPos &x, &y, &w, &h, winTitle
        WinMove x + Random(-10, 10), y + Random(-10, 10), w, h, winTitle
    }
}

GlitchAllWindows() {
    windows := WinGetList()
    for id in windows {
        try {
            if WinExist("ahk_id " id) {
                WinGetPos &x, &y, &w, &h, "ahk_id " id
                WinMove x + Random(-8, 8), y + Random(-8, 8), w, h, "ahk_id " id
            }
        }
    }
}

ScreenShake(iterations) {
    windows := WinGetList()
    Loop iterations {
        for id in windows {
            try {
                if WinExist("ahk_id " id) {
                    WinGetPos &x, &y, &w, &h, "ahk_id " id
                    WinMove x + Random(-15, 15), y + Random(-15, 15), w, h, "ahk_id " id
                }
            }
        }
        Sleep 50
    }
    for id in windows {
        try {
            if WinExist("ahk_id " id) {
                WinGetPos &x, &y, &w, &h, "ahk_id " id
            }
        }
    }
}

ShowScheduleGUI() {
    scheduleGui := Gui("+AlwaysOnTop", "🕐 Προγραμματισμός Ώρας Έναρξης")
    scheduleGui.SetFont("s11", "Segoe UI")
    scheduleGui.BackColor := "0x1a1a1a"
    scheduleGui.SetFont("s14 bold", "Segoe UI")
    scheduleGui.Add("Text", "x20 y20 w360 Center cFF6600", "⏰ ΠΡΟΓΡΑΜΜΑΤΙΣΜΟΣ ΩΡΑΣ")
    scheduleGui.SetFont("s10 norm", "Segoe UI")
    scheduleGui.Add("Text", "x20 y60 w360 cWhite", "Το script θα ξεκινήσει αυτόματα`nτην ώρα που θα ορίσεις:")
    scheduleGui.SetFont("s11 bold", "Segoe UI")
    currentTimeText := scheduleGui.Add("Text", "x20 y110 w360 Center c00FF00", "Τρέχουσα ώρα: " FormatTime(, "HH:mm:ss"))
    global scheduleTimeText := currentTimeText
    SetTimer UpdateScheduleTime, 1000
    scheduleGui.OnEvent("Close", (*) => StopScheduleTimer())
    scheduleGui.SetFont("s11 bold", "Segoe UI")
    scheduleGui.Add("Text", "x20 y150 w160 cWhite", "Ώρα (HH):")
    scheduleGui.Add("Text", "x220 y150 w140 cWhite", "Λεπτά (MM):")
    hours := []
    Loop 24
        hours.Push(Format("{:02}", A_Index - 1))
    hourDDL := scheduleGui.Add("DropDownList", "x20 y180 w160", hours)
    hourDDL.Choose(StrSplit(FormatTime(, "HH:mm"), ":")[1] + 1)
    minutes := []
    Loop 60
        minutes.Push(Format("{:02}", A_Index - 1))
    minuteDDL := scheduleGui.Add("DropDownList", "x220 y180 w140", minutes)
    minuteDDL.Choose(1)
    scheduleGui.SetFont("s9", "Segoe UI")
    scheduleGui.Add("Text", "x20 y230 w360 cFFFF00", "⚡ Το script θα ξεκινήσει ακριβώς την επιλεγμένη ώρα")
    scheduleGui.Add("Text", "x20 y250 w360 cFFFF00", "⚡ Μπορείς να ακυρώσεις από το tray menu")
    scheduleGui.SetFont("s11 bold", "Segoe UI")
    scheduleBtn := scheduleGui.Add("Button", "x50 y290 w140 h40 cWhite", "📅 Προγραμματισμός")
    scheduleBtn.OnEvent("Click", (*) => SetSchedule(hourDDL.Text, minuteDDL.Text, scheduleGui))
    cancelBtn := scheduleGui.Add("Button", "x210 y290 w140 h40 cWhite", "❌ Άκυρο")
    cancelBtn.OnEvent("Click", (*) => CancelScheduleGUI(scheduleGui))
    scheduleGui.Show("w400 h360")
}

SetSchedule(hour, minute, guiObj) {
    global scheduledTime, scheduledActive
    scheduledTime := hour ":" minute
    scheduledActive := true
    SetTimer UpdateScheduleTime, 0
    guiObj.Destroy()
    A_TrayMenu.Enable("🚫 Ακύρωση Προγραμματισμού")
    TrayTip "🕐 Προγραμματισμός Ενεργός", "Το script θα ξεκινήσει στις " scheduledTime, 2
    UpdateTrayTooltip()
}

UpdateScheduleTime() {
    global scheduleTimeText
    try {
        scheduleTimeText.Text := "Τρέχουσα ώρα: " FormatTime(, "HH:mm:ss")
    }
}

StopScheduleTimer() {
    SetTimer UpdateScheduleTime, 0
}

CancelScheduleGUI(guiObj) {
    SetTimer UpdateScheduleTime, 0
    guiObj.Destroy()
}

CancelSchedule() {
    global scheduledTime, scheduledActive
    scheduledActive := false
    scheduledTime := ""
    A_TrayMenu.Disable("🚫 Ακύρωση Προγραμματισμού")
    TrayTip "🚫 Προγραμματισμός Ακυρώθηκε", "Ο προγραμματισμένος χρόνος ακυρώθηκε", 1
    UpdateTrayTooltip()
}

HideScriptSimple() {
    A_IconHidden := true
    TrayTip "👻 Script Αποκρύφθηκε", "Το script τρέχει στο background`nΓια εμφάνιση: Ανοίξτε ξανά το script", 1
}