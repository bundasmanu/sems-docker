#!/bin/bash

set -e

trap "Ok received Exit" HUP INT QUIT TERM

copy_deb_pkgs() {
    mkdir -p ${PKG_DEBS_FOLDER}
    cp -rp ../libsems1-dev*.deb ../sems-dbg_*.deb ../sems_*.deb \
        ${PKG_DEBS_FOLDER}
}

copy_plugin_configs (){
    cp -rp ${TMP_CONF_FOLDER}/* ${PLUGINS_CONF_FOLDER}
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
        copy_plugin_configs
        run_sems
        ;;
    *)
        echo "Executing custom command"
        exec "$@"
        ;;
esac
