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
table_name = 'groups'
api_key = getenv("API_KEY")

url = "https://api.mailerlite.com/api/v2/groups"

headers = {
    "accept": "application/json",
    "X-MailerLite-ApiDocs": "true",
    "X-MailerLite-ApiKey": api_key
}
params = {
    "limit": 5000,
    "offset": 0,
}


def fetch_data_from_api() -> List[Dict]:
    all_responses = []
    while True:
        response = requests.get(url, headers=headers, params=params, timeout=90)
        if response.status_code != 200:
            logging.error(f"Failed to fetch data. HTTP Status Code: {response.status_code}")
            response.raise_for_status()
        data = response.json()
        all_responses.extend(data)

        if len(data) < params["limit"]:
            logging.info(f"Total items {len(all_responses)}")
            break

    return all_responses


def prepare_and_load_to_bq(all_responses: List[Dict]):
    flattened_data = []

    for item in all_responses:
        flattened_item = {
            'id': item['id'],
            'name': item['name'],
            'total': item['total'],
            'active': item['active'],
            'unsubscribed': item['unsubscribed'],
            'bounced': item['bounced'],
            'unconfirmed': item['unconfirmed'],
            'junk': item['junk'],
            'sent': item['sent'],
            'opened': item['opened'],
            'clicked': item['clicked'],
            'parent_id': item['parent_id'],
            'date_created': item['date_created'],
            'date_updated': item['date_updated']
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


def load_groups(request) -> str:
    all_responses = fetch_data_from_api()
    result = prepare_and_load_to_bq(all_responses)
    return result
