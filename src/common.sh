export DOCKER_FZF_PREFIX="--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all"

_fzf_complete_docker_run_post() {
    awk '{print $1":"$2}'
}

_fzf_complete_docker_run () {
    _fzf_complete "$DOCKER_FZF_PREFIX -m --header-lines=1" "$@" < <(
        docker images
    )
}

_fzf_complete_docker_image_post() {
    awk -F"\t" '{print $2}'
}

_fzf_complete_docker_image () {
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
