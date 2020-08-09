# rsyslog-k8s-logserver

A very simple rsyslog server intended to be used in the k8s cluster for collecting logs from external systems, the logs could be then processed by filebeat or any other tool and pushed to the central logging server.

Sample k8s deployment manifest:
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rsyslog
  namespace: monitor
spec:
  replicas: 1
  selector:
    matchLabels:
      app: rsyslog
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: rsyslog
      annotations:
        prometheus.io/scrape: "false"
    spec:
      containers:
      - name: rsyslog
        image: zmazay/rsyslog-k8s-logserver:latest
        imagePullPolicy: Always
        readinessProbe:
          tcpSocket:
            port: tcp
          timeoutSeconds: 30
        livenessProbe:
          tcpSocket:
            port: tcp
          timeoutSeconds: 60
          failureThreshold: 5
        resources:
          requests:
            cpu: 50m
            memory: 32Mi
          limits:
            cpu: 50m
            memory: 32Mi
        ports:
        - containerPort: 514
          name: udp
          protocol: UDP
        - containerPort: 514
          name: tcp
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: rsyslog-udp
  namespace: monitor
spec:
  ports:
  - port: 514
    protocol: UDP
    targetPort: udp
  selector:
    app: rsyslog
  externalTrafficPolicy: Local
  sessionAffinity: None
  type: LoadBalancer
  loadBalancerIP: 198.51.100.11
---
apiVersion: v1
kind: Service
metadata:
  name: rsyslog-tcp
  namespace: monitor
spec:
  ports:
  - port: 514
    protocol: TCP
    targetPort: tcp
  selector:
    app: rsyslog
  externalTrafficPolicy: Local
  sessionAffinity: None
  type: LoadBalancer
  loadBalancerIP: 198.51.100.12
```
