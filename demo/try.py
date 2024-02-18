import pandas as pd
from sentence_transformers import SentenceTransformer
from sqlalchemy import create_engine, text

def search(data):
    username = 'SUPERUSER'
    password = 'SYS2'
    hostname = 'localhost' 
    port = '1972' 
    namespace = 'USER'
    CONNECTION_STRING = f"iris://{username}:{password}@{hostname}:{port}/{namespace}"
    engine = create_engine(CONNECTION_STRING)
    conn = engine.connect()

    # Begin a transaction
    trans = conn.begin()

    try:
        df = pd.read_csv("/Users/aryanput/dp/treehacks-2024/data/scotch_review.csv")
        table = "zzz2"
        sql = f"""
                CREATE TABLE {table} (
            description VARCHAR(2000),
            description_vector VECTOR(DOUBLE, 384)
        )
                """
        # result = conn.execute(text(sql))
        model = SentenceTransformer('all-MiniLM-L6-v2')
        embeddings = model.encode(df['description'].tolist(), normalize_embeddings=True)

        df['description_vector'] = embeddings.tolist()
        for index, row in df.iterrows():
            sql = text(f"""
                INSERT INTO {table}
                (description, description_vector) 
                VALUES (:description, TO_VECTOR(:description_vector))
            """)
            res = conn.execute(sql, {
                'description': row['description'], 
                'description_vector': str(row['description_vector'])
            })
            print(res)
        search_vector = model.encode(data, normalize_embeddings=True).tolist() # Convert search phrase into a vector
        sql = text(f"""
            SELECT TOP 1 * FROM {table}
            ORDER BY VECTOR_DOT_PRODUCT(description_vector, TO_VECTOR(:search_vector)) DESC
        """)
        results = conn.execute(sql, {'search_vector': str(search_vector)}).fetchall()
        print(results)
        results_df = pd.DataFrame(results)
        results_df = results_df.iloc[:, 1:-1]

        # Commit the transaction
        trans.commit()
    except:
        # Rollback the transaction in case of error
        trans.rollback()
        raise
    finally:
        # Always make sure to close the connection
        conn.close()
    

if __name__ == '__main__':
    search("""smooth""")
