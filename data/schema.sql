-- TransLogix Logistics Project
-- Schema definition

CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    origin_country VARCHAR(50),
    destination_country VARCHAR(50),
    transport_mode VARCHAR(30),
    carrier VARCHAR(50),
    shipment_date DATE,
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    shipment_status VARCHAR(20)
);

CREATE TABLE shipment_costs (
    cost_id SERIAL PRIMARY KEY,
    shipment_id INT REFERENCES shipments(shipment_id),
    base_cost NUMERIC(10,2),
    fuel_surcharge NUMERIC(10,2),
    customs_cost NUMERIC(10,2),
    total_cost NUMERIC(10,2)
);

CREATE TABLE delivery_performance (
    performance_id SERIAL PRIMARY KEY,
    shipment_id INT REFERENCES shipments(shipment_id),
    delay_days INT,
    on_time_flag BOOLEAN
);
