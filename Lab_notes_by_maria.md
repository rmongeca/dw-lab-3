# DW

## Notes on introductory session on Data Dashboarding

In the relation model we have two tables for one dimension temporal and month.
In the multidimensional model we need to know more about what are the facts, so we create a view drillacross 
(subquery{aircaft utilization join temporal dimension group by} logbook reporting people dim) --> View

Pentaho creates schema by taking relational database
and it creates another logical XML schema on top
which interperates relational db in a multidimensional way
this is not automatically generated but it will be given to us 

For the people dim,
we have no information to relate airport and roles (one airport can have mult roles and viceversa)
so in the logical schema we build another hierarchy Person-Airport so we can always roll up

Aircraft utilization metrics (first lab pdf),
the definitions/formulas of the measures are included in this XML schema.
Can we calculate metric a metric in a distributed manner or not?
For the distributed ones it calculates them before doing the aggregation

In the pentaho business analytics tool,
we need to connect to oracle rel database
then we need to import this beforementioned XML file
using import analysis

In the main editor we create the dashboard (create new --> cde dashboard)
3 main views for the editing, 1 layout panel visual way of organizing how many
boxes and how they are placed
using prepared templates and possibly extending them
when you create charts you put references to panels (row, body, rows, columns)
2d charts analyze in terms of one dim and put another dim as filter
eg. analyze flight cycles/hours in terms of months and then filtering in terms of aircraft models
under wizard we use OLAP selector and OLAP chart. OLAP Selector Wizard
Dimensions (previously created in our XML file) with their associated hierarchies
if we drag AircaftModel to rows then we see the filter drop down created in the preview area
this preview area doesn’t work sometimes
hence we want to filter by rows (the filter box underneath refers to sth else..)
this is a slicer in terms of multidimensional cube nomenclature
then using OLAP Chart Wizard
in the filter box we put the previously created saved filter parameter
in rows we can put from dim drop down months and
in column we can put from fh measures drop down