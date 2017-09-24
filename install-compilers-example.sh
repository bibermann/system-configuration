
#!/usr/bin/env bash

set -euo pipefail

# configuration
#***************

configure_projects()
{
    # NOTE: Format of each line of $projects: "<action>,<name>,<version>".
    # NOTE: Ensure there is no space between the elements on each line.
    # NOTE: You can safely comment out lines.
    # NOTE: <action>() is defined in "functions/<action>.sh".
    # NOTE: <name> is used as $project_name in configure_target_directories().
    # NOTE: <version> is used as $project_version in <action>().

    projects=(
        build_gcc,gcc-5.4.0,gcc-5.4.0/gcc-5.4.0.tar.bz2
        build_gcc,gcc-6.4.0,gcc-6.4.0/gcc-6.4.0.tar.xz
        build_gcc,gcc-7.2.0,gcc-7.2.0/gcc-7.2.0.tar.xz
        build_clang,clang-4.0.1,tags/RELEASE_401/final
        build_clang,clang-5.0.0,tags/RELEASE_500/final
        build_clang,clang-6.0.0,trunk
        )
}

configure_actions()
{
    gcc_new_abi=1
    gcc_dual_abi=1
    njobs=$(grep -c ^processor /proc/cpuinfo)
}

configure_main_logic()
{
    skip_if_src_exists=1
    skip_if_install_exists=1
    remove_src_on_success=1
    remove_build_on_success=1
}

configure_target_directories()
{
    # Available variable: $project_name.

    # NOTE: $project_root is relative to the current directory (but may be specified absolute).
    # NOTE: Other paths are relative to $project_root (but may be specified absolute).

    project_root=~/tools/$project_name
    project_src=src
    project_build=build
    project_install=install

    # Possible alternative: Common install directory (if you only have one gcc and one clang build)
    # ($skip_if_install_exists in configure_main_logic() has to be 0 then):
    #project_root=~/tools
    #project_src=$project_name
    #project_build=$project_name/build
    #project_install=install
}

# run
#*****

script_dir=$(cd `dirname $0`; pwd)

for project in ${projects[@]}; do
    IFS=',' read project_action <<< "${project}"
    source "$script_dir/functions/$project_action.sh"
done
source "$script_dir/functions/main.sh"

main "$@"
