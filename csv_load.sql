CREATE DATABASE products;
CREATE OR REPLACE mystage;
-- PUT FILE://C:/Users/kevin.seely/sample_products.csv @mycsvstage; --only in snowsql
CREATE OR REPLACE FILE FORMAT myformat TYPE = csv, parse_header = true;
CREATE OR REPLACE TABLE products using template (
    SELECT array_agg(object_construct(*)) 
    FROM TABLE (infer_schema(
        location => '@mystage',
        files => '.csv',
        file_format => 'mycsvformat'))); 
COPY INTO emp FROM @mycsvstage
    files = ('sample_products.csv')
    file_format = (format_name=mycsvformat)
    match_by_column_name = case_sensitive;
