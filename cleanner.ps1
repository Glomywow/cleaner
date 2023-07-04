# Установка шаблонного пути к папкам пользователей
$usersPath = "C:\Users"
$diskThreshold = 1 # Пороговое значение свободного места на диске в гигабайтах

# Проверка доступного места на диске
$diskFreeSpaceGB = (Get-PSDrive -PSProvider 'FileSystem' | Where-Object {$_.Root -eq 'C:\'}).Free / 1GB
if ($diskFreeSpaceGB -lt $diskThreshold) {
    Write-Host "Недостаточно свободного места на диске. Операция удаления отменена."
    exit
}

# Поиск пользовательских папок
$userFolders = Get-ChildItem -Path $usersPath -Directory

# Вывод списка пользователей
$userCount = $userFolders.Count
Write-Host "Найдено $userCount пользователей с никами:"
foreach ($userFolder in $userFolders) {
    $userName = $userFolder.Name
    Write-Host $userName
}

# Логирование
$logFilePath = "G:\123.log"
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logFilePath -Value "[$date] Найдено $userCount пользователей."

# Запрос на удаление временных файлов
$deleteTemp = Read-Host "Хотите удалить временные файлы для всех найденных пользователей? (y/n)"

if ($deleteTemp.ToLower() -eq "y") {
    foreach ($userFolder in $userFolders) {
        $userName = $userFolder.Name
        Write-Host "Удаляются временные файлы для пользователя $userName"

        # Удаление временных файлов
        $tempPath = Join-Path -Path $userFolder.FullName -ChildPath "AppData\Local\Temp"
        try {
            Remove-Item -Path $tempPath\* -Force -Recurse -ErrorAction Stop
            Write-Host "Временные файлы успешно удалены для пользователя $userName"
        }
        catch {
            Write-Host "Ошибка при удалении временных файлов для пользователя ${userName}: $_"
        }

        # Очистка папок "Мои документы", "Рабочий стол" и "Загрузки"
        $documentsPath = Join-Path -Path $userFolder.FullName -ChildPath "Documents"
        $desktopPath = Join-Path -Path $userFolder.FullName -ChildPath "Desktop"
        $downloadsPath = Join-Path -Path $userFolder.FullName -ChildPath "Downloads"

        try {
            Remove-Item -Path $documentsPath\* -Force -Recurse -ErrorAction Stop
            Remove-Item -Path $desktopPath\* -Force -Recurse -ErrorAction Stop
            Remove-Item -Path $downloadsPath\* -Force -Recurse -ErrorAction Stop
            Write-Host "Папки пользователя $userName успешно очищены"
        }
        catch {
            Write-Host "Ошибка при очистке папок пользователя ${userName}: $_"
        }

        # Логирование
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $logFilePath -Value "[$date] Папки пользователя $userName очищены."
    }
}
