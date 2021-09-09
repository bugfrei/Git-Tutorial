function MakeContentFile($filename)
{ 
    $file = New-Item -ItemType File -Name $filename

    [Random] $rnd = [Random]::new()
    $loremLength = $rnd.Next(1, 20)
    
    $content = Invoke-RestMethod -uri "https://baconipsum.com/api/?type=meat-and-filler&sentences=$loremLength"
    Set-Content $file -Value $content
}

function gelb($t) { $t = (rep $t); Write-Host $t -ForegroundColor Yellow }
function grün($t) { $t = (rep $t); Write-Host $t -ForegroundColor Green }
function grau($t) { $t = (rep  $t); Write-Host $t -ForegroundColor Gray }
function rot($t, $lf = 1)
{ 
    $t = (rep $t)
    if ($lf -eq 1)
    {
        Write-Host "`n$t" -ForegroundColor Red 
    }
    else
    {
        Write-Host "$t" -ForegroundColor Red 
    }
}

function rep([string] $t)
{
    return ([string] $t).Replace("#rep", "Repository").Replace("#com", "Commit")
}
Function Init
{
    [CmdletBinding()]
    param(
        $silent = 0
    )
    $dir = "$([System.Environment]::GetFolderPath("user"))\GIT_LESSON1"
    Set-Location c:\
    if (Test-Path $dir)
    {
        Remove-Item $dir -Recurse -Force
    }
    mkdir $dir | Out-Null
    Set-Location $dir


    mkdir Code1 | Out-Null
    Set-Location Code1

    MakeContentFile "text.txt"
    MakeContentFile "datei1.txt"
    MakeContentFile "datei2.txt"

    $hilfe = "Bei Befehlen, die viel auflisten (z.B. git log und auch hier) kann es vorkommen, das die Auflistung mit einem : oder -- Fortsetzung -- endet. In diesem Fall ist das Terminal (PowerShell) zu klein um alles anzuzeigen.
Bei dem : / -- Fortsetzung -- kann folgendes eingegeben werden:
Return : Naechste Zeile (bei : auch Cursor hoch/runter)
Space  : naechste Zeile (bei : auch Bild hoch/runter)
h      : Hilfe (nur bei :)
q      : Ausgabe beenden (auch nötigt am Ende (END))
`nKopieren kann man, in dem man den Bereich markiert und dann ein Rechtsklick darauf macht.
`nDas ^ Zeichen wir eingegeben, in dem man links oben (links neben der 1) die ^ Taste drück und dann das nächste Zeichen oder Space (^! mit ^-Taste gefolgt von den !)
`nTexte in Gelb sind Anweisungen
Texte in Gruen stellen Beispiele dar
Texte in Grau stellen zusätzliche Informationen dar
Texte in Rot stellt die Anweisung oder die Befehlszeile dar, die exakt so eingegeben werden muss
Allen Git-'Befehlen' muss git (=> das eigentliche Programm) vorangestellt werden!
`nZu einem Schritt springen, zurueck, nochmal oder Kapitelwahl mit Inhalt setzt das Tutorial zurück.
D.h. alle Schritte bis zum den gewuenschten Punkt werden EXAKT so wie im Tutorial durchgefuehrt.
Eigene Aktionen werden dabei hinfaellig!
`nEs gibt folgende Befehle (Gross/Kein-Schreibung spielt keine Rolle):
Weiter (oder w)    : Springt zum naechsten Schritt des Tutorials
Anweisung (oder a) : Zeigt nochmal die Anweisung des aktuellen Schrittes
Nochmal (oder n)   : Fuehrt den aktuellen Schritt erneut aus (Achtung: Tutorial wird dabei zurueckgesetzt!)
Zurueck (oder z)   : Springt ein Schritt zurueck (Achtung: Tutorial wird dabei zurueckgesetzt!)
Schritt <nr>       : Springt zum angegeben Schritt (z.B. Schritt 3 oder s 3)
Inhalt             : Zeigt eine Kapiteluebersicht mit der Moeglichkeit ein Kapitel zu waehlen
Init               : Setzt das Tutorial zurueck. Danach faengt man mit w oder weiter bei Schritt 1 an
Hilfe (oder help)  : Liste die Befehle auf (dieser Text). Mit 'Hilfe <Strg+Space> kann angegeben werden, über was man Hilfe möchte.
Info               : Diesen Text
Install            : Informationen zur Installation von git"

    New-Item -ItemType File -Name ".\hilfe.txt"  | Out-Null
    Set-Content Hilfe.txt -Value $hilfe -Encoding utf8


    New-Item -ItemType File -Name "leer.txt" | Out-Null
    if ($silent -eq 0)
    {
        $sprache = Read-Host -Prompt "Willst Du Sprachausgabe? (j/N)"
        if ($sprache -eq "J")
        {
            $global:sprache = $true
        }
        else
        {
            $global:sprache = $false
        }

        if (-not (HasGit))
        {
            rot "Es wurde kein git auf deinem Computer gefunden!"
            gelb "`nDu gelangst nun zum Installationsassistenten für git..."
            Read-Host -Prompt "Drücke Return"
            inst
        }

        $ein = Read-Host -Prompt "Willst Du eine kleine Einführung in die Bedienung des Tutorials? (j/N)"
        if ($ein -eq "J")
        {
            $global:schritt = 10000
            w
            return
        }
        info 
        hilfe
        rot "Gebe zuerst mal Hilfe ein, gefolgt von einem Space und drücke dann die Tabulator-Taste ein paar mal (oder Strg+Space)"
        grau "Das ist das Hilfesystem des Tutorials, ich versuche alles was Probleme machen könnte hier aufzuführen."
        rede "Gebe zuerst mal Hilfe ein, gefolgt von einem Space und drücke dann die Tabulator-Taste ein paar mal (oder Strg+Space)"
        rede "Das ist das Hilfesystem des Tutorials, ich versuche alles was Probleme machen könnte hier aufzuführen."

        rot "Solltest Du noch kein git installiert haben, so bitte inst eingeben."
        rede "Solltest Du noch kein git installiert haben, so bitte inst eingeben."

        rot "`nGebe nun w ein und drücke return."
        rede "Gebe nun w ein und drücke return."
    }
    $global:schritt = 1
}

