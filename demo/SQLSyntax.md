
# Using Vectors in IRIS SQL

:alert: Please refer to the [full product documentation](https://docs.intersystems.com/iris20241/csp/docbook/Doc.View.cls?KEY=GSQL_vecsearch) for the full syntax and instructions. This page is for offline reference only.

## VECTOR (type, length)
**Optional parameters:**

- `type` - Optional, defaults to DOUBLE. The datatype of elements allowed to be stored in the vector. Can be DECIMAL, DOUBLE, INTEGER, TIMESTAMP, or STRING. 
- `length` - Optional, can be specified only if type is also specified. An integer for the number of elements allowed to be stored in the vector. If specified, length restriction for INSERT INTO the vector column will be imposed.

### Creating a table with vector columns:
```sql
CREATE TABLE Test.Demo (vec1 VECTOR(DOUBLE,3))
CREATE TABLE Test.Demo (vec1 VECTOR(DOUBLE))
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


## SQL Functions

### TO_VECTOR (input, type, length)
**Parameters:**

- `input` - String value (VARCHAR) representing the vector contents in either of the supported input formats, "val1,val2,val3" (recommended), or "[ val1,val2, val3]"
- `type` - Optional, defaults to DOUBLE. The datatype of elements in the array, can be DECIMAL, DOUBLE, INTEGER, TIMESTAMP, or STRING. 
- `length` - Optional. When specified, input will be padded with NULL values or truncated to the specified length, such that the result is a VECTOR of the specified length. The two-argument version of this function simply returns a vector with as many elements as the supplied list.

**Returns:** the corresponding vector to be added to tables or used in other vector operations.

**Example:**
```sql
INSERT INTO Test.Demo (vec1) VALUES (TO_VECTOR('0.1,0.2,0.3',DOUBLE, 3))
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
SELECT TOP 3 * FROM Test.Demo ORDER BY VECTOR_COSINE(vec1, TO_VECTOR('0.2,0.4,0.6', DOUBLE)) DESC
```
**Using Dot Product:**
```sql
SELECT TOP 3 * FROM Test.Demo ORDER BY VECTOR_DOT_PRODUCT(vec1, TO_VECTOR('0.2,0.4,0.6', DOUBLE)) DESC
```
Note that we use 'DESC', since a higher magnitude for dot product/cosine similarity means the vector is more similar.

This can be combined with 'WHERE' clauses to add filters on other columns.

