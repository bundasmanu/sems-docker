#!/bin/bash

set -e

trap "Ok received Exit" HUP INT QUIT TERM

copy_deb_pkgs() {
    mkdir -p ${PKG_DEBS_FOLDER}
    cp -rp ../libsems1-dev*.deb ../sems-dbg_*.deb ../sems_*.deb \
        ${PKG_DEBS_FOLDER}
}

install_sems (){
    dpkg -i ${PKG_DEBS_FOLDER}/sems_*.deb && \
    dpkg -i ${PKG_DEBS_FOLDER}/libsems1-dev*.deb
}

run_sems () {
    sems -E -f ${CONFIGS_ROOT_FOLDER}/sems.conf
}

case "$1" in
    shell)
        exec /bin/bash --login
        ;;
    start)
        copy_deb_pkgs
        install_sems
        run_sems
        ;;
    *)
        echo "Executing custom command"
        exec "$@"
        ;;
esac
