FROM jupyter/base-notebook

COPY demo "${HOME}/demo"
COPY data "${HOME}/data"
COPY requirements.txt "${HOME}"

RUN pip install -r requirements.txt
RUN pip install jupyterlab-execute-time

# run without password
CMD start.sh jupyter lab --LabApp.token=''
