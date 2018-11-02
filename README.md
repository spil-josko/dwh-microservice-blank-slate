# dwh-microservice-blank-slate
Blank slate repository for microservice development.

I will try to document here what is needed to properly initialise the microservice for my own use.

# k8s
This is what has to be done in `k8s.yaml`:
- update items/0/metadata/name and items/0/spec/jobTemplate/template/spec/containers/name