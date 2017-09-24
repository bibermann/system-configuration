
build_clang()
{
    # Available variables:
    # - $project_version
    # - $abs_project_src
    # - $abs_project_build
    # - $abs_project_install
    # - $use_existing_src
    # - configuration variables

    if [ ${use_existing_src} -eq 0 ]; then
        svn co http://llvm.org/svn/llvm-project/llvm/$project_version "$abs_project_src"/llvm
        svn co http://llvm.org/svn/llvm-project/cfe/$project_version "$abs_project_src"/llvm/tools/clang
        svn co http://llvm.org/svn/llvm-project/clang-tools-extra/$project_version "$abs_project_src"/llvm/tools/clang/tools/extra
        svn co http://llvm.org/svn/llvm-project/lld/$project_version "$abs_project_src"/llvm/tools/lld
        svn co http://llvm.org/svn/llvm-project/libcxx/$project_version "$abs_project_src"/llvm/projects/libcxx
        svn co http://llvm.org/svn/llvm-project/libcxxabi/$project_version "$abs_project_src"/llvm/projects/libcxxabi
        svn co http://llvm.org/svn/llvm-project/compiler-rt/$project_version "$abs_project_src"/llvm/projects/compiler-rt
    fi

    cd "$abs_project_build"
    cmake "$abs_project_src"/llvm -G Ninja -DCMAKE_INSTALL_PREFIX="$abs_project_install" -DCMAKE_BUILD_TYPE=Release
    ninja -j $njobs
    ninja install
}
