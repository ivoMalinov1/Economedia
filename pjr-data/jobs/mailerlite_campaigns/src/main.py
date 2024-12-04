import logging
from os import getenv
from typing import List, Dict

import pandas as pd
import pandas_gbq
from pandas_gbq.exceptions import GenericGBQException
import requests


logging.getLogger().setLevel(logging.DEBUG)

project_id = getenv("PROJECT_ID")
dataset_id = 'mailerlite_economedia_data_prod_laoy'
table_name = 'campaigns'
api_key = getenv("API_KEY")

headers = {
    "accept": "application/json",
    "X-MailerLite-ApiDocs": "true",
    "X-MailerLite-ApiKey": api_key
}
params = {
    "limit": 5000,
    "offset": 0,
}

urls = [
    "https://api.mailerlite.com/api/v2/campaigns/sent",
    "https://api.mailerlite.com/api/v2/campaigns/draft",
    "https://api.mailerlite.com/api/v2/campaigns/outbox"
]


def fetch_data_from_api() -> List[Dict]:
    all_responses = []
    for url in urls:
        response = requests.get(url, headers=headers, params=params, timeout=90)
        if response.status_code != 200:
            logging.error(f"Failed to fetch data. HTTP Status Code: {response.status_code}")
            response.raise_for_status()
        data = response.json()
        all_responses.extend(data)

    return all_responses


def prepare_and_load_to_bq(all_responses: List[Dict]) -> str:
    flattened_data = []

    for item in all_responses:
        flattened_item = {
            'id': item['id'],
            'total_recipients': item['total_recipients'],
            'type': item['type'],
            'date_created': item['date_created'],
            'date_send': item['date_send'],
            'name': item['name'],
            'subject': item['subject'],
            'status': item['status'],
            'opened_count': item['opened']['count'],
            'opened_rate': item['opened']['rate'],
            'clicked_count': item['clicked']['count'],
            'clicked_rate': item['clicked']['rate']
        }
        flattened_data.append(flattened_item)

    df = pd.DataFrame(flattened_data)

    try:
        pandas_gbq.to_gbq(
            df,
            destination_table=f"{project_id}.{dataset_id}.{table_name}",
            project_id=project_id,
            if_exists='replace'
        )
        logging.info(f"Loaded data: {df}")
        logging.info(f"Total rows loaded into BigQuery: {len(df)}")
    except GenericGBQException as e:
        logging.error(f"Load items failed: {e}")
        return "failed to load data into big query"

    return "groups items loaded"


def load_campaigns(request) -> str:
    all_responses = fetch_data_from_api()
    result = prepare_and_load_to_bq(all_responses)
    return result
