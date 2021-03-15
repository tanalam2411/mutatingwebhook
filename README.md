# mutatingwebhook
k8s mutatingwebhook


```bash
$ minikube start --extra-config=apiserver.enable-admission-plugins=MutatingAdmissionWebhook,ValidatingAdmissionWebhook
```

```bash
$ docker login

$ make docker-build

$ make docker-push
```

1. 
```bash
mutatingwebhook$ k apply -f webhook.yaml 
mutatingwebhookconfiguration.admissionregistration.k8s.io/mymutatingwebhook.example.com created
namespace/mutatingwebhook created
namespace/testmutatingwebhook created
deployment.apps/mutatingwebhook created
service/mutatingwebhook created
```

2. Get Certificate from current cluster
```bash
mutatingwebhook$ kubectl exec -it -n mutatingwebhook $(kubectl get pods --no-headers -o custom-columns=":metadata.name" -n mutatingwebhook) -- wget -q -O- localhost:8080/ca.pem?base64
LS0tLS1CRUdJTRVJUSUZJQ0FURS0tLS0tCg==
```

3. Update the webhook.yaml's `caBundle:` with the new certificate generate above

4. Apply webhook.yaml again with updated certificate
```bash
mutatingwebhook$ k apply -f webhook.yaml 
mutatingwebhookconfiguration.admissionregistration.k8s.io/mymutatingwebhook.example.com configured
namespace/mutatingwebhook unchanged
namespace/testmutatingwebhook unchanged
deployment.apps/mutatingwebhook unchanged
service/mutatingwebhook unchanged
```

5. k apply -f pod.yaml
```bash
mutatingwebhook$ k apply -f pod.yaml 
pod/ubuntu created

mutatingwebhook$ k get pods --show-labels -n testmutatingwebhook
NAME     READY   STATUS    RESTARTS   AGE     LABELS
ubuntu   1/1     Running   0          3m24s   app=ubuntu,myExtraLabel=webhook-was-here
```
