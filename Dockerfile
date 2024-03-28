FROM jupyter/base-notebook

COPY demo "${HOME}"
COPY requirements.txt "${HOME}"

RUN pip install -r requirements.txt

# run without password
CMD start.sh jupyter lab --LabApp.token=''