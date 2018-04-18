
all: docker-fzf.bash docker-fzf.zsh

clean:
	rm -f docker-fzf.bash docker-fzf.zsh

docker-fzf.%: src/docker-fzf.tmpl.% src/common.sh 
	rm -f $@
	cat $< >> $@
	gsed -i -e '/#{{content}}/{r src/common.sh' -e 'd}' $@ 

