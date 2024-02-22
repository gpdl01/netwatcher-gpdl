$Output= @()
$names = Get-content "target-IPs.txt"
$pcname = $env:COMPUTERNAME #get computer name to save where ping come from
$host.ui.RawUI.WindowTitle = “NET-Watcher#by gpdl” # custom window name

while ($true) {
    foreach ($name in $names){ #looping on target-IPs list
      $Time = (Get-Date).ToString(“HH:mm:ss”) #get time
      $Date = Get-Date -Format dd.MM.yyyy #get date
      $response = (Test-Connection -ComputerName $name -Count 2 -BufferSize 30 -ErrorAction SilentlyContinue | measure-Object -Property ResponseTime -Average).average #ping command config and average
      if ($response -ne $null){
        $response = ($response -as [int] ) #rouding response value
        $Output+= "$Date,$Time,$name,up,$response ms,$pcname" #writing variables to file
        Write-Host "$Date,$Time,$Name,up,$response ms" -ForegroundColor Green #printing variables
      }else{
        $Output+= "$Date,$Time,$name,down,no response"
        Write-Host "$Date,$Time,$Name,down,no response" -ForegroundColor Red
        #Invoke-RestMethod -Uri "https://api.telegram.org/bot%YOUR TOKEN HEREsendMessage?chat_id=-%YOUR ID HERE%&text=$pcname->$Name-caiu-" -Method Post #sending msgs to your Telegram Bot
      }
    }
    $Output | Out-file ping-logs.csv #saving to file
    Start-Sleep -Seconds 60 #delay time between loops
    # Start-Sleep -Millis 300
}