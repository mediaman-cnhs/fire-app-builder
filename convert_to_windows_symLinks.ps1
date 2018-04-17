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
    $symlinkpath = ($symlinkpath -replace "/","\")
    
    #replace symlink path to windows path
    $symlink = ($symlink -replace "/","\")
    
    #remove the linux symlink file converted into xml file    
    rm $linuxsymlink

    #create windows symlink
    cmd /c mklink $symlink $symlinkpath
    
    #let git assume the symlinks haven't got changed
    &git update-index --assume-unchanged $linuxsymlink
}
