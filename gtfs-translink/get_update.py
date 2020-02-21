import sys
from typing import Iterator, Dict, Any
import requests
import json
import csv
from collections.abc import MutableMapping
from google.transit import gtfs_realtime_pb2
from google.protobuf import json_format
from itertools import islice
from datetime import datetime
import db
import os

def write_update_rows(update:Iterator[Any]) -> Iterator[Dict[Any,Any]]:
    # takes an update and creates a database row
    update_dict = json_format.MessageToDict(update, preserving_proto_field_name=True)
    update = flatten_dict(update_dict)
    return update

def flatten_dict(data:Iterator, parent_key:str='', sep:str='_') -> Dict[Any,Any]:
    # flattens a json-style dictionary, attempts to avoid overly redundant key names
    items = []
    for key, value in data.items():
        new_key = parent_key + sep + key if parent_key else key
        # remove duplicate words in new key
        new_key = '_'.join(dict.fromkeys(new_key.split('_')))
        if isinstance(value, MutableMapping):
            if key in items:
                items.extend(flatten_dict(value, new_key, sep=sep).items())
            else:
                items.extend(flatten_dict(value, key, sep=sep).items())
        else:
            items.append((new_key, value))
    # should be 12 columns
    return dict(items)

def iter_updates_from_api(endpoint:str) -> Iterator[Any]:
    payload = {'apikey': os.environ["translink_api_key"]}
    feed = gtfs_realtime_pb2.FeedMessage()
    res = requests.get(endpoint, payload, allow_redirects=True)
    print(res.status_code)
    res.raise_for_status()
    feed.ParseFromString(res.content)  

    yield from feed.entity

def to_csv(data:Iterator[Dict[str,Any]], prefix:str) -> None:
    with open(f'../csv/{prefix}-{int(datetime.now().timestamp())}.csv', "w") as f:
        csvwriter = csv.writer(f)
        csvwriter.writerows(
            ((row["id"],
            row["trip_id"],
            row["trip_start_date"],
            row["trip_route_id"],
            row["trip_direction_id"],
            row["position_latitude"],
            row["position_longitude"],
            row["vehicle_current_stop_sequence"],
            datetime.fromtimestamp(int(row["vehicle_timestamp"])),
            row["vehicle_stop_id"],
            row["vehicle_id"],
            row["vehicle_label"],
            )
            for row in data)
        )

def main():
    try:
        endpoint = sys.argv[1]
    except:
        endpoint = 'gtfsposition'
    # end points are gtfsrealtime (for trip updates) and gtfsposition (for vehicle positions)
    try:
        url = f'https://gtfs.translink.ca/v2/{endpoint}'
    except HTTPError as e:
        print(f'{e}. Did you try an valid endpoint? Valid endpoints for GTFS API include: gtfsrealtime, gtfsposition')

    updates = (write_update_rows(update) for update in iter_updates_from_api(url))

    #to_csv(updates, endpoint)
    conn = db.connect()
    db.insert_values(conn, updates)

if __name__ == '__main__':
    main()