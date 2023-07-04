function Get-FolderSize {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]$FolderPath
    )

    $totalSize = 0

    $folders = Get-ChildItem -Path $FolderPath -Directory -Recurse

    foreach ($folder in $folders) {
        $files = Get-ChildItem -Path $folder.FullName -File
        if ($files) {
            $folderSize = $files |
                Measure-Object -Property Length -Sum |
                Select-Object -ExpandProperty Sum
        }
        else {
            $folderSize = 0
        }

        $totalSize += $folderSize
    }

    return $totalSize
}

function Perform-FolderCleanup {
    # ...
    # (код очистки папок пользователей)
    # ...
}

function Perform-FileCleanup {
    # ...
    # (код очистки файлов пользователей)
    # ...
}

function Get-UserDiskUsage {
    $userDiskUsage = @()

    $users = Get-ChildItem -Path "C:\Users" -Directory

    foreach ($user in $users) {
        $userName = $user.Name
        $userFolderPath = Join-Path -Path "C:\Users" -ChildPath $userName

        $userDiskUsage += [PSCustomObject]@{
            UserName = $userName
            DiskUsage = (Get-FolderSize -FolderPath $userFolderPath) / 1MB
        }
    }

    $userDiskUsage = $userDiskUsage | Sort-Object -Property DiskUsage -Descending

    return $userDiskUsage
}

function Output-UserDiskUsage {
    param (
        [Parameter(Mandatory=$true)]
        [array]$UserDiskUsage,
        [Parameter(Mandatory=$true)]
        [string]$OutputFilePath
    )

    $output = "Занимаемая память пользователей:`r`n"

    foreach ($userUsage in $UserDiskUsage) {
        $output += "User: $($userUsage.UserName) - $($userUsage.DiskUsage) MB`r`n"
        $output += "Топ 3 папки по занимаемому месту пользователя:`r`n"
        
        $userFolderPath = Join-Path -Path "C:\Users" -ChildPath $userUsage.UserName
        $topFolders = Get-ChildItem -Path $userFolderPath -Directory |
            ForEach-Object {
                $folderPath = $_.FullName
                $folderSize = Get-FolderSize -FolderPath $folderPath
                [PSCustomObject]@{
                    FolderName = $_.Name
                    FolderSize = $folderSize / 1MB
                }
            } |
            Sort-Object -Property FolderSize -Descending |
            Select-Object -First 3

        foreach ($folder in $topFolders) {
            $output += "$($folder.FolderName)`r`n"
        }

        $output += "`r`n"
    }

    $output | Out-File -FilePath $OutputFilePath
    Write-Host "Результаты проверки занятого места каждым пользователем сохранены в файл $OutputFilePath"
}

Write-Host "Выберите вариант очистки"
Write-Host "1. Произвести заготовленную чистку папок"
Write-Host "2. Произвести чистку jpg, word, pdf"
Write-Host "3. Проверить занятое место каждым пользователем"

# Получение выбранного варианта
$choice = Read-Host "Введите номер варианта (1, 2 или 3)"

switch ($choice) {
    1 {
        # Пункт 1: заготовленная чистка папок
        Perform-FolderCleanup
    }
    2 {
        # Пункт 2: чистка jpg, word, pdf
        Perform-FileCleanup
    }
    3 {
        # Пункт 3: проверка занятого места каждым пользователем
        $userDiskUsage = Get-UserDiskUsage
        $outputFilePath = "UserDiskUsage.txt"
        Output-UserDiskUsage -UserDiskUsage $userDiskUsage -OutputFilePath $outputFilePath
    }
    default {
        Write-Host "Некорректный выбор. Завершение скрипта."
    }
}