function Info
{
    [CmdletBinding()]
    param(
    )
    $dir = "$([System.Environment]::GetFolderPath("user"))\GIT_LESSON1\Code1\Hilfe.txt"
    Get-Content $dir | more
}

function rede($t)
{
    if ($global:sprache)
    {
        Add-Type –AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $speak.Speak($t)
    }
}

class Kapitel
{
    [string] $id
    [string] $schritt
    [string] $bezeichnung

    Kapitel($id, $schritt, $bez)
    {
        $this.id = $id
        $this.schritt = $schritt
        $this.bezeichnung = $bez
    }

    [void] Ausgabe()
    {
        $text = $this.id + (" " * (5 - $this.id.Length)) + $this.bezeichnung
        Write-Host $text
    }

    [void] static Titel()
    {
        $text = "Nr.  Kapitelbezeichnung"
        Write-Host $text
    }
    [void] Start()
    {
        Write-Host "Gehe zu $($this.bezeichnung)"
        Schritt $this.schritt 1
    }
}

function Nochmal
{
    [CmdletBinding()]
    [Alias("n")]
    param(
    )

    Schritt (([int]$global:schritt) - 1)
}
function Zurück
{
    [CmdletBinding()]
    [Alias("z", "Zurueck")]
    param(
    )

    Schritt (([int]$global:schritt) - 2)
}



function Anweisung
{
    [CmdletBinding()]
    [Alias("a")]
    param(
    )

    $Global:schritt = $Global:schritt - 1
    Weiter
}

# @Test

