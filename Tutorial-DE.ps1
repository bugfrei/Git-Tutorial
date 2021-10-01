function MakeContentFile($filename)
{ 
    $file = New-Item -ItemType File -Name $filename

    [Random] $rnd = [Random]::new()
    $loremLength = $rnd.Next(1, 20)
    
    $content = Invoke-RestMethod -uri "https://baconipsum.com/api/?type=meat-and-filler&sentences=$loremLength"
    Set-Content $file -Value $content
}

function gelb($t) { $t = (rep $t); Write-Host $t -ForegroundColor Yellow; $Global:FF = $false }
function grün($t) { $t = (rep $t); Write-Host $t -ForegroundColor Green; $Global:FF = $false }
function grau($t) { $t = (rep  $t); Write-Host $t -ForegroundColor Gray; $Global:FF = $false }
function weiss($t) { $t = (rep  $t); Write-Host $t -ForegroundColor White; $Global:FF = $false }
function cyan($t) { $t = (rep  $t); Write-Host $t -ForegroundColor Cyan; $Global:FF = $false }

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
    $Global:FF = $false 
}
function HTMLBase
{
    return "<!DOCTYPE html>`n<html lang=`"de`">`n<head>`n    <meta charset=`"UTF-8`">`n    <meta http-equiv=`"X-UA-Compatible`" content=`"IE=edge`">`n    <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0`">`n    <title>Document</title>`n</head>`n<body>`n    `n</body>`n</html>`n"
}

function browse
{
    [CmdletBinding()]
    [Alias("web", "b")]
    param (
        [string] $file = "index.html"
    )
    ii $file    
}
function BrowseServer
{
    [CmdletBinding()]
    [Alias("webs", "server", "bs")]
    param(

    )
    ii "~\GIT_LESSON1\server\index.html"
}


function Edit($file = "index.html", $ask = 0)
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
        elseif ($Global:Editor -eq "gvim")
        {
            gvim $file
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
    return ([string] $t).replace("#rep", "Repository").Replace("#com", "Commit").Replace("#sta", "Stage-Bereich").Replace("#work", "Workspace").Replace("#wor", "Workspace").Replace("~", "`n").Replace("´", "`"").Replace("#hcom", "HEAD-Commit").Replace("#bra", "Bransh").Replace("#bru", "Bransh").Replace("#reps", "Repositories")
}

function CodeCSExt()
{
    $neuTeil = @("        // Programmcode",
        "        // Nochmehr Code...",
        "  // Hier ist der Bug - Lösche diese Zeile und speichere ab (vim: zur Zeile gehen dann dd:wq<Return> drücken)",
        "        // Wieder richtige Code")
    $altTeil = Get-Content code.cs
    $erg = Insert-Array -SourceArray $altTeil -InsertArray $neuTeil -Zeile 5
    Set-Content -Path code.cs -Value $erg
}
function CodeCSBugdel()
{
    $altTeil = Get-Content code.cs
    $erg = LineRemove-Array -SourceArray $altTeil -Zeile 8 -AnzahlZeilen 1
    Set-Content -Path code.cs -Value $erg
}
function Insert-ArrayInFile
{
    param($File,
        $InsertArray,
        [int] $Zeile)
    $sa = Get-Content -Path $File
    $da = Insert-Array $sa $InsertArray $Zeile
    Set-Content -Path $File -Value $da
}
function Insert-Array
{
    param(
        $SourceArray,
        $InsertArray,
        [int] $Zeile
    )

    $neu = @()
    for ($i = 0; $i -lt $Zeile; $i++)
    {
        $neu += $SourceArray[$i]
    }
    foreach ($ins in $InsertArray)
    {
        $neu += $ins
    }
    for ($i = $Zeile; $i -lt $SourceArray.Length; $i++)
    {
        $neu += $SourceArray[$i]
    }

    $neu
}

function LineRemove-ArrayInFile
{
    param($File,
        [int] $Zeile,
        [int] $AnzahlZeilen)
    $sa = Get-Content -Path $File
    $da = LineRemove-Array $sa $Zeile $AnzahlZeilen
    Set-Content -Path $File -Value $da
}

function LineRemove-Array
{
    param(
        $SourceArray,
        [int] $Zeile,
        [int] $AnzahlZeilen
    )

    $neu = @()
    for ($i = 0; $i -lt $Zeile - 1; $i++)
    {
        $neu += $SourceArray[$i]
    }
    for ($i = $Zeile + $AnzahlZeilen - 1; $i -lt $SourceArray.Length; $i++)
    {
        $neu += $SourceArray[$i]
    }

    $neu
}

function InitKapitel2
{
    [CmdletBinding()]
    param (
    )
    if (-not ($Global:MainInit))
    {
        init -silent 1
    }
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
}

Function Init
{
    [CmdletBinding()]
    param(
        $silent = 0
    )
    $PSDefaultParameterValues['*:Encoding'] = 'utf8'

    $Global:MainInit = $True

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
Texte in Gruen stellen Beispiele oder einzugebende Texte dar
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
Schritt <nr> <k>   : Springt zum angegeben Schritt <nr> des Kapitels <k> (z.B. Schritt 3 1 oder s 3 1)
                     Ohne Angabe des Kapitels (s 10) wird innerhalb des aktuellen Kapitel gesprungen.
Inhalt             : Zeigt eine Kapiteluebersicht mit der Moeglichkeit ein Kapitel zu waehlen
Init               : Setzt das Tutorial zurueck. Danach faengt man mit w oder weiter bei Schritt 1 an
edit <datei>       : Nutzt den gewählten Editor zum editieren der Datei (ohne Datei wird index.html editiert; s. Kapitel 2)
browse <datei> (b) : browse oder b öffnet die angegebene Datei (oder index.html falls keine angegeben) im Standard-Browser
BrowseServer (bs)  : Öffnet die index.html auf dem server(-Verzeichnis) im Standard-Browser
Hilfe (oder help)  : Liste die Befehle auf (dieser Text). Mit 'Hilfe <Strg+Space> kann angegeben werden, über was man Hilfe möchte.
Info               : Diesen Text
Install            : Informationen zur Installation von git
Install-tools      : Instalation von Tools (Editoren, Merge-Tools)"

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
                weiss "V. VIM (Tutorial für VIM mit vimtutor)"
                weiss "G. GVIM (VIM in extra Fenster mit Menüs - Einsteigerfreundlicher aber extra Fenster!)"
            }
            else
            {
                if (HasChoco)
                {
                    weiss "V. VIM (vorher automatisch installieren)"
                }
            }
            if (HasCode)
            {
                weiss "C. Visual Studio Code"
            }
            else
            {
                if (HasChoco)
                {
                    weiss "C. Visual Studio Code (vorher automatisch installieren)"
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
            if ($ein -eq "G")
            {
                if (HasVim)
                {
                    $Global:Editor = "gvim"
                }
                else
                {
                    if (HasChoco)
                    {
                        choco install vim -y
                        $Global:Editor = "gvim"
                    }
                }
            }
            if ($ein -eq "C")
            {
                if (HasCode)
                {
                    $Global:Editor = "code"
                }
                else
                {
                    if (HasChoco)
                    {
                        choco install vscode -y
                        $Global:Editor = "code"
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

            git config --global core.editor "$Global:Editor" --replace-all
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
    else
    {
        if (-not ($Global:Editor))
        {
            if (HasVIM)
            {
                $Global:Editor = "vim"
            }
            elseif (HasCode)
            {
                $Global:Editor = "code"
            }
            else
            {
                $Global:Editor = "notepad"
            }
        }
        if (-not ($global:sprache))
        {
            $global:sprache = $false
        }
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
        Schritt $this.schritt -silent 1
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
    $nr = $Global:Schritt
    $kapitel = [Math]::Truncate($nr / 100)
    $nrx = ($nr - ($kapitel * 100)) - 1 
    if (($nrx - 1) -eq 0)
    {
        gelb "Verwendet s <Schritt> <Kapitel> um Kapitel zu wechseln."
        Start-Sleep -Seconds 2
    }
    Schritt ($nrx - 1)
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
    $editor = $Global:Editor
    if ($editor -eq $null -or ($editor -eq ""))
    {
        $editor = "notepad"
    }
    rot "git config --global core.editor ´$editor´" 0

    grau "`nAnstelle von code kannst du natürlich auch andere Editoren verwenden (notfalls notepad)."

}

