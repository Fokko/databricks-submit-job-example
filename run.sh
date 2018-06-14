#!/usr/bin/env bash

python3 setup.py bdist_egg

# Get the ID of the cluster
export CLUSTER_ID=`databricks clusters list | grep fokko | grep RUNNING | awk '{print $1}'`

PROJECT_ID="example_databricks_submit_job"

echo "Uploading resources"
databricks fs cp --overwrite dist/${PROJECT_ID}-0.1-py3.6.egg dbfs:/tmp/${PROJECT_ID}-0.1-py3.6.egg
databricks fs cp --overwrite run.py dbfs:/tmp/${PROJECT_ID}.py

JSON=`cat << EOM
{
  "name": "Fokko training example",
  "existing_cluster_id": "${CLUSTER_ID}",
  "libraries": [{
      "egg": "dbfs:/tmp/${PROJECT_ID}-0.1-py3.6.egg"
  }],
  "email_notifications": {
    "on_start": [],
    "on_success": [],
    "on_failure": []
  },
  "spark_python_task": {
    "python_file": "dbfs:/tmp/${PROJECT_ID}.py"
  },
  "timeout_seconds": 3600,
  "max_retries": 1
}
EOM`

echo "Creating job"
export JOB_ID=`databricks jobs create --json "${JSON}" | jq .job_id`

echo "Start job ${JOB_ID}"
export RUN_ID=`databricks jobs run-now --job-id ${JOB_ID} | jq .run_id`

export URL=`databricks runs get --run-id ${RUN_ID} | jq .run_page_url`

echo "Job running at: ${URL}"
