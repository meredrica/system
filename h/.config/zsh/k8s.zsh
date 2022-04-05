function _k8_get_pod {
	# get the pods via kubectl
	kubectl get pods | cut -d ' ' -f 1 | tail -n +2 | fzf -1 -q ${1:-' '}
}

function _k8_shell {
	local pod=$( _k8_get_pod $@);
	kubectl exec --stdin --tty $pod -- /bin/bash
}

function _k8_port_forward {
	local pod=$( _k8_get_pod $@);
	local port=$( kubectl -o json get pod $pod | jq '.spec.containers[]?.ports[]?.containerPort'  | fzf -1 )
	kubectl port-forward $pod $port
}

# remote shell
alias krs=_k8_shell
# port forward
alias kpf=_k8_port_forward
# context switch
alias kc="kubectl config use-context"
# save the keyboards!
alias k=kubectl
# completions ftw
source <(kubectl completion zsh)