function instchoco
{
    if (HasChoco)
    {
        gelb "Chocolatey ist bereits installiert."
        return
    }
    if (Test-AdminRecht)
    {
        rot "Chocolatey wird installiert..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Start-Sleep -Seconds 2
    }
    else
    {
        Gelb "Hierfür brauchst Du Administrator-Rechte.~Starte die PowerShell als Administrator und führe das Tutorial-Skript erneut aus.~Danach kannst Du mit instchoco Chocolatey installieren."
        rot "<PowerShell als Administrator starten>"
        rot "instchoco"
    }
}

function install-tools
{
    [CmdletBinding()]
    param (
    )
    $prg = @()
    $anz = @()

    if (HasChoco)
    {
        if (-not (hasvim))
        {
            $prg += "vim"
            $anz += "VIM (Editor für Konsolen)"
        }
        if (-not (HasCode))
        {
            $prg += "vscode"
            $anz += "Visual Studio Code"
        }
        $prg += "meld"
        $anz += "Meld (Merge Tool)"
        $prg += "p4merge"
        $anz += "P4Merge (Merge Tool)"
        $prg += "kdiff3"
        $anz += "kdiff3 (Merge Tool)"
    }
    else
    {
        $prg += "choco"
        $anz += "Chocolatey (Tool zur Installation von Software)"
    }
    cls
    if (Test-AdminRecht)
    {
        gelb "Folgende Programme können installiert werden:~"
        for ($nr = 1; $nr -le $anz.Length; $nr++)
        {
            Write-Host "${nr}. $($anz[$nr-1])"
        }

        [int]$ein = Read-Host -Prompt "`nBitte wählen (1-$($anz.Length) / keine Eingabe)"
        if ($ein -gt 0 -and ($ein -le $anz.Length))
        {
            $install = $prg[$ein - 1]
            if ($install -ne "choco")
            {
                choco install $install -y

                if ($install -eq "p4merge")
                {
                    cls
                    # Konfiguration von p4merge
                    $p4mPath = ""
                    if (Test-Path -Path 'C:\Program Files\Perforce\p4merge.exe')
                    {   
                        $p4mPath = 'C:\Program Files\Perforce\p4merge.exe'
                    }
                    else
                    {
                        if (Test-Path -Path "$([System.Environment]::GetFolderPath("user"))\AppData\Local\Perforce\p4merge.exe")
                        {
                            $p4mPath = "$([System.Environment]::GetFolderPath("user"))\AppData\Local\Perforce\p4merge.exe"
                        }
                    }

                    if ($p4mPath -eq "")
                    {
                        Write-Host "Konnte den Pfad zum p4merge.exe nicht finden. Bitte selber ausfindig machen und dann für die Konfiguration verwenden."
                        $p4mPath = "<Pfad zur p4merge.exe hier einfügen>"
                    }

                    gelb "Settings für Git:"
                    rot "git config --global merge.tool p4merge"
                    rot "git config --global mergetool.p4merge.path `"$p4mPath`"" 0
                    gelb "~In der Regel ist noch ein Neustart der PowerShell (und das Skript/init) notwendig."
                }
                elseif ($install -eq "meld")
                {
                    cls
                    gelb "Settings für Git:"
                    rot "git config --global merge.tool meld"
                    grau "~Sollte dies nicht funktionieren bitte den Pfad der meld.exe suchen und und folgendes ausführen:"
                    rot "git config --global mergetool.meld.path <hier den Pfad zu meld.exe einfügen>" 0
                    gelb "~In der Regel sollte ein Neustart der PowerShell (und das Skript/init) ausreichend."
                }
                elseif ($install -eq "kdiff3")
                {
                    cls
                    gelb "Settings für Git:"
                    rot "git config --global merge.tool kdiff3"
                    grau "~Sollte dies nicht funktionieren bitte den Pfad der kdiff3.exe suchen und und folgendes ausführen:"
                    rot "git config --global mergetool.kdiff3.path <hier den Pfad zu kdiff3.exe einfügen>" 0
                    gelb "~In der Regel sollte ein Neustart der PowerShell (und das Skript/init) ausreichend."
                }

                if ($install -in @("meld", "p4merge", "kdiff3"))
                {
                    gelb "~Einen Pfad zur .exe Datei findest Du durch folgende Schritte:"
                    gelb "1. Startmenü öffnen und das Programm suchen bzw. Name des Programme (p4merge, meld) eingeben."
                    gelb "2. Rechtsklick darauf und Dateispeicherort öffnen wählen."
                    gelb "3. Im Explorer anschließend auf die angezeigte Verknüfung rechtsklicken und Eigenschaften wählen."
                    gelb "4. Im Textfeld ´Ziel´ befindet sich der Pfad zur .exe Datei, diese markieren/kopieren"              

                    gelb "~Bei einem Merge-Konflikt kann das Mergetool dann mit"
                    rot "git mergetool"
                    gelb "~aufgerufen werden. Dort kan man dann wählen was von welcher Version (Branch) in die aktuelle Zieldatei soll."
                    grau "~Bei meld (braucht etwas Zeit zum Laden nach git mergetool) zuerst die mittlere Datei (in den Inhalt klicken), dann kann man speichern.~Bei p4merge muss ggfs. das Encoding mit File/Character Encoding auf UTF8 geändert werden.. "
                }
            }
            else
            {
                gelb "Es wird nun chocolatey installiert. Nach Abschluss der Installation die PowerShell erneut starten, und das Tutorial-Skript ausführen."       
                gelb "Solltest Du Tools installieren wollen, einfach install-tools erneut ausführen."
                gelb "Andernfalls das Tutorial mit init initialisieren.`n"
                Read-Host -Prompt "Return zu starten der Installation von chocolatey"
                instchoco
            }
        }
    }
    else
    {
        gelb "Für die Instalation werden Administratorrechte benötigt."
        gelb "~Bitte die PowerShell als Administrator starten, das Tutorial-Skript ausführen und install-tools erneut aufrufen."
    }
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
            if (not (Test-AdminRecht))
            {
                Write-Host "Um eine automatische Installation durchführen zu können, bitte den Assistenten mit q beenden, die PowerShell oder ISE als Administrator starten und das Tutorial-DE.ps1-Skript erneut ausführen und nochmal install eingeben." -ForegroundColor Red
                Write-Host "`nBitte wählen:"
            }
            Write-Host "C.  Chrome mit git Webseite öffnen"
            Write-Host "E.  Edge mit git Webseite öffnen"
            Write-Host "A.  Automatische Installation (benötigt Administrator-Rechte; installiert zuvor Chocolatey und damit dann git)"
            Write-Host "AC. Chocolatey Website in Chrome öffnen"
            Write-Host "AE. Chocolatey Seite in Edge öffnen"
            Write-Host "I.  Ich habe es manuell installiert."
            Write-Host "Q.  Installationsassistenten beenden."
            $ein = Read-Host -Prompt "Bitte wählen (c, e, a, ac, ae, q)"
        }
        if ($ein -eq "i")
        {
            if (-not (HasGit))
            {
                Write-Host "Ok, Du solltest die PowerShell und danach das Tutorial-Skript neu starten."
                break
            }
            Write-Host "Ja, ich habe erkannt das Git installiert ist. Du braucht die PowerShell nicht neu starten sondern kann sofort loslegen."
            break
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
                instchoco
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
    return $false
}

function HasCode()
{
    try
    {
        $v = (code --version)
        [int]$vl = $v[0].replace(".", "")

        return ($vl -gt 0)
    }
    catch
    {

    }
    return $false
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
            "Github", "Bitbucket",
            "Alias", "Cmdlet", "Powershell Befehle",
            "Ordner anzeigen", "Dateiinhalte anzeigen",
            "Navigation in der PowerShell",
            "Befehlesparameter", "VIM")]
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
        Write-Host "Schritt <nr> <k>   : Springt zum angegeben Schritt <nr> des Kapitels <k> (z.B. Schritt 3 1 oder s 3 1)" -ForegroundColor Cyan
        Write-Host "                     Ohne Angabe des Kapitels (s 10) wird innerhalb des aktuellen Kapitel gesprungen." -ForegroundColor Cyan
        Write-Host "Inhalt             : Zeigt eine Kapitelübersicht mit der Möglichkeit ein Kapitel zu wählen" -ForegroundColor Cyan
        Write-Host "Init               : Setzt das Tutorial zurück. Danach fängt man mit w oder weiter bei Schritt 1 ein" -ForegroundColor Cyan
        Write-Host "edit <datei>       : Nutzt den gewählten Editor zum editieren der Datei (ohne Datei wird index.html editiert; s. Kapitel 2)" -ForegroundColor Cyan
        Write-Host "browse <datei> (b) : browse oder b öffnet die angegebene Datei (oder index.html falls keine angegeben) im Standard-Browser" -ForegroundColor Cyan
        Write-Host "BrowseServer (bs)  : Öffnet die index.html auf dem server(-Verzeichnis) im Standard-Browser" -ForegroundColor Cyan
        Write-Host "Hilfe (oder help)  : Liste die Befehle auf (dieser Text). Mit 'Hilfe <Strg+Space> kann angegeben werden, über was man Hilfe möchte." -ForegroundColor Cyan
        Write-Host "Info               : Kompletter Info Text (der von init)" -ForegroundColor Cyan
        Write-Host "Install            : Informationen zur Installation von git" -ForegroundColor Cyan
        Write-Host "Install-tools      : Instalation von Tools (Editoren, Merge-Tools)" -ForegroundColor Cyan
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
Texte in Gruen stellen Beispiele oder einzugebende Texte dar
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
        weiss "~Nach der Erstellung eines #rep mit 'git init' wird automatisch der Branch 'master' erstellt."
        weiss "In diesem Branch sollte immer die neuste nutzbare Version abgelegt werden. Also eine Version die immer alle Änderungen alle Branches beinhaltet."

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
    elseif ($Was -in "Alias", "Cmdlet", "Powershell Befehle")
    {
        weiss "Ein Cmdlet bzw. Powershell Befehl besteht in der Regel aus einem Verb-Nomen."
        weiss "z.B. Get-ChildItem, Get-Content, Set-Location"
        weiss "Es gibt für diese Kombinationen aber auch Aliase, z.B.: dir, type, cd"
        weiss "Welche Aliase es für welche Verb-Nomen Befehle gibt kann man mit 'Get-Alias -Definition verb-nomen' z.B.:"
        weiss "Get-Alias -Definition Get-Content"
        weiss "Andersherum geht es ohne -Definition (Get-Alias dir)."
        weiss "Im Tutorial verwendet ich viele Verb-Nomen Befehle, aber auch Aliase kommen zum Einsatz."
        weiss "Es ist dir überlassen ob Du z.B. Get-Content code.cs oder type code.cs verwendest."
    }
    elseif ($Was -eq "Ordner anzeigen")
    {
        weiss "Für das auflisten von Ordnerinhalten gibt es das Cmdlet Get-ChildItem (oder Alias dir, ls oder gci)."
        weiss "dir temp        Listet z.B: den Inhalt des Ordner temp auf (dieser muss sich im aktuellen Verzeichnis befinden)."
        weiss "~Das aktuelle Verzeichnis wird im Eingabe-Prompt immer zwischen PS und der >-Klammer angegeben."
        weiss "Das aktuelle Verzeichnis kann man auch mit einem . ansprechen"
        weiss "dir .           Listet auch den Inhalt des aktuellen Orders auf"
        weiss "code .          Öffent Visual Studio Code im aktuellen Ordner (ohne Punkte wird VSC nur gestartet)"
        weiss "~Einen Ordner zurück spricht man mit .. an"
        weiss "dir ..          Listet den Inhalt des vorherigen Ordners (z.B. user1) auf."
        weiss "~Man kann diese auch kombinieren (dir ..\..\PowerShellTutorial\User1"
        gelb "~Um z.B. vom aktuellen Ordner 'user1' den Inhalt von 'user2' zu sehen gibt man"
        weiss "dir ..\user2    ein"
        weiss "~git clone . ..\user2   Klont also vom aktuellen (.) Ordner in den Ordner davor\user2"
        weiss "~Absolute Pfade werden immer mit Laufwerkbuchstabe:\Ordner...\Ordner... angegeben."
        weiss "dir $([System.Environment]::GetFolderPath('User'))"
    }
    elseif ($Was -eq "Dateiinhalte anzeigen")
    {
        weiss "Zum einen kann man den Explorer nutzen und dort die Datei öffnen."
        weiss "Das ist aber super umständlich wenn man in der PowerShell arbeitet."
        weiss "Dafür gibt es Get-Content (oder Alias type, cat, gc)."
        weiss "Get-Content code.cs"
        weiss "type code.cs"
        weiss "~Hier können natürlich auch Pfade verwendet werden:"
        weiss "type .\code.cs        (aktueller Pfad)"
        weiss "type ..\user2\code.cs (ein Pfad zurück, dann Ordner user2 und dort die code.cs)"
        weiss "type $([System.Environment]::GetFolderPath('User'))\GIT_LESSON1\user1\code.cs"
    }
    elseif ($Was -eq "Navigation in der PowerShell")
    {
        weiss "Mit Cursor-Hoch bzw. Cursor-Runter kann der vorherige oder wieder der Befehl danach angezeigt werden."
        weiss "Du kannst Du Taste auch mehrmals drücken um z.B. 10 Befehle zurück zu gehen."
        weiss "~Mit Cursor links bzw. Cursor-Rechts kannst Du den Cursor bewegen um z.B. einen vorherigen Befehl leicht zu ändern."
        weiss "~Sollte dich der Inhalt der PowerShell stören, kannst Du den Bildschirm mit 'cls' und Return leeren."
        rot "Hier im Tutorial kannst Du mit a und Return dir die Anweisung zum aktuellen Schritt nochmal anzeigen lassen. Hier wird der Bildschirm auch geleert."
        weiss "~Weitere Tasten:"
        weiss "Pos1        : Springt an den Zeilenanfang"
        weiss "Ende        : Springt an das Zeilenende"
        weiss "Bild hoch   : Blättert eine Seite nach oben"
        weiss "Bild runter : Blättert eine Seite nach unten"
        weiss "Esc         : Löscht die aktuelle Zeile"
    }
    elseif ($Was -eq "Befehlesparameter")
    {
        weiss "Befehlsparameter geben einem Befehl die notwendigen Daten um arbeiten zu können."
        weiss "Ein Get-Content (type) ohne Angabe einer Datei würde nicht wirklich funktionieren. Die Datei ist also der Parameter bzw. das Argument für den Parameter"
        gelb "~In der PowerShell werden Parameter mit einem vorangestellten - benannt"
        weiss "type -Path code.cs"
        weiss "Wobei hier der Name weg gelassen werden kann. Da -Path der erste Parameter ist ist das erste Argument immer für diesen Parameter."
        weiss "Gibst Du - ein gefolgt von einem Tabulator, kannst Du mit Tab/Shift Tab die verfügbaren Parameter vor/zurück blättern."
        weiss "Drückst du nach einen - Strg+Space werden alle verfügbaren Parameter aufgelistet und Du kannst den entsprechenden auswählen."
        gelb "~In Git werden Parameter in der Regel mit -- (z.B. --message) oder kurz auch mit - (z.B. -m) gebannt."
        weiss "Hier bietet PowerShell keine Auflistung oder Vervollständigung mit Strg+Space/Tab. Man muss wissen was man eingibt."
        weiss "Der Grund ist, das git kein PowerShell Befehl ist (es ist eine normale .exe Datei, die man auch in der Cmd-Konsole oder Bash-Konsole starten kann)."
        weiss "Die Bash-Konsole besitzt dann Parameterlisten und Vervollständigung von Befehlen und Parameter."
        weiss "ACHTUNG: In der Bash-Konsole werden absolute Pfade nicht mit C:\User...\ sondern mit C/User/.../ angegeben!"
    }
    elseif ($Was -eq "VIM")
    {
        weiss "VIM ist ein Texteditor für Konsolen (GVIM ist mit extra Fenster und Menüs - Etwas anwenderfreundlicher, jedoch während der Arbeit in einer Konsole ist ein Extra Fenster für schnelles Editieren eher störend)."
        weiss "~Der große Vorteil von VIM ist, das man keine Maus benötigt. Der Handwechsel von Tastatur zur Maus entfällt als vollständig. Für alles was man mit der Maus machen würde gibt es Befehle.~Ein weiterer Vorteil ist, das Vim in der Konsole geöffnet wird, kein Fenster das man suchen muss, oder aktivieren. Kein Wechsel zwischen Maus und Fenster, nur Tastatur. Glaube mir effektiver geht es nicht."
        weiss "~VIM befindet sich Grundsätzlich im Normalmodus. Hier können Befehle mit einzellnen Tasten oder Kombinationen (z.B. dd löscht die aktuelle Zeile) eingegeben werden."
        weiss "~Mit : gelangt man in den Befehlsmodus, hier werden Befehle sichtbar eingegeben und mit Return ausgeführt (z.B. :q beendet VIM, :q! beendet Vim auch bei Änderung in der Datei (gehen Verloren), :w schreibt die Datei, :wq Schreibt und Beendet)"
        weiss "~Im Normalmodus gelangt man mit i in den Einfügemodus. Hier kann man Texte eingeben, aber keine Befehle mehr ausführen. Zurück in den Normalmodus gelangt man hier mit Esc."
        rot "~Die Verwendung von VIM ist Anfang sehr gewöhnungsbedürftig. Jedoch wenn man die Befehle Intus hat, kann man damit extrem effektiv arbeiten."
        weiss "Ich Empfehle das Ausführen des Tutorials für VIM mit vimtutor"
        rot "vimtutor"
        grau "~Ggfs. erscheinende Meldung da gvim nicht gefunden werden kann einfach weg klicken."
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
        [int] $kapitel = -1,
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
    # In welchem Kapitel bin ich
    $kapAkt = [Math]::Truncate($global:schritt / 100)  # 0 = Kapitel 1, 1 = Kapitel 2...
    if ($kapitel -gt -1)
    {
        $kapAkt = $kapitel - 1
    }
    $nr += ($kapAkt * 100)  # Kapitel 2 > kapAkt = 1, 1*100 = 100 + $nr = 1xx

    
    $kapitel = [Math]::Truncate($nr / 100)
    $nrx = $nr - ($kapitel * 100)
    $kapitel++;
    $nrz = $nr
    if ($silent -eq 0)
    {
        gelb("Springe zum Schritt $nrx - Kapitel $kapitel")
    }
    if ($kapitel -eq 1)
    {
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
            $codeOriginal = "class Programm`n{`n    public void main(string[] args)`n    {`n        // I do something...`n    }`n}`n"
            Set-Content -Value $codeOriginal -Path code.cs
            git add --all
            git commit -m "Code"
        }
        if ($nr -gt 27)
        {
            for ($versuch = 1; $versuch -le 3; $versuch++)
            {
                $codeVersuch = "class Programm`n{`n    public void main(string[] args)`n    {`n        // I do something...`n        // Versuch $versuch`n    }`n}`n"
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
                $codeVersuch = "class Programm`r{`r    public void main(string[] args)`r    {`r        // I do something...`r        // Versuch $versuch`r    }`r}`r"
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
        if ($nr -gt 33)
        { 
            CodeCSExt
            @("A", "B", "C", "D", "E") | ForEach-Object { $_ > "$_.txt"; git add .; git commit -m "Datei $_.txt hinzugefügt." } | Out-Null
        }
        if ($nr -gt 34)
        {
            @("A", "B", "C", "D", "E") | ForEach-Object { "Änderung $_"  > "$_.txt"; git add .; git commit -m "Datei $_.txt verändert." | Out-Null; git tag "Change$_" | Out-Null } 
            git revert ChangeC --no-edit
        }
        if ($nr -gt 36)
        {
            git branch NeueKlassen
            git checkout NeueKlassen
        }
        if ($nr -gt 37)
        {
            md Klassen
            cd Klassen
            "class Mitarbeiter { ...} " > Mitarbeiter.class
            "class Kunde { ... }" > Kunde.class
            "class Auftrag { ...}" > Auftrag.class
            git add --all
            git commit -m "Mitarbeiter, Kunde und Auftrag erstellt"
        }
        if ($nr -gt 38)
        {
            cd ..
            git checkout master
        }
        if ($nr -gt 39)
        {
            CodeCSBugdel
        }
        Write-Host "Rufe das A-Team"
        Start-Sleep -Milliseconds ($warteZeitFuerGimmics * 2)
        if ($nr -gt 40)
        {
            git add --all
            git commit -m "Bugfix"
        }
        if ($nr -gt 41)
        {
            git checkout NeueKlassen
            cd Klassen
            "// noch zu tun: Kundennummer einfügen" >> Kunde.class
            "Dokumentation" > doku.txt
            git add --all
            git commit -m "Todo für Kunde + Doku"
        }
        if ($nr -gt 42)
        {
            cd..
            git checkout master
            "Änderung`nÄnderung 2`n" > leer.txt
            "Neue Datei" > leer2.txt
            Remove-Item stage.txt
            git add --all
            git commit -m "Geändert, neu und gelöscht"
        }
        if ($nr -gt 43)
        {
            git checkout NeueKlassen
            "hier initialisieren wir die neuen Klassen" > Neueklassen.class
            cd Dokumentation
            "Anleitung neue Klassen" > neueklassen.txt
            cd..
            git add --all
            git commit -m "Letzte Änderungen und Doku"
        }
        if ($nr -gt 44)
        {
            git checkout master
            git merge NeueKlassen
        }
        if ($nr -gt 45)
        {
            for ($i = 1; $i -le 10; $i++) { Add-Content -Value "Zeile $i" -Path branch.txt }
            git add --all
            git commit -m "branch.txt hinzugefügt 1-10"
            git branch zwei
            git checkout zwei
            del branch.txt
            for ($i = 1; $i -le 10; $i++)
            { 
                if ($i -eq 3) 
                {
                    Add-Content -Value "ZWEI" -Path branch.txt
                }
                Add-Content -Value "Zeile $i" -Path branch.txt 
            }
        }
        if ($nr -gt 46)
        {
            git add --all
            git commit -m "branch.txt Nach Zeile 2: ZWEI"
            git checkout master
            git branch drei
            git checkout drei
            del branch.txt
            for ($i = 1; $i -le 10; $i++)
            { 
                if ($i -eq 6)
                {
                    Add-Content -Value "DREI" -Path branch.txt
                }
                Add-Content -Value "Zeile $i" -Path branch.txt 
            }
            git add --all
            git commit -m "branch.txt Nach Zeile 5: DREI"
        }
        if ($nr -gt 47)
        {
            git checkout master
            git branch vier
            git checkout vier
            del branch.txt
            for ($i = 1; $i -le 10; $i++)
            { 
                if ($i -eq 10)
                {
                    Add-Content -Value "VIER" -Path branch.txt
                }
                Add-Content -Value "Zeile $i" -Path branch.txt 
            }
            git add --all
            git commit -m "branch.txt Nach Zeile 9: VIER"        
            git checkout master
        }
        if ($nr -gt 49)
        {
            git merge zwei
            git merge drei
            git merge vier
        }
        if ($nr -gt 50)
        {
            git checkout vier
            del branch.txt
            for ($i = 1; $i -le 10; $i++)
            { 
                if ($i -eq 5)
                {
                    Add-Content -Value "Irgendeine Veränderung" -Path branch.txt
                }
                Add-Content -Value "Zeile $i" -Path branch.txt 
            }
            git add --all
            git commit -m "branch.txt geändert."
            git checkout master
        }
        if ($nr -gt 51)
        {
            git branch -d NeueKlassen
            git branch -d zwei
            git branch -d drei
            git branch -D vier
        }
        if ($nr -gt 53)
        {
            git branch base1
            git checkout base1
            Add-Content -Path code.cs -value "// NEUE ZEILE FÜR DEN REBASE TEST"
            "Neue Datei" >rebase.txt
            git add --all
            git commit -m "Rebasetest"
            git checkout master
            "Neue Datei im Master" >master.txt
            git add --all
            git commit -m "Rebasetest"
        }
        if ($nr -gt 54)
        {
            git rebase base1
        }
        if ($nr -gt 55)
        {
            $Global:MakeDiff = $false

        }
    }
    if ($kapitel -eq 2)
    {
        $nr = $nrx
        Write-Host $nr -ForegroundColor Magenta
        if ($nr -gt 1)
        {
            initkapitel2
        }
        if ($nr -gt 2)
        {
            Set-Content -Path index.html -Value (HTMLBase)
            git init
            git add --all
            git commit -m "index.html erstellt"
            insert-arrayinfile .\index.html "    Hello World!" 9
            LineRemove-ArrayInFile .\index.html 11 1
        }
        if ($nr -gt 3)
        {
            git add --all
            git commit -m "Hello World!"
        }
        if ($nr -gt 4)
        {
            md ..\server | Out-Null
            git clone .git ..\server
        }
        if ($nr -gt 5)
        {
            LineRemove-ArrayInFile index.html 10 1
            Insert-ArrayInFile index.html @("    <h1>Hello World!</h1>") 10
            git add --all
            git commit -m "Überschrift"
        }
        if ($nr -gt 6)
        {
            cd ..\server
            git branch nix
            git checkout nix
            cd ..\user1
            git push --set-upstream ..\server master
        }
        if ($nr -gt 7)
        {
            cd ..\server
            git checkout master
            cd ..\user1
        }
        if ($nr -gt 8)
        {
            Insert-ArrayInFile index.html @("    Willkommen in der Welt von git.") 11
            git add --all
            git commit -m "Willkommen"
        }
        if ($nr -gt 9)
        {
            cd ..\server
            git pull ..\user1
            cd ..\user1
        }  

    }
    
    
    
    
    
    <# TODO __2__(Schritt #) Schritt nr erstellen  #>
    $global:schritt = $nrz
    weiter
}

function ??
{
    param(
        [int] $add = 0
    )
    $nr = $Global:Schritt
    $kapitel = [Math]::Truncate($nr / 100)
    $nrx = ($nr - ($kapitel * 100)) - 1 + $add
    $kapitel++;
    $Global:FF = $true
   
    if ($add -eq 0)
    {
        cls
        $st = "Schritt $nrx (Kapitel $kapitel)"; Write-Host (" " * ($st.Length) * 3 + "`n" + " " * ($st.Length) + $st + " " * ($st.Length) + "`n" + " " * ($st.Length) * 3)  -BackgroundColor DarkGray -ForegroundColor Black
        Write-Host "Zusätzliche Hilfe:" -ForegroundColor DarkGray
    }

    $nr = $nrx
    if ($Kapitel -eq 1)
    {
        ;
    }
    elseif ($Kapitel -eq 2)
    {
        if ($nr -eq 2)
        {
            rot "git init" 0
            rot "git add --all" 0
            rot "git commit -m ´index.html erstellt´" 0
            rot "edit"
            grün "..."
            grün "<body>"
            grün "    Hello World!"
            grün "</body>"
            grün "..."
            rot "b"
        }
        if ($nr -eq 3)
        {
            rot "git add --all" 0
            rot "git commit -m ´Hello World!´" 0
        }
        if ($nr -eq 5)
        {
            rot "edit index.html"
            grau "Falls nicht bereits geöffnet."
            grün "..."
            grün "<body>"
            grün "    <h1>Hello World!<h1>"
            grün "</body>"
            grün "..."
            rot "git add --all"
            rot "git commit -m ´Überschrift´" 0
        }
        if ($nr -eq 7)
        {
            rot "cd ..\server"
            rot "git checkout master" 0
            rot "bs" 0
            rot "cd ..\user1"
        }
        if ($nr -eq 8)
        {
            rot "edit index.html"
            grau "Falls nicht bereits geöffnet."
            grün "..."
            grün "<body>"
            grün "    <h1>Hello World!<h1>"
            grün "    Willkommen in der Welt von git."
            grün "</body>"
            grün "..."
            rot "git add --all"
            rot "git commit -m ´Willkommen´" 0
        }

        
    }

    # TODO: ??

    if ($Global:FF)
    {
        gelb "Zu diesem Schritt gibt es keine zusätzliche Hilfe.~~Gebe a ein, um die normale Anweisung einzusehen."
        rot "a"
    }

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
            if ($nr % 100 -eq 0)
            {
                $nr++
            }
            $kapitel = [Math]::Truncate($nr / 100)
            $nrx = $nr - ($kapitel * 100)
            $kapitel++;
            $st = "Schritt $nrx (Kapitel $kapitel)"; Write-Host (" " * ($st.Length) * 3 + "`n" + " " * ($st.Length) + $st + " " * ($st.Length) + "`n" + " " * ($st.Length) * 3)  -BackgroundColor Gray -ForegroundColor Black
        }
        else
        {
            $st = "Tutorialeinleitung $($nr - 9999)"; Write-Host (" " * ($st.Length) * 3 + "`n" + " " * ($st.Length) + $st + " " * ($st.Length) + "`n" + " " * ($st.Length) * 3)  -BackgroundColor Gray -ForegroundColor Black
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
                $codeOriginal = "class Programm`n{`n    public void main(string[] args)`n    {`n        // I do something...`n    }`n}`n"
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
                    $codeVersuch = "class Programm`r{`r    public void main(string[] args)`r    {`r        // I do something...`r        // Versuch $versuch`r    }`r}`r"
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
            break
        }
        # KAPITEL: Revert
        33
        {
            if (-not ($anweisung))
            {
                CodeCSExt
                @("A", "B", "C", "D", "E") | ForEach-Object { $_ > "$_.txt"; git add .; git commit -m "Datei $_.txt hinzugefügt." | Out-Null }
            }
            gelb "Nach einiger Zeit entstehend eineige Dateien. Inzwischen gibt es die Dateien A.txt, B.txt, C.txt, D.txt und E.txt"
            gelb "In jeder diese Dateien steht der entsprechende Buchstaben (also in A.txt ein ´A´ usw.)"
            gelb "Die Dateien wurden jeweils in einen eigenen #com geschrieben. Somit haben wir 5 weitere #coms."
            gelb "Schau dich etwas um..."
            rot "dir"
            rot "Get-Content C.txt" 0
            rot "git log --oneline" 0
            break
        }
        34
        {
            if (-not ($anweisung))
            {
                @("A", "B", "C", "D", "E") | ForEach-Object { "Änderung $_"  > "$_.txt"; git add .; git commit -m "Datei $_.txt verändert." | Out-Null; git tag "Change$_" | Out-Null }
            }
            gelb "Später wurden alle (A-E) Dateien verändert. Und wenig später merkst Du, das die Änderung in C.txt fehlerhaft ist."
            gelb "Natürlich könnte man zum #com vor der Verändert von C.txt springen. Dann müsste man aber wieder die D.txt und E.txt Änderung machen."
            gelb "In diesem Fall wäre der Aufwand noch überschaubar. Es ist ja nur jeweil eine Datei pro #com. Aber es könnten auch 100 Dateien in jedem #com geändert worden sein. Und Dateien hinzugefügt oder gelöscht..."
            gelb "Zuerst schauen wir uns um... dann machen wir nun nur die Änderung der C.txt Datei rückgängig."
            rot "dir"
            rot "Get-Content C.txt" 0
            rot "git log --oneline" 0
            grau "~Zum Glück wurden die Änderungscommits mit einem Tag versehen."
            rot "git revert ChangeC"
            grau "~Danach geht der Editor auf, der Informationen zum Revert auflistet. Dies wird im Editor gemacht da man diese Information vielleicht abspeichern, ausdrucken o.ä. will.~Wir schließen einfach den Editor (Vim -> :q)."
            break
        }
        35
        {
            gelb "Wir schauen uns mal um."
            rot "dir"
            rot "Get-Content A.txt" 0
            rot "Get-Content B.txt" 0
            grau "~Ok, das sind noch die geänderte Versionen"
            rot "Get-Content C.txt"
            grau "~Diese Änderung wurde rückgängig gemacht, hier steht nur ein ´C´."
            rot "Get-Content D.txt"
            rot "Get-Content E.txt" 0
            grau "~Das sind weiterhin die neuen Versionen. Es wurde als nur die C.txt auf den alten (ersten) Stand gebracht."
            grau "git revert ist ein nützliches Tool. Bei komplexen Änderungen (womöglich in der gleichen Datei) kann git revert jedoch auf Probleme stoßen. Dann ist die Meldung im Editor zu beachten."
            rot "git log --oneline"
            grau "~Ok, das #com von ChangeC gibt es noch, es wurde automatisch ein neues #com erstellt in dem das Revert geschrieben wurde."
            grau "~Das läst die Option offen zum #com ChangeB zu springen und die Änderungen doch noch händisch zu übernehmen. Bei komplexen Änderungen durchaus notwendig."
            break
        }
        # KAPITEL: Branches
        36
        {
            gelb "#braes sind Nebenläufige #coms und werden für die parallele Entwicklung benötigt."
            gelb "Angenommen in einem Projekt soll etwas zusätzliches programmiert (z.B. ein paar neue Klassen) werden da etwas Zeit benötigt."
            gelb "Damit diese (unvollständige) Klassen nicht ein ein #com einfließen macht man ein Branch. Ein neuer Entwicklungszweig."
            gelb "Dort kann man dann arbeiten, unabhängig vom Master-Branch der ja immer die aktuelle Version darstellt."
            gelb "Erst wenn die Arbeit im ´Klassen´-Entwicklungszweig ferig ist, bindet man diese in den Master-Branch ein (Merge)."
            gelb "~Wird brauchen also eine Art Snapshop des aktuellen Standes in dem wir unsere Klassen erstellen. Dann arbeiten wir daran."
            rot "git branch NeueKlassen"
            grau "~Wir müssen noch in diesen Branch wechseln"
            rot "git checkout NeueKlassen"
            grau "~Ab sofort arbeiten wir im Branch ´NeueKlassen´."
            break
        }
        37
        {
            gelb "Wir erstellen einen Ordner in dem wir schonmal ein paar Klassen schreiben."
            gelb "Wir wechseln dann in diesen Ordner"
            rot "md Klassen"
            rot "cd Klassen" 0
            gelb "~Wir erstellen nur ein paar Klassendateien."
            rot "´class Mitarbeiter { ... }´ > Mitarbeiter.class"
            rot "´class Kunde { ... }´ > Kunde.class" 0
            rot "´class Auftrag { ... }´ > Auftrag.class" 0
            gelb "~Zu diesem Zustand machen wir ein #com."
            rot "git add --all"
            git "git commit -m ´Mitarbeiter, Kunde und Auftrag erstellt´" 0
            break
        }
        38
        {
            gelb "Nun müssen wir in der aktuellen Version schnell etwas anpassen (Bubfix)"
            gelb "In der Datei code.cs hat sich wohl ein Bug eingeschlichen. Den müssen wir entfernen."
            gelb "Dazu wechseln wir in den vorherigen Ordner."
            gelb "Da die aktuelle Version geändert werden soll, müssen wir in den Master-Branch wechseln."
            rot "cd .."
            rot "git checkout master" 0
            rot "dir" 0
            grau "~Wir sehen, im Master ist der Ordner ´Klassen´ verschwunden. Dieser existiert nur im ´NeueKlassen´ Branch."          
            break
        }
        39
        {
            gelb "Nun editieren wir die Datei ´code.cs´ und suchen den Fehler (Tipp, er ist in Zeile 8)."
            edit -file code.cs -ask 1
            break
        }
        40
        {
            gelb "Nun erstellen wir ein #com und schauen uns mal die #coms genauer an."
            rot "git add --all"
            rot "git commit -m ´Bugfix´" 0
            rot "git log --graph --all --oneline" 0
            grau "~In dieser Darstellung sehen wir die Abzweigung unseres ´NeueKlassen´ Branch."
            break
        }
        41
        {
            gelb "Wir wechseln wieder zum Branch ´NeueKlassen´ und arbeiten an unseren Klassen weiter."
            rot "git checkout NeueKlassen"
            rot "dir" 0
            grau "~Der Klassenordner ist wieder da"
            rot "cd Klassen" 
            rot "dir" 0
            rot "´// noch zu tun: Kundenummer einfügen´ >> Kunde.class" 0
            grau "Es sind zwei >> !!! D.h. den Text an die Datei anhängen"
            rot "´Dokumentation´ > doku.txt"
            rot "git add --all"
            rot "git commit -m ´Todo für Kunde + Doku´" 0
            rot "git log --graph --oneline --all 0"
            grau "~Wir sehen nun ist der Master-Branch eine Abzweigung, da wir ja im ´NeueKlassen´ Branch den letzten #com gemacht haben."
            break
        }
        42
        {
            gelb "Nun ändern wir nochmal etwas im Master-Branch und machen ein #com."
            rot "cd .."
            rot "git checkout master" 0
            grau "~Wir schreiben in der leer.txt eine zweite Zeile ´Änderung 2´ (Vim: i, dann Text eingeben, Esc :wq<Return>)"
            rot "edit leer.txt"
            rot "´Neue Datei´ > leer2.txt" 0
            rot "del stage.txt" 0
            rot "git add --all"
            rot "git commit -m ´Geändert, neu und gelöscht´" 0
            break
        }
        43
        {
            gelb "Wir machen nun die letzten Änderung im Branch ´NeueKLassen´, danach wollen wir alle Änderung in der Master-Branch zusammenführen."
            rot "git checkout NeueKlassen"
            rot "´hier initialisieren wir die neuen Klassen´ > Neueklassen.class"
            rot "cd Dokumentation" 0
            rot "´Anleitung neue Klassen´ > neueklassen.txt" 0
            rot "cd.." 0
            rot "git add --all" 0
            rot "git commit -m ´Letzte Änderungen und Doku´" 0
            break
        }
        44
        {
            gelb "Mit git branch sehen wir, das wir noch im ´NeueKlassen´ Branch sind. Wir wechseln in den Master und schauen uns das Graph-Log an."
            gelb "Anschließend Mergen wir den Branch ´NeueKlassen´ in den Master-Branch."
            rot "git branch"
            rot "git checkout master" 0
            rot "git log --graph --oneline --all" 0
            rot "git merge NeueKlassen" 0
            rot "git log --graph --oneline --all" 0
            grau "~Hier sehen wir gut, wie der NeueKlassen-Branch in den Master-Branch einfließt. Jetzt haben wir nur noch den Master-Branch und dieser beinhaltet nun alle Änderungen, die wir (abseits vom Master-Branch) im NeueKlassen-Branch durchgeführt hatten."
            break
        }
        45
        {
            if (-not ($anweisung))
            {
                for ($i = 1; $i -le 10; $i++) { Add-Content -Value "Zeile $i" -Path branch.txt }
            }
            gelb "Beim erstellen neuer Ordner und Dateien innerhalb verschiedener und beliebig vieler Branches verläuft das Zusammenführen (Merge) immer ohne Probleme."
            gelb "In einer Datei, die ich bereits erstelt habe, fügen wir nun aus 3 Branches Zeilen hinzu."
            rot "git status"
            grau "~Wir sehen, die branch.txt ist verändert und noch untracket (mit im #sta)"
            rot "git add --all"
            rot "git commit -m ´branch.txt hinzugefügt 1-10´"
            grau "~Die hinzugefügte Datei muss Commitet werden. Vor der Erstellung eines Branches sollte/muss der aktuelle/Master-Branch aktuell sein!"
            rot "git branch zwei" 
            rot "git checkout zwei" 0
            grau "~Wird schreiben zwischen Zeile 2 und 3 die Zeile: ´ZWEI´ (VIM: i -> Insert Mode, Text eingeben, Esc dann :wq<Return>)"
            rot "edit branch.txt"
            break
        }
        # TODO >>> GEPRÜFT BIS HIER HIN *v*v*v*v*v*v*v*v*v*v*v*v*v* <<<
        46
        {
            gelb "Nun commiten wir diese Änderung in den Branch ´zwei´ und machen eine Änderung in einem weiteren Branch (den wir natürlich vom Master-Branch erstellen)."
            rot "git add --all"
            rot "git commit -m ´branch.txt Nach Zeile 2: ZWEI´" 0
            rot "git checkout master" 0
            rot "git branch drei" 0
            rot "git checkout drei" 0
            grau "~Wird schreiben zwischen Zeile 5 und 6 die Zeile: ´DREI´ (VIM: i -> Insert Mode, Text eingeben, Esc dann :wq<Return>)"
            rot "edit branch.txt" 0
            rot "git add --all" 
            rot "git commit -m ´branch.txt Nach Zeile 5: DREI´" 0
            break
        }
        47
        {
            gelb "Wir machen eine letzte Änderung in einem weiteren Branch (den wir natürlich vom Master-Branch erstellen)."
            rot "git checkout master" 0
            rot "git branch vier" 0
            rot "git checkout vier" 0
            grau "~Wird schreiben zwischen Zeile 9 und 10 die Zeile: ´VIER´ (VIM: i -> Insert Mode, Text eingeben, Esc dann :wq<Return>)"
            rot "edit branch.txt" 0
            rot "git add --all" 
            rot "git commit -m ´branch.txt Nach Zeile 9: VIER´" 0
            rot "git checkout master"
            rot "type branch.txt" 0
            grau "~Im Master-Branch ist keine Änderung der Datei ´branch.txt´ vorhanden"
            break
        }
        48
        {
            gelb "Wir kontrollieren mal alles."
            rot "git checkout zwei"
            rot "type branch.txt" 0
            grau "~Hier steht nach Zeile 2 ´ZWEI´, dann Zeile 3 bis 10"
            rot "git checkout drei"
            rot "type branch.txt" 0
            grau "~Hier steht nach Zeile 5 ´DREI´, dann Zeile 6 bis 10"
            rot "git checkout vier"
            rot "type branch.txt" 0
            grau "~Hier steht nach Zeile 9 ´VIER´, dann Zeile 10"
            rot "git checkout master"
            rot "type branch.txt" 0
            grau "Hier stehen nur Zeile 1 bis 10"
            break
        }
        49
        {
            gelb "Nun führen wir schrittweise die 3 Branch in den Master-Branch. Wir sehen uns jedesmal die ´branch.txt´ Datei an."
            rot "git merge zwei"
            rot "type branch.txt" 0
            grau "~Jetzt steht ´ZWEI´ nach Zeile 2"
            rot "git merge drei"
            rot "type branch.txt" 0
            grau "~Jetzt steht auch ´DREI´ nach Zeile 5"
            rot "git merge vier"
            rot "type branch.txt" 0
            grau "~Nun stehen alle Änderungen (´ZWEI´, ´DREI´, ´VIER´) an der richtigen Stelle."
            grau "Auch wichtig zu wissen ist:"
            gelb "War ein Branch erfolgeich, wird automatisch ein #com erstellt. Gab es Konflikte muss der Benutzer dieser lösen und selber ein #com erstellen. Wobei Konfliktfreie Inhalte breits im #sta sind (also git add ....)."
            break
        }
        50
        {
            gelb "Wir wechseln nochmal in der Branch ´vier´ und machen eine Änderung in der branch.txt"
            gelb "Danach welchseln wir in der Master-Branch."
            rot "git checkout vier"
            rot "edit branch.txt" 0
            grau "~Irgendwas rein schreiben, egal was, hauptsache eine Veränderung."
            rot "git add --all"
            rot "git commit -m ´branch.txt geändert´" 0
            rot "git checkout master" 0
            break
        }
        51
        {
            gelb "Nun löschen wir die Branches: NeueKlassen zwei, drei und vier."
            rot "git branch" 0
            grau "~Wir sehen unsere vorhandenen Branches"
            rot "git branch -d NeueKlassen"
            rot "git branch -d zwei"
            rot "git branch -d drei"
            rot "git branch -d vier"
            grau "~Beim letzten kommt eine Fehlermeldung, da hier ja noch eine Änderung vorhanden ist. Wir wollen aber trotzdem den Branch löschen. Dies geht mit einem großen -D"
            rot "git branch -D vier"
            rot "git branch"
            grau "~Es gibt nur noch den Master-Branch in dem wir uns auch befinden."
            break
        }
        52
        {
            gelb "Bei Änderung an einer Datei an gleichen Zeilen oder auch das Löschen dieser, führt zu Konflikten da git das nicht weiss, welche Zeile aus welchen Branch jetzt übernommen werden soll."
            gelb "Hierfür gibt es Merge-Tools wie Meld oder P4Merge (natürlich noch andere) die kostenlos installiert werden können."
            gelb "Man muss dann noch entsprechend git Konfigurieren!"
            gelb "~Mit"
            grün "git merge --abort" 0
            gelb "wird git versuchen den Zustand VOR dem Merge wiederherzustellen (diese ist nur sicher, wenn es vor dem Merge-Befehl keine Änderungen gab (also alles gecommitet war oder ein #sta erstellt wurde)."
            grau "Am anfachsten passt man dann die Konflikt-Dateien im Master-Branch manuell an und löscht diese aus den anderen Branch die gemerged werden sollen."
            if (HasChoco)
            {
                gelb "~Wenn Du dich für Merge-Tools interessierst, kannst Du nun install-tools eingeben. Dann kommst Du in den Assistenten für ein Mergetool inkl. Konfiguration von Git."
                rot "install-tools"
            }
            else
            {
                gelb "Leider hast Du kein Choco installiert, mit Choco könntest Du dir über den Tutorial-Mergetool-Assistenten ein Mergetool installieren und Git gleich Konfigurieren."                
                if (-not ($anweisung))
                {
                    if (Test-AdminRecht)
                    {
                        if (fragen -frage "Soll Choco installiert werden?")
                        {
                            instchoco
                        }
                    }
                    else
                    {
                        gelb "Starte die PowerShell als Administrator, führe das Tutorial-Skript erneut aus und gebe instchoco ein um Chocolatey zu installieren."
                    }
                }
            }
            break
        }
        53
        {
            gelb "Oft kommt es vor das im Master-Branch keine oder nur sehr wenig Änderungn vorhanden sind. Die meisten Änderungen gab es in einem Bransh."
            gelb "Ein Merge funktioniert dann zwar perfekt, jedoch wird die Darstellung des History (git log --graph) sehr unübersichtlich."
            gelb "Schöner wäre es, wenn es in der History nicht zu sehen wäre, also ein #com ohne die Branch-Verzweigungen."
            gelb "Hierfür gibt es Rebasing. Es funktioniert grundsätzlich wie ein Merge."
            gelb "Wir erstellen nun ein Branch, ändern dort etwas. Anschließend machen wir eine kleine Veränderung im Master-Branch."
            rot "git branch base1"
            rot "git checkout base1" 0
            rot "edit code.cs" 0
            grau "In der code.cs irgendeine Änderung machen. Hinzufügen, Löschen vom Text, eigenlich egal was."
            rot "´Neue Datei´ > rebase.txt"
            rot "git add --all" 0
            rot "git commit -m ´Rebasetest´" 0
            rot "git checkout master"
            rot "´Neue Datei im Master´ > master.txt" 0
            rot "git add --all" 0
            rot "git commit -m ´Rebasetest´" 0
            break
        }
        54
        {
            gelb "Nun noch den Rebase durchführen. Dann sollte allte Änderungen im Master-Branch sein."
            rot "dir"
            grau "~Die Branch.txt ist nicht da"
            rot "type code.cs"
            grau "~Auch die Änderungen in code.cs ist nicht vorhanden"
            rot "git rebase base1"
            rot "dir" 0
            rot "type code.cs" 0
            grau "~Nun sind die Änderungen im Master-Branch vorhanden"
            rot "git log --graph --oneline --all"
            grau "~Aber es ist nicht ersichtlich, das es mal ein Branch gab."
            break
        }
        55
        {
            gelb "Mit Merge würde es anders aussehen."
            if (-not ($anweisung))
            {
                $Global:MakeDiff = $false
                if (fragen "Schritt 54 wiederholen?")
                {
                    $Global:Copy = git log --graph --all --oneline
                    $Global:MakeDiff = $true
                    s 54
                }
            }
            cls
            gelb "Du kannst den Schritt nun wiederholen. Versuche es dann mal mit"
            rot "git merge base1"
            rot "dir" 0
            rot "type code.cs" 0
            gelb "~Interessant ist dann die Darstellung der History"
            rot "git log --graph --oneline --all"
            break
        }
        56
        {
            if ($Global:MakeDiff)
            {
                $diff = (git log --graph --oneline --all)
                Set-Content -path unterschied.txt -value "Log vom Rebase:"
                $x = 1
                Add-Content -path unterschied.txt -value  ($Global:Copy[0..10] | ForEach { "{0:00}: $_ " -f $x++ })
                #                Add-Content -path unterschied.txt -value $Global:Copy[0..10]
                Add-Content -path unterschied.txt -value "----------------------------------"
                add-content -path unterschied.txt -value "Log vom Merge:"
                $x = 1
                add-content -path unterschied.txt -value  ($diff[0..10] | ForEach { "{0:00}: $_ " -f $x++ })
                #                add-content -path unterschied.txt -value $diff[0..10]
            }
            gelb "Wenn es beim Rebase Konflikte gibt, muss zuerst genauso verfahren werden wie beim Merge."
            gelb "Sind alle Konflikte beseitigt kann mit"
            grün "git rebase --continue"
            gelb "~Das Rebasing fortgesetzt werden."

            if (Test-Path unterschied.txt)
            {
                if (fragen "Willst Du nochmal den Unterschid vom git log des Rebasing und der Merge sehen?")
                {
                    edit "unterschied.txt"
                }
            }
            break
        }
        101
        {
            gelb "Das war jetzt die Theorie. Jetzt wird es etwas praktischer."
            gelb "Wir entwickeln eine kleine Webseite, Simulieren später zwei Server und es werden mehrere Mitarbeiter an dem Projekt arbeiten."
            if ($Global:Editor -ne "code")
            {
                gelb "~Für dieses Kapitel empfehle ich Visual Studio Code als Editor."
                if (HasCode)
                {
                    if (fragen -frage "Soll ich Visual Studio Code als Standardeditor für das Tutorial wählen?" -jaDefault)
                    {
                        $Global:Editor = "code"
                    }
                    else
                    {
                        gelb "Gebe Install-Tools ein um Visual Studio Code zu installieren oder gehe auf die entsprechende Website um Visual Studio Code herunterzuladen und manuell zu installieren."
                        rot "Install-Tools"
                    }
                }
            }
            else
            {
                gelb "~Sehr schön, Visual Studio Code ist als Editor gewählt. Dieser ist für dieses Kapitel am besten geeignet."
            }
            grau "~Gehe in den nächsten Schritt wenn Du soweit bist."
            InitKapitel2
            break
        }
        102
        {
            Set-Content -Path index.html -Value (HTMLBase) -NoNewline
            gelb "Ich habe eine index.html ohne body-Inhalt erzeugt. Für dieses Kapitel sind HTML Kenntnisse sicher von Vorteil, es geht aber auch ohne." 
            gelb "~Die index.html kann im Browser mit browse oder einfach nur b im Standard-Browser geöffnet werden. Wird browser bzw. b eine Datei mit angegeben, so wird diese geöffnet."
            gelb "Genauso verhält es sich mit edit. Ohne Datei wird im eingestellten Editor die index.html editiert."
            gelb "Für diese html-Vorlage machen wir unser erstes Commit, dafür müssen wir aber erst ein Repository initialisieren."
            rot "Für einfache und bereits vorgekommene git-Befehle werde ich hier keine Anleitung mehr in rot darstellen."
            rot "Solltest Du dennoch Anweisungen brauchen, so erhälst Du sie durch Eingabe von ??." 0
            gelb "~Wir fangen mal so an wie man ein Projekt anfängt: Mit ´Hello World!´"
            gelb "Editiere die index.html und schreibe in der leeren Zeile zwischen <body> und </body> ´Hello World!´. Dann natürlich speichern."
            rot "Aufgabe erledigen oder ?? für Anweisungen"
            break
        }
        103
        {
            gelb "Sehr schön, für diese kleine Änderung erstellen wir nun ein Commit."
            gelb "Vergiss nicht ?? für die Anweisungen, probiere es aber erstmal ohne diese Hilfe."
            break
        }
        104
        {
            md "..\server" | Out-Null
            gelb "Der Server wurde inzwischen eingerichtet und steht über den Ordner ..\server bereit."
            gelb "Schaue dich mit dir um, anschließend werden wir unser Repository in der Server klonen."
            rot "dir .."
            rot "dir ..\server" 0
            grau "Der Server ist natürlich noch leer"
            rot "git clone .git ..\server"
            grau "Wird klonen also unser lokales .git-Repository (wenn Du dir -Hidden eingibst, siehst Du im Explorer den Ordner .git) nach ..\server"
            rot "dir --Hidden"
            rot "dir ..\server" 0
            grau "Nun ist unsere HTML-Seite auf dem Server."
            break
        }
        105
        {
            gelb "´Hello World!´ soll nun die Überschrift der Seite sein. Wir umschließen diese Zeile in ein <h1>-Tag."
            gelb "Anschließend speichern und ein #com erstellen."
            break
        }
        106
        {
            gelb "Mit b können wir uns nun die geänderte Webseite im Browser ansehen. Mit bs öffnet der Browser immer die index.html im ..\server-Verzeichnis."
            rot "b"
            rot "bs" 0
            gelb "Wir sehen, der Server hat noch die alte Version."
            gelb "Wir schicken dem Server nun die neue. Dafür muss sich der Server auf einem anderem Branch befinden da man noch von master zur master pushen kann."
            rot "cd ..\server"
            rot "git branch nix" 0
            rot "git checkout nix" 0
            rot "cd ..\user1" 0
            rot "git push --set-upstream ..\server master" 0
            break
        }
        107
        {
            gelb "Nun müssen wir auf dem Server nur noch in den master-Branch wechseln, dann sollte der Browser Hello World! ebenfalls als Überschrift anzeigen."
            gelb "Wir wechseln danach wieder in das ..\user1 Verzeichnis."
            break
        }
        108
        {
            gelb "Nun ist es immer umständlich im Server auf einen anderen Branch zu wechseln, zu pushen und wieder zurück zu wechseln. Daher werden wir die nächste Änderung pullen."
            gelb "~Wir schreiben unter unserer Überschrift ´Willkommen in der Welt von git.´."
            gelb "Anschließend speichern, #com erstellen."
            break
        }
        109
        {
            gelb "Auch jetzt hat natürlich der Server diese Zeile noch nicht. Wir wechseln zum Server und pullen uns die Änderung."
            rot "cd ..\server"
            rot "git pull ..\user1" 0
            rot "cd ..\user1" 0
            rot "bs"
            grau "Wir sehen, nun hat der Server die Änderung."
            grau "Es liegt in unserem Fall einem frei push oder pull zu verwenden. Bei Verwendung von GitHub bleibt nur push als Möglichkeit, da wir nich zu GitHub können um auf deren Server ein pull zu machen."
            grau "Ansonsten verhält es sich zwischen einen Verzeichnis im eigenen Dateisystem und einem Server/GitHub sehr ähnlich. Es gibt noch Möglichkeiten den Remote-Server (GitHub) zu konfurieren (Benutzername, Passwort/Token). Aber sonnst ist es sehr ähnlich."
        }

        <# TODO __1__(Weiter) Nächster Schritt #>
    }
    
    $nr++
    $global:schritt = $nr
}
if (-not (Test-Path ~\ScriptSilent))
{
    init

    rot "Solten Befehle nicht Funktionieren, so das Skript bitte mit vorangestelltem . ausführen"
    rot ". Tutorial-DE.ps1" 0
}

