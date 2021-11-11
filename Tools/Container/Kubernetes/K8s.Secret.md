command:
    kubernetes apaye$ kubectl describe secret dashboard-admin-token-kkdj9 -n kube-system
response:
    Name:         dashboard-admin-token-kkdj9
    Namespace:    kube-system
    Labels:       <none>
    Annotations:  kubernetes.io/service-account.name: dashboard-admin
                  kubernetes.io/service-account.uid: 7cdf2478-c18b-11e9-887d-025000000001

    Type:  kubernetes.io/service-account-token

    Data
    ====
    ca.crt:     1025 bytes
    namespace:  11 bytes
    token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4ta2tkajkiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiN2NkZjI0NzgtYzE4Yi0xMWU5LTg4N2QtMDI1MDAwMDAwMDAxIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.PxRhxPH6k8RBWpyY_eNHFmBOWmicju14CvDk1ObXFsatGNb0PcOm99mkE58JsWThK1Q2tPcOOrYxZedhEMSDOIFkknuvgX242Ip2GO95qwf2JDf143hdbJx5I0BgZVH29zxwKnGoS6jkjghNO5nghh6wsdlv6VgdjwXMFFZIhSlwmXaeIbpBPdMWpBy4ScAo-FdM98utEhRiDic5_E6GuRhIVeI8I2-X_eHaJ6TWI6ANZhOeJkVHE-A5EOdY5vjvic5CfGQdP-ArAJqByMrCglh_yKQ3PGovTxPemKcq7_UxTil9s-eXQ_5_3o6rjFetqrlcN8Nt02dZV-Re5zaMkg
