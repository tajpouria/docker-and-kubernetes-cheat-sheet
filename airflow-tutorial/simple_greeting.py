from __future__ import print_function

import datetime

from airflow import models
from airflow.operators import bash_operator, python_operator

default_args = {
    "start_date": datetime.datetime(2022, 1, 1),
}

with models.DAG(
    "composer_sample_simple_greeting",
    schedule_interval=datetime.timedelta(minutes=5),
    default_args=default_args,
) as dag:

    def greet():
        import logging

        logging.info("Hello World!")

    hello_python = python_operator.PythonOperator(
        task_id="hello_python",
        python_callable=greet,
    )

    goodbye_bash = bash_operator.BashOperator(
        task_id="goodbye_bash",
        bash_command="echo Goodbye World!",
    )

    hello_python >> goodbye_bash
