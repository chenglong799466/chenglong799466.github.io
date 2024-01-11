




* kubectl get - 列出资源
* kubectl describe - 显示有关资源的详细信息
* kubectl logs - 打印 pod 和其中容器的日志
* kubectl exec - 在 pod 中的容器上执行命令




# kubectl proxy 
会启动一个k8s server的反向代理，提供http接口访问k8s server

# 获取pod名字
kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'


curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/



# K8s创建一个容器程序

kubectl create deployment 【the deployment name】 --image=【app image location】


kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1


# K8s暴露你的服务 ，创建一个service

kubectl expose deployment/[the deployment name] --type=【"NodePort",""】


kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080


# K8s 水平扩容

kubectl expose deployment/[the deployment name] --replicas=【数量】


kubectl scale deployments/kubernetes-bootcamp --replicas=4


# K8s 滚动升级


kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2


# K8s 查看是否升级成功
kubectl rollout status deployments/kubernetes-bootcamp

# K8s 回滚升级
kubectl rollout undo deployments/kubernetes-bootcamp



# K8s 创建configmap

https://kubernetes.io/docs/concepts/configuration/configmap/

kubectl expose deployment/[the deployment name] --replicas=【数量】

kubectl create configmap [the configmap name] --from-literal【--from-file ， --from-env-file】 name=my-system【key=value】



kubectl create configmap sys-app-name --from-literal name=my-system


# K8s 创建sercret


kubectl create secret generic sys-app-credentials --from-literal username=bob --from-literal password=bobpwd