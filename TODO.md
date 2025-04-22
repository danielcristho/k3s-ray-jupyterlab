This project aims to implement a distributed GPU infrastructure management system using Docker containers and JupyterLab. The final goal is to enable multi-user access to GPU resources in an efficient, fair, and scalable manner within a Kubernetes (K3s) cluster.

## Progress

- [x] Deployed RAY Cluster on K3S
- [x] Create custom Docker image for RAY and Jupyterlab
- [x] JupyterHub integrated and accessible to users
- [x] JupyterLab with RAY auto-connect
- [x] Ray tasks distributed and tracked across nodes

## To-do

- [ ] Enable GPU scheduling and isolation with NVIDIA Docker or CUDA runtime
- [ ] Implement job prioritization and fairness across users
- [ ] Evaluate and log user-level GPU usage metrics
- [ ] Secure access and auth with JupyterHub (OAuth, TLS)
- [ ] Create UI/dashboard for monitoring task and resource usage
- [ ] ...