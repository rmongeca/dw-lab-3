-- FH, FC (30%)
SELECT d2.model, d1.monthID, SUM(f.flightHours) FH, SUM(f.flightCycles) FC
FROM TemporalDimension d1, AircraftDimension d2, AircraftUtilization f
WHERE f.aircraftID = d2.ID
    AND f.timeID = d1.ID
GROUP BY d2.model, d1.monthID
ORDER BY d2.model, d1.monthID
-- Dashboard query for sample model '737'
SELECT monthID, FH, FC
FROM (
    SELECT d2.model, d1.monthID, SUM(f.flightHours) FH, SUM(f.flightCycles) FC
    FROM TemporalDimension d1, AircraftDimension d2, AircraftUtilization f
    WHERE f.aircraftID = d2.ID
        AND f.timeID = d1.ID
    GROUP BY d2.model, d1.monthID
    ORDER BY d2.model, d1.monthID
    ) T
WHERE T.model = '737'
-- Alternative without subquery
SELECT d1.monthID, SUM(f.flightHours) FH, SUM(f.flightCycles) FC
FROM TemporalDimension d1, AircraftDimension d2, AircraftUtilization f
WHERE f.aircraftID = d2.ID
    AND f.timeID = d1.ID
    AND d2.model = '737'
GROUP BY d1.monthID
ORDER BY d1.monthID
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- ADOSS, ADOSU (30%)
SELECT f.aircraftID, d3.y,
    SUM(f.scheduledOutOfService) ADOSS, SUM(f.unScheduledOutOfService) ADOSU
FROM TemporalDimension d1, AircraftDimension d2, Months d3, AircraftUtilization f
WHERE f.aircraftID = d2.ID
    AND f.timeID = d1.ID
    AND d1.monthID = d3.ID
GROUP BY f.aircraftID, d3.y
ORDER BY f.aircraftID, d3.y
-- Dashboard query for sample model 'XY-KKF'
SELECT y, ADOSS, ADOSU
FROM (
    SELECT f.aircraftID, d3.y,
        SUM(f.scheduledOutOfService) ADOSS, SUM(f.unScheduledOutOfService) ADOSU
    FROM TemporalDimension d1, AircraftDimension d2, Months d3, AircraftUtilization f
    WHERE f.aircraftID = d2.ID
        AND f.timeID = d1.ID
        AND d1.monthID = d3.ID
    GROUP BY f.aircraftID, d3.y
    ORDER BY f.aircraftID, d3.y
    ) T
WHERE T.aircraftID = 'XY-KKF'
-- Alternative without subquery
SELECT d3.y,
    SUM(f.scheduledOutOfService) ADOSS, SUM(f.unScheduledOutOfService) ADOSU
FROM TemporalDimension d1, Months d3, AircraftUtilization f
WHERE f.aircraftID = 'XY-KKF'
    AND f.timeID = d1.ID
    AND d1.monthID = d3.ID
GROUP BY d3.y
ORDER BY d3.y
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- RRh, RRc, PRRh, PRRc, MRRh, MRRc (20%)
SELECT d1.model, f.monthID,
    SUM(f.COUNTER)/SUM(f.FLIGHTCYCLES) RRc, SUM(f.COUNTER)/SUM(f.FLIGHTHOURS) RRh,
    SUM(f.PIREP)/SUM(f.FLIGHTCYCLES) PRRc, SUM(f.PIREP)/SUM(f.FLIGHTHOURS) PRRh,
    SUM(f.MAREP)/SUM(f.FLIGHTCYCLES) MRRc, SUM(f.MAREP)/SUM(f.FLIGHTHOURS) MRRh
FROM AircraftDimension d1, FACTS_DRILLACCROSS f
WHERE f.aircraftID = d1.ID
GROUP BY d1.model, f.monthID
ORDER BY d1.model, f.monthID
-- Dashboard query for sample model '737'
SELECT monthID, RRc, RRh, PRRc, PRRh, MRRc, MRRh
FROM (
    SELECT d1.model, f.monthID,
        SUM(f.COUNTER)/SUM(f.FLIGHTCYCLES) RRc, SUM(f.COUNTER)/SUM(f.FLIGHTHOURS) RRh,
        SUM(f.PIREP)/SUM(f.FLIGHTCYCLES) PRRc, SUM(f.PIREP)/SUM(f.FLIGHTHOURS) PRRh,
        SUM(f.MAREP)/SUM(f.FLIGHTCYCLES) MRRc, SUM(f.MAREP)/SUM(f.FLIGHTHOURS) MRRh
    FROM AircraftDimension d1, FACTS_DRILLACCROSS f
    WHERE f.aircraftID = d1.ID
    GROUP BY d1.model, f.monthID
    ORDER BY d1.model, f.monthID
    ) T
WHERE T.model = '737'
-- Alternative without subquery
SELECT f.monthID,
    SUM(f.COUNTER)/SUM(f.FLIGHTCYCLES) RRc, SUM(f.COUNTER)/SUM(f.FLIGHTHOURS) RRh,
    SUM(f.PIREP)/SUM(f.FLIGHTCYCLES) PRRc, SUM(f.PIREP)/SUM(f.FLIGHTHOURS) PRRh,
    SUM(f.MAREP)/SUM(f.FLIGHTCYCLES) MRRc, SUM(f.MAREP)/SUM(f.FLIGHTHOURS) MRRh
FROM AircraftDimension d1, FACTS_DRILLACCROSS f
WHERE f.aircraftID = d1.ID
    AND d1.model = '737'
GROUP BY f.monthID
ORDER BY f.monthID
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- MRRh, MRRc (20%)
SELECT d2.airport, d1.model,
    SUM(f.MAREP)/SUM(f.FLIGHTCYCLES) MRRc, SUM(f.MAREP)/SUM(f.FLIGHTHOURS) MRRh
FROM AircraftDimension d1, PeopleDimension d2, FACTS_DRILLACCROSS f
WHERE f.aircraftID = d1.ID
    AND f.PERSONID = d2.ID
GROUP BY d2.airport, d1.model
ORDER BY d2.airport, d1.model
-- Dashboard query for sample model 'BSL'
SELECT model, MRRc, MRRh
FROM (
    SELECT d2.airport, d1.model,
        SUM(f.MAREP)/SUM(f.FLIGHTCYCLES) MRRc, SUM(f.MAREP)/SUM(f.FLIGHTHOURS) MRRh
    FROM AircraftDimension d1, PeopleDimension d2, FACTS_DRILLACCROSS f
    WHERE f.aircraftID = d1.ID
        AND f.PERSONID = d2.ID
    GROUP BY d2.airport, d1.model
    ORDER BY d2.airport, d1.model
    ) T
WHERE T.airport = 'BSL'
-- Alternative without subquery
SELECT d1.model,
    SUM(f.MAREP)/SUM(f.FLIGHTCYCLES) MRRc, SUM(f.MAREP)/SUM(f.FLIGHTHOURS) MRRh
FROM AircraftDimension d1, PeopleDimension d2, FACTS_DRILLACCROSS f
WHERE f.aircraftID = d1.ID
    AND f.PERSONID = d2.ID
    AND d2.airport = 'BSL'
GROUP BY d1.model
ORDER BY d1.model
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------