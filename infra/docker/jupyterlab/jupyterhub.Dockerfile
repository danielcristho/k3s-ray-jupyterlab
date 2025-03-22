FROM jupyterhub/jupyterhub:1.4

RUN pip install -r "ray[default, data, tune, serve, client]==2.12.0"

COPY ../jupyterlab-cluster/jupyterhub_config.yaml /srv/jupyterhub/jupyterhub_config.yaml

