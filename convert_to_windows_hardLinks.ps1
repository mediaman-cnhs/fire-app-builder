#find all the symlinks in current path
$symlinklines = &git ls-files -s | findstr 120000

#Create windows symlink for all these linux symlinks
ForEach($symlinkline in $symlinklines){
    #get the symlink path
    $splitUp = $symlinkline -split "\s+"
    $symlink = $splitUp[3]
    $linuxsymlink = $symlink

    #replace symlink destination path to windows path
    $symlinkpath = Get-Content $symlink 
    $symlinkpath = ($symlinkpath -replace "/","\").Trim("\", ".")
    
    #replace symlink linux path to windows path
    $symlink = ($symlink -replace "/","\")
    
    #create hardlink path
    $lensymlinkpath = $symlinkpath.Split("\").Length
    $splitUp = $symlink.Split("\")
    $hardlinkpath = $splitUp[0..($splitUp.count-($lensymlinkpath + 1))] -join '\'
    $hardlinkpath = $hardlinkpath + '\' + $symlinkpath

    #remove the linux symlink file converted into xml file    
    rm $linuxsymlink

    #create windows hardlink
    cmd /c mklink /H $symlink $hardlinkpath
    
    #let git assume the symlinks haven't got changed
    &git update-index --assume-unchanged $linuxsymlink
}
