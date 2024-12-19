
# Using Vectors in IRIS SQL

:alert: Please refer to the [full product documentation](https://docs.intersystems.com/iris20241/csp/docbook/Doc.View.cls?KEY=GSQL_vecsearch) for the full syntax and instructions. This page is for offline reference only.

## VECTOR (type, length)
**Optional parameters:**

- `type` - Optional, defaults to FLOAT (was DOUBLE up to 2024.2). The datatype of elements allowed to be stored in the vector. Can be DECIMAL, DOUBLE, FLOAT, INTEGER, TIMESTAMP, or STRING. 
- `length` - Optional, can be specified only if type is also specified. An integer for the number of elements allowed to be stored in the vector. If specified, length restriction for INSERT INTO the vector column will be imposed.

### Creating a table with vector columns:
```sql
CREATE TABLE Test.Demo (vec1 VECTOR(FLOAT,3))
CREATE TABLE Test.Demo (vec1 VECTOR(FLOAT))
CREATE TABLE Test.Demo (vec1 VECTOR)
```
### Inserting into a table with vector columns:
```sql
INSERT INTO Test.Demo (vec1) VALUES ('0.1,0.2,0.3')
```
This query will succeed following any of the above three table creations. It will default to the table's vector type.

### Selecting from a table with vector columns:
```sql
SELECT * FROM Test.Demo
```

## Vector Index

**Note**: This feature is available only for InterSystems IRIS 2025.1 and later versions. Please join the [Early Access Program](https://live.evaluation.iscinternal.com/download/adminearlyaccess.csp?earlyAccessProgram=Vector_Search) if you'd like access to a preview kit.

After storing data in InterSystems IRIS in the VECTOR type, you may define a vector index (also called an approximate nearest neighbor index or an ANN index) to improve the efficiency of searches issued against your stored vectors.

In a standard vector search, comparisons against an input vector must be made against every individual vector in the database. While this approach guarantees that your searches are completely accurate, it is computationally inefficient. A vector index leverages nearest neighbor algorithms to store the vectors in a sorted data structure that limits the number of comparison operations performed between an input vector and the stored vectors. As a result, when a search is performed, the system does not make comparisons with each stored vector but instead uses the sorted data structure to eliminate vectors that are not close to the input vector. This approach dramatically improves the performance of searches on a vector database, particularly when dealing with large amounts of high-dimensional data.

> **Note:** Queries that use a vector index currently do not support parallelization.

As with standard indexes, the query optimizer may decide that the most efficient query plan does not use the vector index you have defined. To see if a query uses the vector index, examine the query plan with the `EXPLAIN` command.

### Hierarchical Navigable Small World Index

InterSystems SQL allows you to define a Hierarchical Navigable Small World (HNSW) index, which uses the HNSW algorithm to create a vector index.

You can define an HNSW index using a `CREATE INDEX` statement. To define an HNSW index, the following requirements must be met:

- The HNSW index is defined on a VECTOR-typed field with a fixed length that is of type `FLOAT`, `DOUBLE` or `DECIMAL`.
- The table the index is defined on must have IDs that are bitmap-supported.
- The table the index is defined on must use default storage.

There are three parameters you can specify when defining an HNSW index:

1. **Distance** (required): The distance function used by the index, surrounded by quotes (`''`). There are two possible values: `Cosine` and `DotProduct`. This parameter is case-insensitive.
2. **M** (optional): The number of bi-directional links created for every new element during construction. This value should be a positive integer larger than 1; the value will fall between 2–100. Higher M values work better on datasets with high dimensionality or recall, while lower M values work better with low dimensionality or recall. The default value is 64.
3. **efConstruct** (optional): The size of the dynamic list for the nearest neighbors. This value should be a positive integer larger than M. Larger `efConstruct` values generally lead to better index quality but longer construction time. There is a maximum value past which `efConstruct` does not improve the quality of the index. The default value is 64.

#### Examples of defining HNSW indexes with various parameter values:

```sql
CREATE INDEX HNSWIndex ON TABLE Company.People (Biography)
  AS %SQL.Index.HNSW(Distance='Cosine')

CREATE INDEX HNSWIndex ON TABLE Company.People (Biography)
  AS %SQL.Index.HNSW(M=80, Distance='DotProduct')

CREATE INDEX HNSWIndex ON TABLE Company.People (Biography)
  AS %SQL.Index.HNSW(M=72, efConstruct=100, Distance='Cosine')
```

## SQL Functions

### TO_VECTOR (input, type, length)
**Parameters:**

- `input` - String value (VARCHAR) representing the vector contents in either of the supported input formats, "val1,val2,val3" (recommended), or "[ val1,val2, val3]"
- `type` - Optional, defaults to FLOAT. The datatype of elements in the array, can be DECIMAL, DOUBLE, FLOAT, INTEGER, TIMESTAMP, or STRING. 
- `length` - Optional. When specified, input will be padded with NULL values or truncated to the specified length, such that the result is a VECTOR of the specified length. The two-argument version of this function simply returns a vector with as many elements as the supplied list.

**Returns:** the corresponding vector to be added to tables or used in other vector operations.

**Example:**
```sql
INSERT INTO Test.Demo (vec1) VALUES (TO_VECTOR('0.1,0.2,0.3', FLOAT, 3))
```
### VECTOR_COSINE (vec1, vec2)
**Parameters:**

- `vec1, vec2` - vectors

**Returns:** a double value of the cosine distance between the two vectors, taking value from -1 to 1.

**Example:**
```sql
SELECT * FROM Test.Demo WHERE (VECTOR_COSINE(vec1, TO_VECTOR('0.4,0.5,0.6')) < 0)
```
### VECTOR_DOT_PRODUCT (vec1, vec2)
**Parameters:**

- `vec1, vec2` - vectors

**Returns:** a double value of the dot product of two vectors.

**Example:**
```sql
SELECT * FROM Test.Demo WHERE (VECTOR_DOT_PRODUCT(vec1, TO_VECTOR('0.4,0.5,0.6')) > 10)
SELECT * FROM Test.Demo WHERE (VECTOR_DOT_PRODUCT(vec1, vec1) > 10)
```
## Nearest Neighbor Search
Getting the top 3 most similar vectors (to an input vector) from a table

**Using Cosine Similarity:**
```sql
SELECT TOP 3 * FROM Test.Demo ORDER BY VECTOR_COSINE(vec1, TO_VECTOR('0.2,0.4,0.6', FLOAT)) DESC
```
**Using Dot Product:**
```sql
SELECT TOP 3 * FROM Test.Demo ORDER BY VECTOR_DOT_PRODUCT(vec1, TO_VECTOR('0.2,0.4,0.6', FLOAT)) DESC
```
Note that we use 'DESC', since a higher magnitude for dot product/cosine similarity means the vector is more similar.

This can be combined with 'WHERE' clauses to add filters on other columns.

