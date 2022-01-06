CreateObject("Wscript.Shell").Run "C:\Windows\System32\wsl.exe --distribution Ubuntu bash --login -c ""export DISPLAY=:0; export LIBGL_ALWAYS_INDIRECT=1; export XCURSOR_SIZE=16; emacs""",0,True
