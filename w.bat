@echo off
setlocal enabledelayedexpansion

cipher /d /s:"C:\Users\%USERPROFILE%\OneDrive\Documents\ratbat"

set "base=%USERPROFILE%\OneDrive\Documents\ratbat"

echo Base folder is "!base!"

if not exist "!base!" (
    echo Base folder "!base!" not found.
    goto :end
)

set "protected=0"

rem Loop through all subfolders under base (ratbat1..ratbat99 etc.)
for /D %%F in ("!base!\*") do (
    set "sub=%%F"

    rem Extract folder name only (e.g. ratbat42)
    for %%X in ("!sub!") do set "fname=%%~nX"

    echo Checking folder "!sub!"

    rem If bat.txt exists in this subfolder, skip it entirely and mark protection
    if exist "!sub!\bat.txt" (
        msg * Could not delete folder !fname! because it contains a protection file. Remove the file first to delete !fname! and it's folder base ratbat
        set "protected=1"
    ) else (
        echo Cleaning folder "!sub!"

        rem Delete only rat*.txt files one by one
        for %%R in ("!sub!\rat*.txt") do (
            echo Deleting "%%R"
            del /q "%%R"
        )

        rem If any rat*.txt files are still present, do not remove this folder
        if exist "!sub!\rat*.txt" (
            msg * Could not delete folder !fname! because it contains a protection file. Remove the file first to delete !fname! and it's folder base ratbat
            set "protected=1"
        ) else (
            echo Removing folder "!sub!"
            rd "!sub!"
        )
    )
)

rem If no protected folders left, remove the base folder; otherwise, keep it
if "!protected!"=="0" (
    echo Removing base folder "!base!"
    rd "!base!"
) else (
    msg * Could not delete folder ratbat because it contains a protection file. Remove the file(s) first to delete ratbat and it's folder base ratbat
)

:end
echo Finished Deleting ratbat files. Closing in :
timeout /t 10 /nobreak
endlocal