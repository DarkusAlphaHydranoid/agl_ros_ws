# NanoPC-T6 support
SRC_URI:nanopct6 = " \
    git://github.com/friendlyarm/rkbin.git;protocol=https;nobranch=1;branch=nanopi6;name=rkbin \
    git://github.com/JeffyCN/mirrors.git;protocol=https;branch=tools;name=tools;destsuffix=git/extra \
"

SRCREV_rkbin:nanopct6 = "f02d10e468d8c783c45137d230ff33d42ca670b4"
SRCREV_tools:nanopct6 = "1a32bc776af52494144fcef6641a73850cee628a"
