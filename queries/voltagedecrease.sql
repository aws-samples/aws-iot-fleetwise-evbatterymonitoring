WITH AverageBatteryVoltage AS (
    WITH BatteryVoltage AS (
        SELECT
            vehicleName,
            time,
            "measure_value::double" AS signalValue
        FROM
            "fleetwise"."fleetwise"
        WHERE
            (
                time BETWEEN ago(15m)
                AND NOW()
            )
            AND measure_name = 'EVDemo.Main.BatteryElectrical_v'
        ORDER BY
            time DESC
    )
    SELECT
        vehicleName,
        YEAR(time) AS year,
        MONTH(time) AS MONTH,
        DAY(time) AS DAY,
        HOUR(time) AS HOUR,
        MINUTE(time) AS MINUTE,
        avg(signalValue) AS avg_value
    FROM
        BatteryVoltage
    GROUP BY
        vehicleName,
        YEAR(time),
        MONTH(time),
        DAY(time),
        HOUR(time),
        MINUTE(time)
    ORDER BY
        vehicleName,
        YEAR(time),
        MONTH(time),
        DAY(time),
        HOUR(time),
        MINUTE(time)
)
SELECT
    *,
    LAG(avg_value) OVER (
        PARTITION BY vehicleName,
        year,
        MONTH,
        DAY,
        HOUR
        ORDER BY
            vehicleName,
            year,
            MONTH,
            DAY,
            HOUR
    ) previous_avg_value,
    (
        LAG(avg_value) OVER (
            PARTITION BY vehicleName,
            year,
            MONTH,
            DAY,
            HOUR
            ORDER BY
                vehicleName,
                year,
                MONTH,
                DAY,
                HOUR
        )
    ) / avg_value -1 increase
FROM
    AverageBatteryVoltage