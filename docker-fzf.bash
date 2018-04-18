#! /usr/bin/bash

export DOCKER_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

_fzf_complete_docker_run_post() {
    awk '{print $1":"$2}'
}

_fzf_complete_docker_run () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker images
    )
}

_fzf_complete_docker_common_post() {
    awk -F"\t" '{print $2}'
}

_fzf_complete_docker_common () {
    _fzf_complete "$DOCKER_FZF_PREFIX --reverse -m" "$@" < <(
        docker images --format "{{.Repository}}:{{.Tag}}\t {{.ID}}"
    )
}

_fzf_complete_docker_container_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker ps -a
    )
}


_fzf_complete_docker() {
    local cur prev words cword
    _get_comp_words_by_ref -n : cur prev words cword

    if ! type _docker > /dev/null 2>&1; then
        _completion_loader "$@"
        complete -F _fzf_complete_docker -o default -o bashdefault docker
    fi

    local counter=1
    while [ $counter -lt $cword ]; do
        case "${words[$counter]}" in
            run)
                _fzf_complete_docker_run "$@"
                return
            ;;
            exec|rm)
                _fzf_complete_docker_container "$@"
                return
            ;;
            save|load|push|pull|tag|rmi)
                _fzf_complete_docker_common "$@"
                return
            ;;
        esac
        (( counter++ ))
    done
    _fzf_handle_dynamic_completion docker "$@"
}

export _fzf_orig_completion_docker=_docker
complete -F _fzf_complete_docker -o default -o bashdefault docker

