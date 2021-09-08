function MakeContentFile($filename)
{
    $file = New-Item -ItemType File -Name $filename

    [Random] $rnd = [Random]::new()
    $loremLength = $rnd.Next(1,20)
    
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

function rep([string] $t) {
    return ([string] $t).Replace("#rep", "Repository").Replace("#com", "Commit")
}
Function Init
{
    [CmdletBinding()]
    param(
        $silent = 0
    )
    $dir = "$([System.Environment]::GetFolderPath("user"))\GIT_LESSON1"
    cd c:\
    if (Test-Path $dir)
    {
        Remove-Item $dir -Recurse -Force
    }
    md $dir | Out-Null
    cd $dir

    md Code1 | Out-Null
    cd Code1

    MakeContentFile "text.txt"
    MakeContentFile "datei1.txt"
    MakeContentFile "datei2.txt"
    New-Item -ItemType File -Name "leer.txt" | Out-Null
    if ($silent -eq 0)
    {
        Write-Host "Es gibt folgende Befehle:"
        Write-Host "Weiter (oder w) : Springt zum nächsten Schritt des Tutorials"
        Write-Host "Nochmal (oder n): Führt den aktuellen Schritt erneut aus (Achtung: Tutorial wird dabei zurückgesetzt!)"
        Write-Host "Zurück (oder z) : Springt ein Schritt zurück (Achtung: Tutorial wird dabei zurückgesetzt!)"
        Write-Host "Schritt <nr>    : Springt zum angegeben Schritt (z.B. Schritt 3 oder s 3)"
        Write-Host "Inhalt          : Zeigt eine Kapitelübersicht mit der Möglichkeit ein Kapitel zu wählen"
        Write-Host "Init            : Setzt das Tutorial zurück. Danach fängt man mit w oder weiter bei Schritt 1 ein"
        Write-Host "`nZu einem Schritt springen, zurück, nochmal oder Kapitelwahl mit Inhalt setzt das Tutorial zurück." -ForegroundColor Gray
        Write-Host "D.h. alle Schritte bis zum den gewünschten Punkt werden EXAKT so wie im Tutorial durchgeführt." -ForegroundColor Gray
        Write-Host "Eigene Aktionen werden dabei hinfällig!" -ForegroundColor Gray
        gelb "`nTexte in Gelb sind Anweisungen"
        grün "Texte in Grün stellen Beispiele dar"
        grau "Texte in Grau stellen zusätzliche Informationen dar"
        rot "Texte in Rot stellt die Anweisung oder die Befehlszeile dar, die exakt so eingegeben werden muss"
        grau "Allen Git-'Befehlen' muss git (=> das eigentliche Programm) vorangestellt werden!"
        rot "Gebe nun w ein und drücke return."
    }
    $global:schritt = 1
}


function Schritt {
    [CmdletBinding()]
    [Alias("s")]
    param(
        [int] $nr,
        [int] $silent = 0
    )
    if ($silent -eq 0)
    {
        gelb("Springe zum Schritt $nr")
    }
    init 1
    if ($nr -gt 1) { git init }
    if ($nr -gt 2) { git add --all }
    if ($nr -gt 3) { git commit --message "Start" }
    if ($nr -gt 4) { Set-Content -Path leer.txt -Value "Änderung" }
    if ($nr -gt 5) {
            git add --all
            git commit --message "kleine Änderung"
        }

    $global:schritt = $nr
    weiter
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
        $text = $this.id + (" " * (5-$this.id.Length)) + $this.bezeichnung
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
        Jump $this.schritt 1
    }
}

function Nochmal
{
    [CmdletBinding()]
    [Alias("n")]
    param(
    )

    Jump (([int]$global:schritt) - 1)
}
function Zurück
{
    [CmdletBinding()]
    [Alias("z")]
    param(
    )

    Jump (([int]$global:schritt) - 2)
}

function Inhalt {
    [CmdletBinding()]
    param(
    )
    
    $alle = @([Kapitel]::new(1, 1, "Der Anfang"),
              [Kapitel]::new(2, 3, "Erstes Commit")
              )

    [Kapitel]::Titel()
    foreach($k in $alle)
    {
        $k.Ausgabe()
    }

    $ein = Read-Host -Prompt "`nBitte Nr. eingeben"
    $alle[$ein-1].Start()
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

    $st = "Schritt $nr"; Write-Host (" "*($st.Length)*3 +  "`n" + " " *($st.Length) + $st + " " * ($st.Length) + "`n" + " "*($st.Length)*3)  -BackgroundColor Gray -ForegroundColor Black
    switch ($nr)
    {
        1 {
            gelb "Git für $dir\Code1 Initialisieren (#rep erstellen)" 
            grau "Der Befehl 'init' erstellt ein leeres #rep im aktuellen Ordner" 
            Write-Host "Und denk daran, mit w (oder weiter) geht es weiter" -ForegroundColor Cyan
            rot "git init"
            break }
        2 {
            gelb "Als erstes müssen alle Dateien als #com in das #rep aufgenommen werden"
            grau "Der Befehl add fügt Dateien dem #com hinzu. Entwerder einzelln (hier natürlich auch Dateien, die gelöscht wurden)"
            grau "oder alle auf einmal mit git add --all"
            rot "git add --all" 
            break }
        3 {
            gelb "Nun machen wir den ersten #com und übertragen den aktuellen Stand in das #rep."
            grau "Jedes #com benötigt eine Message, also eine Information zum aktuellen #com. Hier sollte kurz eingetragen werden, was das #com aus macht."
            rot "git commit --message `"Start`""
            break }
        4 {
            gelb "Nun schreiben wir in die Datei 'leer.txt' eine Zeile mit 'Änderung' und speichern diese ab."
            Read-Host "Bereit? (drücke Return)"
            Invoke-Item leer.txt
            break }
        5 {
            gelb "Nun möchten wir das diese Änderung in das #rep übertragen wird."
            rot "git add --all" 
            rot "git commit --message `"kleine Änderung`"" 0

            break }
    }
    
    $nr++
    $global:schritt = $nr
}
