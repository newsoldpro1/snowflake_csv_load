CREATE DATABASE my_table;
CREATE OR REPLACE my_stage;
-- PUT FILE://<path_to_file>/<filename> @my_stage; --only in snowsql
CREATE OR REPLACE FILE FORMAT my_format TYPE = csv, parse_header = true;
CREATE OR REPLACE TABLE sample_products using template (
    SELECT array_agg(object_construct(*)) 
    FROM TABLE (infer_schema(
        location => '@my_stage',
        files => '.csv',
        file_format => 'my_format'))); 
COPY INTO sample_products FROM @my_stage
    files = ('sample_products.csv')
    file_format = (format_name=my_format)
    match_by_column_name = case_sensitive;
