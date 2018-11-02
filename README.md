# dwh-microservice-blank-slate
Blank slate repository for microservice development.

I will try to document here what is needed to properly initialise the microservice for my own use.

# k8s
This is what has to be done in `k8s.yaml`:
- update items/0/metadata/name and items/0/spec/jobTemplate/template/spec/containers/name
- if importer, add items/spec/0/jobTemplate/spec/template/spec/containers/configMapRef/name dwh-importer-env
- If you want it to run for a longer time, change items/0/spec/startingDeadlineSeconds (Currently 10 minutes)
- Add secrets to items/0/spec/jobTemplate/spec/template/volumes[]

# volumes.json
If you want to use more secrets (likely), add them to volumes.json. Currently only bigQuery is in there. The format:
- name
  - type secret
  - mountPath
  - from-files: volumes/$NAME.json
  - auto-create boolean

