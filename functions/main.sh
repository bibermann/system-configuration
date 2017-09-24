
main()
{
    configure_projects
    configure_actions
    configure_main_logic

    errors=()

    for project in ${projects[@]}; do
        IFS=',' read project_action project_name project_version <<< "${project}"

        printf 'Building %s from %s...\n\n' "$project_name" "'$project_version'"

        configure_target_directories

        mkdir -p "$project_root" && cd $_
        abs_project_root=$(pwd)

        if [ ${skip_if_src_exists} -eq 1 ] && [ -d "$project_src" ]; then
            errors+=("Skipped $project_name: 'skip_if_src_exists' is true and directory '$project_src' already exists.")
            printf '\n%s\n\n' "${errors[-1]}"
            continue
        fi
        if [ ${remove_build_on_success} -eq 1 ] && [ -d "$project_build" ]; then
            errors+=("Skipped $project_name: 'remove_build_on_success' is true and directory '$project_build' already exists.")
            printf '\n%s\n\n' "${errors[-1]}"
            continue
        fi
        if [ ${skip_if_install_exists} -eq 1 ] && [ -d "$project_install" ]; then
            errors+=("Skipped $project_name: 'skip_if_install_exists' is true and directory '$project_install' already exists.")
            printf '\n%s\n\n' "${errors[-1]}"
            continue
        fi

        if [ -d "$project_src" ]; then use_existing_src=1; else use_existing_src=0; fi
        mkdir -p "$project_src"
        mkdir -p "$project_build"
        mkdir -p "$project_install"
        abs_project_src=$(cd "$project_src"; pwd)
        abs_project_build=$(cd "$project_build"; pwd)
        abs_project_install=$(cd "$project_install"; pwd)

        $project_action

        if [ ${remove_src_on_success} -eq 1 ];   then rm -rf "$abs_project_src" || true; fi
        if [ ${remove_build_on_success} -eq 1 ]; then rm -rf "$abs_project_build" || true; fi
        rmdir "$abs_project_root" || true

        printf '\nFinished %s.\n' "$project_name"

    done

    if [ ${#errors[@]} -eq 0 ]; then
        printf '\nFinished. No errors occured.\n'
    else
        printf '\nFinished with %i errors:\n' ${#errors[@]}
        printf '    %s\n' "${errors[@]}"
    fi
}
