#! /usr/bin/bash

export DOCKER_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

_fzf_complete_docker_image_post() {
  awk '{ if ($1=="<none>") print $3; else print $1":"$2 }'
}

_fzf_complete_docker_image () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker images
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

_fzf_complete_docker_container_running_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container_running () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker ps
    )
}

_fzf_complete_docker_container_stopped_post() {
    awk '{print $NF}'
}

_fzf_complete_docker_container_stopped () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker ps --filter "status=exited" --filter="status=created"
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
            exec|attach|kill|pause|unpause|port|stats|stop|top|wait)
                _fzf_complete_docker_container_running "$@"
                return
            ;;
            start)
                _fzf_complete_docker_container_stopped "$@"
                return
            ;;
            commit|cp|diff|export|logs|rename|restart|rm|update)
                _fzf_complete_docker_container "$@"
                return
            ;;
            run|save|push|pull|tag|rmi|history|inspect|create)
                _fzf_complete_docker_image "$@"
                return
            ;;
            container)
                (( counter++ ))
                while [ $counter -lt $cword ]; do
                    case "${words[$counter]}" in
                        exec|attach|kill|pause|unpause|port|stats|stop|top|wait)
                            _fzf_complete_docker_container_running "$@"
                            return
                        ;;
                        start)
                            _fzf_complete_docker_container_stopped "$@"
                            return
                        ;;
                        commit|cp|diff|export|inspect|logs|rename|restart|rm|update)
                            _fzf_complete_docker_container "$@"
                            return
                        ;;
                        run|create)
                            _fzf_complete_docker_image "$@"
                            return
                        ;;
                    esac
                    (( counter++ ))
                done
            ;;
            image)
                (( counter++ ))
                while [ $counter -lt $cword ]; do
                    case "${words[$counter]}" in
                        save|push|pull|tag|rm|history|inspect)
                            _fzf_complete_docker_image "$@"
                            return
                        ;;
                    esac
                    (( counter++ ))
                done
            ;;
        esac
        (( counter++ ))
    done
    _fzf_handle_dynamic_completion docker "$@"
}

export _fzf_orig_completion_docker=_docker
complete -F _fzf_complete_docker -o default -o bashdefault docker

