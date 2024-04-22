FROM jupyter/base-notebook

COPY requirements.txt "${HOME}"
RUN pip install -r requirements.txt

COPY demo "${HOME}/demo"
COPY data "${HOME}/data"
# run without password
CMD start.sh jupyter lab --LabApp.token=''