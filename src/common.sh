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

