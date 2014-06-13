>  15:26 < keru> i'm reading the gcc cross compiler documentation on the wiki, it suggest to use the same version of gcc of the host system. problem : it's clang (macos X)
>  15:28 < zhiayang> keru: just download clang from the llvm website
>  15:28 < zhiayang> unpack it somewhere
>  15:28 < zhiayang> and run that clang.
>  15:28 < zhiayang> you'll want to pass '-target x86_64-elf' and '-integrated-as' to clang.
