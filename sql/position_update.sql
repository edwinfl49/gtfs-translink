CREATE TABLE position_update (
    update_pkey uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    update_id varchar(20),
    trip_id bigint,
    start_date date,
    route_id int,
    direction_id smallint,
    latitude numeric(21,18),
    longitude numeric(21,18),
    current_stop_sequence smallint,
    timestamp timestamp, 
    stop_id int,
    vehicle_id int,
    label varchar(10)
);