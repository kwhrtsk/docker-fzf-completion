# docker-fzf-completion
Extends default docker completion with fzf

<img src="https://raw.githubusercontent.com/Mike-Now/img/master/docker-fzf-completion.gif" width=640>

## Installation
1. Download and install fzf and docker with docker autocompletion
2. Set default FZF trigger to something else beside ** (optionally)

```bash
  export FZF_COMPLETION_TRIGGER='%%'
```

3. Source either `docker-fzf.bash` or `docker-fzf.zsh` depending on your shell.

## Extension from original code

* Supports almost commands about container and images like `attach`, `kill`, and more.
* Consider the state of the container. For example, only stopped containers suggested to `docker start`.
* Supports subcommands of `docker container` and `docker image`.
  * These subcommands have been added since version [1.13](https://blog.docker.com/2017/01/whats-new-in-docker-1-13/).
* Use `IMAGE_ID` instead of `REPOSITORY:TAG` when completion for image commands,
  because sometimes there are images without `REPOSITORY:TAG`. These images will be shown as `<none>:<none>`.

Original code is [Mike-Now/docker-fzf-completion](https://github.com/Mike-Now/docker-fzf-completion)(MIT License).
