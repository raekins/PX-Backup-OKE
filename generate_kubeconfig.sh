SERVICE_ACCOUNT=pxbackup-sa
NAMESPACE=kube-system
SERVER=https://x.x.x.x:6443

SERVICE_ACCOUNT_TOKEN=$(kubectl -n ${NAMESPACE} get secret ${SERVICE_ACCOUNT} -o "jsonpath={.data.token}" | base64 --decode)
SERVICE_ACCOUNT_CERTIFICATE=$(kubectl -n ${NAMESPACE} get secret ${SERVICE_ACCOUNT} -o "jsonpath={.data['ca\.crt']}")

cat <<END
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${SERVICE_ACCOUNT_CERTIFICATE}
    server: ${SERVER}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: ${NAMESPACE}
    user: ${SERVICE_ACCOUNT}
current-context: default-context
users:
- name: ${SERVICE_ACCOUNT}
  user:
    token: ${SERVICE_ACCOUNT_TOKEN}
END