function Install
{
    [CmdletBinding()]
    [Alias("Installation", "inst")]
    param(
    )

    While ($true)
    {
        if (HasGit)
        {
            rot "Git ist bereits installiert!"

            rot "`nInitialisiere das Tutorial mit init und starte anschließend den ersten Schritt mit w"
            return
        }
        if (HasChoco)
        {
            $ein = "a"
        }
        else
        {
            Clear-Host
            Write-Host "Willkommen zum Installationsassistenten für git."
            Write-Host "Um eine automatische Installation durchführen zu können, bitte den Assistenten mit q beenden, die PowerShell oder ISE als Administrator starten und das Tutorial-DE.ps1-Skript erneut ausführen und nochmal install eingeben." -ForegroundColor Red
            Write-Host "`nBitte wählen:"
            Write-Host "C.  Chrome mit git Webseite öffnen"
            Write-Host "E.  Edge mit git Webseite öffnen"
            Write-Host "A.  Automatische Installation (benötigt Administrator-Rechte; installiert zuvor Chocolatey und damit dann git)"
            Write-Host "AC. Chocolatey Website in Chrome öffnen"
            Write-Host "AE. Chocolatey Seite in Edge öffnen"
            Write-Host "Q.  Installationsassistenten beenden."
            $ein = Read-Host -Prompt "Bitte wählen (c, e, a, ac, ae, q)"
        }
        if ($ein -eq "q")
        {
            break
        }
        if ($ein -eq "C")
        {
            Start-Process "chrome.exe" "https://git-scm.com/downloads"
        }
        if ($ein -eq "E")
        {
            Start-Process "msedge.exe" "https://git-scm.com/downloads"
        }
        if ($ein -eq "AC" -or ($ein -eq "CC"))
        {
            Start-Process "chrome.exe" "https://chocolatey.org/install"
        }
        if ($ein -eq "AE" -or ($ein -eq "CE"))
        {
            Start-Process "msedge.exe" "https://chocolatey.org/install"
        }
        if ($ein -eq "A")
        {
            if (-not (Test-AdminRecht))
            {
                $Global:schritt = -999
                break
            }
            if (-not (HasChoco))
            {
                rot "Chocolatey wird installiert..."
                Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
                Start-Sleep -Seconds 2
                if (-not (HasChoco))
                {
                    $Global:schritt = -99999
                    break
                }
            }

            choco install git -y --force -force
            $Global:schritt = -9999999
            break
        }
    }
    Clear-Host
    Anweisung
}
function Test-AdminRecht
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function HasChoco()
{
    try
    {
        [string] $c = choco | Out-String
        return ($c.StartsWith("Chocolatey"))
    }
    catch
    {
        
    }
    return $false
}
function HasGit()
{
    try
    {
        [string] $c = git | Out-String
        return ($c.StartsWith("usage"))
    }
    catch
    {
        
    }
    return $false
}


function Hilfe
{
    [CmdletBinding()]
    [Alias("help")]
    param(
        [ValidateSet("Befehle", "^", "Kopieren", "Lange Textausgaben", "Textfarben")]
        $Was = "Befehle"
    )

    Write-Host ""
    if ($Was -eq "Befehle")
    {
        Write-Host "Es gibt folgende Befehle (Groß/Kein-Schreibung spielt keine Rolle):" -ForegroundColor Cyan
        Write-Host "Weiter (oder w)    : Springt zum nächsten Schritt des Tutorials" -ForegroundColor Cyan
        Write-Host "Anweisung (oder a) : Zeigt nochmal die Anweisung des aktuellen Schrittes" -ForegroundColor Cyan
        Write-Host "Nochmal (oder n)   : Führt den aktuellen Schritt erneut aus (Achtung: Tutorial wird dabei zurückgesetzt!)" -ForegroundColor Cyan
        Write-Host "Zurück (oder z)    : Springt ein Schritt zurück (Achtung: Tutorial wird dabei zurückgesetzt!)" -ForegroundColor Cyan
        Write-Host "Schritt <nr>       : Springt zum angegeben Schritt (z.B. Schritt 3 oder s 3)" -ForegroundColor Cyan
        Write-Host "Inhalt             : Zeigt eine Kapitelübersicht mit der Möglichkeit ein Kapitel zu wählen" -ForegroundColor Cyan
        Write-Host "Init               : Setzt das Tutorial zurück. Danach fängt man mit w oder weiter bei Schritt 1 ein" -ForegroundColor Cyan
        Write-Host "Hilfe (oder help)  : Liste die Befehle auf (dieser Text). Mit 'Hilfe <Strg+Space> kann angegeben werden, über was man Hilfe möchte." -ForegroundColor Cyan
        Write-Host "Info               : Kompletter Info Text (der von init)" -ForegroundColor Cyan
        Write-Host "Install            : Informationen zur Installation von git" -ForegroundColor Cyan
    }
    elseif ($Was -eq "Kopieren")
    {
        Write-Host "Kopieren kann man, in dem man den Bereich markiert und dann ein Rechtsklick darauf macht." -ForegroundColor Cyan
    }
    elseif ($Was -eq "^")
    {
        Write-Host "Das ^ Zeichen wir eingegeben, in dem man links oben (links neben der 1) die ^ Taste drück und dann das nächste Zeichen oder Space (^! mit ^-Taste gefolgt von den !)" -ForegroundColor Cyan
    }
    elseif ($Was -eq "Lange Textausgaben")
    {
        Write-Host "Bei Befehlen, die viel auflisten (z.B. git log und auch hier) kann es vorkommen, das die Auflistung mit einem : oder -- Fortsetzung -- endet. In diesem Fall ist das Terminal (PowerShell) zu klein um alles anzuzeigen. -ForegroundColor CyanBei dem : / -- Fortsetzung -- kann folgendes eingegeben werden:
Return : Naechste Zeile (bei : auch Cursor hoch/runter)
Space  : naechste Zeile (bei : auch Bild hoch/runter)
h      : Hilfe (nur bei :)
q      : Ausgabe beenden (auch nötigt am Ende (END))" -ForegroundColor Cyan
    }
    elseif ($Was -eq "Textfarben")
    {
        Write-Host "Texte in Gelb sind Anweisungen
Texte in Gruen stellen Beispiele dar
Texte in Grau stellen zusätzliche Informationen dar
Texte in Rot stellt die Anweisung oder die Befehlszeile dar, die exakt so eingegeben werden muss" -ForegroundColor Cyan
    }
}

