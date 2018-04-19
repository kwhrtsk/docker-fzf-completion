#! /usr/bin/bash

#{{content}}

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
            save|push|pull|tag|rmi|history|inspect|create)
                _fzf_complete_docker_image "$@"
                return
            ;;
            container)
                (( counter++ ))
                while [ $counter -lt $cword ]; do
                    case "${words[$counter]}" in
                        run)
                            _fzf_complete_docker_run "$@"
                            return
                        ;;
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
                        create)
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

