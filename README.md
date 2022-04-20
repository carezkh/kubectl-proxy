# Kubectl Proxy

A K8S API Server proxy with specified object access running in container.

Goals:

- Specify K8S objects access mode (which object & how to)

- Proxy local traffics (work as ambassador container and listen in 127.0.0.1)

- Proxy remote traffics (work as cluster proxy)

## Specify Object Access with RBAC

Object access is achieved through K8S [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

You can refer to [example/rbac.yaml](/example/rbac.yaml) to create your own access permissions.

Here, we create a **ClusterRole** *kubectl-proxy* which can `get` and `list` Pod, and bind it to **ServiceAccount** *kubectl-proxy*.

## Proxy Local Traffics

You can refer to [example/local-proxy.yaml](/example/local-proxy.yaml) to deploy the proxy as a ambassador container (also named sidecar).

Here, we create a Pod *local-proxy* with above **ServiceAccount** *kubectl-proxy*, and run two containers `curl` and `kubectl-proxy`. Notice the args `--wide local` in container `kubectl-proxy`, which means this proxy only listening in localhost.

Then, try to get and list object Pod in container `curl`:

```shell
apk add curl

curl localhost:8080/api/v1/namespaces/default/pods
curl localhost:8080/api/v1/namespaces/default/pods/local-proxy
```

## Proxy Remote Traffics

You can refer to [example/cluster-proxy.yaml](/example/cluster-proxy.yaml) to deploy the proxy as a cluster proxy.

Here, we create a Pod *cluster-proxy* with above **ServiceAccount* *kubectl-proxy*, and a Service *cluster-proxy* to access the proxy easily. Notice the args `--wide cluster` in container, which means this proxy listening in 0.0.0.0

Then, try to get and list object Pod in cluster (pod & host). In host, you may need to add `10.96.0.10` to nameserver:

```shell

curl cluster-proxy.default.svc.cluster.local/api/v1/namespaces/default/pods
curl cluster-proxy.default.svc.cluster.local/api/v1/namespaces/default/pods/cluster-proxy
```

In order to access proxy from outside the cluster, you can use **NodePort** service and etc.
