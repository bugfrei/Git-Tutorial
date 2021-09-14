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
function weiss($t) { $t = (rep  $t); Write-Host $t -ForegroundColor White }
function cyan($t) { $t = (rep  $t); Write-Host $t -ForegroundColor Cyan }

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

function Edit($file, $ask = 0)
{
    if ($ask -eq 1)
    {
        Read-Host "`nBereit? (drücke Return)"
    }
    if ($Global:Editor)
    {
        if ($Global:Editor -eq "vim")
        {
            vim $file
        }
        else
        {
            Start-Process $Global:Editor -ArgumentList $file
        }
    }
    else
    {
        $f = Get-Item $file
        if ($f.Extension -eq ".TXT")
        {
            Invoke-Item $file    
        }
        else
        {
            Start-Process "notepad" -ArgumentList $file
        }
    }
    

}
function rep([string] $t)
{
    . L:\GIT\GitTutorial\Tutorial-DE.ps1
    return ([string] $t).replace("#rep", "Repository").Replace("#com", "Commit").Replace("#sta", "Stage-Bereich").Replace("#work", "Workspace").Replace("#wor", "Workspace").Replace("~", "`n").Replace("´", "`"").Replace("#hcom", "HEAD-Commit").Replace("#bra", "Bransh").Replace("#bru", "Bransh")
}
Function Init
{
    [CmdletBinding()]
    param(
        $silent = 0
    )
    $PSDefaultParameterValues['*:Encoding'] = 'utf8'

    $dir = "$([System.Environment]::GetFolderPath("user"))\GIT_LESSON1"
    Set-Location c:\
    if (Test-Path $dir)
    {
        Remove-Item $dir -Recurse -Force
    }
    mkdir $dir | Out-Null
    Set-Location $dir


    mkdir user1 | Out-Null
    Set-Location user1

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

        if (-not ($Global:Editor) -or ($Global:Editor:Editor -eq $null) -or ($Global:Editor -eq ""))
        {
            weiss "Welchen Text-Editor möchtest Du verwenden?~"
            if (HasVIM)
            {
                weiss "V.  VIM"
            }
            else
            {
                if (HasChoco)
                {
                    weiss "V. VIM (vorher automatisch installieren)"
                }
            }
            weiss "N. Notepad"   
            weiss "S. Standard Windows Text-Editor (für .txt Dateien)"
            $ein = Read-Host -Prompt "Bitte wählen"
            if ($ein -eq "V")
            {
                if (HasVim)
                {
                    $Global:Editor = "vim"
                }
                else
                {
                    if (HasChoco)
                    {
                        choco install vim -y
                        $Global:Editor = "vim"
                    }
                }
            }
            if ($ein -eq "N")
            {
                $Global:Editor = "notepad"
            }
            if ($ein -eq "S")
            {
                $Global:Editor = ""
            }
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
    $dir = "$([System.Environment]::GetFolderPath("user"))\GIT_LESSON1\user1\Hilfe.txt"
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
    Weiter -anweisung $true
}

function config
{
    [CmdletBinding()]
    [Alias("cfg")]
    param(
    )   
    
    cls
    rot "Konfiguration von Git"
    gelb "`nWir Konfigurieren nun Git. Hier gibt es viele Einstellungemöglichkeiten, wobei 3 wichtig sind:"
    Write-Host "user.name  : Der Benutzername"
    Write-Host "user.email : Deine E-Mail Adresse"
    Write-Host "core.editor: Einen Editor damit man in git auch Eingaben machen kann."
    grau "`nDiese Konfiguration hat NICHTS mit Github zu tun. Es ist nur wichtig, damit in einem #com der Name/E-Mail Addresse des Benutzer gespeichert werden kann. Damit kann man später sehen: wer hat was gemacht."
    gelb "`nGebe folgendes ein (bzw. passe Name, E-Mail Adresse noch an):"
    [String] $un = $Env:USERNAME
    $em = $un.Replace(" ", ".")
    rot "git config --global user.name `"$un`""
    rot "git config --global user.email `"${em}@gmail.com`"" 0
    rot "git config --global core.editor code" 0

    grau "`nAnstelle von code kannst du natürlich auch andere Editoren verwenden (notfalls notepad)."

}

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
            Start-Sleep -Seconds 2
            if (HasGit)
            {
                config
                gelb "Danach die Powershell neu starten (Administrator ist nicht nötig), das Tutorial-Skript neu ausführen."
                return
            }
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
function HasVIM()
{
    try
    {
        [string] $v = vim --version | Out-String
        return ($v.StartsWith("VIM - Vi IMproved"))
    }
    catch
    {

    }
    return false
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
        [ValidateSet("Befehle", "^", "Kopieren", 
            "Lange Textausgaben", "Textfarben",
            "Commit", "Repository", "Branch", "Merge", "Tag",
            "Hash", "Workspace",
            "Github", "Bitbucket")]
        $Was = "Befehle"
    )

    clear
    Write-Host "Beschreibung für $Was`n" -ForegroundColor Yellow
    
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
    elseif ($Was -eq "Repository")
    {
        weiss "Ein #rep ist eine Sammlung von 2 bis 3 Bereichen."
        weiss "Die #coms, die unterschiedliche Zustände/Version der Dateien/Ordner entsprechend."
        weiss "Die #stas, die enthalten was im nächsten #com geschrieben werden soll."
        weiss "Und, abgesehen von Git Hubs wie z.B. Github oder Bitbucket, das Workspace. Das ist der Bereich, in dem der Benutzer arbeitet."
        weiss "In einem Git #rep können unterschiedliche Aktionen durchgeführt werden. Allesammt mit dem Befehl git."
        weiss "Wobei es eine Dezentrale Versionsverwaltung ist, d.h. es ist kein Internet nötig (außer man möchste zum Git Hoster pushen (=übertragen))"
        grau "Ein #rep erkennt man an dem Ordner .git im Workspace. In diesem Ordner befinden sich die #stas, #coms und alles was dazu gehört bzw. dafür gebraucht wird."
        gelb "Man unterscheidet zwischen folgenden #rep Typen:"
        write-Host "Blessed #rep:" -ForegroundColor Black -BackgroundColor White
        weiss "Hier werden offizielle Releases erstellt. D.h. nur fertige, auslieferbare Versionen."
        Write-Host "Shared #rep:"  -ForegroundColor Black -BackgroundColor White
        weiss "Dient zum Austausch zwischen den Entwicklern. Es kann auch mehrere Shared Repositories geben, je nach Größe des Projektes, anzahl der Entwickler oder Orte an denen Entwickelt wird."
        Write-Host "Workflow #rep:"  -ForegroundColor Black -BackgroundColor White
        weiss "Hier werden Versionen veröffentlicht, die einen bestimmten Status erreicht haben. z.B. abgeschlossene Reviews ode Tests."
        Write-Host "Fork #rep:"  -ForegroundColor Black -BackgroundColor White
        weiss "Wird hauptsächlich für große Umbauten von Projekten genutzt. Also ein Ausbruch aus der normalen Entwicklungslinie oder für experimentielle Entwicklungen die vielleicht nie in die normale Entwicklungslinie einfließen sollen."
        Write-Host "Lokales #rep:"  -ForegroundColor Red -BackgroundColor White
        weiss "Hier arbeiter der Entwickler. Dieses befindet sich auf seinem Rechner und wird mit den anderen Repositories abgeglichen (gepushed)."
        rot "    In solch einem #rep arbeiten wir hier im Tutorial."
        rot "    Andere #rep Typen simuliere werden im Tutorial mit entsprechenden Ordnern (user1, user2, share) simuliert."
    }
    elseif ($was -eq "Commit")
    {
        weiss "Ein #com entspricht immer eine Version und beinhaltet technisch gesehen alles was im Workspace ist. D.h. alle Dateien, alle Ordner (wenn Sie Datein beinhalten!) mit dem Inhalt eines Bestimmten Moments."
        weiss "#coms sind Hauptbestandteil eines #rep."
        weiss "Ein #com geht immer in einen #bra."
        weiss "Bei meheren Entwicklern kann es mehrere #coms unterschiedlicher Versionen zur gleichen Zeit geben. Dies kann man mit den #bra verwalten."
        weiss "In einem Master-#bra ist immer der entgültige #com."
    }
    elseif ($Was -eq "Branch" -or ($Was -eq "Merge"))
    {
        weiss "Ein Branch ist eine Art Name für einen Bereich im #rep. Damit können unterschiedliche Entwickler gleichzeitig arbeiten ohne sich in die Quere zu kommen."
        weiss "Es gibt immer einen Master-#bra in dem der entgültige #com gespeichert wird."
        weiss "Mehere #braes mit unterschiedlichen Änderungen werden mit einem Merge zu einen Master-#bra 'zusammengefügt'."

    }
    elseif ($Was -eq "Tag" -or ($Was -eq "Hash"))
    {
        weiss "Ein Tag ist eigentlich nur ein Name für ein #com."
        weiss "Ohne einem Tag kann man einen bestimmten #com nur durch seinen Hash-Wert ansprechend."
        weiss "Dies ist umständlich da die Hashwerte durch den Inhalt eines #coms berechnet und keinen für den Menschen logischen Aufbau haben."
        weiss "Somit kann man, gerade für wichtige #coms, einen Tag vergeben und den #com damit mit diesen 'Namen' ansprechen."
        weiss "Jeder Entwickler kann für einen #com beliebig viele Tags vergeben. Ein #com kann also beliebig viele Namen haben. Dies ist wichtig, da jeder Entwickler vielleicht seinen eigenen Namen vergibt und sich merkt."
    }
    elseif ($was -eq "Stage-Bereich")
    {
        weiss "Ein #sta ist ein Zwischenspeicher zwischen dem was im aktuellen (HEAD) #com ist und was in den nächsten #com soll."
        weiss "1. Nach einem #com sind diese #com und der #sta identisch"
        weiss "2. Ändert man nun etwas ist der #com identisch mit dem #sta, der #sta jedoch nicht mit dem Workspace."
        weiss "3. Mit dem Befehl 'git add .' wird nun alles was sich geändert hat in den #sta geschrieben."
        weiss "Nun ist der #com nicht mehr identisch zum #sta. Dafür der #sta mit dem Workspace."
        weiss "4. Ändert man nun weiteres im Workspace sind alle (#com, #sta und Workspace) mit keinem mehr identisch."
        weiss "5. Führt man nun einem #com aus, so ist der #com wieder mit dem #sta Identisch (der #sta wird in den #com geschrieben)."
        weiss "Durch die Änderung bei 4. ist der #sta aber nicht mit dem Workspace identisch."
        weiss "~Ein 'git add .' gefolgt von einem #com sorgt dafür das wieder alles Identisch ist (1.)"
    }
    elseif ($Was -eq "Workspace")
    {
        weiss "Ein Workspace ist das, was der Entwickler als sein Arbeitsbereich ansieht. Also die Ordner und Dateien mit bzw. in denen er arbeitet."
        weiss "Grundsätzlich ist alles auf einem Computer ein Workspace, aber nur mit "git init" wird aus einem Workspace (Ordner) ein #rep."
    }
    elseif ($was -eq "Github")
    {
        Write-Host "Github ist ein Git Hoster für Repositories. Hier können private und öffentliche Repositories erstellt und verwaltet werden."
        Rot "Bei Github findest Du die URL zum #rep im #rep nach Klicken auf Code (oben/rechts)."
        $ein = fragenmulti -frage "Soll Github-Webseite geöffnet werden? (j oder c in Chrome / e in Edge / N)" -neinZeichen n -defaultZeichen n -erlaubteZeichen jce
        if ($ein -eq "j" -or ($ein -eq "c"))
        {
            Start-Process "chrome.exe" -ArgumentList "https://github.com/"
        }
        elseif ($ein -eq "e")
        {
            Start-Process "msedge.exe" -ArgumentList "https://github.com/"
        }
    }
    elseif ($was -eq "Bitbucket")
    {
        Write-Host "Bitbucket ist ein Git Hoster für Repositories. Hier können private und öffentliche Repositories erstellt und verwaltet werden."
        Rot "Bei Bitbucket findest Du die URL zum #rep im #rep nach Klicken auf Clone (oben/rechts)."
        $ein = fragenmulti -frage "Soll Bitbucket-Webseite geöffnet werden? (j oder c in Chrome / e in Edge / N)" -neinZeichen n -defaultZeichen n -erlaubteZeichen jce
        if ($ein -eq "j" -or ($ein -eq "c"))
        {
            Start-Process "chrome.exe" -ArgumentList "https://bitbucket.org/"
        }
        elseif ($ein -eq "e")
        {
            Start-Process "msedge.exe" -ArgumentList "https://bitbucket.org/"
        }
    }
    else
    {
        rot "Zu diesem Thema gibt es leider noch keine Hilfe!"
    }

    # TODO HILFE <--------------
}


function Make19
{
    if (Test-Path neu)
    {
        return
    }
    @("Zweiter Ordner", "temp", "Dokumentation", "neu") | ForEach-Object {
        New-Item -ItemType Directory -Path $_  | Out-Null
        New-Item -ItemType Directory -Path "$_\Unterordner" | Out-Null
        New-Item -ItemType File -Path "$_\datei.txt" | Out-Null
        New-Item -ItemType File -Path "$_\Unterordner\readme.txt" | Out-Null
    }
    Set-Content ".\neu\Unterordner\readme.txt" -Value "die anderen Dateien sind leer."

}

function fragenmulti()
{
    [CmdletBinding()]
    param(
        [string] $frage,
        [ValidateLength(0, 1)]
        [string]$neinZeichen = "|",
        [ValidateLength(1, 1)]
        [string] $defaultZeichen = "n",
        [ValidateLength(1, 99)]
        [string] $erlaubteZeichen
    )
    if ($erlaubteZeichen.ToLower().Contains($neinZeichen.ToLower()))
    {
        throw "Das neinZeichen darf NICHT in den erlaubtenZeichen enthalten sein!"
    }

    $ein = Read-Host -Prompt $frage
    if ($ein -eq "")
    {
        $ein = $defaultSymbol
    }
    if ($ein -eq $neinSymbol)
    {
        return $false
    }

    if (-not ($erlaubteZeichen.ToLower().Contains($ein.ToLower())))
    {
        return $false
    }
    return $ein

}
function fragen($frage, [switch] $jaDefault)
{
    $def = " (j/N)"
    if ($jaDefault)
    {
        $def = " (J/n)"
    }
    $ein = Read-Host -Prompt ($frage + $def)
    if ($jaDefault)
    {
        return -not ($ein -eq "N")
    }
    else
    {
        return $ein -eq "J"
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

    <# TODO __3__(Inhalt) Kapitel definieren #>

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

    $warteZeitFuerGimmics = 0 # Einheiten; Millisekunden, lange Gimmics * $warte...*2 : DEFAULT = 1000
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
    Write-Host "Scotty beam me up"
    Start-Sleep -Milliseconds ($warteZeitFuerGimmics * 2)

    if ($nr -gt 11)
    {
        mkdir .\ordner | Out-Null
        @("datei1", "datei2", "datei3") | New-Item -ItemType File -Path { "Ordner\$_.txt" }
        git add --all
        git commit --message "Neuer Ordner"
    }
    if ($nr -gt 14) { git tag Neuer.Ordner }
    if ($nr -gt 18) { Make19 }
    Write-Host "Connection to matrix.Nebuchadnezzar"
    Start-Sleep -Milliseconds ($warteZeitFuerGimmics * 3)
    if ($nr -gt 19)
    {
        git add Dokumentation
        git add .\neu\Unterordner\readme.txt
        git commit -m "Viel hinzu"
        git tag viel
    }
    if ($nr -gt 20)
    {
        "A" > stage.txt
        git add --all | Out-Null
        git commit -m "Stage A" | Out-Null
        "B" > stage.txt
    }
    if ($nr -gt 21) { git add stage.txt }
    if ($nr -gt 22) { "C" > stage.txt }
    if ($nr -gt 24) { git commit -m "Stage B" }
    if ($nr -gt 25)
    {
        git add --all
        git commit -m "Stage C"
    }
    if ($nr -gt 26)
    {
        $codeOriginal = "class Programm`n    {`n        public void main(string[] args)`n        {`n            // I do something...`n        }`n    }`n"
        Set-Content -Value $codeOriginal -Path code.cs
        git add --all
        git commit -m "Code"
    }
    if ($nr -gt 27)
    {
        for ($versuch = 1; $versuch -le 3; $versuch++)
        {
            $codeVersuch = "class Programm`n    {`n        public void main(string[] args)`n        {`n            // I do something...`n            // Versuch $versuch`n        }`n    }`n"
            Set-Content -Value $codeVersuch -Path code.cs
            git stash save "Versuch $versuch"
        }
    }

    if ($nr -gt 28) { git stash apply 0 }
    if ($nr -gt 29) { git stash drop 1 }
    if ($nr -gt 30)
    {
        git add -all
        git commit -m "Versuch 3"
        git stash clear
    }
    if ($nr -gt 31)
    {
        for ($versuch = 4; $versuch -le 7; $versuch++)
        {
            $codeVersuch = "class Programm`r    {`r        public void main(string[] args)`r        {`r            // I do something...`r            // Versuch $versuch`r        }`r    }`r"
            Set-Content -Value $codeVersuch -Path code.cs
            git stash save "Versuch $versuch" | Out-Null
        }
        git stash pop
        for ($versuch = 4; $versuch -le 6; $versuch++)
        {
            git restore code.cs
            git stash pop
        }
    }
    if ($nr -gt 32) { git restore . }
    

    <# TODO __2__(Schritt #) Schritt nr erstellen  #>
    $global:schritt = $nr
    weiter
}

function Weiter
{
    [CmdletBinding()]
    [Alias("w")]
    param
    (
        $nr = -1,
        $anweisung = $false
    )
    if ($nr -eq -1)
    {
        $nr = $global:schritt
    }
    if ($nr -lt -100000)
    {
        gelb "Git ist nun installiert. Die Powershell neu starten (als Administrator ist nicht nötig), das Tutorial-Skript neu ausführen"
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
            grau "`"Die Hilfe beschreibt dir auch Begriffe, die in der Auswahl enthalten sind."
            gelb "`nZeige dir einfach ein paar Hilfe-Themen an, dann gehts weiter"            
            rot "hilfe"
            rot "hilfe <Tabulatortaste><Tabulatortaste...>" 0
            rot "hilfe <Strg+Space>" 0
            rot "w" 0
            break
        }
        10007
        {
            gelb "Als nächstes lernen wir die Ausgabe von langen Textausgaben von Git"
            gelb "Mit Curcor runter/Bild runter gehst Du eine Zeile/Seite nach unten"
            gelb "Mit Cursor hoch/Bild hoch entsprechend eine Zeile/Seite nach oben"
            gelb "Mit q beendet du die Anzeige"
            grau "Mit h könntest Du sogar eine Hilfe angezeigt bekommen (mit q beenden)"
            gelb "`nScrolle/Blätter mit Cursor runter/Bild runter nach ganz unten zur ersten Datei..."
            Read-Host -Prompt "Bereit? Drücke Return (dauert ein paar Sekunden)"
            $path = "$([System.Environment]::GetFolderPath("USER"))\_1_2_3_4_5"

            if (Test-Path $path)
            {
                Remove-Item $path -Recurse -Force
            }
            New-Item -ItemType Directory -Path $path | cd
            git init | Out-Null
            for ($i = 1; $i -lt 20; $i++)
            {
                New-Item -ItemType File -Name "File ${i}.txt" | Out-Null
                git add "File ${i}.txt" | Out-Null
                if ($i -eq 1)
                {
                    git commit -m "Super jetzt wieder mit Cursor hoch/Bild hoch nach oben. Mit q beendest Du die Anzeige (dann mit w Weiter)." | Out-Null
                }
                else
                {
                    git commit -m "Datei ${i}" | Out-Null
                }
            }
            git log
            cd..
            Remove-Item $path -Recurse -Force
        }
        10008
        {
            gelb "Wir sind nun am Ende der Tutorialeinleitung. Ein Befehl gibt es noch: init"
            gelb "Dieser initialisiert das Tutorial und beendet somit auch die Einleitung."
            gelb "Danach kannst Du mit den besagten Befehlen arbeiten. Am besten fängst Du dann mit w an und startest damit Schritt 1 des Tutorials."
            rot "init"
            rot "w"
            break
        }
        10009
        {
            gelb "Die Tutorialeinleitung ist schon zuende. Gehe zurück"
            rot "z"
            break
        }
        10010
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
        # KAPITEL - Start
        0
        {
            rot "Starte das Tutorial mit w"
            break
        }
        1
        {
            gelb "Git für $dir\user1 Initialisieren (#rep erstellen)" 
            grau "Der Befehl 'init' erstellt ein leeres #rep im aktuellen Ordner" 
            Write-Host "Und denk daran, mit w (oder weiter) geht es weiter" -ForegroundColor Cyan
            rot "git init"
            break 
        }
        # KAPITEL: Erstes Commit
        2
        {
            gelb "Als erstes müssen alle Dateien als #com in das #rep (genauer in dem #sta) aufgenommen werden"
            grau "Der Befehl add fügt Dateien dem nächsten #com hinzu. Entwerder einzelln (hier natürlich auch Dateien, die gelöscht wurden angeben)"
            grau "oder alle auf einmal mit git add --all"
            gelb "git add aktualisiert den #sta, dazu kommen wir weiter unten."
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
            gelb "Nun schreiben wir in die Datei 'leer.txt' die folgende Zeile und speichern ab."
            grün "Änderung"
            Edit "leer.txt" 1
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
        # KAPITEL: Unterschiede anzeigen lassen
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
            rot "git diff --stat bf7ec81f06^!"
            rot "git diff --statt 941364c bf7ec81f^!" 0
            grau "Die Hash hier sind natürlich Beispiele."
            break
        }
        # KAPITEL: Details zu Commits
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
        13
        {
            gelb "Gerade git log führt zu langen, teils unübersichtlichen Ausgaben."
            gelb "Dafür gibt es Ausgabeformate die entweder alles kürzer machen oder andere Informationen anzeigen."
            gelb "Probiere einfach mal aus:"
            rot "git log --oneline"
            grau "Achtung: oneline (eine Zeile) nicht online!!!"
            rot "git log --stat"
            rot "git log --shortstat"
            rot "git log --graph"
            grau "Werden wir später nochmal ansehen wenn wir gemerged haben)"
            break
        }
        # KAPITEL: Tags und Commits
        14
        {
            gelb "Nun ist es umständlich die #coms immer mit dem Hash anzusprechen."
            gelb "Viel einfacher wäre es, wenn #coms einen Namen haben"
            gelb "Dies kann man mit sogenannten Tags"
            gelb "Ein #com kann beliebig viele Tags erhalten (ist auch wichtig, damit unterschiedliche Benutzer ihre Tagsnamen vergeben können)"
            gelb "`nWir erstellen für den aktuellen #com ein Tag."
            rot "git tag Neuer.Ordner"
            grau "`nEin Tagname muss ein `"Wort`" sein. Bindestriche, Unterstriche und Punkte sind erlaubt."
            grau "Also git tag Neuer_Ordner, git tag Neuer-Ordner wäre auch ok."
            rot "git log --oneline"
            break
        }
        15
        {
            gelb "Nun lernen wir wie man #coms ansprechen kann. Bisher haben wir ja immer den Hash (oder den ersten Teil davon) genutzt."
            gelb "Da #coms eines der wichtigsten Elemente von git sind, macht es Sinn sie möglichst einfach benennen zu können."
            gelb "Zum einen geht es mit dem neuen Tag `"Neuer.Ordner`""
            rot "git show --stat Neuer.Ordner"
            break
        }
        16
        {
            gelb "Es gibt aber auch schon fertige Namen und Branches die man nehmen kann."
            gelb "Bei git log --online steht beim ersten #com"
            weiss "xxxxxxx (HEAD -> master, tag: Neuer.Ordner) Neuer ordner"
            grau "xxxxxxx      : ist der Hash"
            grau "HEAD         : ist immer der aktuelle #com"
            grau "master       : ist der Branch (dazu kommen wir später)"
            grau "Neuer.Ordner : der Tag"
            grau "Neuer Ordner : ist die Message, die wir beim git commit angegeben hatten"
            rot "git show --stat HEAD"
            rot "git show --stat master" 0
            rot "git show --stat Neuer.Ordner" 0
            grau "`nAnsprechen über die Message geht nicht!"
            # TODO ?? Ansprechen eines Commits über die Message - wenn es doch geht
            break
        }
        17
        {
            gelb "Zusätzlich kann man eine Art Steuercode an den Namen hängen."
            gelb "Einen kennen wir schon : ^! (immer der vorherige #com, ist aber eher für diff wichtig, da hier immer 2 #coms verglichen werden.)"
            gelb "~  : Der Parent (vorherige) #com. Kann auch kombiniert (~~~) werden."
            gelb "~2 : 2 Parents (oder auch ~3, ~4, ...). ~2 entspricht also ~~."
            rot "git show --stat HEAD~"
            rot "git show --stat HEAD~~~"
            rot "git show --stat HEAD~3"
            grau "Die letzten beiden zeigen den Start #com"
            rot ""
            break
        }
        18
        {
            gelb "Auch mehere #coms auf einmal sind möglich."
            rot "git show --stat HEAD HEAD~ HEAD~2"
            grau "Also von aktuellen #com bis zu 2 #coms davor."
            break
        }
        19
        {
            Make19
            gelb "Nach längerer Zeit sind in unserem #rep ein paar Dateien und Ordner entstanden."
            grau "Ich habe diese mal erstellt"
            gelb "Nun wollen wir nur die Dokumentation und die readme.txt in neu\Unterordner in das nächste #com übernehmen."
            grau "`nBeim add Befehl sind Jokerzeichen wie ? und * möglich."
            grau "Bei angaben von Verzeichnisse sind diese immer Recursive (d.h. alle Unterordner darin kommen auch ins #com)"
            grau "Der Punkt bezeichnet das aktuelle Verzeichnis (git add . -> fügt das aktuelle und alle darin enthaltenen Verzeichnisse ins #com hinzu)"
            rot "dir"
            rot "git add Dokumentation" 0
            rot "git add .\neu\Unterordner\readme.txt" 0
            grau "Mit der Tab Taste kannst Du die Ordner auch vervollständigen. Mit Strg+Space auch anzeigen."
            rot "git commit -m `"Viel hinzu`"" 0
            rot "git tag viel" 0
            rot "git log --oneline" 0
            rot "git status"
            grau "Wir sehen, das nur das angegebene im Commit ist."
            break
        }
        # KAPITEL: Stage-Bereich
        20
        {
            gelb "Nun schauen wir uns mal den #sta genauer an."
            grau "Der #sta wird in der Hilfe genauer beschrieben."
            gelb "Aktuell entspricht der #com dem #sta und der #sta dem #work."
            gelb "Wir prüfen das, ändern was und fügen es dem #sta hinzu."
            grau "Wir betrachten uns diesmal die Datei stage.txt. Diese habe ich erstellt und ein `"A`" darin gespeichert. Ein Commit mit allen Änderung habe ich auch bereits gemacht."
            if (-not ($anweisung))
            {
                "A" > stage.txt
                git add --all | Out-Null
                git commit -m "Stage A" | Out-Null
            }
            gelb "Nun ändern wir den Inhalt von stage.txt auf ein `"B`" und schauen uns den Status an."
            rot "git status"
            rot "`"B`" > stage.txt" 0
            rot "git status" 0
            grau "`nDie Datei wurde als geändert erkannt, ist aber nicht im #sta."
            break
        }
        21
        {
            gelb "Nun fügen wie diese Datei dem #sta hinzu. Danach schauen wird uns wieder den Status an."
            rot "git add stage.txt"
            rot "git status" 0
            grau "`nNun wird die Datei grün angezeigt. Sie ist im #sta."
            break
        }
        22
        {
            gelb "Das was jetzt im Stage ist (stage.txt: `"B`") würde in den #com übertragen."
            gelb "Aber wird ändern jetzt erneut die stage.txt und schreiben ein `"C`" hinein"
            grau "Vorher mal den Unterschied anzeigen."
            rot "git diff"
            grau "~Kein Unterschied, da der #sta dem #work entspricht."
            rot "´C´ > stage.txt"
            rot "git status"
            grau "~Die stage.txt taucht nun 2 mal auf."
            grau "Einmal grün, das ist die ´B´ Version."
            grau "Einmal rot, das ist die ´C´ Version."
            break
        }
        23
        {
            gelb "Wird schauen uns mal die Unterschiede mit git diff an."
            rot "git diff"
            grau "~Der Unterschied zwischen #work (´+ C´) und dem #sta (´- B´)."
            rot "git diff --staged"
            grau "~Der Unterschied zwischen dem #sta (´+ B´) und dem HEAD-#com (´- A´)."
            break
        }
        24
        {
            gelb "Wenn wir jetzt ein #com machen, wird nicht die stage.txt mit dem ´C´ in dem #com gespeichert."
            gelb "Nein, gelangt wird nur immer der aktuelle #sta in den #com."
            rot "git commit -m ´Stage B´"
            rot "git status" 0
            rot "git diff" 0
            grau "~Wir sehen, die letzte Änderung (das ´C´) wird noch als nicht im #sta angezeigt."
            grau "Zusätzlich sehen wir den Unterschied zum #work (´+ C´) und zum #sta (was ja jetzt auch der HEAD-#com ist) (´- B´)."
            break
        }
        25 
        {
            gelb "Erst wenn wir ein neues git add --all (oder git add stage.txt) und ein #com machen, ist alles wieder identisch."
            rot "git add --all"
            rot "git commit -m ´Stage C´" 0
            rot "git status" 0
            grau "~Nun ist der Inhalt des #hcom, des #stas und des #work vollkommen identisch."
            break
        }
        # KAPITEL: Stashing - Änderungn zwischenspeichern
        26
        {
            if (-not ($anweisung))
            {
                $codeOriginal = "class Programm`n    {`n        public void main(string[] args)`n        {`n            // I do something...`n        }`n    }`n"
                Set-Content -Value $codeOriginal -Path code.cs
                git add --all
                git commit -m "Code"
            }
            gelb "Angenommen wir haben einen Quellcode. Wir möchten jetzt Änderungen an diesem Code durchführen."
            gelb "Wir versuchen 3 unterschiedliche Codes aus, testen also etwas herum."
            gelb "Am Ende wollten wir den Originalzustand oder einen der getesteten Codes verwenden."
            grau "Nach jeder Änderung ein #com machen wäre umständlich und die #coms werden unübersichtlich."
            gelb "Hilf hilft git stash. Die Datei mit dem Code ist bereits erstellt (code.cs) und im #com ´Code´."
            gelb "Wir sehen uns den Code an."
            rot "Get-Content code.cs"
            break
        }
        27
        {
            gelb "Nun machen wir die erste Änderung und schreiben unter der Kommentarzeile"
            rot "edit code.cs"
            grün "// Versuch 1"
            grau "Dies entspricht in der Praxis dann ein Quellcode aus meheren Zeilen den wir testen würden.~edit ist KEIN PowerShell Befehl, sondern Bestandteil dieses Tutorials!"
            gelb "diesen Speichern wird in einem stash und setzen die Datei code.cs auf den Originalzustand zurück."
            rot "git stash save ´Versuch 1´"
            grau "´Versuch 1´ ist kein Name sondern nur eine Notiz"
            gelb "~Anschließend ändern wir die Kommentarzeile auf folgende, speichern und erstellen jeweils ein stash dafür."
            rot "edit code.cs"
            grün "// Versuch 2"
            rot "git stash save ´Versuch 2´" 0
            rot "edit code.cs"
            grün "// Versuch 3"
            rot "git stash save ´Versuch 3´" 0
            break
        }
        28
        {
            gelb "Schauen wir uns zuerst die gespeicherten Stashes an. Und laden Versuch 2 in die Datei code.cs."
            rot "git stash list"
            rot "git stash apply 1" 0
            grau "~1 steht für stash@{1}, also Versuch 2"
            rot "Get-Content code.cs"
            grau "~Wir sehen, es steht nun // Versuch 2 im Quellcode"
            gelb "Nein, doch lieber Versuch 3..."
            rot "git restore code.cs"
            rot "git stash apply 0" 0
            break
        }
        29
        {
            gelb "Den Stash Nr. 1 (Versuch 2) wollen wir aus der Stashliste löschen."
            rot "git stash list" 
            rot "git stash drop 1" 0
            rot "git stash list" 0
            grau "~Wir sehen, Versuch 2 ist gelöscht."
            break
        }
        30
        {
            gelb "Diese Version möchten wir nun in den #com. Dies geschieht wie gewohnt."
            rot "git add --all"
            rot "git commit -m ´Versuch 3´" 0
            gelb "~Wir prüfen die #coms und die Stashes"
            rot "git log --oneline"
            rot "git stash list" 0
            gelb "~Die Stash sind immer noch da, wir lös::::q
            n alle."
            rot "git stash clear"
            break
        }
        31
        {
            if (-not ($anweisung))
            {
                for ($versuch = 4; $versuch -le 7; $versuch++)
                {
                    $codeVersuch = "class Programm`r    {`r        public void main(string[] args)`r        {`r            // I do something...`r            // Versuch $versuch`r        }`r    }`r"
                    Set-Content -Value $codeVersuch -Path code.cs
                    git stash save "Versuch $versuch" | Out-Null
                }
            }
            gelb "Wir hatte noch ein paar Versuche unternommen. Im Stash sind nun Versuch 4 bis 7."
            gelb "Es gibt noch folgende Befehle für git stash:"
            gelb "git stash apply               : ohne Nummer wird immer Nr. 0 (erster Eintrag von git stash list) genutzt"
            gelb "git stash pop                 : auch hier ohne Nummer die Nr. 0. Jedoch wird dieser stash nach dem Pop gelöscht."
            gelb "git stash show                : ohne Nummer die Nr.0. Zeigt Informationen zum angegeben (oder 0) Stash an."
            rot "git stash list"
            rot "git stash pop" 0
            rot "git stash list" 0
            rot "Get-Content code.cs" 0
            grau "~Wiederhole ein paar mal die folgenden Befehle (bis Stashliste leer)"
            rot "git restore code.cs"
            rot "git stash pop" 0
            rot "git stash list" 0
            rot "Get-Content code.cs" 0
            grau "~Wird gehen also die Stashed Rückwärts zurück."
            break
        }
        32
        {
            gelb "Zuerst löschen wird die überbleibsel von den letzten Stashes."
            rot "git restore ."
            grau "Also alles zurücksetzten zum letzten #com."
            git stash pop
            break
        }
        # TODO >>> GEPRÜFT BIS HIER HIN *v*v*v*v*v*v*v*v*v*v*v*v*v* <<<
        # KAPITEL: Branches
        33
        {
            gelb "#braes sind Nebenläufige #coms und werden für die parallele Entwicklung benötigt."
            gelb "Einen weiteren Entwickler simulieren wir durch eine Klon des #rep im Ordner ..\user2."
            gelb "Wir clonen also das aktuelle #rep nach ..\user2"
            rot "git clone . ..\user2"
            rot "dir .."
            grau "Also Klone das 'Aktuelle' (.) #rep nach 'Ein Ordner Zurück\user2' (..\user2)."
            grau "Nach dem dir sehen wir, das wir 2 #rep haben. Wir stellen und vor user1 und user2 nutzen unterschiedliche Rechner."
            gelb "~Zusätzlich brauchen wir ein #rep für den Datenaustausch. Wir könnten hier Github oder Bitbucket nutzen."
            break
        }
        <# TODO __1__(Weiter) Nächster Schritt #>
    }
    
    $nr++
    $global:schritt = $nr
}


# init
