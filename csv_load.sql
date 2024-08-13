CREATE DATABASE products;
CREATE OR REPLACE FILE FORMAT csv_format TYPE = csv, parse_header = true;
CREATE OR REPLACE STAGE my_stage;
-- PUT FILE://<path_to_file>/<filename> @my_stage; --only in snowsql
CREATE OR REPLACE TABLE products using template (
    SELECT array_agg(object_construct(*)) 
    FROM TABLE (infer_schema(
        location => '@my_stage',
        files => 'products.csv',
        file_format => 'csv_format')));
COPY INTO products FROM @my_stage
    files = ('products.csv')
    file_format = (format_name=csv_format)
    match_by_column_name = case_sensitive;