function Inhalt
{
    [CmdletBinding()]
    param(
    )
    if ($Global:schritt -gt 9999)
    {
        $alle = @([Kapitel]::new(1, 10000, "Tutorialeinleitung 1"),
            [Kapitel]::new(2, 10006, "Nächster Punkt in der Tutorialeinleitung")
    
        )
    }
    else
    {
        $alle = @([Kapitel]::new(1, 1, "Der Anfang"),
            [Kapitel]::new(2, 3, "Erstes Commit")
    
        )
    }

    <# TODO (Inhalt) Kapitel definieren #>

    [Kapitel]::Titel()
    foreach ($k in $alle)
    {
        $k.Ausgabe()
    }

    $ein = Read-Host -Prompt "`nBitte Nr. eingeben"
    $alle[$ein - 1].Start()
}

function Schritt
{
    [CmdletBinding()]
    [Alias("s")]
    param(
        [int] $nr,
        [int] $silent = 0
    )
    if ($nr -gt 9999)
    {
        $nr -= 9999
    }
    if ($global:schritt -gt 9999)
    {
        $global:schritt = ($nr + 9999)
        w
        return
    }
    if ($silent -eq 0)
    {
        gelb("Springe zum Schritt $nr")
    }
    init 1
    if ($nr -gt 1) { git init }
    if ($nr -gt 2) { git add --all }
    if ($nr -gt 3) { git commit --message "Start" }
    if ($nr -gt 4) { Set-Content -Path leer.txt -Value "Änderung" }
    if ($nr -gt 5)
    {
        Remove-Item .\datei1.txt
        "Inhalt" > inhalt.txt
        git add leer.txt
        git commit --message "kleine Änderung"
    }
    if ($nr -gt 6)
    {
        git add --all
        git commit --message "gelöscht und hinzu"
    }
    if ($nr -gt 11)
    {
        mkdir .\ordner | Out-Null
        @("datei1", "datei2", "datei3") | New-Item -ItemType File -Path { "Ordner\$_.txt" }
        git add --all
        git commit --message "Neuer Ordner"
    }

    <# TODO (Schritt #) Schritt nr erstellen  #>
    $global:schritt = $nr
    weiter
}

