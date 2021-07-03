export KUBECONFIG=$(k3d kubeconfig write manage)
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl create namespace argocd
helm upgrade --install argocd ./argo-cd \
  --namespace=argocd \
  -f values.yaml

while true; do
  echo "Waiting for deployment/argocd-server..."
  if kubectl wait --for=condition=available --timeout 240s deployment/argocd-server -n argocd; then
    break;
  fi;
  sleep 5;
done

while true; do
  echo "Waiting for deployment/argocd-repo-server..."
  if kubectl wait --for=condition=available --timeout 240s deployment/argocd-repo-server -n argocd; then
    break;
  fi;
  sleep 5;
done

argocd app sync projects
argocd app sync applications
argocd app sync argocd
