import logging
from os import getenv

import pandas as pd
import pandas_gbq
from pandas_gbq.exceptions import GenericGBQException
from simple_salesforce import Salesforce


logging.getLogger().setLevel(logging.DEBUG)

project_id = getenv("PROJECT_ID")
dataset_id = 'salesforce_economedia_data_prod_laoy'
table_name = 'company_info'

sf = Salesforce(username=getenv("USER"), password=getenv("PASSWORD"), security_token=getenv("SECRET"))

OrderItems = sf.query_all("""
SELECT Order.Id, Create_Date_vl__c, Order.AccountId, Order.Account.Name,
Order.Account.EIK__c, Order.Account.RecordTypeId
FROM OrderItem
where DAY_ONLY(convertTimezone(Create_Date_vl__c)) = YESTERDAY
""")


def load_company_info(request):

    orders_df_raw = pd.DataFrame(OrderItems['records'])
    orders = []

    for _index, row in orders_df_raw.iterrows():
        order_id = row['Order']['Id']
        create_date = row['Create_Date_vl__c']
        account_id = row['Order']['AccountId']
        account_name = row['Order']['Account']['Name']
        eik = row['Order']['Account']['EIK__c']
        record_type_id = row['Order']['Account']['RecordTypeId']

        order_dict = {
            'id': order_id,
            'create_date': create_date,
            'account_id': account_id,
            'account_name': account_name,
            'eik': eik,
            'record_type_id': record_type_id
        }
        orders.append(order_dict)

    orders_df = pd.DataFrame(orders)

    orders_df['create_date'] = pd.to_datetime(orders_df['create_date'])

    try:
        pandas_gbq.to_gbq(
            orders_df,
            destination_table=f'{project_id}.{dataset_id}.{table_name}',
            project_id=project_id,
            if_exists='append'
        )
    except GenericGBQException:
        return "Load of order items has failed"

    logging.info(f"Loaded data: {orders_df}")

    return "Order items loaded"