function Weiter
{
    [CmdletBinding()]
    [Alias("w")]
    param
    (
        $nr = -1
    )
    if ($nr -eq -1)
    {
        $nr = $global:schritt
    }
    if ($nr -lt -100000)
    {
        gelb "Git ist nun installiert. Die Powershell neu starten (als Administrator ist nicht nötig), das Tutorial-Skript neu ausführen"
        rot "Danach mit init das Tutorial initialisieren und den Anweisungen folgen"
        return
    }
    if ($nr -lt -1000)
    {
        gelb "Bitte die Powershell erneut als Administrator starten, das Tutorial-Skript neu ausführen und erneut inst eingeben."
        rot "Danach wieder den Punkt a für Automatische installation wählen. Danach wird git installiert."
        gelb "Diese Powershell kann geschlossen werden"
        rot "exit"
        return
    }
    if ($nr -lt 0)
    {
        gelb "Bitte die Powershell als Administrator starten, das Tutorial-Skript neu ausführen und erneut inst eingeben."
        gelb "Diese Powershell kann geschlossen werden"
        rot "exit"
        return
    }

    if ($nr -gt 0)
    {
        Clear-Host
        if ($nr -lt 10000)
        {
            $st = "Schritt $nr"; Write-Host (" " * ($st.Length) * 3 + "`n" + " " * ($st.Length) + $st + " " * ($st.Length) + "`n" + " " * ($st.Length) * 3)  -BackgroundColor Gray -ForegroundColor Black
        }
        else
        {
            $st = "Tutorialeinleitung $($nr-9999)"; Write-Host (" " * ($st.Length) * 3 + "`n" + " " * ($st.Length) + $st + " " * ($st.Length) + "`n" + " " * ($st.Length) * 3)  -BackgroundColor Gray -ForegroundColor Black
        }
    }
    switch ($nr)
    {
        10000
        {
            rot "Willkommen beim Git-Tutorial"
            gelb "Während dies Tutorials kannst Du git und alle sämtlichen PowerShell Befehle ausführen."
            gelb "Gesteuert wird das Tutorial mit Tutorialeigenenen Befehlen."
            gelb "Der erste ist Weiter (oder kurz w), damit gelangt man immer zum nächsten Schritt."
            gelb "Im Tutorial wird immer in rot das dargestellt, was Du eingeben musst."
            rot "w"
            break
        }
        10001
        {
            gelb "Damit bist Du zum nächsten Schritt gesprungen. Das kannst Du tun wann immer Du willst!"
            gelb "Aber die notwendigen, in rot, angegeben Schritt mit git-Befehlen solltest Du natürlich gemacht haben, sonnst sind die nächsten Schritte wahrscheinlich nicht durchführbar."
            gelb "`nWenn Du den aktuellen Schritt nochmal machen möchtest, gebe einfach Nochmal oder kurz n ein."
            gelb "Wichtig ist jedoch, das damit das Tutorial auch zurückgesetzt und alles nach Vorgaben bis zum vorherigen Schritt durchgeführt wurde."
            gelb "`nMach diesen Schritt nochmal (beliebig oft) und gehe dann weiter."
            rot "n"
            rot "w" 0
            break
        }
        10002
        {
            gelb "Um den vorherigen Schritt nochmal zu machen, kannst Du Zurück oder kurz z eingeben."
            gelb "Auch hier wird das Tutorial zurück gesetzt und alles bis zum vorherigen Schritt nach Vorgaben durchgeführt."
            gelb "Gehe einmal zurück und dann zweimal weiter."
            rot "z"
            rot "w" 0
            rot "w" 0
            break
        }
        10003
        {
            gelb "Wenn Du durch Ausgaben von Git oder anderen PowerShell-Befehlen die Anweisung nicht mehr sehen kannst, kannst Du dir diese mit Anweisung oder kurz a nochmal anzeigen lassen."
            gelb "Lösche den Bildschirm und zeige dir dann diese Anweisung nochmal an, danach gehts weiter"
            rot "cls"
            rot "a" 0
            rot "w" 0
            break
        }
        10004
        {
            gelb "Wenn Du zu einem bestimmten Schritt springen willst, kannst Du das mit Schritt oder kurz s."
            gelb "Danach die Schrittnummer eingeben. Da wir hier im Tutorialeinleitung 5 sind, gehe zur Einleitung Nr. 6."
            rot "s 6"

            break
        }
        10005
        {
            gelb "Wenn Du mal bestimmte Kapitel des Tutorial machen möchtest, kannst Du dir mit Inhalt eine Kapitelübersicht anzeigen lassen."
            gelb "Dort kannst Du dann wählen in welches Kapitel Du willst."
            gelb "Das Tutorial wird dann mit Vorgaben bis zu diesem Schritt zurückgesetzt."
            gelb "Lasse dir den Inhalt anzeigen und gehe in das Kapitel 1 und nochmal mit inhalt dann aber in Kapitel 2 der Tutorialeinleitung."
            rot "inhalt"
            break
        }
        10006
        {
            gelb "Wenn mal etwas unklar ist, z.B. kennst Du die Befehle nicht mehr. Dann kannst Du die Hilfe verwenden."
            gelb "Nur hilfe zeigt dir die Befehle an."
            gelb "Es gibt aber mehrere Hilfe-Themen. Das zu gibst Du hilfe ein, gefolgt von einem Space und drückst dann die Tabulatortaste um zwischen den Hilfe-Themen zu wechseln."
            gelb "Oder gebe hilfe ein, ein Space und dann Strg+Space um eine Liste der Hilfethemen zu bekommen."
            gelb "Zeige dir einfach ein paar Hilfe-Themen an, dann gehts weiter"            break
            rot "hilfe"
            rot "hilfe <Tabulatortaste><Tabulatortaste...>" 0
            rot "hilfe <Strg+Space>" 0
            rot "w" 0
        }
        10007
        {
            gelb "Wir sind nun am Ende der Tutorialeinleitung. Ein Befehl gibt es noch: init"
            gelb "Dieser initialisiert das Tutorial und beendet somit auch die Einleitung."
            gelb "Danach kannst Du mit den besagten Befehlen arbeiten. Am besten fängst Du dann mit w an und startest damit Schritt 1 des Tutorials."
            rot "init"
            rot "w"
        }
        10008
        {
            gelb "Die Tutorialeinleitung ist schon zuende. Gehe zurück"
            rot "z"
        }
        10009
        {
            gelb "Hey, was willst Du hier?"
            gelb "Ich warte jetzt 15 Sekunden, dann initialisiere ich das Tutorial, fange dann mit w beim Schritt 1 an."
            rot "w"
            $rest = 15
            for ($i = 0; $i -lt 3; $i++)
            {
                Start-Sleep -Seconds 5
                $rest -= 5
                Write-Host "Noch $rest Sekunden..."
            }
            init
            return
        }
        0
        {
            rot "Starte das Tutorial mit w"
            break
        }
        1
        {
            gelb "Git für $dir\Code1 Initialisieren (#rep erstellen)" 
            grau "Der Befehl 'init' erstellt ein leeres #rep im aktuellen Ordner" 
            Write-Host "Und denk daran, mit w (oder weiter) geht es weiter" -ForegroundColor Cyan
            rot "git init"
            break 
        }
        2
        {
            gelb "Als erstes müssen alle Dateien als #com in das #rep aufgenommen werden"
            grau "Der Befehl add fügt Dateien dem #com hinzu. Entwerder einzelln (hier natürlich auch Dateien, die gelöscht wurden)"
            grau "oder alle auf einmal mit git add --all"
            rot "git add --all" 
            break 
        }
        3
        {
            gelb "Nun machen wir den ersten #com und übertragen den aktuellen Stand in das #rep."
            grau "Jedes #com benötigt eine Message, also eine Information zum aktuellen #com. Hier sollte kurz eingetragen werden, was das #com aus macht."
            rot "git commit --message `"Start`""
            break 
        }
        4
        {
            gelb "Nun schreiben wir in die Datei 'leer.txt' eine Zeile mit 'Änderung' und speichern diese ab."
            Read-Host "Bereit? (drücke Return)"
            Invoke-Item leer.txt
            break 
        }
        5
        {
            gelb "Nun möchten wir das diese Änderung in das #rep übertragen wird."
            gelb "Vorher schauen wir uns den Status an. Danach machen wir den #com."
            gelb "Wir füge nur die geänderte leer.txt hinzu. (git add -- all würde auch funktionieren)"
            grau "Alternativ zu --messsage kann auch -m verwendet werden (git commit -m `"kleine Änderung`")"
            rot "git status"
            rot "git add leer.txt" 0
            rot "git commit --message `"kleine Änderung`"" 0

            break 
        }
        6
        {
            gelb "Nun löschen wir die Datei `"datei1.txt`" und erstellen eine neue mit Inhalt."
            gelb "Anschließend lassen wir uns den Status anzeigen und erstellen wieder ein #com."
            grau "Alternativ kann die Änderung auch im Explorer stattfinden, aber mit den hier gezeigten Befehlen ist es einfacher."
            rot "Remove-Item datei1.txt"
            rot "`"Inhalt`" > inhalt.txt" 0
            rot "git status" 0
            rot "git add --all" 0
            rot "git commit --message `"gelöscht und hinzu`"" 0
            break
        }
        7
        {
            gelb "Nun schauen wir uns die Unterschiede zu den #coms an."
            gelb "Der Befehl hierzu heißt 'git diff' - ohne Angabe von Commits vergleicht er den aktuellen Stand der Dateien mit dem letzten (HEAD) #com."
            rot "git diff"
            grau "Zeigt also nichts an (es passiert auch nichts)"
            gelb "Um die #coms aufzulisten schauen wir uns das log an."
            rot "git log"
            grau "Wir sehen 3 #coms, das oberste ist das HEAD-#com."
            gelb "Wir kopieren uns die ersten ca. 8 Zeichen vom Hashcode neben (z.B. 'commit 41eef6b05ca...' vom unteren #com 'Start' und dem darüber 'kleine Änderung'"
            gelb "Das kopierte fügen wir dann beim Befehl an die Stelle <Start_HASH> und <kleine Änderung_HASH>"
            rot "git diff <Start_HASH> <kleine Änderung_HASH>"
            grau "z.B. git diff b604f2b9 0d7f6c77d`nDie korrekte Befehlezeile kann ich nicht auflisten da die Hashcodes immer anderes sind."
            grau "Hier sehen wir das hinzufügen von Änderung in der Datei leer.txt"
            break
        }
        8
        {
            gelb "Kürzer geht es mit ^! am Ende des Hash. Damit wird der angegebene #com mit dem #com davor verglichen."
            gelb "Wir zeigen nochmal alle #coms an und kopieren die ersten ca. 8 Zeichen vom #com-Hash von 'kleine Änderung'."
            gelb "Diesen setzten wir beim Befehl bei <Hash> ein."
            rot "git log"
            rot "git diff <kleine Änderung_HASH>^!" 0
            grau "z.B. git diff 5304232b1^!"
            grau "Das Ergebnis ist das gleiche wie zuvor."
            gelb "Natürlich kann man auch den 'Start'-#com mit dem 'gelöscht und hinzu'-#com vergleichen. Einfach mal probieren."
            break
        }
        9
        {
            gelb "Mit git diff --stat können nur Statistiken über die Änderung eingesehen werden."
            gelb "Einfach den git diff Befehle von zuvor mit einem --stat nach 'diff' erneut ausführen."
            grau "Hierzu die Befehle mit Cursor hoch suchen, ändern und mit return ausführen)"
            grau "z.B. git diff --stat 5304232b1^!"
            break
        }
        10
        {
            gelb "Um Informationen über ein #com zu erhalten verwendet man git show."
            gelb "Hierzu lassen wir uns erstmal wieder die #coms anzeigen und wählen dann irgendein #com Hash, kopieren ca. 8 Zeichen am Anfang und fügen es beim Befehl bei <HASH> ein."
            rot "git show <HASH>"
            grau "Hier sieht man dann den kompletten Hash, den Autor, den Zeitpunkt des #coms, den Namen (Message) und die Änderungen die zu diesem Zeitpunkt vorhanden waren."
            break
        }
        11
        {
            gelb "git show kann noch mehr. Mit"
            rot "git show <HASH>:"
            grau "z.B. git show 37ae9cf6fe22:"
            gelb "wird die Dateistruktur aufgezeigt. Schreibt man nach dem : ein Datei- oder Verzeichnis Namen wird nur dies angezeigt."
            gelb "Wir erstellen nun ein Ordner mit 3 Dateien und machen ein #com."
            rot "md ordner"
            rot "@(`"datei1`", `"datei2`", `"datei3`") | New-Item -ItemType File -Path {`"Ordner\`$_.txt`"}" 0
            rot "git add --all"
            rot "git commit --message `"Neuer Ordner`"" 0
            break
        }
        12
        {
            gelb "Um den obersten #com anzusprechen muss man nicht dessen HASH kennen. Man kann ihn immer mit HEAD benennen."
            rot "git show head:"
            rot "git show head:ordner" 0
            rot "git show head:ordner/datei1.txt" 0
            grau "Wichtig hier, zwischen Ordner und datei1.txt kommt kein Backslash sondern ein Slash (Shift 7)!!!"
            grau "Und auch wichtig: Groß-/Kleinschreibung spielt hier eine Rolle!!!"
            break
        }

        <# TODO (Weiter) Nächster Schritt #>
    }
    
    $nr++
    $global:schritt = $nr
}

# init

