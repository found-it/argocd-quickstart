export KUBECONFIG=$(k3d kubeconfig write manage)
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

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


helm template bootstrap/management/ | kubectl apply -f -
