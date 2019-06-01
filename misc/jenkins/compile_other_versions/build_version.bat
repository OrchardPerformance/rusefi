rm -rf temp
set folder=snapshot_%date:~10%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%_%bundle_name%_rusefi
set folder=temp\%folder%

rem this replaces spaces with 0s - that's needed before 10am
set folder=%folder: =0%

echo Building file
call misc\jenkins\build_working_folder.bat

rem TODO: extract FTP duplication with 407 build

echo open ftp://%RUSEFI_BUILD_FTP_USER%:%RUSEFI_BUILD_FTP_PASS%@%FTP_SERVER%/ > ftp_commands.txt
echo binary >> ftp_commands.txt
echo put rusefi_bundle.zip rusefi_bundle_%bundle_name%.zip >> ftp_commands.txt

echo exit >> ftp_commands.txt

cd temp
mv rusefi_bundle.zip rusefi_bundle_%bundle_name%.zip

ncftpput -u %RUSEFI_BUILD_FTP_USER% -p %RUSEFI_BUILD_FTP_PASS% %FTP_SERVER% . rusefi_bundle_%bundle_name%.zip

rem call winscp.com /script=../ftp_commands.txt
rem IF NOT ERRORLEVEL 0 echo winscp error DETECTED
rem IF NOT ERRORLEVEL 0 EXIT /B 1
cd ..
