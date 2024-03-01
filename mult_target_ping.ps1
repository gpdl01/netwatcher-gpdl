$downcounter = 0
$maxdowncount = 5
$sendtotelegram = 1
while ($true) {
    foreach ($name in $names){
      $Time = (Get-Date).ToString(“HH:mm:ss”)
      $Date = Get-Date -Format dd.MM.yyyy
      $response = (Test-Connection -ComputerName $name -Count 2 -BufferSize 54 -ErrorAction SilentlyContinue | measure-Object -Property ResponseTime -Average).average
      if ($response -ne $null){
        $response = ($response -as [int] ) 
        $Output+= "$Date,$Time,$name,up,$response ms"
        Write-Host "$Date,$Time,$Name,up,$response ms" -ForegroundColor Green
      }else{
        $Output+= "$Date,$Time,$name,down,no response"
        Write-Host "$Date,$Time,$Name,down,no response" -ForegroundColor Red
	    if ($sendtotelegram -eq 1){
        #Invoke-RestMethod -Uri "https://api.telegram.org/bot%YOUR TOKEN HEREsendMessage?chat_id=-%YOUR ID HERE%&text=$pcname->$Name-caiu-" -Method Post #sending msgs to your Telegram Bot
        }
        $downcounter = $downcounter + 1

        if ($downcounter -ge $maxdowncount) {
        Write-Host "$Name will not come back! Telegram alerts disabled." -ForegroundColor YELLOW
        Start-Sleep -Seconds 1
	    $downcounter = 0
        $sendtotelegram = 0
        }
      }
    }
    $Output | Out-file result.csv
    Start-Sleep -Seconds 5
}
