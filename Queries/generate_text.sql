/*
RESTARTING ENVIRONMENT

DROP TABLE IF EXISTS demo_e2e.invoices;
DROP TABLE IF EXISTS demo_e2e.invoices_extracted;
*/


# creating an external table where the diagrams are stored
CREATE OR REPLACE EXTERNAL TABLE `llm_eu.invoices`
  WITH CONNECTION `eu.vertex_ai`
  OPTIONS (
    object_metadata = 'SIMPLE',
    uris =
      ['gs://rgc-gcs-demos/invoices/*.png']);


select * from `spark_demos.invoices`;

-- creating the model
CREATE OR REPLACE MODEL `rgc-demos.llm_eu.claude_37`
REMOTE WITH CONNECTION `eu.vertex_ai`
OPTIONS (ENDPOINT = 'claude-3-7-sonnet@20250219');


SELECT
  uri,
  ml_generate_text_llm_result,
  json_value(replace(replace(ml_generate_text_llm_result, "```json", ""), "```", ""), "$.total") as total,
  json_value(replace(replace(ml_generate_text_llm_result, "```json", ""), "```", ""), "$.num_items") as num_items,
  json_value(replace(replace(ml_generate_text_llm_result, "```json", ""), "```", ""), "$.invoice_number") as invoice_number,
  json_value(replace(replace(ml_generate_text_llm_result, "```json", ""), "```", ""), "$.date") as date
FROM
  ML.GENERATE_TEXT( 
    MODEL `llm_eu.claude_37`,
    TABLE `llm_eu.invoices`,
    STRUCT(
      'Analyze the image that represents an invoice and produce the following output with json format: total (total amount of the invoice), num_items (number of items in the invoice), invoice_number (number of the invoice), date (formated as yyyy-mm-dd). do not include ```json nor ```' as PROMPT,
      .5 AS TEMPERATURE,
      TRUE AS FLATTEN_JSON_OUTPUT
    )
  );