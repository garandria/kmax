## Example on BusyBox

To run kmax on all Kbuild files in the BusyBox source tree, run the following:

    mkdir .kmax
    kmaxall -z $(find | grep "Kbuild$" | cut -c3-) | tee .kmax/kmax

    kanalysis --kmax-formulas .kmax/kmax loginutils/addgroup.o
    kanalysis --kmax-formulas .kmax/kmax coreutils/


    mkdir .kmax
    kmaxall -z $(find | grep "Kbuild$" | cut -c3-) | tee .kmax/kmax
    mkdir -p .kmax/kclause/x86_64/
    /home/paul/research/repos/kmax/kconfig_extractor_ubuntu-v4.18/kconfig_extractor_ubuntu-v4.18 --extract Config.in > .kmax/kclause/x86_64/kconfig_extract
    kclause --remove-orphaned-nonvisible < .kmax/kclause/x86_64/kconfig_extract > .kmax/kclause/x86_64/kclause
    klocalizer coreutils/fsync.o
