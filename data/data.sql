-- TransLogix Logistics Project
-- Data generation script
-- WARNING: Run ONLY ONCE on an empty TransLogix database

-- =========================
-- SHIPMENTS
-- =========================
INSERT INTO shipments (
    origin_country,
    destination_country,
    transport_mode,
    carrier,
    shipment_date,
    estimated_delivery_date,
    actual_delivery_date,
    shipment_status
)
SELECT
    CASE
        WHEN gs % 3 = 0 THEN 'Germany'
        WHEN gs % 3 = 1 THEN 'Turkey'
        ELSE 'Poland'
    END AS origin_country,

    CASE
        WHEN gs % 4 = 0 THEN 'France'
        WHEN gs % 4 = 1 THEN 'Italy'
        WHEN gs % 4 = 2 THEN 'Netherlands'
        ELSE 'Spain'
    END AS destination_country,

    CASE
        WHEN gs % 2 = 0 THEN 'Road'
        ELSE 'Sea'
    END AS transport_mode,

    CASE
        WHEN gs % 2 = 0 THEN 'DHL'
        ELSE 'Maersk'
    END AS carrier,

    CURRENT_DATE - (gs % 180) AS shipment_date,
    CURRENT_DATE - (gs % 180) + 7 AS estimated_delivery_date,

    CASE
        WHEN gs % 5 = 0
            THEN CURRENT_DATE - (gs % 180) + 10
        ELSE CURRENT_DATE - (gs % 180) + 7
    END AS actual_delivery_date,

    CASE
        WHEN gs % 5 = 0 THEN 'Delayed'
        ELSE 'Delivered'
    END AS shipment_status
FROM generate_series(1, 5000) gs;


-- =========================
-- SHIPMENT COSTS
-- =========================
INSERT INTO shipment_costs (
    shipment_id,
    base_cost,
    fuel_surcharge,
    customs_cost,
    total_cost
)
SELECT
    shipment_id,
    ROUND(100 + RANDOM() * 400, 2) AS base_cost,
    ROUND(RANDOM() * 50, 2) AS fuel_surcharge,
    ROUND(RANDOM() * 80, 2) AS customs_cost,
    0
FROM shipments;


UPDATE shipment_costs
SET total_cost = base_cost + fuel_surcharge + customs_cost;


-- =========================
-- DELIVERY PERFORMANCE
-- =========================
INSERT INTO delivery_performance (
    shipment_id,
    delay_days,
    on_time_flag
)
SELECT
    shipment_id,
    CASE
        WHEN shipment_status = 'Delayed'
            THEN (actual_delivery_date - estimated_delivery_date)
        ELSE 0
    END AS delay_days,
    shipment_status = 'Delivered' AS on_time_flag
FROM shipments;
