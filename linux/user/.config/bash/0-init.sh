
if [[ -z "${PS1}" ]]; then
	return
fi

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
	source /usr/share/bash-completion/bash_completion
else
	echo 'bash-completion not found'
fi

shopt -s checkwinsize
shopt -s direxpand
shopt -s histverify
