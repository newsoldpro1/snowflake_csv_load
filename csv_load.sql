CREATE DATABASE my_table;
CREATE OR REPLACE my_stage;
-- PUT FILE://C:/Users/kevin.seely/sample_products.csv @mycsvstage; --only in snowsql
CREATE OR REPLACE FILE FORMAT my_format TYPE = csv, parse_header = true;
CREATE OR REPLACE TABLE products using template (
    SELECT array_agg(object_construct(*)) 
    FROM TABLE (infer_schema(
        location => '@my_stage',
        files => '.csv',
        file_format => 'my_format'))); 
COPY INTO emp FROM @mycsvstage
    files = ('sample_products.csv')
    file_format = (format_name=my_format)
    match_by_column_name = case_sensitive;
