# InterSystems IRIS Vector Search

With the 2025.1 release, we're adding a powerful [Vector Search capability to the InterSystems IRIS Data Platform](https://www.intersystems.com/news/iris-vector-search-support-ai-applications/), to help you innovate faster and build intelligent applications powered by Generative AI. At the center of the new capability is a new [`VECTOR` native datatype](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RSQL_datatype&ADJUST=1) for IRIS SQL, along with [similarity functions](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GSQL_vecsearch&ADJUST=1) that leverage optimized chipset instructions (SIMD).

The latest version of IRIS 2025.1 includes not only bug fixes and performance enhancements, but a new disk-based Approximate Nearest Neighbors index that speeds up vector search for large collections of vectors (typically over 100K). See [the docs](https://docs.intersystems.com/iris20251/csp/docbook/DocBook.UI.Page.cls?KEY=GSQL_vecsearch#GSQL_vecsearch_index) for more information on how to define and use the index.

The same Vector Search capability is now also available with [InterSystems IRIS Cloud SQL](https://developer.intersystems.com/products/iris-cloud-sql-integratedml/). Check out [`cloud_sql_demo.ipynb`](demo/cloud_sql_demo.ipynb) for instructions on setting up a connection from your Jupyter notebook. The notebooks exploring langchain and llama-index also support connecting to Cloud SQL deployments.

This repository offers code samples to get you started with the new features, and we'll continue to add more, but encourage you to let us know about your own experiments on the [InterSystems Developer Community](https://community.intersystems.com). At the bottom of this page, you'll find links to a few demo repositories we liked a lot!


## InterSystems IRIS Vector Search Quickstart

1. Clone the repo
    ```Shell
    git clone https://github.com/intersystems-community/iris-vector-search.git
    ```
   

### Using a Jupyter container

If you prefer just running the demos from your local Python environment, skip to [Using your local Python environment](#using-your-local-python-environment).


2. For [`langchain_demo.ipynb`](demo/langchain_demo.ipynb) and [`llama_demo.ipynb`](demo/llama_demo.ipynb), you need an [OpenAI API Key](https://platform.openai.com/api-keys). Update the corresponding entry in `docker-compose.yml`:
    ```
      OPENAI_API_KEY: xxxxxxxxx
    ```

3. Start the Docker containers (one for IRIS, one for Jupyter):
    ```Shell
    docker-compose up
    ```

    Please note that building the container involves downloading the `sentence_transformers` module, which measures over 2GB!

### Using your local Python environment 

2. Install IRIS Community Edtion in a container:
    ```Shell
    docker run -d --name iris-comm -p 1972:1972 -p 52773:52773 -e IRIS_PASSWORD=demo -e IRIS_USERNAME=demo intersystemsdc/iris-community:latest 
    ```
    :information_source: After running the above command, you can access the System Management Portal via http://localhost:52773/csp/sys/UtilHome.csp. Please note you may need to [configure your web server separately](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCGI_private_web&ADJUST=1) when using another product edition.

3. Create a Python environment and activate it (conda, venv or however you wish) For example:
    
    ```Shell
    conda create --name iris-vector-search python=3.10
    conda activate iris-vector-search
    ```

4. Install packages for all demos:
    ```Shell
    pip install -r requirements.txt
    ```

5. For [`langchain_demo.ipynb`](demo/langchain_demo.ipynb) and [`llama_demo.ipynb`](demo/llama_demo.ipynb), you need an [OpenAI API Key](https://platform.openai.com/api-keys). Create a `.env` file in this repo to store the key:
    ```
    OPENAI_API_KEY=xxxxxxxxx
    ```
    
6. The demos in this repository are formatted as Jupyter notebooks. To run them, just start Jupyter and navigate to the `/demo/` folder:

    ```Shell
    jupyter lab
    ```

## Basic Demos

### [sql_demo.ipynb](demo/sql_demo.ipynb)

IRIS SQL now supports vector search (with other columns)! In this demo, we're searching a whiskey dataset for whiskeys that are priced < $100 and have a taste description similar to "earthy and creamy taste".

### [langchain_demo.ipynb](demo/langchain_demo.ipynb)

IRIS now has a langchain integration as a VectorDB! In this demo, we use the langchain framework with IRIS to ingest and search through a document. 

### [llama_demo.ipynb](demo/llama_demo.ipynb)

IRIS now has a llama_index integration as a VectorDB! In this demo, we use the llama_index framework with IRIS to ingest and search through a document. 

### [cloud_sql_demo.ipynb](demo/cloud_sql_demo.ipynb)

This notebook describes how to tap into the Vector Search capability when using [InterSystems IRIS Cloud SQL](https://developer.intersystems.com/products/iris-cloud-sql-integratedml/) instead of a local install or container. It covers the additional settings for establishing a secure connection to a Cloud SQL deployment.


## Which to use?

If you need to use hybrid search (similarity search with other columns), use IRIS SQL. 

If you're building a genAI app that uses a variety of tools (agents, chained reasoning, api calls), go for langchain. 

If you're building a RAG app, go for the approach llama_index.

Feel free to contact Fan / Thomas or file an issue in this GitHub repository if you have any questions!


## More Demos / References:

### [Voice-controlled shopping cart](https://github.com/intersystems-dach/RAG-demo)
Neat shopping cart demo that leverages Vector Search to match your voice-recorded order to available items.

### [NLP Queries on  Youtube Audio Transcription](https://github.com/jrpereirajr/intersystems-iris-notebooks/blob/main/vector/langchain-iris/nlp_queries_on_youtube_audio_transcription_dataset.ipynb)
Uses langchain-iris to search Youtube Audio transcriptions

### [langchain-iris demo](https://github.com/caretdev/langchain-iris/blob/main/demo.ipynb)
Original IRIS langhain demo, that runs the containerized IRIS in the notebook

### [llama-iris demo](https://github.com/caretdev/llama-iris/blob/main/demo.ipynb)
Original IRIS llama_index demo, that runs the containerized IRIS in the notebook

### [InterSystems Documentation](https://docs.intersystems.com/)
Official page for InterSystems Documentation
