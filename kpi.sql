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
    SUM(f.PIREP)/SUM(f.FLIGHTCYCLES) PRRc,  SUM(f.PIREP)/SUM(f.FLIGHTHOURS) PRRh,
    SUM(f.MAREP)/SUM(f.FLIGHTCYCLES) MRRc,  SUM(f.MAREP)/SUM(f.FLIGHTHOURS) MRRh
FROM AircraftDimension d1, FACTS_DRILLACCROSS f
WHERE f.aircraftID = d1.ID
    AND d1.model = '737'
GROUP BY f.monthID
ORDER BY f.monthID
-- Alternative without view
SELECT
    T_AIR.monthID,
    SUM(T_LOGS.CNT)/  SUM(T_AIR.FC) RRc,   SUM(T_LOGS.CNT)/  SUM(T_AIR.FH) RRh,
    SUM(T_LOGS.PIREP)/SUM(T_AIR.FC) PRRc,  SUM(T_LOGS.PIREP)/SUM(T_AIR.FH) PRRh,
    SUM(T_LOGS.MAREP)/SUM(T_AIR.FC) MRRc,  SUM(T_LOGS.MAREP)/SUM(T_AIR.FH) MRRh
FROM (
        SELECT t.monthID, SUM(f.flightHours) FH, SUM(f.flightCycles) FC
        FROM AircraftDimension d, AircraftUtilization f, TEMPORALDIMENSION t
        WHERE f.aircraftID = d.ID
        	AND f.TIMEID = t.ID
            AND d.model = '737'
        GROUP BY t.monthID
        ORDER BY t.monthID
    ) T_AIR,
    (
        SELECT L.monthID,
        	SUM(L.COUNTER) AS CNT,
	        SUM(CASE WHEN p.role='P' THEN L.COUNTER ELSE 0 END) AS PIREP,
	        SUM(CASE WHEN p.role='M' THEN L.COUNTER ELSE 0 END) AS MAREP
        FROM LOGBOOKREPORTING L, PeopleDimension p, AircraftDimension d
        WHERE L.aircraftID = d.ID
            AND L.PERSONID = p.ID
            AND d.model = '737'
        GROUP BY L.monthID
        ORDER BY L.monthID
    ) T_LOGS
WHERE T_AIR.monthID = T_LOGS.monthID
GROUP BY T_AIR.monthID
ORDER BY T_AIR.monthID 
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
-- Alternative without view
SELECT
    T_AIR.model,
    SUM(T_LOGS.MAREP)/SUM(T_AIR.FC) MRRc,
    SUM(T_LOGS.MAREP)/SUM(T_AIR.FH) MRRh
FROM (
        SELECT d.model, SUM(f.flightHours) FH, SUM(f.flightCycles) FC
        FROM AircraftDimension d, AircraftUtilization f
        WHERE f.aircraftID = d.ID
        GROUP BY d.model
        ORDER BY d.model
    ) T_AIR,
    (
        SELECT d.model,
        SUM(CASE WHEN P.role='M' THEN L.COUNTER ELSE 0 END) AS MAREP
        FROM LOGBOOKREPORTING L, PeopleDimension P, AircraftDimension d
        WHERE L.aircraftID = d.ID
            AND L.PERSONID = P.ID
            AND P.airport = 'BSL' 
        GROUP BY d.model
        ORDER BY d.model
    ) T_LOGS
WHERE T_AIR.model = T_LOGS.model
GROUP BY T_AIR.model
ORDER BY T_AIR.model
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------