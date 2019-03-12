#
# backup & shrink 1c logs (EDIT THIS FILE!!!)
#

param (
    [string]$1cexe = "C:\Program Files (x86)\1cv8\8.3.7.1860\bin\1cv8.exe",
    [string]$1cbase = "server:port\basename",
    [string]$1cuser = "user",
    [string]$1cupassword = "passwd",
    [string]$1coperlog = "E:\scripts\log\1cshrink.log",
    [string]$1cdaysoflogstore = 30,
    [string]$1clogsarchive = "E:\scripts\journal\",
    [string]$1clogfilename = $env:COMPUTERNAME.ToLower() + "-1clog-" + ($1cbase.split("\"))[1] + "-" + (get-date).Date.ToString("yyyyMMdd") + ".elf"
)

$1clog = $1clogsarchive + $1clogfilename

cmd /c "`"`"$1cexe`" CONFIG `/s$1cbase `/N`"$1cuser`" `/P`"$1cupassword`" `/Out$1coperlog `/ReduceEventLogSize $((get-date).Date.AddDays(-$1cdaysoflogstore).ToString("yyyy-MM-dd")) -saveAs`"$1clog`"`""