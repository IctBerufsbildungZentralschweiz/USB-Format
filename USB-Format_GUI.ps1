$shell = New-Object -ComObject Shell.Application

function formatusb{
$disks = (Get-Disk | Where-Object {($_.Bustype -Eq "USB") -and ($_.Size -Lt "64GB")})
$numdisks = (Get-Disk | Where-Object {($_.Bustype -Eq "USB") -and ($_.Size -Lt "64GB")}).count
$progressbar.Value = 0
$Count= 0

foreach ($disk in $disks)
    {
    $diskID = $disk.number
    $diskName = $disk.friendlyname
    Clear-Disk -Number $diskID -RemoveData -RemoveOEM -Confirm:$False
    New-Partition -DiskNumber $diskID -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem exfat -NewFileSystemLabel ICT-BZ
    $Label2.text  = "cleaning Disk $diskID | $diskName"
    $Count = $Count + 1
    $progressbar.Value = $count
    $Label3.text = $Count

    $ProgressBar.Refresh()
    $ICTBZtool.Refresh()

    foreach ($window in ($shell.Windows() | Where-Object { $_.LocationURL -like "$(([uri]"*ICT-BZ*").AbsoluteUri)*" }))
        {
        $window.Quit()
        $Label2.text   = "cleaning Disk $diskID done!"
        
        }
}


}

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ICTBZtool                       = New-Object system.Windows.Forms.Form
$ICTBZtool.ClientSize            = New-Object System.Drawing.Point(400,289)
$ICTBZtool.text                  = "ICT-BZ USB Formating Tool"
$ICTBZtool.TopMost               = $false
$ICTBZtool.icon = "C:\Users\brj\Downloads\harddisk.png"

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Dieses Tool formatiert automatisiert sämtliche USB-Devices"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(24,19)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Start                           = New-Object system.Windows.Forms.Button
$Start.text                      = "Start Formating"
$Start.width                     = 148
$Start.height                    = 30
$Start.location                  = New-Object System.Drawing.Point(24,138)
$Start.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Start.ForeColor                 = [System.Drawing.ColorTranslator]::FromHtml("#ae0000")
$Start.BackColor                 = [System.Drawing.ColorTranslator]::FromHtml("#50e3c2")
$Start.Add_Click({
    if($Standard.checked)
{
$maxsize = $TextBox1.Value + "GB"
} 
    formatusb
    
    })


$Close                           = New-Object system.Windows.Forms.Button
$Close.text                      = "Close"
$Close.width                     = 144
$Close.height                    = 30
$Close.location                  = New-Object System.Drawing.Point(221,138)
$Close.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Close.BackColor                 = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")
$Close.Add_Click({    $ICTBZtool.Close()})


$Standard                        = New-Object system.Windows.Forms.RadioButton
$Standard.text                   = "Standard"
$Standard.AutoSize               = $false
$Standard.width                  = 104
$Standard.height                 = 20
$Standard.enabled                = $true
$Standard.location               = New-Object System.Drawing.Point(24,52)
$Standard.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Manuell                         = New-Object system.Windows.Forms.RadioButton
$Manuell.text                    = "Manuell"
$Manuell.AutoSize                = $true
$Manuell.width                   = 104
$Manuell.height                  = 20
$Manuell.location                = New-Object System.Drawing.Point(226,52)
$Manuell.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$DTXT                            = New-Object system.Windows.Forms.Label
$DTXT.text                       = "Disk-Size in GB:"
$DTXT.AutoSize                   = $true
$DTXT.width                      = 25
$DTXT.height                     = 10
$DTXT.location                   = New-Object System.Drawing.Point(241,80)
$DTXT.Font                       = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 100
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(241,105)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)




$ProgressBar                     = New-Object system.Windows.Forms.ProgressBar
$ProgressBar.width               = 342
$ProgressBar.height              = 30
$ProgressBar.location            = New-Object System.Drawing.Point(24,210)
$ProgressBar.Minimum             = 0
$ProgressBar.value               = $progress
$ProgressBar.Maximum             = $numdisks
$progressBar.Style="Continuous"


$Label2                          = New-Object system.Windows.Forms.Label
$Label2.width                    = 250
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(95,190)
$Label2.AutoSize                 = $true
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


$Label3                          = New-Object system.Windows.Forms.Label
$Label3.width                    = 250
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(95,230)
$Label3.AutoSize                 = $true
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


    
$ICTBZtool.controls.AddRange(@($Label1,$Start,$Close,$Standard,$Manuell,$DTXT,$TextBox1,$Label2 ,$Label3,$ProgressBar))

$Manuell.Add_GiveFeedback({  })




#Write your logic code here

[void]$ICTBZtool.ShowDialog()