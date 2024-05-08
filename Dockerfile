FROM jupyter/base-notebook

COPY demo "${HOME}/demo"
COPY data "${HOME}/data"
COPY requirements.txt "${HOME}"

RUN pip install -r requirements.txt
RUN pip install jupyterlab-execute-time

COPY lib/intersystems_irispython-5.0.0-6545-6545-cp36.cp37.cp38.cp39.cp310.cp311.cp312-cp36m.cp37m.cp38.cp39.cp310.cp311.cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl /tmp/lib/intersystems_irispython-5.0.0-6545-cp36.cp37.cp38.cp39.cp310.cp311.cp312-cp36m.cp37m.cp38.cp39.cp310.cp311.cp312-manylinux2014_x86_64.whl
RUN pip install /tmp/lib/intersystems_irispython-5.0.0-6545-cp36.cp37.cp38.cp39.cp310.cp311.cp312-cp36m.cp37m.cp38.cp39.cp310.cp311.cp312-manylinux2014_x86_64.whl

COPY SSLConfigs.ini "/usr/cert-demo/"
ENV ISC_SSLconfigurations="/usr/cert-demo/SSLConfigs.ini"

USER root
RUN chown -R jovyan "${HOME}/demo" /usr/cert-demo/
USER jovyan

# run without password
CMD start.sh jupyter lab --LabApp.token=''
