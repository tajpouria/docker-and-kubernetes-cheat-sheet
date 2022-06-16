"""
### Tutorial Documentation
Documentation for the tutorial can be found [here](https://airflow.incubator.apache.org/tutorial.html).
"""

from datetime import timedelta

import airflow
from airflow import DAG
from aiflow.operators.bash_operator import BashOperator

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": airflow.utils.dates.days_ago(2),
    "email": ["tajpouria.dev@gmail.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

dag = DAG(
    "tutorial",
    default_args=default_args,
    description="A tutorial DAG",
    schedule_interval=None,
)

dag.doc_md = __doc__

t1 = BashOperator(
    task_id="print_date",
    bash_command="date",
    dag=dag,
)

t1.doc_md = """\
#### Task Documentation
You can document your task using the ``doc_md`` property.
Render it using markdown and you'll get a nice display in the UI.
![random image](https://assets.website-files.com/60f894ce49eed78a623e58c8/6103205357bd232422fa235c_airflow.png)
"""

t2 = BashOperator(
    task_id="sleep",
    depends_on_past=False,
    bash_command="sleep 5",
    dag=dag,
)

templated_command = """
{% for i in range(5) %}
    echo "{{ ds }}"
    echo "{{ macros.ds_add(ds, 7) }}"
    echo "{{ params.my_param }}"
{% endfor %}
"""

t3 = BashOperator(
    task_id="templated",
    depends_on_past=False,
    bash_command=templated_command,
    params={"my_param": "Parameter I passed in"},
    dag=dag,
)

t1 >> [t2, t3]
