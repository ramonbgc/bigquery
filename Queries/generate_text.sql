-- creating the model
CREATE OR REPLACE MODEL `rgc-demos.llm_bel.claude_37`
REMOTE WITH CONNECTION `europe-west1.vertex_ai_bel`
OPTIONS (ENDPOINT = 'claude-3-7-sonnet@20250219');


-- rows
SELECT * FROM `llm_bel.patient_data` LIMIT 5;

-- querying
SELECT * 
FROM
  ML.GENERATE_TEXT( 
    MODEL `llm_bel.claude_37`,
    (
      SELECT CONCAT('Considering the following medication: ', Medication, ' and the dose: ', Dose_mg, ', predict the condition the patient has and the probable age range. Be specific and return just the top 3 most probable condition for every medication. Return the results in Spanish.') AS prompt,
      Patient_ID
      FROM `llm_bel.patient_data` LIMIT 5
    ),
    STRUCT(
      TRUE AS FLATTEN_JSON_OUTPUT,
      1000 AS MAX_OUTPUT_TOKENS
    )
  );  