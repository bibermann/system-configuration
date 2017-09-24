
build_gcc()
{
    # Available variables:
    # - $project_version
    # - $abs_project_src
    # - $abs_project_build
    # - $abs_project_install
    # - $use_existing_src
    # - configuration variables
    
    if [ ${use_existing_src} -eq 0 ]; then
        extension="${project_version##*.}"
        if   [ "$extension" == "gz" ];  then decompression_flag=-z
        elif [ "$extension" == "bz2" ]; then decompression_flag=-j
        elif [ "$extension" == "xz" ];  then decompression_flag=-J
        else echo "Script error: Unknown file extension: $extension"; exit 1
        fi
        wget -q -O - "https://ftpmirror.gnu.org/gnu/gcc/$project_version" | tar -x $decompression_flag -f - -C "$abs_project_src" --strip-components 1

        cd "$abs_project_src"
        ./contrib/download_prerequisites
    fi

    configure_flags=()
    if [ ${gcc_new_abi} -eq 1 ]; then
        configure_flags+=(--with-default-libstdcxx-abi=new)
    else
        configure_flags+=(--with-default-libstdcxx-abi=gcc4-compatible)
    fi
    if [ ${gcc_dual_abi} -eq 0 ]; then configure_flags+=(--disable-libstdcxx-dual-abi); fi

    cd "$abs_project_build"
    "$abs_project_src"/configure --prefix="$abs_project_install" --disable-multilib --enable-languages=c++,c ${configure_flags[@]}
    make -j $njobs
    make install
}
