FROM jupyter/minimal-notebook:python-3.10

USER root

RUN pip install --no-cache-dir "ray[default, data, tune, serve, client]==2.12.0" jupyterhub==5.2.1

COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

COPY 00-ray-init.py /tmp/00-ray-init.py

ENV RAY_ADDRESS="ray://192.168.122.10:10001"

USER jovyan

CMD ["bash", "-c", "mkdir -p /home/jovyan/.ipython/profile_default/startup && \
        cp /tmp/00-ray-init.py /home/jovyan/.ipython/profile_default/startup/ && \
        start-notebook.sh"]
