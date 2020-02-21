DROP TABLE IF EXISTS agency;
CREATE TABLE agency (
    agency_url varchar(49),
    agency_name varchar(99),
    agency_timezone varchar(99),
    agency_id varchar(2),
    angency_lang varchar(2),
    PRIMARY KEY(agency_id)
);

DROP TABLE IF EXISTS calendar_dates;
CREATE TABLE calendar_dates (
    service_id int,
    date date,
    exception_type smallint,
    PRIMARY KEY(service_id, date)
);

DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar (
    service_id varchar(25),
    start_date date,
    end_date date,
    monday smallint,
    tuesday smallint,
    wednesday smallint,
    thursday smallint,
    friday smallint,
    saturday smallint,
    sunday smallint,
    PRIMARY KEY(service_id, start_date, end_date)
);

DROP TABLE IF EXISTS stop_times;
CREATE TABLE stop_times (
    trip_id bigint, 
    arrival_time varchar(8), -- is there a time data type? 
    departure_time varchar(8), 
    stop_id int, 
    stop_sequence smallint,
    stop_headsign varchar(255), 
    pickup_type smallint, 
    drop_off_type smallint, 
    shape_dist_traveled decimal(8,4),
    timepoint smallint,
    PRIMARY KEY(trip_id, stop_id)
);

DROP TABLE IF EXISTS direction_names_exceptions;
CREATE TABLE direction_names_exceptions (
    exception_key serial,
    route_name varchar(16),
    direction_id smallint,
    direction_name varchar(25),
    direction_do smallint
);

DROP TABLE IF EXISTS routes;
CREATE TABLE routes (
    route_long_name varchar(25), 
    route_type smallint, 
    route_text_color varchar(6), 
    route_color varchar(6),
    agency_id varchar(2), 
    route_id int, 
    route_url varchar(49), 
    route_desc varchar(99), 
    route_short_name varchar(25),
    PRIMARY KEY(route_id)
);

DROP TABLE IF EXISTS shapes;
CREATE TABLE shapes (
    shape_id bigint,
    shape_pt_lat decimal(9,6),
    shape_pt_lon decimal(9,6),
    shape_pt_sequence int,
    shape_dist_traveled decimal(9,6),
    PRIMARY KEY(shape_id, shape_pt_sequence)
);

DROP TABLE IF EXISTS stops;
CREATE TABLE stops (
    stop_lat decimal(9,6),
    stop_code int,
    stop_lon decimal(9,6),
    stop_id int,
    stop_url varchar(99),
    parent_station int,
    stop_desc varchar(99),
    stop_name varchar(49),
    location_type smallint,
    zone_id varchar(10),
    PRIMARY KEY (stop_id)
);

DROP TABLE IF EXISTS trips;
CREATE TABLE trips (
    block_id varchar(9),
    bikes_allowed smallint,
    route_id int,
    wheelchair_accessible smallint,
    direction_id smallint,
    trip_headsign varchar(20),
    shape_id int,
    service_id varchar(25),
    trip_id int,
    trip_short_name varchar(25),
    PRIMARY KEY(trip_id)
);