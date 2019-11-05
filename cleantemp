cd C:\Users
ForEach ($t in dir -Name -Exclude "All Users") 
{del "$t\AppData\Local\Temp\*",
    "$t\AppData\Local\1C\*",
    "$t\AppData\Roaming\1C\1Cv82",
    "$t\AppData\Roaming\1C\1Cv8",
    "$t\AppData\Roaming\1C\Файлы",
 "$t\AppData\Local\Microsoft\Windows\WebCache\*",
 "$t\AppData\Local\Microsoft\Windows\INetCache\IE\*",
 "$t\AppData\Local\Microsoft\Windows\INetCache\Low\IE\*",
 "$t\AppData\Roaming\Microsoft\Шаблоны\LiveContent\*",
 "$t\AppData\Local\Microsoft\Windows\INetCache\ERC\*",
 "$t\AppData\Roaming\Telegram Desktop",
"$t\AppData\Local\Microsoft\Terminal Server Client\*",
 "$t\Downloads\*",
 "$t\AppData\Local\Google\Chrome\User Data\Crashpad\*",
 "$t\AppData\Local\Google\Chrome\User Data\Default\Media Cache",
 "$t\AppData\Local\Microsoft\Windows\WER\*",

 "$t\AppData\Local\Google\Chrome\User Data\Default\Application Cache\Cache\*",
 "$t\AppData\Local\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force; Write-Host "$t = OK"}
cd C:\
Write-Host "`nПРОЦЕСС ЗАВЕРШЕН`n"
