import psycopg2
import psycopg2.extras
import os
import uuid
from datetime import datetime
from typing import Iterator, Dict, List, Any

def connect() -> psycopg2.extensions.connection:
    conn = psycopg2.connect(
        dbname = os.environ["translink_db_name"],
        user = os.environ["translink_db_user"],
        password = os.environ["translink_db_pass"],
        host = os.environ["translink_db_host"]
        )
    return conn

def uuid_key(values:List[Any], namespace:uuid.UUID=uuid.NAMESPACE_DNS) -> uuid.UUID:
    # creates a uuid to act as the primary key for the imported data
    # uses the hostname of machine as namespace, and created from the id, trip_id, and trip_direction fields
    namespace = os.environ["uuid_namespace"]
    uuid_namespace = uuid.uuid5(uuid.NAMESPACE_DNS, namespace)
    return uuid.uuid5(uuid_namespace, str(''.join(str(value) for value in values)))

def print_uuids(updates:Iterator[Dict[str,Any]], max_iter=20) -> None:
    # prints a list of what the generated uuid's would look like
    for _, row in zip(range(max_iter), updates):
        print(uuid_key(values=[row['id'], row['trip_id'], row['trip_direction_id']]))

def insert_values(conn:psycopg2.extensions.connection, updates:Iterator[Dict[str,Any]]) -> None:
    # imports data via INSERT...VALUES used for realtime data
    with conn.cursor() as cursor:
        ''' Potential items to clean:
            - update_id could remove _ to use bigint
            - route_id must be varchar due to "6685_merged_11153411"
                could either map it to another routeid or
                remove these entries as there aren't a lot (or keep)
            - timestamp should be a timestamp in postgres
        '''
        psycopg2.extras.execute_values(
            cursor,
            "INSERT INTO position_update VALUES %s;",
            ((str(uuid_key(values=[update["id"], update["trip_id"], update["trip_direction_id"]])),
            update["id"],
            update["trip_id"],
            update["trip_start_date"],
            update["trip_route_id"],
            update["trip_direction_id"],
            update["position_latitude"],
            update["position_longitude"],
            update["vehicle_current_stop_sequence"],
            datetime.fromtimestamp(int(update["vehicle_timestamp"])),
            update["vehicle_stop_id"],
            update["vehicle_id"],
            update["vehicle_label"],
            ) for update in updates)
            )
    conn.commit()

if __name__ == '__main__':
    print("Here's your glimpse of the connection object ", connect())